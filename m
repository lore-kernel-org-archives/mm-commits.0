From: akpm@linux-foundation.org
Subject: [merged] headers_check-recursively-search-for-linux-typesh-inclusion.patch removed from -mm tree
Date: Tue, 27 Mar 2012 11:57:40 -0700
Message-ID: <20120327185742.8AF0DA033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42418 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2C0S5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 14:57:43 -0400
Received: by qabg24 with SMTP id g24so57747qab.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Mar 2012 11:57:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobbypowers@gmail.com, airlied@linux.ie, mmarek@suse.cz, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: headers_check: recursively search for linux/types.h inclusion
has been removed from the -mm tree.  Its filename was
     headers_check-recursively-search-for-linux-typesh-inclusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bobby Powers <bobbypowers@gmail.com>
Subject: headers_check: recursively search for linux/types.h inclusion

headers_check.pl currently emits some spurious warnings, especially for
the drm headers, about using __[us]{8,16,32,64} types without including
linux/types.h.  Recursively search for types.h inclusion, avoiding
circular references.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_check.pl |   38 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff -puN scripts/headers_check.pl~headers_check-recursively-search-for-linux-typesh-inclusion scripts/headers_check.pl
--- a/scripts/headers_check.pl~headers_check-recursively-search-for-linux-typesh-inclusion
+++ a/scripts/headers_check.pl
@@ -19,6 +19,7 @@
 # 3) Check for leaked CONFIG_ symbols
 
 use strict;
+use File::Basename;
 
 my ($dir, $arch, @files) = @ARGV;
 
@@ -99,6 +100,39 @@ sub check_asm_types
 }
 
 my $linux_types;
+my %import_stack = ();
+sub check_include_typesh
+{
+	my $path = $_[0];
+	my $import_path;
+
+	my $fh;
+	my @file_paths = ($path, $dir . "/" .  $path, dirname($filename) . "/" . $path);
+	for my $possible ( @file_paths ) {
+	    if (not $import_stack{$possible} and open($fh, '<', $possible)) {
+		$import_path = $possible;
+		$import_stack{$import_path} = 1;
+		last;
+	    }
+	}
+	if (eof $fh) {
+	    return;
+	}
+
+	my $line;
+	while ($line = <$fh>) {
+		if ($line =~ m/^\s*#\s*include\s+<linux\/types.h>/) {
+			$linux_types = 1;
+			last;
+		}
+		if (my $included = ($line =~ /^\s*#\s*include\s+[<"](\S+)[>"]/)[0]) {
+			check_include_typesh($included);
+		}
+	}
+	close $fh;
+	delete $import_stack{$import_path};
+}
+
 sub check_sizetypes
 {
 	if ($filename =~ /types.h|int-l64.h|int-ll64.h/o) {
@@ -113,6 +147,9 @@ sub check_sizetypes
 		$linux_types = 1;
 		return;
 	}
+	if (my $included = ($line =~ /^\s*#\s*include\s+[<"](\S+)[>"]/)[0]) {
+		check_include_typesh($included);
+	}
 	if ($line =~ m/__[us](8|16|32|64)\b/) {
 		printf STDERR "$filename:$lineno: " .
 		              "found __[us]{8,16,32,64} type " .
@@ -122,4 +159,3 @@ sub check_sizetypes
 		#$ret = 1;
 	}
 }

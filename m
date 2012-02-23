From: akpm@linux-foundation.org
Subject: + headers_check-recursively-search-for-linux-typesh-inclusion.patch added to -mm tree
Date: Thu, 23 Feb 2012 14:20:56 -0800
Message-ID: <20120223222056.9D081A01D6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:50569 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2BWWU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2012 17:20:58 -0500
Received: by vcbf1 with SMTP id f1so220907vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2012 14:20:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bobbypowers@gmail.com, airlied@linux.ie, mmarek@suse.cz, sam@ravnborg.org


The patch titled
     Subject: headers_check: recursively search for linux/types.h inclusion
has been added to the -mm tree.  Its filename is
     headers_check-recursively-search-for-linux-typesh-inclusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-the-compatible-vendor-match.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:22 -0700
Message-ID: <533f093e.qeJM9E4V4kHbXnXR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaDDTeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh@kernel.org, joe@perches.com, florian.vaussard@epfl.ch

Subject: [merged] checkpatch-improve-the-compatible-vendor-match.patch removed from -mm tree
To: florian.vaussard@epfl.ch,joe@perches.com,robh@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:22 -0700


The patch titled
     Subject: checkpatch: improve the compatible vendor match
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-the-compatible-vendor-match.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Vaussard <florian.vaussard@epfl.ch>
Subject: checkpatch: improve the compatible vendor match

Improve the vendor name match in vendor-prefix.txt
by only matching the exact vendor name at the beginning of lines.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Joe Perches <joe@perches.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-compatible-vendor-match scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-compatible-vendor-match
+++ a/scripts/checkpatch.pl
@@ -2080,9 +2080,11 @@ sub process {
 
 			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
 
+			my $dt_path = $root . "/Documentation/devicetree/bindings/";
+			my $vp_file = $dt_path . "vendor-prefixes.txt";
+
 			foreach my $compat (@compats) {
 				my $compat2 = $compat;
-				my $dt_path =  $root . "/Documentation/devicetree/bindings/";
 				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
 				`grep -Erq "$compat|$compat2" $dt_path`;
 				if ( $? >> 8 ) {
@@ -2090,14 +2092,12 @@ sub process {
 					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
 				}
 
-				my $vendor_path = $dt_path . "vendor-prefixes.txt";
-				next if (! -f $vendor_path);
 				next if $compat !~ /^([a-zA-Z0-9\-]+)\,/;
 				my $vendor = $1;
-				`grep -Eq "$vendor" $vendor_path`;
+				`grep -Eq "^$vendor\\b" $vp_file`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
-					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vendor_path\n" . $herecurr);
+					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vp_file\n" . $herecurr);
 				}
 			}
 		}
_

Patches currently in -mm which might be from florian.vaussard@epfl.ch are

origin.patch
linux-next.patch


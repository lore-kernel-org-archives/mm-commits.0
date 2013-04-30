From: akpm@linux-foundation.org
Subject: [merged] checkpatch-complain-about-executable-files.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:29 -0700
Message-ID: <20130430185329.718865A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38445 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3D3Sxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:31 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86510vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: complain about executable files
has been removed from the -mm tree.  Its filename was
     checkpatch-complain-about-executable-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: complain about executable files

Complain about files with an executable bit set that are not in a scripts/
directory and are not type .pl, .py, .awk, or .sh

Based on an initial patch from Stephen.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-complain-about-executable-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complain-about-executable-files
+++ a/scripts/checkpatch.pl
@@ -1583,7 +1583,8 @@ sub process {
 # Check for incorrect file permissions
 		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
 			my $permhere = $here . "FILE: $realfile\n";
-			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+			if ($realfile !~ m@scripts/@ &&
+			    $realfile !~ /\.(py|pl|awk|sh)$/) {
 				ERROR("EXECUTE_PERMISSIONS",
 				      "do not set execute permissions for source files\n" . $permhere);
 			}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-usb-storage-realtek_crc-fix-build.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch


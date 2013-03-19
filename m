From: akpm@linux-foundation.org
Subject: [alternative-merged] checkpatch-complain-about-more-executable-files.patch removed from -mm tree
Date: Tue, 19 Mar 2013 15:09:03 -0700
Message-ID: <20130319220904.196B031C2BB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:36857 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3CSWJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 18:09:06 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so98434qea.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 15:09:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: complain about more executable files
has been removed from the -mm tree.  Its filename was
     checkpatch-complain-about-more-executable-files.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: checkpatch: complain about more executable files

We don't want executable permissions set on files such as devicetree
syntax files, text files, defconfig files, or binary hex files.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-complain-about-more-executable-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complain-about-more-executable-files
+++ a/scripts/checkpatch.pl
@@ -1583,7 +1583,7 @@ sub process {
 # Check for incorrect file permissions
 		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
 			my $permhere = $here . "FILE: $realfile\n";
-			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl|\.dts|\.dtsi|defconfig|\.txt|\.hex|\.HEX|\.ihex)$/) {
 				ERROR("EXECUTE_PERMISSIONS",
 				      "do not set execute permissions for source files\n" . $permhere);
 			}
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
timer_list-split-timer_list_show_tickdevices-v4.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch
kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch


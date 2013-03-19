From: akpm@linux-foundation.org
Subject: + checkpatch-complain-about-more-executable-files.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:39:00 -0700
Message-ID: <20130319213900.743F831C1D1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:36353 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933797Ab3CSVjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:39:02 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so95193ghb.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:39:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: complain about more executable files
has been added to the -mm tree.  Its filename is
     checkpatch-complain-about-more-executable-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
checkpatch-complain-about-more-executable-files.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch
kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch


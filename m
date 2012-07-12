From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:15:49 -0700
Message-ID: <20120712211550.074B15C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:36549 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab2GLVPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:15:52 -0400
Received: by fat25 with SMTP id 25so146821fat.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:15:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2

Add check that works for sizeof *foo as well as sizeof foo

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2
+++ a/scripts/checkpatch.pl
@@ -3266,7 +3266,7 @@ sub process {
 		}
 
 # check for sizeof without parenthesis
-		if ($line =~ /\bsizeof\s+($Lval)/) {
+		if ($line =~ /\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/) {
 			WARN("SIZEOF_PARENTHESIS",
 			     "sizeof $1 should be sizeof($1)\n" . $herecurr);
 		}
_
Subject: Subject: checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch
vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch
checkpatch-update-alignment-check.patch
checkpatch-test-for-non-standard-signatures.patch
checkpatch-check-usleep_range-arguments.patch
checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2.patch


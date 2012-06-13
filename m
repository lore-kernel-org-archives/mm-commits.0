From: akpm@linux-foundation.org
Subject: + checkpatch-update-alignment-check.patch added to -mm tree
Date: Wed, 13 Jun 2012 12:22:57 -0700
Message-ID: <20120613192257.BDE01A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51423 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab2FMTW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 15:22:59 -0400
Received: by yhgm50 with SMTP id m50so127869yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 12:22:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: Update alignment check
has been added to the -mm tree.  Its filename is
     checkpatch-update-alignment-check.patch

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
Subject: checkpatch: Update alignment check

Parenthesis alignment doesn't correctly check an existing line after an
inserted or modified line with an open parenthesis.

Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-alignment-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-alignment-check
+++ a/scripts/checkpatch.pl
@@ -1848,8 +1848,8 @@ sub process {
 
 			my $pos = pos_last_openparen($rest);
 			if ($pos >= 0) {
-				$line =~ /^\+([ \t]*)/;
-				my $newindent = $1;
+				$line =~ /^(\+| )([ \t]*)/;
+				my $newindent = $2;
 
 				my $goodtabindent = $oldindent .
 					"\t" x ($pos / 8) .
_
Subject: Subject: checkpatch: Update alignment check

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
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
checkpatch-update-alignment-check.patch


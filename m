From: akpm@linux-foundation.org
Subject: + checkpatch-check-usleep_range-arguments.patch added to -mm tree
Date: Thu, 21 Jun 2012 12:28:27 -0700
Message-ID: <20120621192827.894E3A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:57491 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129Ab2FUT22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:28:28 -0400
Received: by vbnl22 with SMTP id l22so95580vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:28:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org, yuvalmin@broadcom.com


The patch titled
     Subject: checkpatch: check usleep_range() arguments
has been added to the -mm tree.  Its filename is
     checkpatch-check-usleep_range-arguments.patch

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
Subject: checkpatch: check usleep_range() arguments

usleep_range() shouldn't use the same args for min and max.

Report it when it happens and when both args are decimal and min > max.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Yuval Mintz <yuvalmin@broadcom.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-usleep_range-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-usleep_range-arguments
+++ a/scripts/checkpatch.pl
@@ -3313,6 +3313,22 @@ sub process {
 			}
 		}
 
+# check usleep_range arguments
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+(?:.*?)\busleep_range\s*\(\s*($FuncArg)\s*,\s*($FuncArg)\s*\)/) {
+		 	my $min = $1;
+			my $max = $7;
+			if ($min eq $max) {
+				WARN("USLEEP_RANGE",
+				     "usleep_range should not use min == max args; see Documentation/timers/timers-howto.txt\n" . "$here\n$stat\n");
+			} elsif ($min =~ /^\d+$/ && $max =~ /^\d+$/ &&
+				 $min > $max) {
+				WARN("USLEEP_RANGE",
+				     "usleep_range args reversed, use min then max; see Documentation/timers/timers-howto.txt\n" . "$here\n$stat\n");
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
_
Subject: Subject: checkpatch: check usleep_range() arguments

Patches currently in -mm which might be from joe@perches.com are

origin.patch
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
vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch
checkpatch-update-alignment-check.patch
checkpatch-test-for-non-standard-signatures.patch
checkpatch-check-usleep_range-arguments.patch


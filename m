From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch added to -mm tree
Date: Mon, 09 Jul 2012 14:52:56 -0700
Message-ID: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39825 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2GIVw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 17:52:57 -0400
Received: by ggeh3 with SMTP id h3so1246192gge.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 14:52:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: Add acheck for use of sizeof without parenthesis
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch

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
Subject: checkpatch: Add acheck for use of sizeof without parenthesis

Kernel style uses parenthesis around sizeof.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-use-of-sizeof-without-parenthesis scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-use-of-sizeof-without-parenthesis
+++ a/scripts/checkpatch.pl
@@ -3265,6 +3265,12 @@ sub process {
 			     "sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# check for sizeof without parenthesis
+		if ($line =~ /\bsizeof\s+($Lval)/) {
+			WARN("SIZEOF_PARENTHESIS",
+			     "sizeof $1 should be sizeof($1)\n" . $herecurr);
+		}
+
 # check for line continuations in quoted strings with odd counts of "
 		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
 			WARN("LINE_CONTINUATIONS",
_
Subject: Subject: checkpatch: Add acheck for use of sizeof without parenthesis

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


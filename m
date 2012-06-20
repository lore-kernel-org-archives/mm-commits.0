From: akpm@linux-foundation.org
Subject: + checkpatch-test-for-non-standard-signatures.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:45:24 -0700
Message-ID: <20120620224524.971EBA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34946 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2FTWp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:45:26 -0400
Received: by bkty5 with SMTP id y5so444162bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:45:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: checkpatch: test for non-standard signatures
has been added to the -mm tree.  Its filename is
     checkpatch-test-for-non-standard-signatures.patch

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
Subject: checkpatch: test for non-standard signatures

Warn on non-standard signature styles.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-test-for-non-standard-signatures scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-test-for-non-standard-signatures
+++ a/scripts/checkpatch.pl
@@ -1600,13 +1600,17 @@ sub process {
 
 # Check signature styles
 		if (!$in_header_lines &&
-		    $line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
+		    $line =~ /^(\s*)([a-z0-9_-]+by:|$signature_tags)(\s*)(.*)/i) {
 			my $space_before = $1;
 			my $sign_off = $2;
 			my $space_after = $3;
 			my $email = $4;
 			my $ucfirst_sign_off = ucfirst(lc($sign_off));
 
+			if ($sign_off !~ /$signature_tags/) {
+				WARN("BAD_SIGN_OFF",
+				     "Non-standard signature: $sign_off\n" . $herecurr);
+			}
 			if (defined $space_before && $space_before ne "") {
 				WARN("BAD_SIGN_OFF",
 				     "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
_
Subject: Subject: checkpatch: test for non-standard signatures

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
get_maintainer-fix-help-warning.patch
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


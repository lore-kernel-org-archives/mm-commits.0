From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch added to -mm tree
Date: Tue, 26 Jul 2016 13:44:26 -0700
Message-ID: <5797cbaa.Zl3TcbysXJR//3FA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbcGZUo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 16:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alanjhd@gmail.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve 'bare use of' signed/unsigned types warning
has been added to the -mm tree.  Its filename is
     checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch

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
Subject: checkpatch: improve 'bare use of' signed/unsigned types warning

Fix false positive warning of identifiers ending in signed with an =
assignment of WARNING: Prefer 'signed int' to bare use of 'signed'.

Link: http://lkml.kernel.org/r/6a0e24c3e9102337528ecfcbbe91a0eb5b4820ed.1469529497.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Alan Douglas <alanjhd@gmail.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-bare-use-of-signed-unsigned-types-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-bare-use-of-signed-unsigned-types-warning
+++ a/scripts/checkpatch.pl
@@ -3348,7 +3348,7 @@ sub process {
 		next if ($line =~ /^[^\+]/);
 
 # check for declarations of signed or unsigned without int
-		while ($line =~ m{($Declare)\s*(?!char\b|short\b|int\b|long\b)\s*($Ident)?\s*[=,;\[\)\(]}g) {
+		while ($line =~ m{\b($Declare)\s*(?!char\b|short\b|int\b|long\b)\s*($Ident)?\s*[=,;\[\)\(]}g) {
 			my $type = $1;
 			my $var = $2;
 			$var = "" if (!defined $var);
_

Patches currently in -mm which might be from joe@perches.com are

printk-create-pr_level-functions.patch
checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
checkpatch-allow-c99-style-comments.patch
checkpatch-yet-another-commit-id-improvement.patch
checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch
rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses.patch


From: akpm@linux-foundation.org
Subject: +
 checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch added to -mm tree
Date: Tue, 10 Jun 2014 16:57:28 -0700
Message-ID: <53979b68.4Y7CKkeMmtdcGbYq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFJX53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 19:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 16:57:28 -0700


The patch titled
     Subject: checkpatch: fix complex macro false positive for escaped constant char
has been added to the -mm tree.  Its filename is
     checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch

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
Subject: checkpatch: fix complex macro false positive for escaped constant char

A single escaped constant char is not a complex macro.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char
+++ a/scripts/checkpatch.pl
@@ -3775,7 +3775,7 @@ sub process {
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
 			    $dstat !~ /^[!~-]?(?:$Lval|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo // foo->bar // foo.bar->baz
-			    $dstat !~ /^'X'$/ &&					# character constants
+			    $dstat !~ /^'X'$/ && $dstat !~ /^'XX'$/ &&			# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
 			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
linux-next.patch


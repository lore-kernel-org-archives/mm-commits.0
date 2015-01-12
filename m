From: akpm@linux-foundation.org
Subject: +
 checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
 added to -mm tree
Date: Mon, 12 Jan 2015 15:27:26 -0800
Message-ID: <54b4585e.DxITJfHXQNDGO5GY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbbALX11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:27:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Allow comments in macros tested for single statements
has been added to the -mm tree.  Its filename is
     checkpatch-allow-comments-in-macros-tested-for-single-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-comments-in-macros-tested-for-single-statements.patch

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
Subject: checkpatch: Allow comments in macros tested for single statements

Convert all the comments to spaces before testing for single statement
macros.

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-allow-comments-in-macros-tested-for-single-statements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-comments-in-macros-tested-for-single-statements
+++ a/scripts/checkpatch.pl
@@ -4260,6 +4260,7 @@ sub process {
 			$ctx = $dstat;
 
 			$dstat =~ s/\\\n.//g;
+			$dstat =~ s/$;/ /g;
 
 			if ($dstat =~ /^\+\s*#\s*define\s+$Ident\s*${balanced_parens}\s*do\s*{(.*)\s*}\s*while\s*\(\s*0\s*\)\s*([;\s]*)\s*$/) {
 				my $stmts = $2;
_

Patches currently in -mm which might be from joe@perches.com are

printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch
checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch


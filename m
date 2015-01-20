From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch added to -mm tree
Date: Tue, 20 Jan 2015 14:28:43 -0800
Message-ID: <54bed69b.hoHfSMymsvUAb0TK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbbATW2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 17:28:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add ability to coalesce commit descriptions on multiple lines
has been added to the -mm tree.  Its filename is
     checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch

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
Subject: checkpatch: add ability to coalesce commit descriptions on multiple lines

If a git commit description is split on consecutive lines, coalesce it
before testing.

This allows:

  commit <foo> ("some long
  description")

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines
+++ a/scripts/checkpatch.pl
@@ -2198,6 +2198,13 @@ sub process {
 				 defined $rawlines[$linenr] &&
 				 $rawlines[$linenr] =~ /^\s*\("([^"]+)"\)/) {
 				$orig_desc = $1;
+			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("[^"]+$/i &&
+				 defined $rawlines[$linenr] &&
+				 $rawlines[$linenr] =~ /^\s*[^"]+"\)/) {
+				$line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)$/i;
+				$orig_desc = $1;
+				$rawlines[$linenr] =~ /^\s*([^"]+)"\)/;
+				$orig_desc .= " " . $1;
 			}
 
 			($id, $description) = git_commit_info($orig_commit,
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
checkpatch-update-git-commit-message.patch
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch


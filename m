From: akpm@linux-foundation.org
Subject: + checkpatch-make-the-memory-barrier-test-noisier.patch added to
 -mm tree
Date: Thu, 03 Oct 2013 15:49:43 -0700
Message-ID: <524df487.JQQJcSIN9VpMIVVP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab3JCWto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 18:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oliver@neukum.org, joe@perches.com

Subject: + checkpatch-make-the-memory-barrier-test-noisier.patch added to -mm tree
To: joe@perches.com,oliver@neukum.org,paulmck@linux.vnet.ibm.com,peterz@infradead.org
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 15:49:43 -0700


The patch titled
     Subject: checkpatch: make the memory barrier test noisier
has been added to the -mm tree.  Its filename is
     checkpatch-make-the-memory-barrier-test-noisier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-make-the-memory-barrier-test-noisier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-make-the-memory-barrier-test-noisier.patch

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
Subject: checkpatch: make the memory barrier test noisier

Peter Zijlstra prefers that comments be required near uses of memory
barriers.

Change the message level for memory barrier uses from a --strict test only
to a normal WARN so it's always emitted.

This might produce false positives around insertions of memory barriers
when a comment is outside the patch context block.

And checkpatch is still stupid, it only looks for existence of any
comment, not at the comment content.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-the-memory-barrier-test-noisier scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-the-memory-barrier-test-noisier
+++ a/scripts/checkpatch.pl
@@ -3850,8 +3850,8 @@ sub process {
 # check for memory barriers without a comment.
 		if ($line =~ /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/) {
 			if (!ctx_has_comment($first_line, $linenr)) {
-				CHK("MEMORY_BARRIER",
-				    "memory barrier without comment\n" . $herecurr);
+				WARN("MEMORY_BARRIER",
+				     "memory barrier without comment\n" . $herecurr);
 			}
 		}
 # check of hardware specific defines
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch


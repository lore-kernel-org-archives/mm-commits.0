From: akpm@linux-foundation.org
Subject: [folded-merged] prctl-more-prctlpr_set_mm_-checks-fix.patch
 removed from -mm tree
Date: Thu, 25 Jun 2015 14:50:34 -0700
Message-ID: <558c77aa.w2pPbllIptTVdFNZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbFYVuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl-more-prctlpr_set_mm_-checks-fix
has been removed from the -mm tree.  Its filename was
     prctl-more-prctlpr_set_mm_-checks-fix.patch

This patch was dropped because it was folded into prctl-more-prctlpr_set_mm_-checks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: prctl-more-prctlpr_set_mm_-checks-fix

tidy code, tweak comment

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/sys.c~prctl-more-prctlpr_set_mm_-checks-fix kernel/sys.c
--- a/kernel/sys.c~prctl-more-prctlpr_set_mm_-checks-fix
+++ a/kernel/sys.c
@@ -1902,15 +1902,14 @@ out:
 }
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
-static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr, unsigned long len)
+static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
+			  unsigned long len)
 {
 	/*
-	 * This doesn't move auxiliary vector itself
-	 * since it's pinned to mm_struct, but allow
-	 * to fill vector with new values. It's up
-	 * to a caller to provide sane values here
-	 * otherwise user space tools which use this
-	 * vector might be unhappy.
+	 * This doesn't move the auxiliary vector itself since it's pinned to
+	 * mm_struct, but it permits filling the vector with new values.  It's
+	 * up to the caller to provide sane values here, otherwise userspace
+	 * tools which use this vector might be unhappy.
 	 */
 	unsigned long user_auxv[AT_VECTOR_SIZE];
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
s390-mm-change-hpage_shift-type-to-int.patch
zswap-runtime-enable-disable.patch
prctl-more-prctlpr_set_mm_-checks.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch removed from -mm tree
Date: Fri, 07 Oct 2016 16:38:13 -0700
Message-ID: <57f831e5.+5vCgbvpmEtJk3sX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932776AbcJGXiN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:38:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wei.guo.simon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-check-against-vma-for-actual-mlock-size-fix
has been removed from the -mm tree.  Its filename was
     mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch

This patch was dropped because it was folded into mm-mlock-check-against-vma-for-actual-mlock-size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mlock-check-against-vma-for-actual-mlock-size-fix

clean up comment layout

Cc: Simon Guo <wei.guo.simon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/mlock.c~mm-mlock-check-against-vma-for-actual-mlock-size-fix mm/mlock.c
--- a/mm/mlock.c~mm-mlock-check-against-vma-for-actual-mlock-size-fix
+++ a/mm/mlock.c
@@ -678,12 +678,10 @@ static __must_check int do_mlock(unsigne
 	locked += current->mm->locked_vm;
 	if ((locked > lock_limit) && (!capable(CAP_IPC_LOCK))) {
 		/*
-		 * It is possible that the regions requested
-		 * intersect with previously mlocked areas,
-		 * that part area in "mm->locked_vm" should
-		 * not be counted to new mlock increment
-		 * count. So check and adjust locked count
-		 * if necessary.
+		 * It is possible that the regions requested intersect with
+		 * previously mlocked areas, that part area in "mm->locked_vm"
+		 * should not be counted to new mlock increment count. So check
+		 * and adjust locked count if necessary.
 		 */
 		locked -= count_mm_mlocked_page_nr(current->mm,
 				start, len);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mlock-check-against-vma-for-actual-mlock-size.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
a.patch


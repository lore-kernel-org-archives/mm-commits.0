Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66940EAE6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956991; cv=none; b=rqdb6t/6mJ61HYK06ogALHSn1WmQXG8g1Tr78jPDV77nFuK9T4h3OslN73ZUdner4fgfBVAXFE9wSHp8hXjZNBVdLpf6pBFNwaopMkFO1fR6dSJpzUe63L1uYhQkr2YX0LG1doBkTWrTfyNxtAxXWfODPRPhdmNmaynQYa6KRiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956991; c=relaxed/simple;
	bh=leiaYUa5XR8Ir1xLjc5NHSv0/XVVzd0yspjivaETPN8=;
	h=Date:To:From:Subject:Message-Id; b=RofCjJhrj9ECnkljFJLw1iYnvii5eZlZx4pa6b3nWfaOzywjYR/yfEAfMHMf1MtNObS5EWMwW0ddWcJoi0QfoCK7OFTYtxGBHzpPlNy3PVNgxx1PcPUbOjHlqdq+uwwP6APugnQeeIHCGq/Wyl5Inlj4ZUMTaCkDoM+VMiu5pOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UUoycGWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UUoycGWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF167C113CC;
	Mon,  6 May 2024 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956990;
	bh=leiaYUa5XR8Ir1xLjc5NHSv0/XVVzd0yspjivaETPN8=;
	h=Date:To:From:Subject:From;
	b=UUoycGWGATKkxFwJUAU5Ib9SXI8R3VCKoTKXdL5fQ4tOvfaKFqMTtymkVcD3NIX6D
	 5uGXs2Y7JDOOzHOOP9KovDzvca1j/T4Ub4gPmqfdyjOHRxnC67akCFxGIcFRV1BGlr
	 pBmFJ+IAGJkDgLIj69dBpbWL7PmWnm3kheUKvVEM=
Date: Sun, 05 May 2024 17:56:29 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,minchan@kernel.org,linmiaohe@huawei.com,hughd@google.com,david@redhat.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmswap-add-document-about-rcu-read-lock-and-swapoff-interaction.patch removed from -mm tree
Message-Id: <20240506005629.EF167C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,swap: add document about RCU read lock and swapoff interaction
has been removed from the -mm tree.  Its filename was
     mmswap-add-document-about-rcu-read-lock-and-swapoff-interaction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm,swap: add document about RCU read lock and swapoff interaction
Date: Sun, 7 Apr 2024 14:54:50 +0800

During reviewing a patch to fix the race condition between
free_swap_and_cache() and swapoff() [1], it was found that the document
about how to prevent racing with swapoff isn't clear enough.  Especially
RCU read lock can prevent swapoff from freeing data structures.  So, the
document is added as comments.

[1] https://lore.kernel.org/linux-mm/c8fe62d0-78b8-527a-5bef-ee663ccdc37a@huawei.com/

Link: https://lkml.kernel.org/r/20240407065450.498821-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/swapfile.c~mmswap-add-document-about-rcu-read-lock-and-swapoff-interaction
+++ a/mm/swapfile.c
@@ -1238,16 +1238,15 @@ static unsigned char __swap_entry_free_l
 
 /*
  * When we get a swap entry, if there aren't some other ways to
- * prevent swapoff, such as the folio in swap cache is locked, page
- * table lock is held, etc., the swap entry may become invalid because
- * of swapoff.  Then, we need to enclose all swap related functions
- * with get_swap_device() and put_swap_device(), unless the swap
- * functions call get/put_swap_device() by themselves.
+ * prevent swapoff, such as the folio in swap cache is locked, RCU
+ * reader side is locked, etc., the swap entry may become invalid
+ * because of swapoff.  Then, we need to enclose all swap related
+ * functions with get_swap_device() and put_swap_device(), unless the
+ * swap functions call get/put_swap_device() by themselves.
  *
- * Note that when only holding the PTL, swapoff might succeed immediately
- * after freeing a swap entry. Therefore, immediately after
- * __swap_entry_free(), the swap info might become stale and should not
- * be touched without a prior get_swap_device().
+ * RCU reader side lock (including any spinlock) is sufficient to
+ * prevent swapoff, because synchronize_rcu() is called in swapoff()
+ * before freeing data structures.
  *
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
@@ -2544,10 +2543,11 @@ SYSCALL_DEFINE1(swapoff, const char __us
 
 	/*
 	 * Wait for swap operations protected by get/put_swap_device()
-	 * to complete.
-	 *
-	 * We need synchronize_rcu() here to protect the accessing to
-	 * the swap cache data structure.
+	 * to complete.  Because of synchronize_rcu() here, all swap
+	 * operations protected by RCU reader side lock (including any
+	 * spinlock) will be waited too.  This makes it easy to
+	 * prevent folio_test_swapcache() and the following swap cache
+	 * operations from racing with swapoff.
 	 */
 	percpu_ref_kill(&p->users);
 	synchronize_rcu();
_

Patches currently in -mm which might be from ying.huang@intel.com are



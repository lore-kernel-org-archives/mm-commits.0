Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0674C1DA3A
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712603968; cv=none; b=vDLMHk9Cz5mNvHKTyHMruYkPz3IrI1940rq1OjF4fuwvtJX+eRbUAjb8yF46KsKWlcc+ReDYHm1/3Ly7zAUJPGvu2Spd7px7f1LRK1t6JcA9zvuicwrg0Lt0Q443Q5hkiG+7m4g+UyApIB4vziErTjQFKkdoiNFY8AI5kJ6EJgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712603968; c=relaxed/simple;
	bh=EBs78LyzeXIN1d5MwsgR1Cpj+oSuWXa77fHj+YToPkc=;
	h=Date:To:From:Subject:Message-Id; b=JPtXLRYxA1o+VT4g8zH12/3P//fk526+kadXAdjQ8mTZBkcsHGmOImwL1Chhl3LYxl1/8paeaqmjlAFLJGEMuRCy/Z69l1KqdWQbm2A92z8go8RXovzy84vzBcn/v/saHty3iyQj2VcrsuSgu0+pbaduLZjYJLEJ4Me6ODnBkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xz3PeXEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xz3PeXEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77C3C433C7;
	Mon,  8 Apr 2024 19:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712603967;
	bh=EBs78LyzeXIN1d5MwsgR1Cpj+oSuWXa77fHj+YToPkc=;
	h=Date:To:From:Subject:From;
	b=Xz3PeXEFY4x6CDf/SI/6Lae6Ri6tFZUsdVIq6f1/NiWgyO0NwUZ+d0x3qvTjTTFdd
	 aSF35zBL7K8iIsMVitvJXqqwhyTbajeryAa6qRcSBAmWFDUUWu+PmHI+hEir/MbuBt
	 FDqwAwBDYYirnXl9RlqnTdeeFgDFNzvEJpCBFJ+o=
Date: Mon, 08 Apr 2024 12:19:27 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,minchan@kernel.org,linmiaohe@huawei.com,hughd@google.com,david@redhat.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmswap-add-document-about-rcu-read-lock-and-swapoff-interaction.patch added to mm-unstable branch
Message-Id: <20240408191927.A77C3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,swap: add document about RCU read lock and swapoff interaction
has been added to the -mm mm-unstable branch.  Its filename is
     mmswap-add-document-about-rcu-read-lock-and-swapoff-interaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmswap-add-document-about-rcu-read-lock-and-swapoff-interaction.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Miaohe Lin <linmiaohe@huawei.com>
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
@@ -2531,10 +2530,11 @@ SYSCALL_DEFINE1(swapoff, const char __us
 
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

mmswap-add-document-about-rcu-read-lock-and-swapoff-interaction.patch


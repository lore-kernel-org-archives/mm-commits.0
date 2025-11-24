Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C7527A123
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025882; cv=none; b=iWObxvj280wD1yxd9UzI4byQTyXZAfbFP0qB8VCs9IZ8NuXSLqMqrOkJT3BdqjBMf5CAOJdH2lTH4AmsiBuZBE6HGsDdbKhIKIMXQUwqdo0SePluHfu1PMYWtTpkbhX9AmVVtE7+RdbDRdp7n18esGhVnhsXidQucz2jt5YzgGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025882; c=relaxed/simple;
	bh=SYCUiQHJlIKygUqk/nhJXfAwQH6TX9rfkJL3TVNIapo=;
	h=Date:To:From:Subject:Message-Id; b=obr59PffYuWhJplGZLS+LTLrzsL7ybnfPxX+4Xzol7/aQD82wIAXk9mmEv9xPsNPAQwjMy+R7c55j4CO6Jrh6qv1Bwm8OOXP8UxByebYjQYSRSU5hpSBxr9EGZdsP9LukOpiXV6sLyPrpWo1oWHilCgBbl178T+SPzKXzC/6JYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Io3gPWJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Io3gPWJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56263C4CEF1;
	Mon, 24 Nov 2025 23:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025882;
	bh=SYCUiQHJlIKygUqk/nhJXfAwQH6TX9rfkJL3TVNIapo=;
	h=Date:To:From:Subject:From;
	b=Io3gPWJGhuYPkwRw71nhr0ec6d+ntDce/P9aokBY6NRvhJHI+DcMWYlDmWtBF6C4U
	 YFr8yavdoaspdJDNMDY0pndzC01UE0CScj8L1OzLKPqNTgCdo0haMbLloMYw5J0pOf
	 HLcB5nif2/s0X/F6pmZaG065OEQLlKMsN1sYveyw=
Date: Mon, 24 Nov 2025 15:11:21 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-scan_swap_map_slots-references-from-comments.patch removed from -mm tree
Message-Id: <20251124231122.56263C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: remove scan_swap_map_slots() references from comments
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm: swap: remove scan_swap_map_slots() references from comments
Date: Fri, 31 Oct 2025 15:50:11 +0900

The scan_swap_map_slots() helper has been removed, but several comments
still referred to it in swap allocation and reclaim paths.  This patch
cleans up those outdated references and reflows the affected comment
blocks to match kernel coding style.

Link: https://lkml.kernel.org/r/20251031065011.40863-6-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-scan_swap_map_slots-references-from-comments
+++ a/mm/swapfile.c
@@ -236,11 +236,10 @@ again:
 	ret = -nr_pages;
 
 	/*
-	 * When this function is called from scan_swap_map_slots() and it's
-	 * called by vmscan.c at reclaiming folios. So we hold a folio lock
-	 * here. We have to use trylock for avoiding deadlock. This is a special
-	 * case and you should use folio_free_swap() with explicit folio_lock()
-	 * in usual operations.
+	 * We hold a folio lock here. We have to use trylock for
+	 * avoiding deadlock. This is a special case and you should
+	 * use folio_free_swap() with explicit folio_lock() in usual
+	 * operations.
 	 */
 	if (!folio_trylock(folio))
 		goto out;
@@ -1365,14 +1364,13 @@ start_over:
 		spin_lock(&swap_avail_lock);
 		/*
 		 * if we got here, it's likely that si was almost full before,
-		 * and since scan_swap_map_slots() can drop the si->lock,
 		 * multiple callers probably all tried to get a page from the
 		 * same si and it filled up before we could get one; or, the si
-		 * filled up between us dropping swap_avail_lock and taking
-		 * si->lock. Since we dropped the swap_avail_lock, the
-		 * swap_avail_head list may have been modified; so if next is
-		 * still in the swap_avail_head list then try it, otherwise
-		 * start over if we have not gotten any slots.
+		 * filled up between us dropping swap_avail_lock.
+		 * Since we dropped the swap_avail_lock, the swap_avail_list
+		 * may have been modified; so if next is still in the
+		 * swap_avail_head list then try it, otherwise start over if we
+		 * have not gotten any slots.
 		 */
 		if (plist_node_empty(&next->avail_list))
 			goto start_over;
_

Patches currently in -mm which might be from youngjun.park@lge.com are



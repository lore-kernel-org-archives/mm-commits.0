Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8305854FAD
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 23:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723763320; cv=none; b=JT3XuSRAcVst1kngQ7l1BIt5QVZX1+mFtUF6HHCBOYWrgb6aBhj1N8P+joknKbkQ6Ih7BKvZnxTG8yzR+oP890HvrByl5BOhPD3qnx44FnCCKLiGTdOEXPa42JoUmjRZKipxJ3XZJ7UNqpIlcv0KhlZ5CdpV9TiG7h6Akpsz0hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723763320; c=relaxed/simple;
	bh=L1HyezewLT9/x3tuw2ue72cJIEq1oufCgD0U+HSP/8Q=;
	h=Date:To:From:Subject:Message-Id; b=GbnmR9aIyr46SmI3JuljK8gwxJKwpIuxhcHQsmrMt2NFdlqaTX7XorBR1l5VVF9cxDsPyDGvgFK89libYsA/eqNKvFsPEtBMnl4pKeo2cK8CsDU3GwZKRUF/NHyDSGQZ1V8UXnQvRq09uzMMMBo5OeiEERkkqSdv7471ttzZ3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfNwf1q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfNwf1q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00992C32786;
	Thu, 15 Aug 2024 23:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723763320;
	bh=L1HyezewLT9/x3tuw2ue72cJIEq1oufCgD0U+HSP/8Q=;
	h=Date:To:From:Subject:From;
	b=bfNwf1q8ALPE/vTdQtE1uX48vtctw1jpRZ86sNZ8VORwIPgnKya1oCTp7g3LSFC37
	 HoIhBxZf52tljedJzsth3fbiPL71XMYBk7YK0rUOqWyke/zqcwin0w2LgfbksMgKWt
	 jnamPHm/MfHGfgqv0F3kkbmxVcOLDEOuqkA7Fw98=
Date: Thu, 15 Aug 2024 16:08:39 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch removed from -mm tree
Message-Id: <20240815230840.00992C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-introduce-a-pageflag-for-partially-mapped-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-introduce-a-pageflag-for-partially-mapped-folios-fix
Date: Wed, 14 Aug 2024 13:36:58 +0100

fix MTHP_STAT_SPLIT_DEFERRED for PMD_ORDER

Link: https://lkml.kernel.org/r/88d411c5-6d66-4d41-ae86-e0f943e5fb91@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++++++++--------
 mm/rmap.c        |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/mm/huge_memory.c
@@ -3452,6 +3452,7 @@ void __folio_undo_large_rmappable(struct
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
 
+/* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
@@ -3481,16 +3482,16 @@ void deferred_split_folio(struct folio *
 		return;
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	if (partially_mapped)
+	if (partially_mapped) {
 		folio_set_partially_mapped(folio);
-	else
-		folio_clear_partially_mapped(folio);
+		if (folio_test_pmd_mappable(folio))
+			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
+	} else {
+		/* partially mapped folios cannont become partially unmapped */
+		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
+	}
 	if (list_empty(&folio->_deferred_list)) {
-		if (partially_mapped) {
-			if (folio_test_pmd_mappable(folio))
-				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
-			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
-		}
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
--- a/mm/rmap.c~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/mm/rmap.c
@@ -1578,7 +1578,7 @@ static __always_inline void __folio_remo
 	 * Check partially_mapped first to ensure it is a large folio.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    list_empty(&folio->_deferred_list))
+	    !folio_test_partially_mapped(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix.patch
mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underutilized-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch


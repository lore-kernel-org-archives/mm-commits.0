Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F9EC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjASBQt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjASBPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836744347D
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B228B81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF411C433EF;
        Thu, 19 Jan 2023 01:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090866;
        bh=azvTZQ5bCYBpvyn0unPZAz5GbWTdIup/L3MC3DwAfT4=;
        h=Date:To:From:Subject:From;
        b=n0AuRAb3M3lyXoz1ekRVJGTnRDVFoJKo2zffxBFWkr0Nc/aZCBo7jChI/mqmpa3A/
         1XaQkdaEPCl/SXLi4QJFw+qDr5RWVRDDa/ag62LwBHbPSNiXsOKxG125deyqM1p3Ps
         8npj8O/gbtWIx9tfvTRWsYsZVMvCiGSwqEfB+opw=
Date:   Wed, 18 Jan 2023 17:14:26 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hughd@google.com, hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-lock_page_memcg.patch removed from -mm tree
Message-Id: <20230119011426.CF411C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: remove lock_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-lock_page_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: rmap: remove lock_page_memcg()
Date: Tue, 6 Dec 2022 18:13:40 +0100

The previous patch made sure charge moving only touches pages for which
page_mapped() is stable.  lock_page_memcg() is no longer needed.

Link: https://lkml.kernel.org/r/20221206171340.139790-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-lock_page_memcg
+++ a/mm/rmap.c
@@ -1222,9 +1222,6 @@ void page_add_anon_rmap(struct page *pag
 	bool compound = flags & RMAP_COMPOUND;
 	bool first = true;
 
-	if (unlikely(PageKsm(page)))
-		lock_page_memcg(page);
-
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
 		first = atomic_inc_and_test(&page->_mapcount);
@@ -1262,15 +1259,14 @@ void page_add_anon_rmap(struct page *pag
 	if (nr)
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 
-	if (unlikely(PageKsm(page)))
-		unlock_page_memcg(page);
-
-	/* address might be in next vma when migration races vma_adjust */
-	else if (first)
-		__page_set_anon_rmap(page, vma, address,
-				     !!(flags & RMAP_EXCLUSIVE));
-	else
-		__page_check_anon_rmap(page, vma, address);
+	if (likely(!PageKsm(page))) {
+		/* address might be in next vma when migration races vma_adjust */
+		if (first)
+			__page_set_anon_rmap(page, vma, address,
+					     !!(flags & RMAP_EXCLUSIVE));
+		else
+			__page_check_anon_rmap(page, vma, address);
+	}
 
 	mlock_vma_page(page, vma, compound);
 }
@@ -1329,7 +1325,6 @@ void page_add_file_rmap(struct page *pag
 	bool first;
 
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
-	lock_page_memcg(page);
 
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
@@ -1365,7 +1360,6 @@ void page_add_file_rmap(struct page *pag
 			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
 	if (nr)
 		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
-	unlock_page_memcg(page);
 
 	mlock_vma_page(page, vma, compound);
 }
@@ -1394,8 +1388,6 @@ void page_remove_rmap(struct page *page,
 		return;
 	}
 
-	lock_page_memcg(page);
-
 	/* Is page being unmapped by PTE? Is this its last map to be removed? */
 	if (likely(!compound)) {
 		last = atomic_add_negative(-1, &page->_mapcount);
@@ -1451,8 +1443,6 @@ void page_remove_rmap(struct page *page,
 	 * and remember that it's only reliable while mapped.
 	 */
 
-	unlock_page_memcg(page);
-
 	munlock_vma_page(page, vma, compound);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663333BA24F
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068068; cv=none; b=t4hMKcWC4rVZKad8pfnSzrsuJpLY68zelpN6RGKQGba/hw1wTqdVIw7rKSckgadbuPYhWAp4KomLexJ4r2nPUY6vX6DsjR3TwrtyP0uWQ4PhGbrKnOu3xdLgs4popAs9FcTddTAyxgftXr4ynoDP+WQUcXFcZXXDOA/ZiSRMYU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068068; c=relaxed/simple;
	bh=hld7Xr/uoOtH9hlXHBOPCHzW7oFTusRu1Q7WoElMGmk=;
	h=Date:To:From:Subject:Message-Id; b=fB0yRbCd+xjODCQy0SicfNl2Lx75SwQHWOwT+wwajUuQjirIgN7OSk8ptTVli90OEQ4dz2IGtuAM5oYmtlY/23iMRnZRt4fC0FXF7xDeBlWrrr71nniGa2YpMEDGC9jbUoMNfSw0S2DQdUkvcP0Mruw+3CnXWejMc/PSmzrqXac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ym9CPdYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ym9CPdYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA3F1F00A3A;
	Fri,  7 Aug 2026 02:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068061;
	bh=OvGRMHrsv3VaoeCJvcZ6yr6qsQWTJdOXhIvB/VzonmY=;
	h=Date:To:From:Subject;
	b=ym9CPdYivwBgCWxYMSOUOqcYisT0hpVRYTxLWHHisASfZ6dtDr+sOzVkCla3b0qnQ
	 6xu0nNTFpbybwsWzHs1cTnsbXdpQbOLMKAtZuZ44upwQcJrihoUCNjpar7H7dbAWJa
	 oREKYuuvXhiEZ86fz8rRrfTTR7nEjhoWBOnKnIUc=
Date: Thu, 06 Aug 2026 19:01:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wang.yaxin@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,qi.zheng@linux.dev,npache@redhat.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch removed from -mm tree
Message-Id: <20260807020101.6FA3F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_slot.h: add comments for mm_slot_lookup/insert
has been removed from the -mm tree.  Its filename was
     mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: mm/mm_slot.h: add comments for mm_slot_lookup/insert
Date: Tue, 14 Jul 2026 09:28:15 +0800 (CST)

mm_slot_lookup() and mm_slot_insert() are the only helpers in this header
that are implemented as macros rather than static inline functions.  This
may look inconsistent without explanation.

Explain they must be macros because hash_for_each_possible() needs the
table as an array (for sizeof), not a pointer.

Link: https://lore.kernel.org/20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_slot.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/mm_slot.h~mm-mm_sloth-add-comments-for-mm_slot_lookup-insert
+++ a/mm/mm_slot.h
@@ -33,6 +33,12 @@ static inline void mm_slot_free(struct k
 	kmem_cache_free(cache, objp);
 }
 
+/*
+ * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
+ * functions because the hash helpers (hash_for_each_possible and hash_add) rely
+ * on the actual array argument 'hashtable' for sizeof() instead of pointers.
+ */
+
 #define mm_slot_lookup(_hashtable, _mm) 				       \
 ({									       \
 	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are



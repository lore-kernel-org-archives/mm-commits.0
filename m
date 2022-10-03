Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF99CC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJCVEa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJCVEa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E7631EF5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 084BC610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55977C433D6;
        Mon,  3 Oct 2022 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831068;
        bh=bSWpoWiAOsiOWhNQAvM/ql6q3GGU9zFmpAnFrG9PpZA=;
        h=Date:To:From:Subject:From;
        b=1Y0wuibae5OPGCDMV07XH963YLFtBBTFHA1yHsBc7Wuy5ZhYQPSZZuNgCWTu/JwTY
         4TJHBKEYDP86Ti1dZHMbRlejcjpPmyZyrgJCb7GWGHhxgOkKdVnScTA5BozmCbOpos
         lHLfWb+0cXD9xk2InjAjZ8Axpq5gIKpihy5N0UxI=
Date:   Mon, 03 Oct 2022 14:04:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-common-struct-mm_slot.patch removed from -mm tree
Message-Id: <20221003210428.55977C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce common struct mm_slot
has been removed from the -mm tree.  Its filename was
     mm-introduce-common-struct-mm_slot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: introduce common struct mm_slot
Date: Wed, 31 Aug 2022 11:19:45 +0800

Patch series "add common struct mm_slot and use it in THP and KSM", v2.

At present, both THP and KSM module have similar structures mm_slot for
organizing and recording the information required for scanning mm, and
each defines the following exactly the same operation functions:

 - alloc_mm_slot
 - free_mm_slot
 - get_mm_slot
 - insert_to_mm_slots_hash

In order to de-duplicate these codes, this patchset introduces a common
struct mm_slot, and lets THP and KSM to use it.


This patch (of 7):

At present, both THP and KSM module have similar structures mm_slot for
organizing and recording the information required for scanning mm, and
each defines the following exactly the same operation functions:

 - alloc_mm_slot
 - free_mm_slot
 - get_mm_slot
 - insert_to_mm_slots_hash

In order to de-duplicate these codes, this patch introduces a common
struct mm_slot, and subsequent patches will let THP and KSM to use it.

Link: https://lkml.kernel.org/r/20220831031951.43152-1-zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/20220831031951.43152-2-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_slot.h |   55 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- /dev/null
+++ a/mm/mm_slot.h
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifndef _LINUX_MM_SLOT_H
+#define _LINUX_MM_SLOT_H
+
+#include <linux/hashtable.h>
+#include <linux/slab.h>
+
+/*
+ * struct mm_slot - hash lookup from mm to mm_slot
+ * @hash: link to the mm_slots hash list
+ * @mm_node: link into the mm_slots list
+ * @mm: the mm that this information is valid for
+ */
+struct mm_slot {
+	struct hlist_node hash;
+	struct list_head mm_node;
+	struct mm_struct *mm;
+};
+
+#define mm_slot_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+static inline void *mm_slot_alloc(struct kmem_cache *cache)
+{
+	if (!cache)	/* initialization failed */
+		return NULL;
+	return kmem_cache_zalloc(cache, GFP_KERNEL);
+}
+
+static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
+{
+	kmem_cache_free(cache, objp);
+}
+
+#define mm_slot_lookup(_hashtable, _mm) 				       \
+({									       \
+	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \
+									       \
+	hash_for_each_possible(_hashtable, tmp_slot, hash, (unsigned long)_mm) \
+		if (_mm == tmp_slot->mm) {				       \
+			mm_slot = tmp_slot;				       \
+			break;						       \
+		}							       \
+									       \
+	mm_slot;							       \
+})
+
+#define mm_slot_insert(_hashtable, _mm, _mm_slot)			       \
+({									       \
+	_mm_slot->mm = _mm;						       \
+	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
+})
+
+#endif /* _LINUX_MM_SLOT_H */
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-use-update_mmu_tlb-on-the-second-thread.patch
loongarch-update-local-tlb-if-pte-entry-exists.patch


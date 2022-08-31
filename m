Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F1DECAAD4
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 23:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiHaXO3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 19:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiHaXO1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 19:14:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFE9F8FEA
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 16:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D112CB823BF
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 23:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76250C433D6;
        Wed, 31 Aug 2022 23:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661987663;
        bh=t5vIrOqd8UmH38HXZZpOG4e8V0UnOgMxLoKimqA6D3M=;
        h=Date:To:From:Subject:From;
        b=oVFnm8cHSzRkAAUvkxaSdRzVpy2UI3FDZx2U97Q/kn0NYhntV9oR+KeG8j9D48mJu
         VeXX5WhKWgIFm8MIPTYQ7FTEtV2zNFOkYQd4rxE20MSouOZXCKeJPKNWRekEwg19tT
         2lQY0myCOWZPqV0IFqivlnYNgb2IR2wh+R3bgM5c=
Date:   Wed, 31 Aug 2022 16:14:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-common-struct-mm_slot.patch added to mm-unstable branch
Message-Id: <20220831231423.76250C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce common struct mm_slot
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-common-struct-mm_slot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-common-struct-mm_slot.patch

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

mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch
mm-introduce-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot.patch
ksm-remove-redundant-declarations-in-ksmh.patch
ksm-add-the-ksm-prefix-to-the-names-of-the-ksm-private-structures.patch
ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch
ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch
ksm-convert-to-use-common-struct-mm_slot.patch


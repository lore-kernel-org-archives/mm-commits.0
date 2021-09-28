Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6A0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CDE2611EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbhI1A2W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238343AbhI1A2S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 20:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B356460EE5;
        Tue, 28 Sep 2021 00:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632788799;
        bh=1S2WDGAdYDUbFlxklH/NpTqzE2aFwg1c2y+r2yI8jW8=;
        h=Date:From:To:Subject:From;
        b=zLveFdLxmr1gJS0KQxst670wq2TDaWt3dBH9Drv1rbBYWn5Gfk54DbWTORW1VDBeU
         Pk7PRPIkxox/7AcOtQxONiZZbAbuBGg5ruPaYuN6eJ2uAiF7X3TTZkBL8XZlP4DZSs
         4ReHpQy/+s+/GCrYmzR2S8ELRTF7YQ1D+dsBxBo0=
Date:   Mon, 27 Sep 2021 17:26:38 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shakeelb@google.com,
        vbabka@suse.cz, wangkefeng.wang@huawei.com, willy@infradead.org
Subject:  + slub-add-back-check-for-free-nonslab-objects.patch
 added to -mm tree
Message-ID: <20210928002638.T8tBjzIKr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: add back check for free nonslab objects
has been added to the -mm tree.  Its filename is
     slub-add-back-check-for-free-nonslab-objects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-add-back-check-for-free-nonslab-objects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-add-back-check-for-free-nonslab-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: slub: add back check for free nonslab objects

After commit ("f227f0faf63b slub: fix unreclaimable slab stat for bulk
free"), the check for free nonslab page is replaced by VM_BUG_ON_PAGE,
which only check with CONFIG_DEBUG_VM enabled, but this config may impact
performance, so it only for debug.

Commit ("0937502af7c9 slub: Add check for kfree() of non slab objects.")
add the ability, which should be needed in any configs to catch the
invalid free, they even could be potential issue, eg, memory corruption,
use after free and double-free, so replace VM_BUG_ON_PAGE to WARN_ON, add
dump_page() and object address printing to help use to debug the issue.

Link: https://lkml.kernel.org/r/20210927122646.91934-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rienjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/slub.c~slub-add-back-check-for-free-nonslab-objects
+++ a/mm/slub.c
@@ -3522,7 +3522,11 @@ static inline void free_nonslab_page(str
 {
 	unsigned int order = compound_order(page);
 
-	VM_BUG_ON_PAGE(!PageCompound(page), page);
+	if (WARN_ON(!PageCompound(page))) {
+		dump_page(page, "invalid free nonslab page");
+		pr_warn("object pointer: 0x%p\n", object);
+	}
+
 	kfree_hook(object);
 	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
 	__free_pages(page, order);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

slub-add-back-check-for-free-nonslab-objects.patch
mm-nommu-kill-arch_get_unmapped_area.patch


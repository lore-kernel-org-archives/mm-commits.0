Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DE3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9AA61A02
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhI3V2z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhI3V2z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 17:28:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE360615A2;
        Thu, 30 Sep 2021 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633037232;
        bh=qmwTXTMNVXvvqDYnuJ0QZZWCOVzNqcAbgxnIzcg4+Ug=;
        h=Date:From:To:Subject:From;
        b=pWHuaNBzDYAbk+YaLeWOLXQOQRDsObFvMOy1GQb9zIhHWhVcXhsliqy1frg80dTVa
         c65s6W6H05Eg8y/7Z8EtaWPnbMG2rQuua4WtgYielvcROrQ9AfrgaUv/i/VSgh8Fhm
         go5bXDWKXIN38TOSECFKl+HkrBqXhN2Rtfmo5F8k=
Date:   Thu, 30 Sep 2021 14:27:11 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shakeelb@google.com,
        vbabka@suse.cz, wangkefeng.wang@huawei.com, willy@infradead.org
Subject:  + slub-add-back-check-for-free-nonslab-objects.patch
 added to -mm tree
Message-ID: <20210930212711.RLqzKyaA-%akpm@linux-foundation.org>
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
use after free and double free, so replace VM_BUG_ON_PAGE to WARN_ON_ONCE,
add object address printing to help use to debug the issue.

Link: https://lkml.kernel.org/r/20210930070214.61499-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rienjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c~slub-add-back-check-for-free-nonslab-objects
+++ a/mm/slub.c
@@ -3522,7 +3522,9 @@ static inline void free_nonslab_page(str
 {
 	unsigned int order = compound_order(page);
 
-	VM_BUG_ON_PAGE(!PageCompound(page), page);
+	if (WARN_ON_ONCE(!PageCompound(page)))
+		pr_warn_once("object pointer: 0x%p\n", object);
+
 	kfree_hook(object);
 	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
 	__free_pages(page, order);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

slub-add-back-check-for-free-nonslab-objects.patch
mm-nommu-kill-arch_get_unmapped_area.patch
kallsyms-remove-arch-specific-text-and-data-check.patch
kallsyms-fix-address-checks-for-kernel-related-range.patch
sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch
sections-move-is_kernel_inittext-into-sectionsh.patch
x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch
sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
mm-kasan-use-is_kernel-helper.patch
extable-use-is_kernel_text-helper.patch
powerpc-mm-use-core_kernel_text-helper.patch
microblaze-use-is_kernel_text-helper.patch
alpha-use-is_kernel_text-helper.patch


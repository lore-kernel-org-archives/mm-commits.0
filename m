Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D7CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5BBD20792
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595563758;
	bh=Cjw7N6UXlRQiPas/n/owXX19G2OH9+xQ6u8AOJ2V2fk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YxedyfiV0AF8OCRG1pekF+TG/k7wq5K7Cwe9xvqIj+MGBr/whs6qR37k7ysjrKLKH
	 fKO59wto+MikyS1fHQdtOiiK/wBmpJIkS20wt8oRYb52UPhG2tn6JSfXhzkNOStowv
	 7V1PPeKZb92IsibMKy4q/giJZh1gQTDuYqR7CoK4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgGXEJS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGXEJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:09:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8993320709;
        Fri, 24 Jul 2020 04:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595563757;
        bh=Cjw7N6UXlRQiPas/n/owXX19G2OH9+xQ6u8AOJ2V2fk=;
        h=Date:From:To:Subject:From;
        b=idIn5AZO4sJDn9x+hZyz0GtvZi9oFzZJU9ZEsl0GvTyQNjVTR3krfPxpZK4nHrmuY
         nLZsf3sewEn9mtsKq9ETZKB9X2pDjxZLdQQqpnU2oTe8hcMIIXEkrQnDRd2p+Fddg2
         aJTgRvyFZlA4G8SFNaPLKONFyBpQI9IozAt3dqJA=
Date:   Thu, 23 Jul 2020 21:09:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jannh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, vbabka@suse.cz, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [folded-merged]
 mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch removed
 from -mm tree
Message-ID: <20200724040917.zCTggwUue%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-close-race-between-munmap-and-expand_upwards-downwards-fix
has been removed from the -mm tree.  Its filename was
     mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch

This patch was dropped because it was folded into mm-close-race-between-munmap-and-expand_upwards-downwards.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-close-race-between-munmap-and-expand_upwards-downwards-fix

s/mmap_sem/mmap_lock/ in comment

Cc: Jann Horn <jannh@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-close-race-between-munmap-and-expand_upwards-downwards-fix
+++ a/mm/mmap.c
@@ -2647,9 +2647,9 @@ detach_vmas_to_be_unmapped(struct mm_str
 	vmacache_invalidate(mm);
 
 	/*
-	 * Do not downgrade mmap_sem if we are next to VM_GROWSDOWN or
+	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
 	 * VM_GROWSUP VMA. Such VMAs can change their size under
-	 * down_read(mmap_sem) and collide with the VMA we are about to unmap.
+	 * down_read(mmap_lock) and collide with the VMA we are about to unmap.
 	 */
 	if (vma && (vma->vm_flags & VM_GROWSDOWN))
 		return false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards.patch
mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
revert-revert-mm-vmalloc-modify-struct-vmap_area-to-reduce-its-size.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch


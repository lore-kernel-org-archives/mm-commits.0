Return-Path: <SRS0=RNAI=BY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FB4C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 23:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5254F20774
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 23:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597446426;
	bh=OHDhETSAck9+q+xeox3W+Qxx3rz/242qgd4A8UyYZHo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=U5vrt3HwlwPTc1tIJppQ+tP22npstdX+og5RBzUzmQiO6yG2bi8kj+RN5/JhdvjF+
	 6izXZCSXPlZ8pcJYCQ7iqHYvfB8O9IReUrkB3dnPeGDrh/otSv3VaoKSpDfidWLKuG
	 cHEYteXvuRO+/2nRpfHz27Zh50YAkP7bpy59d68w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgHNXHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 19:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgHNXHF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 19:07:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B6C20771;
        Fri, 14 Aug 2020 23:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597446425;
        bh=OHDhETSAck9+q+xeox3W+Qxx3rz/242qgd4A8UyYZHo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WCUxQ5IEbHriqzmXwh1/ibnpm26nPEBy/HIdDGm8r9FxKh7rtARJTb3mDPkwqitDJ
         0Ech0DE7SrcTiYbQATrwL2U++Q8nP0E4Q4LciAoHJ4Upoq+rpK8juK+8QAtp5r7vDI
         R/icsQKXNuHwL2ij1b47wZzYAV7ioBzFmuw81vyk=
Date:   Fri, 14 Aug 2020 16:07:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dan.j.williams@intel.com, edumazet@google.com, hch@lst.de,
        hughd@google.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [merged]
 dma-debug-fix-debug_dma_assert_idle-use-rcu_read_lock.patch removed from
 -mm tree
Message-ID: <20200814230704.sIbCgKdfs%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: fix debug_dma_assert_idle(), use rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     dma-debug-fix-debug_dma_assert_idle-use-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: dma-debug: fix debug_dma_assert_idle(), use rcu_read_lock()

Since commit 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common() logic")
improved unlock_page(), it has become more noticeable how cow_user_page()
in a kernel with CONFIG_DMA_API_DEBUG=y can create and suffer from heavy
contention on DMA debug's radix_lock in debug_dma_assert_idle().

It is only doing a lookup: use rcu_read_lock() and rcu_read_unlock()
instead; though that does require the static ents[] to be moved onstack...

...but, hold on, isn't that radix_tree_gang_lookup() and loop doing quite
the wrong thing: searching CACHELINES_PER_PAGE entries for an exact match
with the first cacheline of the page in question? 
radix_tree_gang_lookup() is the right tool for the job, but we need
nothing more than to check the first entry it can find, reporting if that
falls anywhere within the page.

(Is RCU safe here?  As safe as using the spinlock was.  The entries are
never freed, so don't need to be freed by RCU.  They may be reused, and
there is a faint chance of a race, with an offending entry reused while
printing its error info; but the spinlock did not prevent that either, and
I agree that it's not worth worrying about.)

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008122005240.11996@eggly.anvils
Fixes: 3b7a6418c749 ("dma debug: account for cachelines and read-only mappings in overlap tracking")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/debug.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/kernel/dma/debug.c~dma-debug-fix-debug_dma_assert_idle-use-rcu_read_lock
+++ a/kernel/dma/debug.c
@@ -565,11 +565,8 @@ static void active_cacheline_remove(stru
  */
 void debug_dma_assert_idle(struct page *page)
 {
-	static struct dma_debug_entry *ents[CACHELINES_PER_PAGE];
-	struct dma_debug_entry *entry = NULL;
-	void **results = (void **) &ents;
-	unsigned int nents, i;
-	unsigned long flags;
+	struct dma_debug_entry *entry;
+	unsigned long pfn;
 	phys_addr_t cln;
 
 	if (dma_debug_disabled())
@@ -578,20 +575,14 @@ void debug_dma_assert_idle(struct page *
 	if (!page)
 		return;
 
-	cln = (phys_addr_t) page_to_pfn(page) << CACHELINE_PER_PAGE_SHIFT;
-	spin_lock_irqsave(&radix_lock, flags);
-	nents = radix_tree_gang_lookup(&dma_active_cacheline, results, cln,
-				       CACHELINES_PER_PAGE);
-	for (i = 0; i < nents; i++) {
-		phys_addr_t ent_cln = to_cacheline_number(ents[i]);
+	pfn = page_to_pfn(page);
+	cln = (phys_addr_t) pfn << CACHELINE_PER_PAGE_SHIFT;
 
-		if (ent_cln == cln) {
-			entry = ents[i];
-			break;
-		} else if (ent_cln >= cln + CACHELINES_PER_PAGE)
-			break;
-	}
-	spin_unlock_irqrestore(&radix_lock, flags);
+	rcu_read_lock();
+	if (!radix_tree_gang_lookup(&dma_active_cacheline, (void **) &entry,
+				    cln, 1) || entry->pfn != pfn)
+		entry = NULL;
+	rcu_read_unlock();
 
 	if (!entry)
 		return;
_

Patches currently in -mm which might be from hughd@google.com are

khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch


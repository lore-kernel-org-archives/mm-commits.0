Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64169C433B4
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 20:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 090EA613CC
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 20:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbhDFUF0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:05:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:50240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234411AbhDFUF0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Apr 2021 16:05:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F052DAF98;
        Tue,  6 Apr 2021 20:05:16 +0000 (UTC)
Date:   Tue, 6 Apr 2021 22:05:14 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     akpm@linux-foundation.org
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, david@redhat.com,
        hpa@zytor.com, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, ziy@nvidia.com, rdunlap@infradead.org
Subject: Re: + x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch added to
 -mm tree
Message-ID: <YGy++mSft7K4u+88@localhost.localdomain>
References: <20210310225856.PQWfPyaE4%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310225856.PQWfPyaE4%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Mar 10, 2021 at 02:58:56PM -0800, akpm@linux-foundation.org wrote:
> ------------------------------------------------------
> From: Oscar Salvador <osalvador@suse.de>
> Subject: x86/vmemmap: handle unpopulated sub-pmd ranges
> 
> When sizeof(struct page) is not a power of 2, sections do not span a PMD
> anymore and so when populating them some parts of the PMD will remain
> unused.
> 
> Because of this, PMDs will be left behind when depopulating sections since
> remove_pmd_table() thinks that those unused parts are still in use.
> 
> Fix this by marking the unused parts with PAGE_UNUSED, so memchr_inv()
> will do the right thing and will let us free the PMD when the last user of
> it is gone.
> 
> This patch is based on a similar patch by David Hildenbrand:
> 
> https://lore.kernel.org/linux-mm/20200722094558.9828-9-david@redhat.com/
> 
> Link: https://lkml.kernel.org/r/20210309214050.4674-4-osalvador@suse.de
> Signed-off-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew,

Could you squash the following on top?
It seems that we need to go back to the ifdef version as the IS_ENABLED
does not properly work and throws a warning.

Thanks a lot

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 13187a3debe9..bbef99622370 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1123,15 +1123,16 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
-			} else if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
-				   vmemmap_pmd_is_unused(addr, next)) {
+			}
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+			else if (vmemmap_pmd_is_unused(addr, next)) {
 					free_hugepage_table(pmd_page(*pmd),
 							    altmap);
 					spin_lock(&init_mm.page_table_lock);
 					pmd_clear(pmd);
 					spin_unlock(&init_mm.page_table_lock);
 			}
-
+#endif
 			continue;
 		}




-- 
Oscar Salvador
SUSE L3

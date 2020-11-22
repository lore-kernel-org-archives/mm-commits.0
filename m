Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38770C56201
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D60222078B
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:11:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bMWv4ql1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgKVGLH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Nov 2020 01:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgKVGLG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Nov 2020 01:11:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D23462078B;
        Sun, 22 Nov 2020 06:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606025466;
        bh=oWPiRvmkIlplBT5LtCcfyg0fr0BToJJO2S7V+Wr/HoM=;
        h=Date:From:To:Subject:From;
        b=bMWv4ql1ls1R1s/hp2YY5wZqgDTMZpC+eOApEIaDbRYD913kB74AJF29NHuUiej/3
         FJCY8ygHXZC7/DNIug7iAq8MbUxGi5XcO05QUxmSuD5wE4ovFsrC+/xRmamDzImz94
         ZFGnVjWvz1SYxv81+ZRzBa9w9puFxDV+bnLy8tig=
Date:   Sat, 21 Nov 2020 22:11:05 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, dan.j.williams@intel.com,
        fenghua.yu@intel.com, hch@infradead.org, hch@lst.de,
        joao.m.martins@oracle.com, lkp@intel.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        tony.luck@intel.com, vishal.l.verma@intel.com
Subject:  [folded-merged]
 mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch
 removed from -mm tree
Message-ID: <20201122061105.6gE3ylmvK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4
has been removed from the -mm tree.  Its filename was
     mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch

This patch was dropped because it was folded into mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4

(Stephen) PowerPC header include dependencies make it difficult to include
asm/sparsemem.h in linux/numa.h due to missing definition of pgprot.  Move
the declaration of create_section_mapping() to asm/mmzone.h.  This has
received a build success notification from the kbuild-robot over 159
configs.

Link: https://lkml.kernel.org/r/160461461867.1505359.5301571728749534585.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: a035b6bf863e ("mm/memory_hotplug: introduce default phys_to_target_node() implementation")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/mmzone.h    |    2 ++
 arch/powerpc/include/asm/sparsemem.h |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/mmzone.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4
+++ a/arch/powerpc/include/asm/mmzone.h
@@ -33,6 +33,8 @@ extern struct pglist_data *node_data[];
 extern int numa_cpu_lookup_table[];
 extern cpumask_var_t node_to_cpumask_map[];
 #ifdef CONFIG_MEMORY_HOTPLUG
+extern int create_section_mapping(unsigned long start, unsigned long end,
+				  int nid, pgprot_t prot);
 extern unsigned long max_pfn;
 u64 memory_hotplug_max(void);
 #else
--- a/arch/powerpc/include/asm/sparsemem.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4
+++ a/arch/powerpc/include/asm/sparsemem.h
@@ -13,8 +13,6 @@
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern int create_section_mapping(unsigned long start, unsigned long end,
-				  int nid, pgprot_t prot);
 extern int remove_section_mapping(unsigned long start, unsigned long end);
 extern int memory_add_physaddr_to_nid(u64 start);
 #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports.patch
mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4-fix.patch
device-dax-kmem-use-struct_size.patch
xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch


Return-Path: <SRS0=pZAw=EM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2E1C2D0A3
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB032087E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604705132;
	bh=E3hPVPCSTJJtMVjgjo0sks/H7Nq+doVTl2Hp+ESvEkA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Z0yndfH50whioTA4t+0nFPULBkirPJmrH6nUvsLdyh2hsEly2Akf7ND7NhNQlnmL1
	 MdGlefMQM2PIuOKXUeM2meEceM7O8HoXFXSGuUtguim1OXKUAn9eyi5W9rwWvqgEtM
	 hCMU+fDfX3Y2O7Oh0GyHiGkAX4ppG5zv6a7HPRZ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgKFXZc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgKFXZb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 18:25:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43FD8206CB;
        Fri,  6 Nov 2020 23:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604705130;
        bh=E3hPVPCSTJJtMVjgjo0sks/H7Nq+doVTl2Hp+ESvEkA=;
        h=Date:From:To:Subject:From;
        b=1X3CSnXjGe5Tal7OhdFmDhNrdmsA5U7vX2V8SrYwHObZHFJFXwG7Vu+b3aq/UVTce
         PE8MpmsgpqoYbFg24mv5SLp/A+25y0s7wv7OznIpAw0zTMNZdh4wCu3TzlDU9aE8Mz
         7nchfHjYPd3mGMtTDzfcUfSojrTiD0sUxIpBRRYM=
Date:   Fri, 06 Nov 2020 15:25:29 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, dan.j.williams@intel.com,
        fenghua.yu@intel.com, hch@infradead.org, hch@lst.de,
        joao.m.martins@oracle.com, lkp@intel.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        tony.luck@intel.com, vishal.l.verma@intel.com
Subject:  +
 mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch
 added to -mm tree
Message-ID: <20201106232529.dMHg72Pfw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4
has been added to the -mm tree.  Its filename is
     mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch
device-dax-kmem-use-struct_size.patch
xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch


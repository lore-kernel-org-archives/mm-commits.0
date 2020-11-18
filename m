Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFDCC6369E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 06:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8855E246AA
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 06:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lebwtoAh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgKRGCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 01:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKRGCc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 01:02:32 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E134E24695;
        Wed, 18 Nov 2020 06:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605679351;
        bh=t/UtcbDSKYYKVLOD79XGvUWkNxZC/z4a6rV8f9A7pTA=;
        h=Date:From:To:Subject:From;
        b=lebwtoAhz5RZ0+fklVvFkqlDQ/Dsx9DGTykeHh51XMBWPgdtySC9l0tsJFUPjml+1
         lj/2m5sUjFdikUyB5epJa37LbQ0hoOMLY8KJEZtNXprJjNUucs2bKSJDLSfCV9GsNE
         LcFZSe6xYdrWPLca/uKQ7FpW3XNNJnCDLUVESqZ4=
Date:   Tue, 17 Nov 2020 22:02:30 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, dan.j.williams@intel.com, lkp@intel.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org
Subject:  +
 =?US-ASCII?Q?mm-fix-phys=5Fto=5Ftarget=5Fnode-and-memory=5Fadd=5Fphysaddr?=
 =?US-ASCII?Q?=5Fto=5Fnid-exports-v4-fix.patch?= added to -mm tree
Message-ID: <20201118060230.WTrimVxMT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: fix create_section_mapping compile warning
has been added to the -mm tree.  Its filename is
     mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4-fix.patch

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
Subject: powerpc: fix create_section_mapping compile warning

0day robot reports that a recent rework of how
memory_add_physaddr_to_nid() and phys_to_target_node() are declared
resulted in the following new compilation warning:

arch/powerpc/mm/mem.c:91:12: warning: no previous prototype for 'create_section_mapping' [-Wmissing-prototypes]
   91 | int __weak create_section_mapping(unsigned long start, unsigned long end,
      |            ^~~~~~~~~~~~~~~~~~~~~~

...fix this by moving the declaration of create_section_mapping()
outside of the CONFIG_NEED_MULTIPLE_NODES ifdef guard, and include an
explicit include of asm/mmzone.h in mem.c. An include of linux/mmzone.h
is not sufficient.

Link: https://lkml.kernel.org/r/160558386174.2948926.2740149041249041764.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/mmzone.h |    7 +++++--
 arch/powerpc/mm/mem.c             |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/mmzone.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4-fix
+++ a/arch/powerpc/include/asm/mmzone.h
@@ -33,8 +33,6 @@ extern struct pglist_data *node_data[];
 extern int numa_cpu_lookup_table[];
 extern cpumask_var_t node_to_cpumask_map[];
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern int create_section_mapping(unsigned long start, unsigned long end,
-				  int nid, pgprot_t prot);
 extern unsigned long max_pfn;
 u64 memory_hotplug_max(void);
 #else
@@ -48,5 +46,10 @@ u64 memory_hotplug_max(void);
 #define __HAVE_ARCH_RESERVED_KERNEL_PAGES
 #endif
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+extern int create_section_mapping(unsigned long start, unsigned long end,
+				  int nid, pgprot_t prot);
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_MMZONE_H_ */
--- a/arch/powerpc/mm/mem.c~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4-fix
+++ a/arch/powerpc/mm/mem.c
@@ -50,6 +50,7 @@
 #include <asm/rtas.h>
 #include <asm/kasan.h>
 #include <asm/svm.h>
+#include <asm/mmzone.h>
 
 #include <mm/mmu_decl.h>
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports.patch
mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4.patch
mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports-v4-fix.patch
device-dax-kmem-use-struct_size.patch
xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch


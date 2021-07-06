Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CECC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A634261C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhGFTTD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231764AbhGFTTC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE29261C7F;
        Tue,  6 Jul 2021 19:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598982;
        bh=qBeKMR9IEL7O6zo/IM4eMVmhlCYGyDAHryxFX7kVN9k=;
        h=Date:From:To:Subject:From;
        b=M9kvhJlAqQb8KPQS0YwPfzJTbAp2boECywXDZ37xXWpA6824SOjq6vPKYrDB27AN5
         Y/cJhAHQt+SVGOnCCJjU8ODrKNzu29oGbjZaKAcLGl60nGS2P4SLps5mm08oE/gbwa
         3xKjdbm/ncLMmUePYKWfw50Ttop4kN2+f0rM/JHI=
Date:   Tue, 06 Jul 2021 12:16:21 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, anshuman.khandual@arm.com,
        bodeddub@amazon.com, bp@alien8.de, bsingharora@gmail.com,
        chenhuang5@huawei.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        david@redhat.com, duanxiongchun@bytedance.com, hpa@zytor.com,
        joao.m.martins@oracle.com, jroedel@suse.de, linmiaohe@huawei.com,
        luto@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, oneukum@suse.com, osalvador@suse.de,
        paulmck@kernel.org, pawan.kumar.gupta@linux.intel.com,
        peterz@infradead.org, rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-disable-memmap=5Fon=5Fmemory-when-hugetl?=
 =?US-ASCII?Q?b=5Ffree=5Fvmemmap-enabled.patch?= removed from -mm tree
Message-ID: <20210706191621.tra_9bbn7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: disable memmap_on_memory when hugetlb_free_vmemmap enabled
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memory_hotplug: disable memmap_on_memory when hugetlb_free_vmemmap enabled

The parameter of memory_hotplug.memmap_on_memory is not compatible with
hugetlb_free_vmemmap.  So disable it when hugetlb_free_vmemmap is enabled.

[akpm@linux-foundation.org: remove unneeded include, per Oscar]
Link: https://lkml.kernel.org/r/20210510030027.56044-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    8 ++++++++
 mm/memory_hotplug.c                             |    1 +
 2 files changed, 9 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1584,6 +1584,10 @@
 			on:  enable the feature
 			off: disable the feature
 
+			This is not compatible with memory_hotplug.memmap_on_memory.
+			If both parameters are enabled, hugetlb_free_vmemmap takes
+			precedence over memory_hotplug.memmap_on_memory.
+
 	hung_task_panic=
 			[KNL] Should the hung task detector generate panics.
 			Format: 0 | 1
@@ -2850,6 +2854,10 @@
 			Note that even when enabled, there are a few cases where
 			the feature is not effective.
 
+			This is not compatible with hugetlb_free_vmemmap. If
+			both parameters are enabled, hugetlb_free_vmemmap takes
+			precedence over memory_hotplug.memmap_on_memory.
+
 	memtest=	[KNL,X86,ARM,PPC,RISCV] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
--- a/mm/memory_hotplug.c~mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled
+++ a/mm/memory_hotplug.c
@@ -1056,6 +1056,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	 *       populate a single PMD.
 	 */
 	return memmap_on_memory &&
+	       !is_hugetlb_free_vmemmap_enabled() &&
 	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
 	       size == memory_block_size_bytes() &&
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7603FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D0DA61361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhKKCuh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhKKCug (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7D5D610A2;
        Thu, 11 Nov 2021 02:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598868;
        bh=+3Yse1eyLxJP31bStvVJIJ0g8vQopy9jYpTthurpN50=;
        h=Date:From:To:Subject:From;
        b=Z7O7uIyxuJq27myErumDOlkFw6X2Dw3TcznlulaPOvHwD1k/ovGjYimftBpExJqrx
         LOnKF65rAVSqtbzJRkebMDOvdQN1dKOUrGumiMQ8LsQiqodsLAd4KNioPBAw8OA62K
         TgKkqJvJAMZvqfawstSNsa5IROXIcuXPAzBLkwoo=
Date:   Wed, 10 Nov 2021 18:47:47 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, arnd@arndb.de, borntraeger@de.ibm.com,
        chenhuacai@kernel.org, david@redhat.com, ebiederm@xmission.com,
        geert@linux-m68k.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Jianyong.Wu@arm.com, jiaxun.yang@flygoat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org,
        shahab@synopsys.com, tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-indicate-memblock=5Fdriver=5Fmanaged-wit?=
 =?US-ASCII?Q?h-ioresource=5Fsysram=5Fdriver=5Fmanaged.patch?= removed from
 -mm tree
Message-ID: <20211111024747.nPmVM8HOH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: indicate MEMBLOCK_DRIVER_MANAGED with IORESOURCE_SYSRAM_DRIVER_MANAGED
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: indicate MEMBLOCK_DRIVER_MANAGED with IORESOURCE_SYSRAM_DRIVER_MANAGED

Let's communicate driver-managed regions to memblock, to properly teach
kexec_file with CONFIG_ARCH_KEEP_MEMBLOCK to not place images on these
memory regions.

Link: https://lkml.kernel.org/r/20211004093605.5830-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jianyong Wu <Jianyong.Wu@arm.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shahab Vahedi <shahab@synopsys.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed
+++ a/mm/memory_hotplug.c
@@ -1342,6 +1342,7 @@ bool mhp_supports_memmap_on_memory(unsig
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct vmem_altmap mhp_altmap = {};
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1370,7 +1371,9 @@ int __ref add_memory_resource(int nid, s
 	mem_hotplug_begin();
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
-		ret = memblock_add_node(start, size, nid, MEMBLOCK_NONE);
+		if (res->flags & IORESOURCE_SYSRAM_DRIVER_MANAGED)
+			memblock_flags = MEMBLOCK_DRIVER_MANAGED;
+		ret = memblock_add_node(start, size, nid, memblock_flags);
 		if (ret)
 			goto error_mem_hotplug_end;
 	}
_

Patches currently in -mm which might be from david@redhat.com are



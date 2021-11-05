Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A31BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 381B761373
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhKEUri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233504AbhKEUri (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63BE06135A;
        Fri,  5 Nov 2021 20:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145098;
        bh=3mBCB+iqeU6b/8es3ptnTWBLGO4nOm6OCH8chmvnUK4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zY1sf7CrJae+W5AvjBeyDnGUAiz5KQ88tSHgyyhSuMGvvBgOEPZ5d6+cVrsnYVXZt
         T6ydQ5De9/QSwltDlswPgGlgNAWRqTWdo8IoAOcZaM1jQjeU9ouZiJGB/LfPcKXfNk
         rC215vxycc2JLwZs+yRCYxmV1yhyKXQkclxTbu1U=
Date:   Fri, 05 Nov 2021 13:44:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        arnd@arndb.de, borntraeger@de.ibm.com, chenhuacai@kernel.org,
        david@redhat.com, ebiederm@xmission.com, geert@linux-m68k.org,
        gor@linux.ibm.com, hca@linux.ibm.com, Jianyong.Wu@arm.com,
        jiaxun.yang@flygoat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org,
        shahab@synopsys.com, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  [patch 196/262] mm/memory_hotplug: indicate
 MEMBLOCK_DRIVER_MANAGED with IORESOURCE_SYSRAM_DRIVER_MANAGED
Message-ID: <20211105204456.Xa1aJk5Q_%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

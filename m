Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A43CC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447BB61371
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhKEUr1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233704AbhKEUr1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A400261357;
        Fri,  5 Nov 2021 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145087;
        bh=HkoYWztKitzLI7Po5xZgHrrfDx7kzFW8kNlNzd+PrAo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SiPOoC29Lop84lj+FSYQypUQE58fcAgcr29tfiTg6E9JjwPqbWAhui/s7obRdjTWl
         gJ1QInYZDNV5Ude50o9ibrBLjZbKMB98lgbgq3FUHpxiBmoqD2VyZfKw+wCR9FLjpU
         k+xy8CKZLCNS2eWH5W2NGDCmbfTZ30Z2oJ9SJ/W4=
Date:   Fri, 05 Nov 2021 13:44:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        arnd@arndb.de, borntraeger@de.ibm.com, chenhuacai@kernel.org,
        david@redhat.com, ebiederm@xmission.com, geert@linux-m68k.org,
        gor@linux.ibm.com, hca@linux.ibm.com, Jianyong.Wu@arm.com,
        jiaxun.yang@flygoat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@linux.ibm.com,
        shahab@synopsys.com, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  [patch 193/262] memblock: improve MEMBLOCK_HOTPLUG
 documentation
Message-ID: <20211105204446.kz5JSc_-i%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: memblock: improve MEMBLOCK_HOTPLUG documentation

The description of MEMBLOCK_HOTPLUG is currently short and consequently
misleading: we're actually dealing with a memory region that might get
hotunplugged later (i.e., the platform+firmware supports it), yet it is
indicated in the firmware-provided memory map as system ram that will just
get used by the system for any purpose when not taking special care.  The
firmware marked this memory region as a hot(un)plugged (e.g., hotplugged
before reboot), implying that it might get hotunplugged again later.

Whether we consider this information depends on the "movable_node" kernel
commandline parameter: only with "movable_node" set, we'll try keeping
this memory hotunpluggable, for example, by not serving early allocations
from this memory region and by letting the buddy manage it using the
ZONE_MOVABLE.

Let's make this clearer by extending the documentation.

Note: kexec *has to* indicate this memory to the second kernel.  With
"movable_node" set, we don't want to place kexec-images on this memory. 
Without "movable_node" set, we don't care and can place kexec-images on
this memory.  In both cases, after successful memory hotunplug, kexec has
to be re-armed to update the memory map for the second kernel and to place
the kexec-images somewhere else.

Link: https://lkml.kernel.org/r/20211004093605.5830-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
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
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shahab Vahedi <shahab@synopsys.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/memblock.h~memblock-improve-memblock_hotplug-documentation
+++ a/include/linux/memblock.h
@@ -28,7 +28,11 @@ extern unsigned long long max_possible_p
 /**
  * enum memblock_flags - definition of memory region attributes
  * @MEMBLOCK_NONE: no special request
- * @MEMBLOCK_HOTPLUG: hotpluggable region
+ * @MEMBLOCK_HOTPLUG: memory region indicated in the firmware-provided memory
+ * map during early boot as hot(un)pluggable system RAM (e.g., memory range
+ * that might get hotunplugged later). With "movable_node" set on the kernel
+ * commandline, try keeping this memory region hotunpluggable. Does not apply
+ * to memblocks added ("hotplugged") after early boot.
  * @MEMBLOCK_MIRROR: mirrored region
  * @MEMBLOCK_NOMAP: don't add to kernel direct mapping and treat as
  * reserved in the memory map; refer to memblock_mark_nomap() description
_

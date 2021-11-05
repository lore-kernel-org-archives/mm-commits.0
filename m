Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7028AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A98A61372
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhKEUrY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhKEUrX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A8B861362;
        Fri,  5 Nov 2021 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145083;
        bh=j83n6yVFIQx4Yb2IDvFFc3Wk9vLnKLD6aw+p2WAF1d4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bOvWEKW4c3GykJUoLRVQsi4WYHUPZ3UAEXMlelbjm2TBHkO4pMfHd3sB6STeOxJyh
         6z4ul6POovpL7/Kx8fF6FP8KxWVspl8l7oq7XicWWtmzhIez38UnkJ57EYhC7NMXeT
         1+6eUV21595jFXo+ovG3qP1PgixjHiTWZZcGa2yQ=
Date:   Fri, 05 Nov 2021 13:44:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        arnd@arndb.de, borntraeger@de.ibm.com, chenhuacai@kernel.org,
        david@redhat.com, ebiederm@xmission.com, geert@linux-m68k.org,
        gor@linux.ibm.com, hca@linux.ibm.com, Jianyong.Wu@arm.com,
        jiaxun.yang@flygoat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org,
        shahab@synopsys.com, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  [patch 192/262] mm/memory_hotplug: handle
 memblock_add_node() failures in add_memory_resource()
Message-ID: <20211105204442.CRZzL-cG-%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: handle memblock_add_node() failures in add_memory_resource()

Patch series "mm/memory_hotplug: full support for add_memory_driver_managed() with CONFIG_ARCH_KEEP_MEMBLOCK", v2.

Architectures that require CONFIG_ARCH_KEEP_MEMBLOCK=y, such as arm64,
don't cleanly support add_memory_driver_managed() yet.  Most prominently,
kexec_file can still end up placing kexec images on such driver-managed
memory, resulting in undesired behavior, for example, having kexec images
located on memory not part of the firmware-provided memory map.

Teaching kexec to not place images on driver-managed memory is especially
relevant for virtio-mem.  Details can be found in commit 7b7b27214bba
("mm/memory_hotplug: introduce add_memory_driver_managed()").

Extend memblock with a new flag and set it from memory hotplug code when
applicable.  This is required to fully support virtio-mem on arm64, making
also kexec_file behave like on x86-64.


This patch (of 2):

If memblock_add_node() fails, we're most probably running out of memory. 
While this is unlikely to happen, it can happen and having memory added
without a memblock can be problematic for architectures that use memblock
to detect valid memory.  Let's fail in a nice way instead of silently
ignoring the error.

Link: https://lkml.kernel.org/r/20211004093605.5830-1-david@redhat.com
Link: https://lkml.kernel.org/r/20211004093605.5830-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jianyong Wu <Jianyong.Wu@arm.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Shahab Vahedi <shahab@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource
+++ a/mm/memory_hotplug.c
@@ -1369,8 +1369,11 @@ int __ref add_memory_resource(int nid, s
 
 	mem_hotplug_begin();
 
-	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
-		memblock_add_node(start, size, nid);
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
+		ret = memblock_add_node(start, size, nid);
+		if (ret)
+			goto error_mem_hotplug_end;
+	}
 
 	ret = __try_online_node(nid, false);
 	if (ret < 0)
@@ -1443,6 +1446,7 @@ error:
 		rollback_node_hotadd(nid);
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
+error_mem_hotplug_end:
 	mem_hotplug_done();
 	return ret;
 }
_

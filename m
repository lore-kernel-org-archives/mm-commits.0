Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D78C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D599610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbhKKCuZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234421AbhKKCuY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D29D06103C;
        Thu, 11 Nov 2021 02:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598856;
        bh=obqY2BD44OrXxULOz1NnDD/Vbl38G8LHZ0h0eR/+kLs=;
        h=Date:From:To:Subject:From;
        b=b4/eY4AwbZGoXWuGusFA4u40asZ2/XX/4yE6TmTSJ1M3dMy/kBU1zeRwvxiqjuCSP
         D335DLfxfzx3cUlZsymtyuLFi/9dyzx7jJS2CNtURqc4UCk94yKibTNC68PWlNg5sq
         FQ7GqggU7Q1VULNV0rWw65B/Jik2r81UphQlmyfs=
Date:   Wed, 10 Nov 2021 18:47:35 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, arnd@arndb.de, borntraeger@de.ibm.com,
        chenhuacai@kernel.org, david@redhat.com, ebiederm@xmission.com,
        geert@linux-m68k.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Jianyong.Wu@arm.com, jiaxun.yang@flygoat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org,
        shahab@synopsys.com, tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-handle-memblock=5Fadd=5Fnode-failures-?=
 =?US-ASCII?Q?in-add=5Fmemory=5Fresource.patch?= removed from -mm tree
Message-ID: <20211111024735.VAa1xqCAV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: handle memblock_add_node() failures in add_memory_resource()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are



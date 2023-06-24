Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDADEC001DC
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjFXAAR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjFXAAJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3CB270B
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C2D561582
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0598C433C8;
        Sat, 24 Jun 2023 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564807;
        bh=zWGD0h9K5pUE+Plooxq6Ialfi39usor7zZLOO8+gCr0=;
        h=Date:To:From:Subject:From;
        b=fdvrWfuogzMWNwC6e3E2pHFpf8VdWdhc9FqI/OPg3heKwAwa2hoA2sfiXb+J5RK89
         ShzLcSRwzJJ4oiUiD/h+Vx9CThj50ay50pkRYXLOmx9maVeprULSogYILbQUQIXC8g
         VO6VMzDZaZ3P3kAmi+lfrrDeZM/VaOkMYg3BiUgA=
Date:   Fri, 23 Jun 2023 17:00:07 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-do-not-tweak-node-in-mem_cgroup_init.patch removed from -mm tree
Message-Id: <20230624000007.D0598C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol: do not tweak node in mem_cgroup_init()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-do-not-tweak-node-in-mem_cgroup_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/memcontrol: do not tweak node in mem_cgroup_init()
Date: Mon, 19 Jun 2023 13:04:42 +0000

mem_cgroup_init() request for allocations from each possible node, and
it's used to be a problem because NODE_DATA is not allocated for offline
node. Things have already changed since commit 09f49dca570a9 ("mm: handle
uninitialized numa nodes gracefully"), so it's unnecessary to check for
!node_online nodes here.

How to test?

qemu-system-x86_64 \
  -kernel vmlinux \
  -initrd full.rootfs.cpio.gz \
  -append "console=ttyS0,115200 root=/dev/ram0 nokaslr earlyprintk=serial oops=panic panic_on_warn" \
  -drive format=qcow2,file=vm_disk.qcow2,media=disk,if=ide \
  -enable-kvm \
  -cpu host \
  -m 8G,slots=2,maxmem=16G \
  -smp cores=4,threads=1,sockets=2  \
  -object memory-backend-ram,id=mem0,size=4G \
  -object memory-backend-ram,id=mem1,size=4G \
  -numa node,memdev=mem0,cpus=0-3,nodeid=0 \
  -numa node,memdev=mem1,cpus=4-7,nodeid=1 \
  -numa node,nodeid=2 \
  -net nic,model=virtio,macaddr=52:54:00:12:34:58 \
  -net user \
  -nographic \
  -rtc base=localtime \
  -gdb tcp::6000

Guest state when booting:

[    0.048881] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.050489] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x13fffffff] -> [mem 0x00000000-0x13fffffff]
[    0.052173] NODE_DATA(0) allocated [mem 0x13fffc000-0x13fffffff]
[    0.053164] NODE_DATA(1) allocated [mem 0x23fffa000-0x23fffdfff]
[    0.054187] Zone ranges:
[    0.054587]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.055551]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.056515]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
[    0.057484] Movable zone start for each node
[    0.058149] Early memory node ranges
[    0.058705]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.059679]   node   0: [mem 0x0000000000100000-0x00000000bffdffff]
[    0.060659]   node   0: [mem 0x0000000100000000-0x000000013fffffff]
[    0.061649]   node   1: [mem 0x0000000140000000-0x000000023fffffff]
[    0.062638] Initmem setup node 0 [mem 0x0000000000001000-0x000000013fffffff]
[    0.063745] Initmem setup node 1 [mem 0x0000000140000000-0x000000023fffffff]
[    0.064855]   DMA zone: 158 reserved pages exceeds freesize 0
[    0.065746] Initializing node 2 as memoryless
[    0.066437] Initmem setup node 2 as memoryless
[    0.067132]   DMA zone: 158 reserved pages exceeds freesize 0
[    0.068037] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.068265] On node 0, zone DMA: 97 pages in unavailable ranges
[    0.124755] On node 0, zone Normal: 32 pages in unavailable ranges

cat /sys/devices/system/node/online
0-1
cat /sys/devices/system/node/possible
0-2

Link: https://lkml.kernel.org/r/20230619130442.2487-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-do-not-tweak-node-in-mem_cgroup_init
+++ a/mm/memcontrol.c
@@ -7376,8 +7376,7 @@ static int __init mem_cgroup_init(void)
 	for_each_node(node) {
 		struct mem_cgroup_tree_per_node *rtpn;
 
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
-				    node_online(node) ? node : NUMA_NO_NODE);
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
 
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are



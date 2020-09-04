Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B9EC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 19:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432272083B
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 19:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599247389;
	bh=Gcp17D8SsYGJcde6ftn43oCmlZr0lns5gSj3EMCJ90I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rypP4QpVaOxumb+4YzWrogdj/P16wRM2daAOxTmHqDDry5Oq0HIJ1Qr2N1iYN5sQj
	 1doSHIntuguLP4bb4fXZd5ZAGH7+cuh8qxaII8OruC9ZedJalo0qRDINvHJPQQ+n3h
	 hyUOmIwuTmoO3uAIBY60TtbJVGjzMnXOeqwuJTEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgIDTXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 15:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgIDTXG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 15:23:06 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB15207EA;
        Fri,  4 Sep 2020 19:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599247385;
        bh=Gcp17D8SsYGJcde6ftn43oCmlZr0lns5gSj3EMCJ90I=;
        h=Date:From:To:Subject:From;
        b=rtElOr+U6PjNbDm0gqLSTgFsV9YyW7gyfj4LYHTtOwqlYFH3Y/McCaFXWMuAXSzSE
         qaPPUGP8grXzQsr/42oHKxC0kl7IEKsAdPYXcdl/bfvQeLE2wPtc2eLeVf1gvSA5zJ
         CP2f28zJ3F8nQkaxvV7x/jjgnGIi25QrJ/Fq77D8=
Date:   Fri, 04 Sep 2020 12:23:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rafael@kernel.org, OSalvador@suse.com,
        nathanl@linux.ibm.com, mhocko@kernel.org,
        gregkh@linuxfoundation.org, david@redhat.com,
        cheloha@linux.ibm.com, ldufour@linux.ibm.com
Subject:  [nacked] mm-check-for-memorys-node-later-during-boot.patch
 removed from -mm tree
Message-ID: <20200904192305.hVaHl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check for memory's node later during boot
has been removed from the -mm tree.  Its filename was
     mm-check-for-memorys-node-later-during-boot.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: mm: check for memory's node later during boot

register_mem_sect_under_nodem() is checking the memory block's node id
only if the system state is "SYSTEM_BOOTING".  On PowerPC, the memory
blocks are registered while the system state is "SYSTEM_SCHEDULING", the
one before SYSTEM_RUNNING.

The consequence on PowerPC guest with interleaved memory node's ranges is
that some memory block could be assigned to multiple nodes on sysfs.  This
lately prevents some memory hot-plug and hot-unplug to succeed because
links are remaining.  Such a panic is then displayed:

------------[ cut here ]------------
kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
Oops: Exception in kernel mode, sig: 5 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
CFAR: c000000000846d20 IRQMASK: 0
GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
NIP [c000000000403f34] add_memory_resource+0x244/0x340
LR [c000000000403f2c] add_memory_resource+0x23c/0x340
Call Trace:
[c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
[c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
[c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
[c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
[c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
[c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
[c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
[c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
[c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
[c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
[c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
[c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
[c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
Instruction dump:
48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
---[ end trace 562fd6c109cd0fb2 ]---

To prevent this multiple links, make the node checking done for states
prior to SYSTEM_RUNNING.

Link: https://lkml.kernel.org/r/20200902090911.11363-1-ldufour@linux.ibm.com
Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <OSalvador@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/node.c~mm-check-for-memorys-node-later-during-boot
+++ a/drivers/base/node.c
@@ -789,7 +789,7 @@ static int register_mem_sect_under_node(
 		 * case, during hotplug we know that all pages in the memory
 		 * block belong to the same node.
 		 */
-		if (system_state == SYSTEM_BOOTING) {
+		if (system_state < SYSTEM_RUNNING) {
 			page_nid = get_nid_for_pfn(pfn);
 			if (page_nid < 0)
 				continue;
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are



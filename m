Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6892D592E;
	Tue, 28 Oct 2025 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761683680; cv=none; b=csqXUqbFmgaM1S4UHya+i9RZLMIxH5EueQCR7Rl+vk/zSlpXuPLnTczbf1/p3ypYLqMtv3E3Ict4V1/U32+rt5LLSDXahPkIaX1RxXct5u9SaKqf+az8Uwx8CNVYezI4FDAQBXSXekmShH/7qX17FsoOoK6+fHxrRXKjvSvSJWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761683680; c=relaxed/simple;
	bh=5p0oJfAp3/0bwptooAuUlXvObN5G8sGD7etCf7q7MhQ=;
	h=Date:To:From:Subject:Message-Id; b=pinDK7L0alBIA+jJfvAoQhHFpNWIO5JAgHLD4wdprGhJK7CJ6+dlnb4MkaW+PWhohAytI3thBNXakOGIriNAP7r6WFZPwDZrJ8B30a5RAEb84Aj6JIykIwIoM6BHU/hID9tvmDh6BV3suLnKk3qzyZYTpxwIPzoXCVQo8Py6AH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wArhh396; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wArhh396"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D97EC4CEE7;
	Tue, 28 Oct 2025 20:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761683679;
	bh=5p0oJfAp3/0bwptooAuUlXvObN5G8sGD7etCf7q7MhQ=;
	h=Date:To:From:Subject:From;
	b=wArhh396OzUi8her9LTD5XX7iPL0O3k1I2T93w66ZWfaTtFK27jOveMvTo4tYotQk
	 tTmD9R/chMp/xAHki8S0YqIy7xWdOeEgG1q+bkyRPH9IHaeXXiUO3Efy0X4xm5d8Vv
	 5ty5B5gAtQnVSHRaDApfm/+1JfGZF/UEiMsc2znM=
Date: Tue, 28 Oct 2025 13:34:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,cl@gentwo.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + codetag-debug-handle-existing-codetag_empty-in-mark_objexts_empty-for-slabobj_ext.patch added to mm-new branch
Message-Id: <20251028203439.5D97EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext
has been added to the -mm mm-new branch.  Its filename is
     codetag-debug-handle-existing-codetag_empty-in-mark_objexts_empty-for-slabobj_ext.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/codetag-debug-handle-existing-codetag_empty-in-mark_objexts_empty-for-slabobj_ext.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext
Date: Mon, 27 Oct 2025 16:52:14 +0800

Even though obj_exts was created with the __GFP_NO_OBJ_EXT flag, objects
in the same slab may have their extensions allocated via
alloc_slab_obj_exts, and handle_failed_objexts_alloc may be called within
alloc_slab_obj_exts to set their codetag to CODETAG_EMPTY.

Therefore, both NULL and CODETAG_EMPTY are valid for the codetag of
slabobj_ext, as we do not need to re-set it to CODETAG_EMPTY if it is
already CODETAG_EMPTY.  It also resolves the warning triggered when the
codetag is CODETAG_EMPTY during slab freeing.

This issue also occurred during our memory stress testing.

The possibility of its occurrence should be as follows:

When a slab allocates a slabobj_ext, the slab to which this slabobj_ext 
belongs may have already allocated its own slabobj_ext

and called handle_failed_objexts_alloc. That is to say, the codetag of 
this slabobj_ext has been set to CODETAG_EMPTY.

To quickly detect this WARN, I modified the code 
from:WARN_ON(slab_exts[offs].ref.ct) to WARN_ON(slab_exts[offs].ref.ct 
== 1);

We then obtained this message:

[21630.898561] ------------[ cut here ]------------
[21630.898596] kernel BUG at mm/slub.c:2050!
[21630.898611] Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
[21630.900372] Modules linked in: squashfs isofs vfio_iommu_type1 
vhost_vsock vfio vhost_net vmw_vsock_virtio_transport_common vhost tap 
vhost_iotlb iommufd vsock binfmt_misc nfsv3 nfs_acl nfs lockd grace 
netfs tls rds dns_resolver tun brd overlay ntfs3 exfat btrfs 
blake2b_generic xor xor_neon raid6_pq loop sctp ip6_udp_tunnel 
udp_tunnel nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
nf_tables rfkill ip_set sunrpc vfat fat joydev sg sch_fq_codel nfnetlink 
virtio_gpu sr_mod cdrom drm_client_lib virtio_dma_buf drm_shmem_helper 
drm_kms_helper drm ghash_ce backlight virtio_net virtio_blk virtio_scsi 
net_failover virtio_console failover virtio_mmio dm_mirror 
dm_region_hash dm_log dm_multipath dm_mod fuse i2c_dev virtio_pci 
virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring autofs4 
aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
[21630.909177] CPU: 3 UID: 0 PID: 3787 Comm: kylin-process-m Kdump: 
loaded Tainted: G        W           6.18.0-rc1+ #74 PREEMPT(voluntary)
[21630.910495] Tainted: [W]=WARN
[21630.910867] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 
2/2/2022
[21630.911625] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[21630.912392] pc : __free_slab+0x228/0x250
[21630.912868] lr : __free_slab+0x18c/0x250[21630.913334] sp : 
ffff8000a02f73e0
[21630.913830] x29: ffff8000a02f73e0 x28: fffffdffc43fc800 x27: 
ffff0000c0011c40
[21630.914677] x26: ffff0000c000cac0 x25: ffff00010fe5e5f0 x24: 
ffff000102199b40
[21630.915469] x23: 0000000000000003 x22: 0000000000000003 x21: 
ffff0000c0011c40
[21630.916259] x20: fffffdffc4086600 x19: fffffdffc43fc800 x18: 
0000000000000000
[21630.917048] x17: 0000000000000000 x16: 0000000000000000 x15: 
0000000000000000
[21630.917837] x14: 0000000000000000 x13: 0000000000000000 x12: 
ffff70001405ee66
[21630.918640] x11: 1ffff0001405ee65 x10: ffff70001405ee65 x9 : 
ffff800080a295dc
[21630.919442] x8 : ffff8000a02f7330 x7 : 0000000000000000 x6 : 
0000000000003000
[21630.920232] x5 : 0000000024924925 x4 : 0000000000000001 x3 : 
0000000000000007
[21630.921021] x2 : 0000000000001b40 x1 : 000000000000001f x0 : 
0000000000000001
[21630.921810] Call trace:
[21630.922130]  __free_slab+0x228/0x250 (P)
[21630.922669]  free_slab+0x38/0x118
[21630.923079]  free_to_partial_list+0x1d4/0x340
[21630.923591]  __slab_free+0x24c/0x348
[21630.924024]  ___cache_free+0xf0/0x110
[21630.924468]  qlist_free_all+0x78/0x130
[21630.924922]  kasan_quarantine_reduce+0x114/0x148
[21630.925525]  __kasan_slab_alloc+0x7c/0xb0
[21630.926006]  kmem_cache_alloc_noprof+0x164/0x5c8
[21630.926699]  __alloc_object+0x44/0x1f8
[21630.927153]  __create_object+0x34/0xc8
[21630.927604]  kmemleak_alloc+0xb8/0xd8
[21630.928052]  kmem_cache_alloc_noprof+0x368/0x5c8
[21630.928606]  getname_flags.part.0+0xa4/0x610
[21630.929112]  getname_flags+0x80/0xd8
[21630.929557]  vfs_fstatat+0xc8/0xe0
[21630.929975]  __do_sys_newfstatat+0xa0/0x100
[21630.930469]  __arm64_sys_newfstatat+0x90/0xd8
[21630.931046]  invoke_syscall+0xd4/0x258
[21630.931685]  el0_svc_common.constprop.0+0xb4/0x240
[21630.932467]  do_el0_svc+0x48/0x68
[21630.932972]  el0_svc+0x40/0xe0
[21630.933472]  el0t_64_sync_handler+0xa0/0xe8
[21630.934151]  el0t_64_sync+0x1ac/0x1b0
[21630.934923] Code: aa1803e0 97ffef2b a9446bf9 17ffff9c (d4210000)
[21630.936461] SMP: stopping secondary CPUs
[21630.939550] Starting crashdump kernel...
[21630.940108] Bye!

Link: https://lkml.kernel.org/r/20251027085214.184672-1-hao.ge@linux.dev
Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/slub.c~codetag-debug-handle-existing-codetag_empty-in-mark_objexts_empty-for-slabobj_ext
+++ a/mm/slub.c
@@ -2046,7 +2046,17 @@ static inline void mark_objexts_empty(st
 	if (slab_exts) {
 		unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
 						 obj_exts_slab, obj_exts);
-		/* codetag should be NULL */
+
+		/*
+		 * codetag should be either NULL or CODETAG_EMPTY.
+		 * When the same slab calls handle_failed_objexts_alloc,
+		 * it will set us to CODETAG_EMPTY.
+		 *
+		 * If codetag is already CODETAG_EMPTY, no action is needed here.
+		 */
+		if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
+			return;
+
 		WARN_ON(slab_exts[offs].ref.ct);
 		set_codetag_empty(&slab_exts[offs].ref);
 	}
_

Patches currently in -mm which might be from gehao@kylinos.cn are

codetag-debug-handle-existing-codetag_empty-in-mark_objexts_empty-for-slabobj_ext.patch


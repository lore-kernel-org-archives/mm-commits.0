From: akpm@linux-foundation.org
Subject: - try-this.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:48:53 -0700
Message-ID: <200710192248.l9JMmrqL023912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbXJSWtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 18:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, akpm@linux-foundation.org, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: networking crash in current mainline:  sk_filter_delayed_uncharge()
has been removed from the -mm tree.  Its filename was
     try-this.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Subject: Re: networking crash in current mainline:  sk_filter_delayed_uncharge()
From: David Miller <davem@davemloft.net>

Date: Thu, 18 Oct 2007 23:09:48 -0700

>
> powerpc mac G5
> config: http://userweb.kernel.org/~akpm/config-g5.txt
> screenshot: http://userweb.kernel.org/~akpm/dsc00005.jpg
>
> It does this shortly after bringing up eth0 (tg3), in dhclient.

Try this:

From 9b013e05e0289c190a53d78ca029e2f21c0e4485 Mon Sep 17 00:00:00 2001
Date: Thu, 18 Oct 2007 21:48:39 -0700
Subject: [PATCH] [NET]: Fix bug in sk_filter race cures.

Looks like this might be causing problems, at least for me on ppc. This
happened during a normal boot, right around first interface config/dhcp
run..

cpu 0x0: Vector: 300 (Data Access) at [c00000000147b820]
    pc: c000000000435e5c: .sk_filter_delayed_uncharge+0x1c/0x60
    lr: c0000000004360d0: .sk_attach_filter+0x170/0x180
    sp: c00000000147baa0
   msr: 9000000000009032
   dar: 4
 dsisr: 40000000
  current = 0xc000000004780fa0
  paca    = 0xc000000000650480
    pid   = 1295, comm = dhclient3
0:mon> t
[c00000000147bb20] c0000000004360d0 .sk_attach_filter+0x170/0x180
[c00000000147bbd0] c000000000418988 .sock_setsockopt+0x788/0x7f0
[c00000000147bcb0] c000000000438a74 .compat_sys_setsockopt+0x4e4/0x5a0
[c00000000147bd90] c00000000043955c .compat_sys_socketcall+0x25c/0x2b0
[c00000000147be30] c000000000007508 syscall_exit+0x0/0x40

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/filter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/core/filter.c~try-this net/core/filter.c
--- a/net/core/filter.c~try-this
+++ a/net/core/filter.c
@@ -447,7 +447,8 @@ int sk_attach_filter(struct sock_fprog *
 	rcu_assign_pointer(sk->sk_filter, fp);
 	rcu_read_unlock_bh();
 
-	sk_filter_delayed_uncharge(sk, old_fp);
+	if (old_fp)
+		sk_filter_delayed_uncharge(sk, old_fp);
 	return 0;
 }
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
zd1201-avoid-null-ptr-access-of-skb-dev.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-scsi-misc.patch
git-wireless.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch

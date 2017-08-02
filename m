From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Wed, 02 Aug 2017 12:27:06 -0700
Message-ID: <20170802192706.7XzjMYYE5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdHBT1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 15:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                     |    5 -----
 drivers/net/hyperv/netvsc_drv.c |   21 ---------------------
 drivers/net/virtio_net.c        |    3 ---
 3 files changed, 29 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -5123,15 +5123,10 @@ M:	Andrew Lunn <andrew@lunn.ch>
 M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-<<<<<<< HEAD
-F:	Documentation/ABI/testing/sysfs-bus-mdio
-F:	Documentation/devicetree/bindings/net/mdio*
-=======
 F:	include/linux/phy.h
 F:	include/linux/phy_fixed.h
 F:	include/linux/platform_data/mdio-bcm-unimac.h
 F:	drivers/net/phy/
->>>>>>> linux-next/akpm-base
 F:	Documentation/networking/phy.txt
 F:	drivers/net/phy/
 F:	drivers/of/of_mdio.c
diff -puN drivers/net/hyperv/netvsc_drv.c~linux-next-git-rejects drivers/net/hyperv/netvsc_drv.c
--- a/drivers/net/hyperv/netvsc_drv.c~linux-next-git-rejects
+++ a/drivers/net/hyperv/netvsc_drv.c
@@ -317,7 +317,6 @@ static u32 init_page_array(void *hdr, u3
 }
 
 static int count_skb_frag_slots(struct sk_buff *skb)
-<<<<<<< HEAD
 {
 	int i, frags = skb_shinfo(skb)->nr_frags;
 	int pages = 0;
@@ -336,26 +335,6 @@ static int count_skb_frag_slots(struct s
 
 static int netvsc_get_slots(struct sk_buff *skb)
 {
-=======
-{
-	int i, frags = skb_shinfo(skb)->nr_frags;
-	int pages = 0;
-
-	for (i = 0; i < frags; i++) {
-		skb_frag_t *frag = skb_shinfo(skb)->frags + i;
-		unsigned long size = skb_frag_size(frag);
-		unsigned long offset = frag->page_offset;
-
-		/* Skip unused frames from start of page */
-		offset &= ~PAGE_MASK;
-		pages += PFN_UP(offset + size);
-	}
-	return pages;
-}
-
-static int netvsc_get_slots(struct sk_buff *skb)
-{
->>>>>>> linux-next/akpm-base
 	char *data = skb->data;
 	unsigned int offset = offset_in_page(data);
 	unsigned int len = skb_headlen(skb);
diff -puN drivers/net/virtio_net.c~linux-next-git-rejects drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~linux-next-git-rejects
+++ a/drivers/net/virtio_net.c
@@ -952,10 +952,7 @@ static int add_recvbuf_mergeable(struct
 
 	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
 	buf += headroom; /* advance address leaving hole at front of pkt */
-<<<<<<< HEAD
-=======
 	ctx = mergeable_len_to_ctx(len, headroom);
->>>>>>> linux-next/akpm-base
 	get_page(alloc_frag->page);
 	alloc_frag->offset += len + headroom;
 	hole = alloc_frag->size - alloc_frag->offset;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
fortify-use-warn-instead-of-bug-for-now-fix.patch
swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945CBC71153
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbjIDTy1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbjIDTyX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:54:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B479E
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC4DEB80EF3
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651FCC433C8;
        Mon,  4 Sep 2023 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693857257;
        bh=dPzSjftnILmB5Q/Q/qnbD6hlj+RCD3pleTAz3Noi8OU=;
        h=Date:To:From:Subject:From;
        b=UtFmu3ZmPhYipC6bnIRf5MjI32HIhmaQy3UwDzh4fTKUWurapiMXC5oEv0Zfq+0Qr
         Og0zJ1uMEHIEcy2bk2Fsxx6A8X46PR5mSHup2pEk9pHXcGYOaGLnjmY/w1wjKRj+jJ
         4Yb11WVRKMvrtna6WitP5sb0PPK6Hv1jHOclGAGo=
Date:   Mon, 04 Sep 2023 12:54:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        paulmck@kernel.org, oleksiy.avramchenko@sony.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com,
        joel@joelfernandes.org, hch@lst.de, david@fromorbit.com,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch added to mm-unstable branch
Message-Id: <20230904195417.651FCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: set nr_nodes/node_size based on CPU-cores
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: set nr_nodes/node_size based on CPU-cores
Date: Tue, 29 Aug 2023 10:11:42 +0200

The density ratio is set to 2, i.e.  two users per one node.  For example
if there are 6 cores in a system the "nr_nodes" is 3.

The "node_size" also depends on number of physical cores.  A
high-threshold limit is hard-coded and set to SZ_4M.

For 32-bit, single/dual core systems an access to a global vmap heap is
not balanced.  Such small systems do not suffer from lock contentions due
to limitation of CPU-cores.

Test on AMD Ryzen Threadripper 3970X 32-Core Processor: sudo
./test_vmalloc.sh run_test_mask=127 nr_threads=64

<default perf>
 94.17%     0.90%  [kernel]    [k] _raw_spin_lock
 93.27%    93.05%  [kernel]    [k] native_queued_spin_lock_slowpath
 74.69%     0.25%  [kernel]    [k] __vmalloc_node_range
 72.64%     0.01%  [kernel]    [k] __get_vm_area_node
 72.04%     0.89%  [kernel]    [k] alloc_vmap_area
 42.17%     0.00%  [kernel]    [k] vmalloc
 32.53%     0.00%  [kernel]    [k] __vmalloc_node
 24.91%     0.25%  [kernel]    [k] vfree
 24.32%     0.01%  [kernel]    [k] remove_vm_area
 22.63%     0.21%  [kernel]    [k] find_unlink_vmap_area
 15.51%     0.00%  [unknown]   [k] 0xffffffffc09a74ac
 14.35%     0.00%  [kernel]    [k] ret_from_fork_asm
 14.35%     0.00%  [kernel]    [k] ret_from_fork
 14.35%     0.00%  [kernel]    [k] kthread
<default perf>
   vs
<patch-series perf>
 74.32%     2.42%  [kernel]    [k] __vmalloc_node_range
 69.58%     0.01%  [kernel]    [k] vmalloc
 54.21%     1.17%  [kernel]    [k] __alloc_pages_bulk
 48.13%    47.91%  [kernel]    [k] clear_page_orig
 43.60%     0.01%  [unknown]   [k] 0xffffffffc082f16f
 32.06%     0.00%  [kernel]    [k] ret_from_fork_asm
 32.06%     0.00%  [kernel]    [k] ret_from_fork
 32.06%     0.00%  [kernel]    [k] kthread
 31.30%     0.00%  [unknown]   [k] 0xffffffffc082f889
 22.98%     4.16%  [kernel]    [k] vfree
 14.36%     0.28%  [kernel]    [k] __get_vm_area_node
 13.43%     3.35%  [kernel]    [k] alloc_vmap_area
 10.86%     0.04%  [kernel]    [k] remove_vm_area
  8.89%     2.75%  [kernel]    [k] _raw_spin_lock
  7.19%     0.00%  [unknown]   [k] 0xffffffffc082fba3
  6.65%     1.37%  [kernel]    [k] free_unref_page
  6.13%     6.11%  [kernel]    [k] native_queued_spin_lock_slowpath
<patch-series perf>

confirms that a native_queued_spin_lock_slowpath bottle-neck
can be considered as negligible for the patch-series version.

The throughput is ~15x higher:

urezki@pc638:~$ time sudo ./test_vmalloc.sh run_test_mask=127 nr_threads=64
Run the test with following parameters: run_test_mask=127 nr_threads=64
Done.
Check the kernel ring buffer to see the summary.

real    24m3.305s
user    0m0.361s
sys     0m0.013s
urezki@pc638:~$

urezki@pc638:~$ time sudo ./test_vmalloc.sh run_test_mask=127 nr_threads=64
Run the test with following parameters: run_test_mask=127 nr_threads=64
Done.
Check the kernel ring buffer to see the summary.

real    1m28.382s
user    0m0.014s
sys     0m0.026s
urezki@pc638:~$

Link: https://lkml.kernel.org/r/20230829081142.3619-10-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores
+++ a/mm/vmalloc.c
@@ -796,6 +796,9 @@ struct vmap_node {
 	atomic_t fill_in_progress;
 };
 
+#define MAX_NODES U8_MAX
+#define MAX_NODE_SIZE SZ_4M
+
 static struct vmap_node *nodes, snode;
 static __read_mostly unsigned int nr_nodes = 1;
 static __read_mostly unsigned int node_size = 1;
@@ -4825,11 +4828,24 @@ static void vmap_init_free_space(void)
 	}
 }
 
+static unsigned int calculate_nr_nodes(void)
+{
+	unsigned int nr_cpus;
+
+	nr_cpus = num_present_cpus();
+	if (nr_cpus <= 1)
+		nr_cpus = num_possible_cpus();
+
+	/* Density factor. Two users per a node. */
+	return clamp_t(unsigned int, nr_cpus >> 1, 1, MAX_NODES);
+}
+
 static void vmap_init_nodes(void)
 {
 	struct vmap_node *vn;
 	int i;
 
+	nr_nodes = calculate_nr_nodes();
 	nodes = &snode;
 
 	if (nr_nodes > 1) {
@@ -4852,6 +4868,16 @@ static void vmap_init_nodes(void)
 		INIT_LIST_HEAD(&vn->free.head);
 		spin_lock_init(&vn->free.lock);
 	}
+
+	/*
+	 * Scale a node size to number of CPUs. Each power of two
+	 * value doubles a node size. A high-threshold limit is set
+	 * to 4M.
+	 */
+#if BITS_PER_LONG == 64
+	if (nr_nodes > 1)
+		node_size = min(SZ_64K << fls(num_possible_cpus()), SZ_4M);
+#endif
 }
 
 void __init vmalloc_init(void)
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch


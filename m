From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-tree-wide-replace-=5F=5Fgfp=5Frepeat-by-=5F=5Fgfp=5Fretry?=
 =?US-ASCII?Q?=5Fmayfail-with-more-useful-semantic.patch?= removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:42:54 -0700
Message-ID: <20170713204254.kxozRoPL8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.com, ralf@linux-mips.org, vbabka@suse.cz


The patch titled
     Subject: mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic
has been removed from the -mm tree.  Its filename was
     mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic

__GFP_REPEAT was designed to allow retry-but-eventually-fail semantic to
the page allocator.  This has been true but only for allocations requests
larger than PAGE_ALLOC_COSTLY_ORDER.  It has been always ignored for
smaller sizes.  This is a bit unfortunate because there is no way to
express the same semantic for those requests and they are considered too
important to fail so they might end up looping in the page allocator for
ever, similarly to GFP_NOFAIL requests.

Now that the whole tree has been cleaned up and accidental or misled usage
of __GFP_REPEAT flag has been removed for !costly requests we can give the
original flag a better name and more importantly a more useful semantic. 
Let's rename it to __GFP_RETRY_MAYFAIL which tells the user that the
allocator would try really hard but there is no promise of a success. 
This will work independent of the order and overrides the default
allocator behavior.  Page allocator users have several levels of guarantee
vs.  cost options (take GFP_KERNEL as an example)

- GFP_KERNEL & ~__GFP_RECLAIM - optimistic allocation without _any_
  attempt to free memory at all.  The most light weight mode which even
  doesn't kick the background reclaim.  Should be used carefully because
  it might deplete the memory and the next user might hit the more
  aggressive reclaim

- GFP_KERNEL & ~__GFP_DIRECT_RECLAIM (or GFP_NOWAIT)- optimistic
  allocation without any attempt to free memory from the current context
  but can wake kswapd to reclaim memory if the zone is below the low
  watermark.  Can be used from either atomic contexts or when the request
  is a performance optimization and there is another fallback for a slow
  path.

- (GFP_KERNEL|__GFP_HIGH) & ~__GFP_DIRECT_RECLAIM (aka GFP_ATOMIC) - non
  sleeping allocation with an expensive fallback so it can access some
  portion of memory reserves.  Usually used from interrupt/bh context with
  an expensive slow path fallback.

- GFP_KERNEL - both background and direct reclaim are allowed and the
  _default_ page allocator behavior is used.  That means that !costly
  allocation requests are basically nofail but there is no guarantee of
  that behavior so failures have to be checked properly by callers (e.g. 
  OOM killer victim is allowed to fail currently).

- GFP_KERNEL | __GFP_NORETRY - overrides the default allocator behavior
  and all allocation requests fail early rather than cause disruptive
  reclaim (one round of reclaim in this implementation).  The OOM killer
  is not invoked.

- GFP_KERNEL | __GFP_RETRY_MAYFAIL - overrides the default allocator
  behavior and all allocation requests try really hard.  The request will
  fail if the reclaim cannot make any progress.  The OOM killer won't be
  triggered.

- GFP_KERNEL | __GFP_NOFAIL - overrides the default allocator behavior
  and all allocation requests will loop endlessly until they succeed. 
  This might be really dangerous especially for larger orders.

Existing users of __GFP_REPEAT are changed to __GFP_RETRY_MAYFAIL because
they already had their semantic.  No new users are added. 
__alloc_pages_slowpath is changed to bail out for __GFP_RETRY_MAYFAIL if
there is no progress and we have already passed the OOM point.  This means
that all the reclaim opportunities have been exhausted except the most
disruptive one (the OOM killer) and a user defined fallback behavior is
more sensible than keep retrying in the page allocator.

[akpm@linux-foundation.org: fix arch/sparc/kernel/mdesc.c]
[mhocko@suse.com: semantic fix]
  Link: http://lkml.kernel.org/r/20170626123847.GM11534@dhcp22.suse.cz
[mhocko@kernel.org: address other thing spotted by Vlastimil]
  Link: http://lkml.kernel.org/r/20170626124233.GN11534@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/20170623085345.11304-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-ISA-LPC.txt                |    2 
 arch/powerpc/include/asm/book3s/64/pgalloc.h |    2 
 arch/powerpc/kvm/book3s_64_mmu_hv.c          |    2 
 arch/sparc/kernel/mdesc.c                    |    2 
 drivers/mmc/host/wbsd.c                      |    2 
 drivers/s390/char/vmcp.c                     |    2 
 drivers/target/target_core_transport.c       |    2 
 drivers/vhost/net.c                          |    2 
 drivers/vhost/scsi.c                         |    2 
 drivers/vhost/vsock.c                        |    2 
 include/linux/gfp.h                          |   56 +++++++++++++----
 include/linux/slab.h                         |    3 
 include/trace/events/mmflags.h               |    2 
 mm/hugetlb.c                                 |    4 -
 mm/internal.h                                |    2 
 mm/page_alloc.c                              |   14 +++-
 mm/sparse-vmemmap.c                          |    4 -
 mm/util.c                                    |    6 -
 mm/vmalloc.c                                 |    2 
 mm/vmscan.c                                  |    8 +-
 net/core/dev.c                               |    6 -
 net/core/skbuff.c                            |    2 
 net/sched/sch_fq.c                           |    2 
 tools/perf/builtin-kmem.c                    |    2 
 24 files changed, 86 insertions(+), 47 deletions(-)

diff -puN Documentation/DMA-ISA-LPC.txt~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic Documentation/DMA-ISA-LPC.txt
--- a/Documentation/DMA-ISA-LPC.txt~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/Documentation/DMA-ISA-LPC.txt
@@ -42,7 +42,7 @@ requirements you pass the flag GFP_DMA t
 
 Unfortunately the memory available for ISA DMA is scarce so unless you
 allocate the memory during boot-up it's a good idea to also pass
-__GFP_REPEAT and __GFP_NOWARN to make the allocator try a bit harder.
+__GFP_RETRY_MAYFAIL and __GFP_NOWARN to make the allocator try a bit harder.
 
 (This scarcity also means that you should allocate the buffer as
 early as possible and not release it until the driver is unloaded.)
diff -puN arch/powerpc/include/asm/book3s/64/pgalloc.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic arch/powerpc/include/asm/book3s/64/pgalloc.h
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -56,7 +56,7 @@ static inline pgd_t *radix__pgd_alloc(st
 	return (pgd_t *)__get_free_page(pgtable_gfp_flags(mm, PGALLOC_GFP));
 #else
 	struct page *page;
-	page = alloc_pages(pgtable_gfp_flags(mm, PGALLOC_GFP | __GFP_REPEAT),
+	page = alloc_pages(pgtable_gfp_flags(mm, PGALLOC_GFP | __GFP_RETRY_MAYFAIL),
 				4);
 	if (!page)
 		return NULL;
diff -puN arch/powerpc/kvm/book3s_64_mmu_hv.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic arch/powerpc/kvm/book3s_64_mmu_hv.c
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -93,7 +93,7 @@ int kvmppc_allocate_hpt(struct kvm_hpt_i
 	}
 
 	if (!hpt)
-		hpt = __get_free_pages(GFP_KERNEL|__GFP_ZERO|__GFP_REPEAT
+		hpt = __get_free_pages(GFP_KERNEL|__GFP_ZERO|__GFP_RETRY_MAYFAIL
 				       |__GFP_NOWARN, order - PAGE_SHIFT);
 
 	if (!hpt)
diff -puN arch/sparc/kernel/mdesc.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic arch/sparc/kernel/mdesc.c
--- a/arch/sparc/kernel/mdesc.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/arch/sparc/kernel/mdesc.c
@@ -205,7 +205,7 @@ static struct mdesc_handle *mdesc_kmallo
 	handle_size = (sizeof(struct mdesc_handle) -
 		       sizeof(struct mdesc_hdr) +
 		       mdesc_size);
-	base = kmalloc(handle_size + 15, GFP_KERNEL | __GFP_REPEAT);
+	base = kmalloc(handle_size + 15, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!base)
 		return NULL;
 
diff -puN drivers/mmc/host/wbsd.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic drivers/mmc/host/wbsd.c
--- a/drivers/mmc/host/wbsd.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/drivers/mmc/host/wbsd.c
@@ -1386,7 +1386,7 @@ static void wbsd_request_dma(struct wbsd
 	 * order for ISA to be able to DMA to it.
 	 */
 	host->dma_buffer = kmalloc(WBSD_DMA_SIZE,
-		GFP_NOIO | GFP_DMA | __GFP_REPEAT | __GFP_NOWARN);
+		GFP_NOIO | GFP_DMA | __GFP_RETRY_MAYFAIL | __GFP_NOWARN);
 	if (!host->dma_buffer)
 		goto free;
 
diff -puN drivers/s390/char/vmcp.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic drivers/s390/char/vmcp.c
--- a/drivers/s390/char/vmcp.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/drivers/s390/char/vmcp.c
@@ -98,7 +98,7 @@ vmcp_write(struct file *file, const char
 	}
 	if (!session->response)
 		session->response = (char *)__get_free_pages(GFP_KERNEL
-						| __GFP_REPEAT | GFP_DMA,
+						| __GFP_RETRY_MAYFAIL | GFP_DMA,
 						get_order(session->bufsize));
 	if (!session->response) {
 		mutex_unlock(&session->mutex);
diff -puN drivers/target/target_core_transport.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic drivers/target/target_core_transport.c
--- a/drivers/target/target_core_transport.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/drivers/target/target_core_transport.c
@@ -252,7 +252,7 @@ int transport_alloc_session_tags(struct
 	int rc;
 
 	se_sess->sess_cmd_map = kzalloc(tag_num * tag_size,
-					GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
+					GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
 	if (!se_sess->sess_cmd_map) {
 		se_sess->sess_cmd_map = vzalloc(tag_num * tag_size);
 		if (!se_sess->sess_cmd_map) {
diff -puN drivers/vhost/net.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic drivers/vhost/net.c
--- a/drivers/vhost/net.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/drivers/vhost/net.c
@@ -897,7 +897,7 @@ static int vhost_net_open(struct inode *
 	struct sk_buff **queue;
 	int i;
 
-	n = kvmalloc(sizeof *n, GFP_KERNEL | __GFP_REPEAT);
+	n = kvmalloc(sizeof *n, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!n)
 		return -ENOMEM;
 	vqs = kmalloc(VHOST_NET_VQ_MAX * sizeof(*vqs), GFP_KERNEL);
diff -puN drivers/vhost/scsi.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic drivers/vhost/scsi.c
--- a/drivers/vhost/scsi.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/drivers/vhost/scsi.c
@@ -1404,7 +1404,7 @@ static int vhost_scsi_open(struct inode
 	struct vhost_virtqueue **vqs;
 	int r = -ENOMEM, i;
 
-	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
+	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
 	if (!vs) {
 		vs = vzalloc(sizeof(*vs));
 		if (!vs)
diff -puN drivers/vhost/vsock.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic drivers/vhost/vsock.c
--- a/drivers/vhost/vsock.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/drivers/vhost/vsock.c
@@ -508,7 +508,7 @@ static int vhost_vsock_dev_open(struct i
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
 	 */
-	vsock = kvmalloc(sizeof(*vsock), GFP_KERNEL | __GFP_REPEAT);
+	vsock = kvmalloc(sizeof(*vsock), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!vsock)
 		return -ENOMEM;
 
diff -puN include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic include/linux/gfp.h
--- a/include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/include/linux/gfp.h
@@ -25,7 +25,7 @@ struct vm_area_struct;
 #define ___GFP_FS		0x80u
 #define ___GFP_COLD		0x100u
 #define ___GFP_NOWARN		0x200u
-#define ___GFP_REPEAT		0x400u
+#define ___GFP_RETRY_MAYFAIL	0x400u
 #define ___GFP_NOFAIL		0x800u
 #define ___GFP_NORETRY		0x1000u
 #define ___GFP_MEMALLOC		0x2000u
@@ -136,26 +136,56 @@ struct vm_area_struct;
  *
  * __GFP_RECLAIM is shorthand to allow/forbid both direct and kswapd reclaim.
  *
- * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
- *   _might_ fail.  This depends upon the particular VM implementation.
+ * The default allocator behavior depends on the request size. We have a concept
+ * of so called costly allocations (with order > PAGE_ALLOC_COSTLY_ORDER).
+ * !costly allocations are too essential to fail so they are implicitly
+ * non-failing by default (with some exceptions like OOM victims might fail so
+ * the caller still has to check for failures) while costly requests try to be
+ * not disruptive and back off even without invoking the OOM killer.
+ * The following three modifiers might be used to override some of these
+ * implicit rules
+ *
+ * __GFP_NORETRY: The VM implementation will try only very lightweight
+ *   memory direct reclaim to get some memory under memory pressure (thus
+ *   it can sleep). It will avoid disruptive actions like OOM killer. The
+ *   caller must handle the failure which is quite likely to happen under
+ *   heavy memory pressure. The flag is suitable when failure can easily be
+ *   handled at small cost, such as reduced throughput
+ *
+ * __GFP_RETRY_MAYFAIL: The VM implementation will retry memory reclaim
+ *   procedures that have previously failed if there is some indication
+ *   that progress has been made else where.  It can wait for other
+ *   tasks to attempt high level approaches to freeing memory such as
+ *   compaction (which removes fragmentation) and page-out.
+ *   There is still a definite limit to the number of retries, but it is
+ *   a larger limit than with __GFP_NORETRY.
+ *   Allocations with this flag may fail, but only when there is
+ *   genuinely little unused memory. While these allocations do not
+ *   directly trigger the OOM killer, their failure indicates that
+ *   the system is likely to need to use the OOM killer soon.  The
+ *   caller must handle failure, but can reasonably do so by failing
+ *   a higher-level request, or completing it only in a much less
+ *   efficient manner.
+ *   If the allocation does fail, and the caller is in a position to
+ *   free some non-essential memory, doing so could benefit the system
+ *   as a whole.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- *   cannot handle allocation failures. New users should be evaluated carefully
- *   (and the flag should be used only when there is no reasonable failure
- *   policy) but it is definitely preferable to use the flag rather than
- *   opencode endless loop around allocator.
- *
- * __GFP_NORETRY: The VM implementation must not retry indefinitely and will
- *   return NULL when direct reclaim and memory compaction have failed to allow
- *   the allocation to succeed.  The OOM killer is not called with the current
- *   implementation.
+ *   cannot handle allocation failures. The allocation could block
+ *   indefinitely but will never return with failure. Testing for
+ *   failure is pointless.
+ *   New users should be evaluated carefully (and the flag should be
+ *   used only when there is no reasonable failure policy) but it is
+ *   definitely preferable to use the flag rather than opencode endless
+ *   loop around allocator.
+ *   Using this flag for costly allocations is _highly_ discouraged.
  */
 #define __GFP_IO	((__force gfp_t)___GFP_IO)
 #define __GFP_FS	((__force gfp_t)___GFP_FS)
 #define __GFP_DIRECT_RECLAIM	((__force gfp_t)___GFP_DIRECT_RECLAIM) /* Caller can reclaim */
 #define __GFP_KSWAPD_RECLAIM	((__force gfp_t)___GFP_KSWAPD_RECLAIM) /* kswapd can wake */
 #define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
-#define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)
+#define __GFP_RETRY_MAYFAIL	((__force gfp_t)___GFP_RETRY_MAYFAIL)
 #define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)
 #define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY)
 
diff -puN include/linux/slab.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic include/linux/slab.h
--- a/include/linux/slab.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/include/linux/slab.h
@@ -471,7 +471,8 @@ static __always_inline void *kmalloc_lar
  *
  * %__GFP_NOWARN - If allocation fails, don't issue any warnings.
  *
- * %__GFP_REPEAT - If allocation fails initially, try once more before failing.
+ * %__GFP_RETRY_MAYFAIL - Try really hard to succeed the allocation but fail
+ *   eventually.
  *
  * There are other flags available as well, but these are not intended
  * for general use, and so are not documented here. For a full list of
diff -puN include/trace/events/mmflags.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/include/trace/events/mmflags.h
@@ -34,7 +34,7 @@
 	{(unsigned long)__GFP_FS,		"__GFP_FS"},		\
 	{(unsigned long)__GFP_COLD,		"__GFP_COLD"},		\
 	{(unsigned long)__GFP_NOWARN,		"__GFP_NOWARN"},	\
-	{(unsigned long)__GFP_REPEAT,		"__GFP_REPEAT"},	\
+	{(unsigned long)__GFP_RETRY_MAYFAIL,	"__GFP_RETRY_MAYFAIL"},	\
 	{(unsigned long)__GFP_NOFAIL,		"__GFP_NOFAIL"},	\
 	{(unsigned long)__GFP_NORETRY,		"__GFP_NORETRY"},	\
 	{(unsigned long)__GFP_COMP,		"__GFP_COMP"},		\
diff -puN mm/hugetlb.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic mm/hugetlb.c
--- a/mm/hugetlb.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/mm/hugetlb.c
@@ -1384,7 +1384,7 @@ static struct page *alloc_fresh_huge_pag
 
 	page = __alloc_pages_node(nid,
 		htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
-						__GFP_REPEAT|__GFP_NOWARN,
+						__GFP_RETRY_MAYFAIL|__GFP_NOWARN,
 		huge_page_order(h));
 	if (page) {
 		prep_new_huge_page(h, page, nid);
@@ -1525,7 +1525,7 @@ static struct page *__hugetlb_alloc_budd
 {
 	int order = huge_page_order(h);
 
-	gfp_mask |= __GFP_COMP|__GFP_REPEAT|__GFP_NOWARN;
+	gfp_mask |= __GFP_COMP|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 	return __alloc_pages_nodemask(gfp_mask, order, nid, nmask);
diff -puN mm/internal.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic mm/internal.h
--- a/mm/internal.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/mm/internal.h
@@ -23,7 +23,7 @@
  * hints such as HIGHMEM usage.
  */
 #define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
-			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
+			__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NOFAIL|\
 			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC|\
 			__GFP_ATOMIC)
 
diff -puN mm/page_alloc.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic mm/page_alloc.c
--- a/mm/page_alloc.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/mm/page_alloc.c
@@ -3284,6 +3284,14 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	/* The OOM killer will not help higher order allocs */
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
 		goto out;
+	/*
+	 * We have already exhausted all our reclaim opportunities without any
+	 * success so it is time to admit defeat. We will skip the OOM killer
+	 * because it is very likely that the caller has a more reasonable
+	 * fallback than shooting a random task.
+	 */
+	if (gfp_mask & __GFP_RETRY_MAYFAIL)
+		goto out;
 	/* The OOM killer does not needlessly kill tasks for lowmem */
 	if (ac->high_zoneidx < ZONE_NORMAL)
 		goto out;
@@ -3413,7 +3421,7 @@ should_compact_retry(struct alloc_contex
 	}
 
 	/*
-	 * !costly requests are much more important than __GFP_REPEAT
+	 * !costly requests are much more important than __GFP_RETRY_MAYFAIL
 	 * costly ones because they are de facto nofail and invoke OOM
 	 * killer to move on while costly can fail and users are ready
 	 * to cope with that. 1/4 retries is rather arbitrary but we
@@ -3920,9 +3928,9 @@ retry:
 
 	/*
 	 * Do not retry costly high order allocations unless they are
-	 * __GFP_REPEAT
+	 * __GFP_RETRY_MAYFAIL
 	 */
-	if (costly_order && !(gfp_mask & __GFP_REPEAT))
+	if (costly_order && !(gfp_mask & __GFP_RETRY_MAYFAIL))
 		goto nopage;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
diff -puN mm/sparse-vmemmap.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/mm/sparse-vmemmap.c
@@ -56,11 +56,11 @@ void * __meminit vmemmap_alloc_block(uns
 
 		if (node_state(node, N_HIGH_MEMORY))
 			page = alloc_pages_node(
-				node, GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
+				node, GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL,
 				get_order(size));
 		else
 			page = alloc_pages(
-				GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
+				GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL,
 				get_order(size));
 		if (page)
 			return page_address(page);
diff -puN mm/util.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic mm/util.c
--- a/mm/util.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/mm/util.c
@@ -339,7 +339,7 @@ EXPORT_SYMBOL(vm_mmap);
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
- * Reclaim modifiers - __GFP_NORETRY and __GFP_NOFAIL are not supported. __GFP_REPEAT
+ * Reclaim modifiers - __GFP_NORETRY and __GFP_NOFAIL are not supported. __GFP_RETRY_MAYFAIL
  * is supported only for large (>32kB) allocations, and it should be used only if
  * kmalloc is preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
@@ -367,11 +367,11 @@ void *kvmalloc_node(size_t size, gfp_t f
 		kmalloc_flags |= __GFP_NOWARN;
 
 		/*
-		 * We have to override __GFP_REPEAT by __GFP_NORETRY for !costly
+		 * We have to override __GFP_RETRY_MAYFAIL by __GFP_NORETRY for !costly
 		 * requests because there is no other way to tell the allocator
 		 * that we want to fail rather than retry endlessly.
 		 */
-		if (!(kmalloc_flags & __GFP_REPEAT) ||
+		if (!(kmalloc_flags & __GFP_RETRY_MAYFAIL) ||
 				(size <= PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
 			kmalloc_flags |= __GFP_NORETRY;
 	}
diff -puN mm/vmalloc.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic mm/vmalloc.c
--- a/mm/vmalloc.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/mm/vmalloc.c
@@ -1795,7 +1795,7 @@ fail:
  *	allocator with @gfp_mask flags.  Map them into contiguous
  *	kernel virtual space, using a pagetable protection of @prot.
  *
- *	Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_REPEAT
+ *	Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
  *	and __GFP_NOFAIL are not supported
  *
  *	Any use of gfp flags outside of GFP_KERNEL should be consulted
diff -puN mm/vmscan.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic mm/vmscan.c
--- a/mm/vmscan.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/mm/vmscan.c
@@ -2506,18 +2506,18 @@ static inline bool should_continue_recla
 		return false;
 
 	/* Consider stopping depending on scan and reclaim activity */
-	if (sc->gfp_mask & __GFP_REPEAT) {
+	if (sc->gfp_mask & __GFP_RETRY_MAYFAIL) {
 		/*
-		 * For __GFP_REPEAT allocations, stop reclaiming if the
+		 * For __GFP_RETRY_MAYFAIL allocations, stop reclaiming if the
 		 * full LRU list has been scanned and we are still failing
 		 * to reclaim pages. This full LRU scan is potentially
-		 * expensive but a __GFP_REPEAT caller really wants to succeed
+		 * expensive but a __GFP_RETRY_MAYFAIL caller really wants to succeed
 		 */
 		if (!nr_reclaimed && !nr_scanned)
 			return false;
 	} else {
 		/*
-		 * For non-__GFP_REPEAT allocations which can presumably
+		 * For non-__GFP_RETRY_MAYFAIL allocations which can presumably
 		 * fail without consequence, stop if we failed to reclaim
 		 * any pages from the last SWAP_CLUSTER_MAX number of
 		 * pages that were scanned. This will return to the
diff -puN net/core/dev.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic net/core/dev.c
--- a/net/core/dev.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/net/core/dev.c
@@ -7384,7 +7384,7 @@ static int netif_alloc_rx_queues(struct
 
 	BUG_ON(count < 1);
 
-	rx = kvzalloc(sz, GFP_KERNEL | __GFP_REPEAT);
+	rx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!rx)
 		return -ENOMEM;
 
@@ -7424,7 +7424,7 @@ static int netif_alloc_netdev_queues(str
 	if (count < 1 || count > 0xffff)
 		return -EINVAL;
 
-	tx = kvzalloc(sz, GFP_KERNEL | __GFP_REPEAT);
+	tx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!tx)
 		return -ENOMEM;
 
@@ -7965,7 +7965,7 @@ struct net_device *alloc_netdev_mqs(int
 	/* ensure 32-byte alignment of whole construct */
 	alloc_size += NETDEV_ALIGN - 1;
 
-	p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_REPEAT);
+	p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!p)
 		return NULL;
 
diff -puN net/core/skbuff.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic net/core/skbuff.c
--- a/net/core/skbuff.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/net/core/skbuff.c
@@ -4747,7 +4747,7 @@ struct sk_buff *alloc_skb_with_frags(uns
 
 	gfp_head = gfp_mask;
 	if (gfp_head & __GFP_DIRECT_RECLAIM)
-		gfp_head |= __GFP_REPEAT;
+		gfp_head |= __GFP_RETRY_MAYFAIL;
 
 	*errcode = -ENOBUFS;
 	skb = alloc_skb(header_len, gfp_head);
diff -puN net/sched/sch_fq.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic net/sched/sch_fq.c
--- a/net/sched/sch_fq.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/net/sched/sch_fq.c
@@ -648,7 +648,7 @@ static int fq_resize(struct Qdisc *sch,
 		return 0;
 
 	/* If XPS was setup, we can allocate memory on right NUMA node */
-	array = kvmalloc_node(sizeof(struct rb_root) << log, GFP_KERNEL | __GFP_REPEAT,
+	array = kvmalloc_node(sizeof(struct rb_root) << log, GFP_KERNEL | __GFP_RETRY_MAYFAIL,
 			      netdev_queue_numa_node_read(sch->dev_queue));
 	if (!array)
 		return -ENOMEM;
diff -puN tools/perf/builtin-kmem.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic tools/perf/builtin-kmem.c
--- a/tools/perf/builtin-kmem.c~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic
+++ a/tools/perf/builtin-kmem.c
@@ -643,7 +643,7 @@ static const struct {
 	{ "__GFP_FS",			"F" },
 	{ "__GFP_COLD",			"CO" },
 	{ "__GFP_NOWARN",		"NWR" },
-	{ "__GFP_REPEAT",		"R" },
+	{ "__GFP_RETRY_MAYFAIL",	"R" },
 	{ "__GFP_NOFAIL",		"NF" },
 	{ "__GFP_NORETRY",		"NR" },
 	{ "__GFP_COMP",			"C" },
_

Patches currently in -mm which might be from mhocko@suse.com are



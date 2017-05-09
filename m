From: akpm@linux-foundation.org
Subject: [merged]
 treewide-use-kvalloc-rather-than-opencoded-variants.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:02:41 -0700
Message-ID: <20170509180241.cX9fmxCZv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34702 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdEISCn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.dilger@intel.com, anton@enomsg.org, ast@kernel.org, boris.ostrovsky@oracle.com, borntraeger@de.ibm.com, bskeggs@redhat.com, ccross@android.com, dan.j.williams@intel.com, davem@davemloft.net, dsterba@suse.com, eric.dumazet@gmail.com, hariprasad@chelsio.com, heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au, idryomov@gmail.com, keescook@chromium.org, kent.overstreet@gmail.com, leonro@mellanox.com, mhocko@suse.com, mm-commits@vger.kernel.org, oleg.drokin@intel.com, rjw@rjwysocki.net, santosh@chelsio.com, schwidefsky@de.ibm.com, tariqt@mellanox.com, tony.luck@intel.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, yishaih@mellanox.com, zyan@redhat.com


The patch titled
     Subject: treewide: use kv[mz]alloc* rather than opencoded variants
has been removed from the -mm tree.  Its filename was
     treewide-use-kvalloc-rather-than-opencoded-variants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: treewide: use kv[mz]alloc* rather than opencoded variants

There are many code paths opencoding kvmalloc.  Let's use the helper
instead.  The main difference to kvmalloc is that those users are usually
not considering all the aspects of the memory allocator.  E.g.  allocation
requests <= 32kB (with 4kB pages) are basically never failing and invoke
OOM killer to satisfy the allocation.  This sounds too disruptive for
something that has a reasonable fallback - the vmalloc.  On the other hand
those requests might fallback to vmalloc even when the memory allocator
would succeed after several more reclaim/compaction attempts previously. 
There is no guarantee something like that happens though.

This patch converts many of those places to kv[mz]alloc* helpers because
they are more conservative.

Link: http://lkml.kernel.org/r/20170306103327.2766-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com> # Xen bits
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Andreas Dilger <andreas.dilger@intel.com> # Lustre
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> # KVM/s390
Acked-by: Dan Williams <dan.j.williams@intel.com> # nvdim
Acked-by: David Sterba <dsterba@suse.com> # btrfs
Acked-by: Ilya Dryomov <idryomov@gmail.com> # Ceph
Acked-by: Tariq Toukan <tariqt@mellanox.com> # mlx4
Acked-by: Leon Romanovsky <leonro@mellanox.com> # mlx5
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Santosh Raspatur <santosh@chelsio.com>
Cc: Hariprasad S <hariprasad@chelsio.com>
Cc: Yishai Hadas <yishaih@mellanox.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: "Yan, Zheng" <zyan@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kvm/kvm-s390.c                             |   10 ---
 crypto/lzo.c                                         |    4 -
 drivers/acpi/apei/erst.c                             |    8 --
 drivers/char/agp/generic.c                           |    8 --
 drivers/gpu/drm/nouveau/nouveau_gem.c                |    4 -
 drivers/md/bcache/util.h                             |   12 ---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_defs.h      |    3 
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c   |   29 +-------
 drivers/net/ethernet/chelsio/cxgb3/l2t.c             |    8 --
 drivers/net/ethernet/chelsio/cxgb3/l2t.h             |    1 
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c        |   12 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h           |    3 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c   |   10 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c   |    8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      |   31 +--------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c    |   14 ++--
 drivers/net/ethernet/chelsio/cxgb4/l2t.c             |    2 
 drivers/net/ethernet/chelsio/cxgb4/sched.c           |   12 +--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c           |    9 --
 drivers/net/ethernet/mellanox/mlx4/mr.c              |    9 --
 drivers/nvdimm/dimm_devs.c                           |    5 -
 drivers/staging/lustre/lnet/libcfs/linux/linux-mem.c |   11 ---
 drivers/xen/evtchn.c                                 |   14 ----
 fs/btrfs/ctree.c                                     |    9 --
 fs/btrfs/ioctl.c                                     |    9 --
 fs/btrfs/send.c                                      |   27 ++------
 fs/ceph/file.c                                       |    9 --
 fs/select.c                                          |    5 -
 fs/xattr.c                                           |   27 ++------
 include/linux/mlx5/driver.h                          |    7 --
 include/linux/mm.h                                   |    8 ++
 lib/iov_iter.c                                       |    5 -
 mm/frame_vector.c                                    |    5 -
 net/ipv4/inet_hashtables.c                           |    6 -
 net/ipv4/tcp_metrics.c                               |    5 -
 net/mpls/af_mpls.c                                   |    5 -
 net/netfilter/x_tables.c                             |   21 +-----
 net/netfilter/xt_recent.c                            |    5 -
 net/sched/sch_choke.c                                |    5 -
 net/sched/sch_fq_codel.c                             |   26 +------
 net/sched/sch_hhf.c                                  |   33 ++--------
 net/sched/sch_netem.c                                |    6 -
 net/sched/sch_sfq.c                                  |    6 -
 security/keys/keyctl.c                               |   22 +-----
 44 files changed, 128 insertions(+), 350 deletions(-)

diff -puN arch/s390/kvm/kvm-s390.c~treewide-use-kvalloc-rather-than-opencoded-variants arch/s390/kvm/kvm-s390.c
--- a/arch/s390/kvm/kvm-s390.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/arch/s390/kvm/kvm-s390.c
@@ -1166,10 +1166,7 @@ static long kvm_s390_get_skeys(struct kv
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kmalloc_array(args->count, sizeof(uint8_t),
-			     GFP_KERNEL | __GFP_NOWARN);
-	if (!keys)
-		keys = vmalloc(sizeof(uint8_t) * args->count);
+	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
 	if (!keys)
 		return -ENOMEM;
 
@@ -1211,10 +1208,7 @@ static long kvm_s390_set_skeys(struct kv
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kmalloc_array(args->count, sizeof(uint8_t),
-			     GFP_KERNEL | __GFP_NOWARN);
-	if (!keys)
-		keys = vmalloc(sizeof(uint8_t) * args->count);
+	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
 	if (!keys)
 		return -ENOMEM;
 
diff -puN crypto/lzo.c~treewide-use-kvalloc-rather-than-opencoded-variants crypto/lzo.c
--- a/crypto/lzo.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/crypto/lzo.c
@@ -32,9 +32,7 @@ static void *lzo_alloc_ctx(struct crypto
 {
 	void *ctx;
 
-	ctx = kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL | __GFP_NOWARN);
-	if (!ctx)
-		ctx = vmalloc(LZO1X_MEM_COMPRESS);
+	ctx = kvmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
diff -puN drivers/acpi/apei/erst.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/acpi/apei/erst.c
--- a/drivers/acpi/apei/erst.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/acpi/apei/erst.c
@@ -513,7 +513,7 @@ retry:
 	if (i < erst_record_id_cache.len)
 		goto retry;
 	if (erst_record_id_cache.len >= erst_record_id_cache.size) {
-		int new_size, alloc_size;
+		int new_size;
 		u64 *new_entries;
 
 		new_size = erst_record_id_cache.size * 2;
@@ -524,11 +524,7 @@ retry:
 				pr_warn(FW_WARN "too many record IDs!\n");
 			return 0;
 		}
-		alloc_size = new_size * sizeof(entries[0]);
-		if (alloc_size < PAGE_SIZE)
-			new_entries = kmalloc(alloc_size, GFP_KERNEL);
-		else
-			new_entries = vmalloc(alloc_size);
+		new_entries = kvmalloc(new_size * sizeof(entries[0]), GFP_KERNEL);
 		if (!new_entries)
 			return -ENOMEM;
 		memcpy(new_entries, entries,
diff -puN drivers/char/agp/generic.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/char/agp/generic.c
@@ -88,13 +88,7 @@ static int agp_get_key(void)
 
 void agp_alloc_page_array(size_t size, struct agp_memory *mem)
 {
-	mem->pages = NULL;
-
-	if (size <= 2*PAGE_SIZE)
-		mem->pages = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (mem->pages == NULL) {
-		mem->pages = vmalloc(size);
-	}
+	mem->pages = kvmalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(agp_alloc_page_array);
 
diff -puN drivers/gpu/drm/nouveau/nouveau_gem.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/gpu/drm/nouveau/nouveau_gem.c
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -568,9 +568,7 @@ u_memcpya(uint64_t user, unsigned nmemb,
 
 	size *= nmemb;
 
-	mem = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (!mem)
-		mem = vmalloc(size);
+	mem = kvmalloc(size, GFP_KERNEL);
 	if (!mem)
 		return ERR_PTR(-ENOMEM);
 
diff -puN drivers/md/bcache/util.h~treewide-use-kvalloc-rather-than-opencoded-variants drivers/md/bcache/util.h
--- a/drivers/md/bcache/util.h~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/md/bcache/util.h
@@ -43,11 +43,7 @@ struct closure;
 	(heap)->used = 0;						\
 	(heap)->size = (_size);						\
 	_bytes = (heap)->size * sizeof(*(heap)->data);			\
-	(heap)->data = NULL;						\
-	if (_bytes < KMALLOC_MAX_SIZE)					\
-		(heap)->data = kmalloc(_bytes, (gfp));			\
-	if ((!(heap)->data) && ((gfp) & GFP_KERNEL))			\
-		(heap)->data = vmalloc(_bytes);				\
+	(heap)->data = kvmalloc(_bytes, (gfp) & GFP_KERNEL);		\
 	(heap)->data;							\
 })
 
@@ -136,12 +132,8 @@ do {									\
 									\
 	(fifo)->mask = _allocated_size - 1;				\
 	(fifo)->front = (fifo)->back = 0;				\
-	(fifo)->data = NULL;						\
 									\
-	if (_bytes < KMALLOC_MAX_SIZE)					\
-		(fifo)->data = kmalloc(_bytes, (gfp));			\
-	if ((!(fifo)->data) && ((gfp) & GFP_KERNEL))			\
-		(fifo)->data = vmalloc(_bytes);				\
+	(fifo)->data = kvmalloc(_bytes, (gfp) & GFP_KERNEL);		\
 	(fifo)->data;							\
 })
 
diff -puN drivers/net/ethernet/chelsio/cxgb3/cxgb3_defs.h~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb3/cxgb3_defs.h
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_defs.h~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_defs.h
@@ -41,9 +41,6 @@
 
 #define VALIDATE_TID 1
 
-void *cxgb_alloc_mem(unsigned long size);
-void cxgb_free_mem(void *addr);
-
 /*
  * Map an ATID or STID to their entries in the corresponding TID tables.
  */
diff -puN drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
@@ -1152,27 +1152,6 @@ static void cxgb_redirect(struct dst_ent
 }
 
 /*
- * Allocate a chunk of memory using kmalloc or, if that fails, vmalloc.
- * The allocated memory is cleared.
- */
-void *cxgb_alloc_mem(unsigned long size)
-{
-	void *p = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-
-	if (!p)
-		p = vzalloc(size);
-	return p;
-}
-
-/*
- * Free memory allocated through t3_alloc_mem().
- */
-void cxgb_free_mem(void *addr)
-{
-	kvfree(addr);
-}
-
-/*
  * Allocate and initialize the TID tables.  Returns 0 on success.
  */
 static int init_tid_tabs(struct tid_info *t, unsigned int ntids,
@@ -1182,7 +1161,7 @@ static int init_tid_tabs(struct tid_info
 	unsigned long size = ntids * sizeof(*t->tid_tab) +
 	    natids * sizeof(*t->atid_tab) + nstids * sizeof(*t->stid_tab);
 
-	t->tid_tab = cxgb_alloc_mem(size);
+	t->tid_tab = kvzalloc(size, GFP_KERNEL);
 	if (!t->tid_tab)
 		return -ENOMEM;
 
@@ -1218,7 +1197,7 @@ static int init_tid_tabs(struct tid_info
 
 static void free_tid_maps(struct tid_info *t)
 {
-	cxgb_free_mem(t->tid_tab);
+	kvfree(t->tid_tab);
 }
 
 static inline void add_adapter(struct adapter *adap)
@@ -1293,7 +1272,7 @@ int cxgb3_offload_activate(struct adapte
 	return 0;
 
 out_free_l2t:
-	t3_free_l2t(l2td);
+	kvfree(l2td);
 out_free:
 	kfree(t);
 	return err;
@@ -1302,7 +1281,7 @@ out_free:
 static void clean_l2_data(struct rcu_head *head)
 {
 	struct l2t_data *d = container_of(head, struct l2t_data, rcu_head);
-	t3_free_l2t(d);
+	kvfree(d);
 }
 
 
diff -puN drivers/net/ethernet/chelsio/cxgb3/l2t.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb3/l2t.c
--- a/drivers/net/ethernet/chelsio/cxgb3/l2t.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb3/l2t.c
@@ -444,7 +444,7 @@ struct l2t_data *t3_init_l2t(unsigned in
 	struct l2t_data *d;
 	int i, size = sizeof(*d) + l2t_capacity * sizeof(struct l2t_entry);
 
-	d = cxgb_alloc_mem(size);
+	d = kvzalloc(size, GFP_KERNEL);
 	if (!d)
 		return NULL;
 
@@ -462,9 +462,3 @@ struct l2t_data *t3_init_l2t(unsigned in
 	}
 	return d;
 }
-
-void t3_free_l2t(struct l2t_data *d)
-{
-	cxgb_free_mem(d);
-}
-
diff -puN drivers/net/ethernet/chelsio/cxgb3/l2t.h~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb3/l2t.h
--- a/drivers/net/ethernet/chelsio/cxgb3/l2t.h~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb3/l2t.h
@@ -115,7 +115,6 @@ int t3_l2t_send_slow(struct t3cdev *dev,
 		     struct l2t_entry *e);
 void t3_l2t_send_event(struct t3cdev *dev, struct l2t_entry *e);
 struct l2t_data *t3_init_l2t(unsigned int l2t_capacity);
-void t3_free_l2t(struct l2t_data *d);
 
 int cxgb3_ofld_send(struct t3cdev *dev, struct sk_buff *skb);
 
diff -puN drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -290,8 +290,8 @@ struct clip_tbl *t4_init_clip_tbl(unsign
 	if (clipt_size < CLIPT_MIN_HASH_BUCKETS)
 		return NULL;
 
-	ctbl = t4_alloc_mem(sizeof(*ctbl) +
-			    clipt_size*sizeof(struct list_head));
+	ctbl = kvzalloc(sizeof(*ctbl) +
+			    clipt_size*sizeof(struct list_head), GFP_KERNEL);
 	if (!ctbl)
 		return NULL;
 
@@ -305,9 +305,9 @@ struct clip_tbl *t4_init_clip_tbl(unsign
 	for (i = 0; i < ctbl->clipt_size; ++i)
 		INIT_LIST_HEAD(&ctbl->hash_list[i]);
 
-	cl_list = t4_alloc_mem(clipt_size*sizeof(struct clip_entry));
+	cl_list = kvzalloc(clipt_size*sizeof(struct clip_entry), GFP_KERNEL);
 	if (!cl_list) {
-		t4_free_mem(ctbl);
+		kvfree(ctbl);
 		return NULL;
 	}
 	ctbl->cl_list = (void *)cl_list;
@@ -326,8 +326,8 @@ void t4_cleanup_clip_tbl(struct adapter
 
 	if (ctbl) {
 		if (ctbl->cl_list)
-			t4_free_mem(ctbl->cl_list);
-		t4_free_mem(ctbl);
+			kvfree(ctbl->cl_list);
+		kvfree(ctbl);
 	}
 }
 EXPORT_SYMBOL(t4_cleanup_clip_tbl);
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4.h~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1184,8 +1184,6 @@ extern const char cxgb4_driver_version[]
 void t4_os_portmod_changed(const struct adapter *adap, int port_id);
 void t4_os_link_changed(struct adapter *adap, int port_id, int link_stat);
 
-void *t4_alloc_mem(size_t size);
-
 void t4_free_sge_resources(struct adapter *adap);
 void t4_free_ofld_rxqs(struct adapter *adap, int n, struct sge_ofld_rxq *q);
 irq_handler_t t4_intr_handler(struct adapter *adap);
@@ -1557,7 +1555,6 @@ int t4_sched_params(struct adapter *adap
 		    int rateunit, int ratemode, int channel, int class,
 		    int minrate, int maxrate, int weight, int pktsize);
 void t4_sge_decode_idma_state(struct adapter *adapter, int state);
-void t4_free_mem(void *addr);
 void t4_idma_monitor_init(struct adapter *adapter,
 			  struct sge_idma_monitor_state *idma);
 void t4_idma_monitor(struct adapter *adapter,
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2634,7 +2634,7 @@ static ssize_t mem_read(struct file *fil
 	if (count > avail - pos)
 		count = avail - pos;
 
-	data = t4_alloc_mem(count);
+	data = kvzalloc(count, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -2642,12 +2642,12 @@ static ssize_t mem_read(struct file *fil
 	ret = t4_memory_rw(adap, 0, mem, pos, count, data, T4_MEMORY_READ);
 	spin_unlock(&adap->win0_lock);
 	if (ret) {
-		t4_free_mem(data);
+		kvfree(data);
 		return ret;
 	}
 	ret = copy_to_user(buf, data, count);
 
-	t4_free_mem(data);
+	kvfree(data);
 	if (ret)
 		return -EFAULT;
 
@@ -2753,7 +2753,7 @@ static ssize_t blocked_fl_read(struct fi
 		       adap->sge.egr_sz, adap->sge.blocked_fl);
 	len += sprintf(buf + len, "\n");
 	size = simple_read_from_buffer(ubuf, count, ppos, buf, len);
-	t4_free_mem(buf);
+	kvfree(buf);
 	return size;
 }
 
@@ -2773,7 +2773,7 @@ static ssize_t blocked_fl_write(struct f
 		return err;
 
 	bitmap_copy(adap->sge.blocked_fl, t, adap->sge.egr_sz);
-	t4_free_mem(t);
+	kvfree(t);
 	return count;
 }
 
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -969,7 +969,7 @@ static int get_eeprom(struct net_device
 {
 	int i, err = 0;
 	struct adapter *adapter = netdev2adap(dev);
-	u8 *buf = t4_alloc_mem(EEPROMSIZE);
+	u8 *buf = kvzalloc(EEPROMSIZE, GFP_KERNEL);
 
 	if (!buf)
 		return -ENOMEM;
@@ -980,7 +980,7 @@ static int get_eeprom(struct net_device
 
 	if (!err)
 		memcpy(data, buf + e->offset, e->len);
-	t4_free_mem(buf);
+	kvfree(buf);
 	return err;
 }
 
@@ -1009,7 +1009,7 @@ static int set_eeprom(struct net_device
 	if (aligned_offset != eeprom->offset || aligned_len != eeprom->len) {
 		/* RMW possibly needed for first or last words.
 		 */
-		buf = t4_alloc_mem(aligned_len);
+		buf = kvzalloc(aligned_len, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
 		err = eeprom_rd_phys(adapter, aligned_offset, (u32 *)buf);
@@ -1037,7 +1037,7 @@ static int set_eeprom(struct net_device
 		err = t4_seeprom_wp(adapter, true);
 out:
 	if (buf != data)
-		t4_free_mem(buf);
+		kvfree(buf);
 	return err;
 }
 
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -880,27 +880,6 @@ freeout:
 	return err;
 }
 
-/*
- * Allocate a chunk of memory using kmalloc or, if that fails, vmalloc.
- * The allocated memory is cleared.
- */
-void *t4_alloc_mem(size_t size)
-{
-	void *p = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-
-	if (!p)
-		p = vzalloc(size);
-	return p;
-}
-
-/*
- * Free memory allocated through alloc_mem().
- */
-void t4_free_mem(void *addr)
-{
-	kvfree(addr);
-}
-
 static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
 			     void *accel_priv, select_queue_fallback_t fallback)
 {
@@ -1299,7 +1278,7 @@ static int tid_init(struct tid_info *t)
 	       max_ftids * sizeof(*t->ftid_tab) +
 	       ftid_bmap_size * sizeof(long);
 
-	t->tid_tab = t4_alloc_mem(size);
+	t->tid_tab = kvzalloc(size, GFP_KERNEL);
 	if (!t->tid_tab)
 		return -ENOMEM;
 
@@ -3445,7 +3424,7 @@ static int adap_init0(struct adapter *ad
 		/* allocate memory to read the header of the firmware on the
 		 * card
 		 */
-		card_fw = t4_alloc_mem(sizeof(*card_fw));
+		card_fw = kvzalloc(sizeof(*card_fw), GFP_KERNEL);
 
 		/* Get FW from from /lib/firmware/ */
 		ret = request_firmware(&fw, fw_info->fw_mod_name,
@@ -3465,7 +3444,7 @@ static int adap_init0(struct adapter *ad
 
 		/* Cleaning up */
 		release_firmware(fw);
-		t4_free_mem(card_fw);
+		kvfree(card_fw);
 
 		if (ret < 0)
 			goto bye;
@@ -4470,9 +4449,9 @@ static void free_some_resources(struct a
 {
 	unsigned int i;
 
-	t4_free_mem(adapter->l2t);
+	kvfree(adapter->l2t);
 	t4_cleanup_sched(adapter);
-	t4_free_mem(adapter->tids.tid_tab);
+	kvfree(adapter->tids.tid_tab);
 	cxgb4_cleanup_tc_u32(adapter);
 	kfree(adapter->sge.egr_map);
 	kfree(adapter->sge.ingr_map);
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -432,9 +432,9 @@ void cxgb4_cleanup_tc_u32(struct adapter
 	for (i = 0; i < t->size; i++) {
 		struct cxgb4_link *link = &t->table[i];
 
-		t4_free_mem(link->tid_map);
+		kvfree(link->tid_map);
 	}
-	t4_free_mem(adap->tc_u32);
+	kvfree(adap->tc_u32);
 }
 
 struct cxgb4_tc_u32_table *cxgb4_init_tc_u32(struct adapter *adap)
@@ -446,8 +446,8 @@ struct cxgb4_tc_u32_table *cxgb4_init_tc
 	if (!max_tids)
 		return NULL;
 
-	t = t4_alloc_mem(sizeof(*t) +
-			 (max_tids * sizeof(struct cxgb4_link)));
+	t = kvzalloc(sizeof(*t) +
+			 (max_tids * sizeof(struct cxgb4_link)), GFP_KERNEL);
 	if (!t)
 		return NULL;
 
@@ -458,7 +458,7 @@ struct cxgb4_tc_u32_table *cxgb4_init_tc
 		unsigned int bmap_size;
 
 		bmap_size = BITS_TO_LONGS(max_tids);
-		link->tid_map = t4_alloc_mem(sizeof(unsigned long) * bmap_size);
+		link->tid_map = kvzalloc(sizeof(unsigned long) * bmap_size, GFP_KERNEL);
 		if (!link->tid_map)
 			goto out_no_mem;
 		bitmap_zero(link->tid_map, max_tids);
@@ -471,11 +471,11 @@ out_no_mem:
 		struct cxgb4_link *link = &t->table[i];
 
 		if (link->tid_map)
-			t4_free_mem(link->tid_map);
+			kvfree(link->tid_map);
 	}
 
 	if (t)
-		t4_free_mem(t);
+		kvfree(t);
 
 	return NULL;
 }
diff -puN drivers/net/ethernet/chelsio/cxgb4/l2t.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/l2t.c
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -646,7 +646,7 @@ struct l2t_data *t4_init_l2t(unsigned in
 	if (l2t_size < L2T_MIN_HASH_BUCKETS)
 		return NULL;
 
-	d = t4_alloc_mem(sizeof(*d) + l2t_size * sizeof(struct l2t_entry));
+	d = kvzalloc(sizeof(*d) + l2t_size * sizeof(struct l2t_entry), GFP_KERNEL);
 	if (!d)
 		return NULL;
 
diff -puN drivers/net/ethernet/chelsio/cxgb4/sched.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/chelsio/cxgb4/sched.c
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -177,7 +177,7 @@ static int t4_sched_queue_unbind(struct
 		}
 
 		list_del(&qe->list);
-		t4_free_mem(qe);
+		kvfree(qe);
 		if (atomic_dec_and_test(&e->refcnt)) {
 			e->state = SCHED_STATE_UNUSED;
 			memset(&e->info, 0, sizeof(e->info));
@@ -201,7 +201,7 @@ static int t4_sched_queue_bind(struct po
 	if (p->queue < 0 || p->queue >= pi->nqsets)
 		return -ERANGE;
 
-	qe = t4_alloc_mem(sizeof(struct sched_queue_entry));
+	qe = kvzalloc(sizeof(struct sched_queue_entry), GFP_KERNEL);
 	if (!qe)
 		return -ENOMEM;
 
@@ -211,7 +211,7 @@ static int t4_sched_queue_bind(struct po
 	/* Unbind queue from any existing class */
 	err = t4_sched_queue_unbind(pi, p);
 	if (err) {
-		t4_free_mem(qe);
+		kvfree(qe);
 		goto out;
 	}
 
@@ -224,7 +224,7 @@ static int t4_sched_queue_bind(struct po
 	spin_lock(&e->lock);
 	err = t4_sched_bind_unbind_op(pi, (void *)qe, SCHED_QUEUE, true);
 	if (err) {
-		t4_free_mem(qe);
+		kvfree(qe);
 		spin_unlock(&e->lock);
 		goto out;
 	}
@@ -512,7 +512,7 @@ struct sched_table *t4_init_sched(unsign
 	struct sched_table *s;
 	unsigned int i;
 
-	s = t4_alloc_mem(sizeof(*s) + sched_size * sizeof(struct sched_class));
+	s = kvzalloc(sizeof(*s) + sched_size * sizeof(struct sched_class), GFP_KERNEL);
 	if (!s)
 		return NULL;
 
@@ -548,6 +548,6 @@ void t4_cleanup_sched(struct adapter *ad
 				t4_sched_class_free(pi, e);
 			write_unlock(&s->rw_lock);
 		}
-		t4_free_mem(s);
+		kvfree(s);
 	}
 }
diff -puN drivers/net/ethernet/mellanox/mlx4/en_tx.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/mellanox/mlx4/en_tx.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -70,13 +70,10 @@ int mlx4_en_create_tx_ring(struct mlx4_e
 	ring->full_size = ring->size - HEADROOM - MAX_DESC_TXBBS;
 
 	tmp = size * sizeof(struct mlx4_en_tx_info);
-	ring->tx_info = kmalloc_node(tmp, GFP_KERNEL | __GFP_NOWARN, node);
+	ring->tx_info = kvmalloc_node(tmp, GFP_KERNEL, node);
 	if (!ring->tx_info) {
-		ring->tx_info = vmalloc(tmp);
-		if (!ring->tx_info) {
-			err = -ENOMEM;
-			goto err_ring;
-		}
+		err = -ENOMEM;
+		goto err_ring;
 	}
 
 	en_dbg(DRV, priv, "Allocated tx_info ring at addr:%p size:%d\n",
diff -puN drivers/net/ethernet/mellanox/mlx4/mr.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/net/ethernet/mellanox/mlx4/mr.c
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -115,12 +115,9 @@ static int mlx4_buddy_init(struct mlx4_b
 
 	for (i = 0; i <= buddy->max_order; ++i) {
 		s = BITS_TO_LONGS(1 << (buddy->max_order - i));
-		buddy->bits[i] = kcalloc(s, sizeof (long), GFP_KERNEL | __GFP_NOWARN);
-		if (!buddy->bits[i]) {
-			buddy->bits[i] = vzalloc(s * sizeof(long));
-			if (!buddy->bits[i])
-				goto err_out_free;
-		}
+		buddy->bits[i] = kvmalloc_array(s, sizeof(long), GFP_KERNEL | __GFP_ZERO);
+		if (!buddy->bits[i])
+			goto err_out_free;
 	}
 
 	set_bit(0, buddy->bits[buddy->max_order]);
diff -puN drivers/nvdimm/dimm_devs.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/nvdimm/dimm_devs.c
--- a/drivers/nvdimm/dimm_devs.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/nvdimm/dimm_devs.c
@@ -106,10 +106,7 @@ int nvdimm_init_config_data(struct nvdim
 		return -ENXIO;
 	}
 
-	ndd->data = kmalloc(ndd->nsarea.config_size, GFP_KERNEL);
-	if (!ndd->data)
-		ndd->data = vmalloc(ndd->nsarea.config_size);
-
+	ndd->data = kvmalloc(ndd->nsarea.config_size, GFP_KERNEL);
 	if (!ndd->data)
 		return -ENOMEM;
 
diff -puN drivers/staging/lustre/lnet/libcfs/linux/linux-mem.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/staging/lustre/lnet/libcfs/linux/linux-mem.c
--- a/drivers/staging/lustre/lnet/libcfs/linux/linux-mem.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/staging/lustre/lnet/libcfs/linux/linux-mem.c
@@ -45,15 +45,6 @@ EXPORT_SYMBOL(libcfs_kvzalloc);
 void *libcfs_kvzalloc_cpt(struct cfs_cpt_table *cptab, int cpt, size_t size,
 			  gfp_t flags)
 {
-	void *ret;
-
-	ret = kzalloc_node(size, flags | __GFP_NOWARN,
-			   cfs_cpt_spread_node(cptab, cpt));
-	if (!ret) {
-		WARN_ON(!(flags & (__GFP_FS | __GFP_HIGH)));
-		ret = vmalloc_node(size, cfs_cpt_spread_node(cptab, cpt));
-	}
-
-	return ret;
+	return kvzalloc_node(size, flags, cfs_cpt_spread_node(cptab, cpt));
 }
 EXPORT_SYMBOL(libcfs_kvzalloc_cpt);
diff -puN drivers/xen/evtchn.c~treewide-use-kvalloc-rather-than-opencoded-variants drivers/xen/evtchn.c
--- a/drivers/xen/evtchn.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/drivers/xen/evtchn.c
@@ -87,18 +87,6 @@ struct user_evtchn {
 	bool enabled;
 };
 
-static evtchn_port_t *evtchn_alloc_ring(unsigned int size)
-{
-	evtchn_port_t *ring;
-	size_t s = size * sizeof(*ring);
-
-	ring = kmalloc(s, GFP_KERNEL);
-	if (!ring)
-		ring = vmalloc(s);
-
-	return ring;
-}
-
 static void evtchn_free_ring(evtchn_port_t *ring)
 {
 	kvfree(ring);
@@ -334,7 +322,7 @@ static int evtchn_resize_ring(struct per
 	else
 		new_size = 2 * u->ring_size;
 
-	new_ring = evtchn_alloc_ring(new_size);
+	new_ring = kvmalloc(new_size * sizeof(*new_ring), GFP_KERNEL);
 	if (!new_ring)
 		return -ENOMEM;
 
diff -puN fs/btrfs/ctree.c~treewide-use-kvalloc-rather-than-opencoded-variants fs/btrfs/ctree.c
--- a/fs/btrfs/ctree.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/fs/btrfs/ctree.c
@@ -5392,13 +5392,10 @@ int btrfs_compare_trees(struct btrfs_roo
 		goto out;
 	}
 
-	tmp_buf = kmalloc(fs_info->nodesize, GFP_KERNEL | __GFP_NOWARN);
+	tmp_buf = kvmalloc(fs_info->nodesize, GFP_KERNEL);
 	if (!tmp_buf) {
-		tmp_buf = vmalloc(fs_info->nodesize);
-		if (!tmp_buf) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	left_path->search_commit_root = 1;
diff -puN fs/btrfs/ioctl.c~treewide-use-kvalloc-rather-than-opencoded-variants fs/btrfs/ioctl.c
--- a/fs/btrfs/ioctl.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/fs/btrfs/ioctl.c
@@ -3539,12 +3539,9 @@ static int btrfs_clone(struct inode *src
 	u64 last_dest_end = destoff;
 
 	ret = -ENOMEM;
-	buf = kmalloc(fs_info->nodesize, GFP_KERNEL | __GFP_NOWARN);
-	if (!buf) {
-		buf = vmalloc(fs_info->nodesize);
-		if (!buf)
-			return ret;
-	}
+	buf = kvmalloc(fs_info->nodesize, GFP_KERNEL);
+	if (!buf)
+		return ret;
 
 	path = btrfs_alloc_path();
 	if (!path) {
diff -puN fs/btrfs/send.c~treewide-use-kvalloc-rather-than-opencoded-variants fs/btrfs/send.c
--- a/fs/btrfs/send.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/fs/btrfs/send.c
@@ -6360,22 +6360,16 @@ long btrfs_ioctl_send(struct file *mnt_f
 	sctx->clone_roots_cnt = arg->clone_sources_count;
 
 	sctx->send_max_size = BTRFS_SEND_BUF_SIZE;
-	sctx->send_buf = kmalloc(sctx->send_max_size, GFP_KERNEL | __GFP_NOWARN);
+	sctx->send_buf = kvmalloc(sctx->send_max_size, GFP_KERNEL);
 	if (!sctx->send_buf) {
-		sctx->send_buf = vmalloc(sctx->send_max_size);
-		if (!sctx->send_buf) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	sctx->read_buf = kmalloc(BTRFS_SEND_READ_SIZE, GFP_KERNEL | __GFP_NOWARN);
+	sctx->read_buf = kvmalloc(BTRFS_SEND_READ_SIZE, GFP_KERNEL);
 	if (!sctx->read_buf) {
-		sctx->read_buf = vmalloc(BTRFS_SEND_READ_SIZE);
-		if (!sctx->read_buf) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	sctx->pending_dir_moves = RB_ROOT;
@@ -6396,13 +6390,10 @@ long btrfs_ioctl_send(struct file *mnt_f
 	alloc_size = arg->clone_sources_count * sizeof(*arg->clone_sources);
 
 	if (arg->clone_sources_count) {
-		clone_sources_tmp = kmalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
+		clone_sources_tmp = kvmalloc(alloc_size, GFP_KERNEL);
 		if (!clone_sources_tmp) {
-			clone_sources_tmp = vmalloc(alloc_size);
-			if (!clone_sources_tmp) {
-				ret = -ENOMEM;
-				goto out;
-			}
+			ret = -ENOMEM;
+			goto out;
 		}
 
 		ret = copy_from_user(clone_sources_tmp, arg->clone_sources,
diff -puN fs/ceph/file.c~treewide-use-kvalloc-rather-than-opencoded-variants fs/ceph/file.c
--- a/fs/ceph/file.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/fs/ceph/file.c
@@ -74,12 +74,9 @@ dio_get_pages_alloc(const struct iov_ite
 	align = (unsigned long)(it->iov->iov_base + it->iov_offset) &
 		(PAGE_SIZE - 1);
 	npages = calc_pages_for(align, nbytes);
-	pages = kmalloc(sizeof(*pages) * npages, GFP_KERNEL);
-	if (!pages) {
-		pages = vmalloc(sizeof(*pages) * npages);
-		if (!pages)
-			return ERR_PTR(-ENOMEM);
-	}
+	pages = kvmalloc(sizeof(*pages) * npages, GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
 
 	for (idx = 0; idx < npages; ) {
 		size_t start;
diff -puN fs/select.c~treewide-use-kvalloc-rather-than-opencoded-variants fs/select.c
--- a/fs/select.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/fs/select.c
@@ -633,10 +633,7 @@ int core_sys_select(int n, fd_set __user
 			goto out_nofds;
 
 		alloc_size = 6 * size;
-		bits = kmalloc(alloc_size, GFP_KERNEL|__GFP_NOWARN);
-		if (!bits && alloc_size > PAGE_SIZE)
-			bits = vmalloc(alloc_size);
-
+		bits = kvmalloc(alloc_size, GFP_KERNEL);
 		if (!bits)
 			goto out_nofds;
 	}
diff -puN fs/xattr.c~treewide-use-kvalloc-rather-than-opencoded-variants fs/xattr.c
--- a/fs/xattr.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/fs/xattr.c
@@ -431,12 +431,9 @@ setxattr(struct dentry *d, const char __
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-		if (!kvalue) {
-			kvalue = vmalloc(size);
-			if (!kvalue)
-				return -ENOMEM;
-		}
+		kvalue = kvmalloc(size, GFP_KERNEL);
+		if (!kvalue)
+			return -ENOMEM;
 		if (copy_from_user(kvalue, value, size)) {
 			error = -EFAULT;
 			goto out;
@@ -528,12 +525,9 @@ getxattr(struct dentry *d, const char __
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			size = XATTR_SIZE_MAX;
-		kvalue = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-		if (!kvalue) {
-			kvalue = vzalloc(size);
-			if (!kvalue)
-				return -ENOMEM;
-		}
+		kvalue = kvzalloc(size, GFP_KERNEL);
+		if (!kvalue)
+			return -ENOMEM;
 	}
 
 	error = vfs_getxattr(d, kname, kvalue, size);
@@ -611,12 +605,9 @@ listxattr(struct dentry *d, char __user
 	if (size) {
 		if (size > XATTR_LIST_MAX)
 			size = XATTR_LIST_MAX;
-		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
-		if (!klist) {
-			klist = vmalloc(size);
-			if (!klist)
-				return -ENOMEM;
-		}
+		klist = kvmalloc(size, GFP_KERNEL);
+		if (!klist)
+			return -ENOMEM;
 	}
 
 	error = vfs_listxattr(d, klist, size);
diff -puN include/linux/mlx5/driver.h~treewide-use-kvalloc-rather-than-opencoded-variants include/linux/mlx5/driver.h
--- a/include/linux/mlx5/driver.h~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/include/linux/mlx5/driver.h
@@ -892,12 +892,7 @@ static inline u16 cmdif_rev(struct mlx5_
 
 static inline void *mlx5_vzalloc(unsigned long size)
 {
-	void *rtn;
-
-	rtn = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (!rtn)
-		rtn = vzalloc(size);
-	return rtn;
+	return kvzalloc(size, GFP_KERNEL);
 }
 
 static inline u32 mlx5_base_mkey(const u32 key)
diff -puN include/linux/mm.h~treewide-use-kvalloc-rather-than-opencoded-variants include/linux/mm.h
--- a/include/linux/mm.h~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/include/linux/mm.h
@@ -532,6 +532,14 @@ static inline void *kvzalloc(size_t size
 	return kvmalloc(size, flags | __GFP_ZERO);
 }
 
+static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	if (size != 0 && n > SIZE_MAX / size)
+		return NULL;
+
+	return kvmalloc(n * size, flags);
+}
+
 extern void kvfree(const void *addr);
 
 static inline atomic_t *compound_mapcount_ptr(struct page *page)
diff -puN lib/iov_iter.c~treewide-use-kvalloc-rather-than-opencoded-variants lib/iov_iter.c
--- a/lib/iov_iter.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/lib/iov_iter.c
@@ -1028,10 +1028,7 @@ EXPORT_SYMBOL(iov_iter_get_pages);
 
 static struct page **get_pages_array(size_t n)
 {
-	struct page **p = kmalloc(n * sizeof(struct page *), GFP_KERNEL);
-	if (!p)
-		p = vmalloc(n * sizeof(struct page *));
-	return p;
+	return kvmalloc_array(n, sizeof(struct page *), GFP_KERNEL);
 }
 
 static ssize_t pipe_get_pages_alloc(struct iov_iter *i,
diff -puN mm/frame_vector.c~treewide-use-kvalloc-rather-than-opencoded-variants mm/frame_vector.c
--- a/mm/frame_vector.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/mm/frame_vector.c
@@ -200,10 +200,7 @@ struct frame_vector *frame_vector_create
 	 * Avoid higher order allocations, use vmalloc instead. It should
 	 * be rare anyway.
 	 */
-	if (size <= PAGE_SIZE)
-		vec = kmalloc(size, GFP_KERNEL);
-	else
-		vec = vmalloc(size);
+	vec = kvmalloc(size, GFP_KERNEL);
 	if (!vec)
 		return NULL;
 	vec->nr_allocated = nr_frames;
diff -puN net/ipv4/inet_hashtables.c~treewide-use-kvalloc-rather-than-opencoded-variants net/ipv4/inet_hashtables.c
--- a/net/ipv4/inet_hashtables.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/ipv4/inet_hashtables.c
@@ -678,11 +678,7 @@ int inet_ehash_locks_alloc(struct inet_h
 		/* no more locks than number of hash buckets */
 		nblocks = min(nblocks, hashinfo->ehash_mask + 1);
 
-		hashinfo->ehash_locks =	kmalloc_array(nblocks, locksz,
-						      GFP_KERNEL | __GFP_NOWARN);
-		if (!hashinfo->ehash_locks)
-			hashinfo->ehash_locks = vmalloc(nblocks * locksz);
-
+		hashinfo->ehash_locks = kvmalloc_array(nblocks, locksz, GFP_KERNEL);
 		if (!hashinfo->ehash_locks)
 			return -ENOMEM;
 
diff -puN net/ipv4/tcp_metrics.c~treewide-use-kvalloc-rather-than-opencoded-variants net/ipv4/tcp_metrics.c
--- a/net/ipv4/tcp_metrics.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/ipv4/tcp_metrics.c
@@ -1011,10 +1011,7 @@ static int __net_init tcp_net_metrics_in
 	tcp_metrics_hash_log = order_base_2(slots);
 	size = sizeof(struct tcpm_hash_bucket) << tcp_metrics_hash_log;
 
-	tcp_metrics_hash = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (!tcp_metrics_hash)
-		tcp_metrics_hash = vzalloc(size);
-
+	tcp_metrics_hash = kvzalloc(size, GFP_KERNEL);
 	if (!tcp_metrics_hash)
 		return -ENOMEM;
 
diff -puN net/mpls/af_mpls.c~treewide-use-kvalloc-rather-than-opencoded-variants net/mpls/af_mpls.c
--- a/net/mpls/af_mpls.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/mpls/af_mpls.c
@@ -2005,10 +2005,7 @@ static int resize_platform_label_table(s
 	unsigned index;
 
 	if (size) {
-		labels = kzalloc(size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
-		if (!labels)
-			labels = vzalloc(size);
-
+		labels = kvzalloc(size, GFP_KERNEL);
 		if (!labels)
 			goto nolabels;
 	}
diff -puN net/netfilter/x_tables.c~treewide-use-kvalloc-rather-than-opencoded-variants net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/netfilter/x_tables.c
@@ -763,17 +763,8 @@ EXPORT_SYMBOL(xt_check_entry_offsets);
  */
 unsigned int *xt_alloc_entry_offsets(unsigned int size)
 {
-	unsigned int *off;
+	return kvmalloc_array(size, sizeof(unsigned int), GFP_KERNEL | __GFP_ZERO);
 
-	off = kcalloc(size, sizeof(unsigned int), GFP_KERNEL | __GFP_NOWARN);
-
-	if (off)
-		return off;
-
-	if (size < (SIZE_MAX / sizeof(unsigned int)))
-		off = vmalloc(size * sizeof(unsigned int));
-
-	return off;
 }
 EXPORT_SYMBOL(xt_alloc_entry_offsets);
 
@@ -1116,7 +1107,7 @@ static int xt_jumpstack_alloc(struct xt_
 
 	size = sizeof(void **) * nr_cpu_ids;
 	if (size > PAGE_SIZE)
-		i->jumpstack = vzalloc(size);
+		i->jumpstack = kvzalloc(size, GFP_KERNEL);
 	else
 		i->jumpstack = kzalloc(size, GFP_KERNEL);
 	if (i->jumpstack == NULL)
@@ -1138,12 +1129,8 @@ static int xt_jumpstack_alloc(struct xt_
 	 */
 	size = sizeof(void *) * i->stacksize * 2u;
 	for_each_possible_cpu(cpu) {
-		if (size > PAGE_SIZE)
-			i->jumpstack[cpu] = vmalloc_node(size,
-				cpu_to_node(cpu));
-		else
-			i->jumpstack[cpu] = kmalloc_node(size,
-				GFP_KERNEL, cpu_to_node(cpu));
+		i->jumpstack[cpu] = kvmalloc_node(size, GFP_KERNEL,
+			cpu_to_node(cpu));
 		if (i->jumpstack[cpu] == NULL)
 			/*
 			 * Freeing will be done later on by the callers. The
diff -puN net/netfilter/xt_recent.c~treewide-use-kvalloc-rather-than-opencoded-variants net/netfilter/xt_recent.c
--- a/net/netfilter/xt_recent.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/netfilter/xt_recent.c
@@ -388,10 +388,7 @@ static int recent_mt_check(const struct
 	}
 
 	sz = sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size;
-	if (sz <= PAGE_SIZE)
-		t = kzalloc(sz, GFP_KERNEL);
-	else
-		t = vzalloc(sz);
+	t = kvzalloc(sz, GFP_KERNEL);
 	if (t == NULL) {
 		ret = -ENOMEM;
 		goto out;
diff -puN net/sched/sch_choke.c~treewide-use-kvalloc-rather-than-opencoded-variants net/sched/sch_choke.c
--- a/net/sched/sch_choke.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/sched/sch_choke.c
@@ -376,10 +376,7 @@ static int choke_change(struct Qdisc *sc
 	if (mask != q->tab_mask) {
 		struct sk_buff **ntab;
 
-		ntab = kcalloc(mask + 1, sizeof(struct sk_buff *),
-			       GFP_KERNEL | __GFP_NOWARN);
-		if (!ntab)
-			ntab = vzalloc((mask + 1) * sizeof(struct sk_buff *));
+		ntab = kvmalloc_array((mask + 1), sizeof(struct sk_buff *), GFP_KERNEL | __GFP_ZERO);
 		if (!ntab)
 			return -ENOMEM;
 
diff -puN net/sched/sch_fq_codel.c~treewide-use-kvalloc-rather-than-opencoded-variants net/sched/sch_fq_codel.c
--- a/net/sched/sch_fq_codel.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/sched/sch_fq_codel.c
@@ -446,27 +446,13 @@ static int fq_codel_change(struct Qdisc
 	return 0;
 }
 
-static void *fq_codel_zalloc(size_t sz)
-{
-	void *ptr = kzalloc(sz, GFP_KERNEL | __GFP_NOWARN);
-
-	if (!ptr)
-		ptr = vzalloc(sz);
-	return ptr;
-}
-
-static void fq_codel_free(void *addr)
-{
-	kvfree(addr);
-}
-
 static void fq_codel_destroy(struct Qdisc *sch)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 
 	tcf_destroy_chain(&q->filter_list);
-	fq_codel_free(q->backlogs);
-	fq_codel_free(q->flows);
+	kvfree(q->backlogs);
+	kvfree(q->flows);
 }
 
 static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt)
@@ -493,13 +479,13 @@ static int fq_codel_init(struct Qdisc *s
 	}
 
 	if (!q->flows) {
-		q->flows = fq_codel_zalloc(q->flows_cnt *
-					   sizeof(struct fq_codel_flow));
+		q->flows = kvzalloc(q->flows_cnt *
+					   sizeof(struct fq_codel_flow), GFP_KERNEL);
 		if (!q->flows)
 			return -ENOMEM;
-		q->backlogs = fq_codel_zalloc(q->flows_cnt * sizeof(u32));
+		q->backlogs = kvzalloc(q->flows_cnt * sizeof(u32), GFP_KERNEL);
 		if (!q->backlogs) {
-			fq_codel_free(q->flows);
+			kvfree(q->flows);
 			return -ENOMEM;
 		}
 		for (i = 0; i < q->flows_cnt; i++) {
diff -puN net/sched/sch_hhf.c~treewide-use-kvalloc-rather-than-opencoded-variants net/sched/sch_hhf.c
--- a/net/sched/sch_hhf.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/sched/sch_hhf.c
@@ -467,29 +467,14 @@ static void hhf_reset(struct Qdisc *sch)
 		rtnl_kfree_skbs(skb, skb);
 }
 
-static void *hhf_zalloc(size_t sz)
-{
-	void *ptr = kzalloc(sz, GFP_KERNEL | __GFP_NOWARN);
-
-	if (!ptr)
-		ptr = vzalloc(sz);
-
-	return ptr;
-}
-
-static void hhf_free(void *addr)
-{
-	kvfree(addr);
-}
-
 static void hhf_destroy(struct Qdisc *sch)
 {
 	int i;
 	struct hhf_sched_data *q = qdisc_priv(sch);
 
 	for (i = 0; i < HHF_ARRAYS_CNT; i++) {
-		hhf_free(q->hhf_arrays[i]);
-		hhf_free(q->hhf_valid_bits[i]);
+		kvfree(q->hhf_arrays[i]);
+		kvfree(q->hhf_valid_bits[i]);
 	}
 
 	for (i = 0; i < HH_FLOWS_CNT; i++) {
@@ -503,7 +488,7 @@ static void hhf_destroy(struct Qdisc *sc
 			kfree(flow);
 		}
 	}
-	hhf_free(q->hh_flows);
+	kvfree(q->hh_flows);
 }
 
 static const struct nla_policy hhf_policy[TCA_HHF_MAX + 1] = {
@@ -609,8 +594,8 @@ static int hhf_init(struct Qdisc *sch, s
 
 	if (!q->hh_flows) {
 		/* Initialize heavy-hitter flow table. */
-		q->hh_flows = hhf_zalloc(HH_FLOWS_CNT *
-					 sizeof(struct list_head));
+		q->hh_flows = kvzalloc(HH_FLOWS_CNT *
+					 sizeof(struct list_head), GFP_KERNEL);
 		if (!q->hh_flows)
 			return -ENOMEM;
 		for (i = 0; i < HH_FLOWS_CNT; i++)
@@ -624,8 +609,8 @@ static int hhf_init(struct Qdisc *sch, s
 
 		/* Initialize heavy-hitter filter arrays. */
 		for (i = 0; i < HHF_ARRAYS_CNT; i++) {
-			q->hhf_arrays[i] = hhf_zalloc(HHF_ARRAYS_LEN *
-						      sizeof(u32));
+			q->hhf_arrays[i] = kvzalloc(HHF_ARRAYS_LEN *
+						      sizeof(u32), GFP_KERNEL);
 			if (!q->hhf_arrays[i]) {
 				/* Note: hhf_destroy() will be called
 				 * by our caller.
@@ -637,8 +622,8 @@ static int hhf_init(struct Qdisc *sch, s
 
 		/* Initialize valid bits of heavy-hitter filter arrays. */
 		for (i = 0; i < HHF_ARRAYS_CNT; i++) {
-			q->hhf_valid_bits[i] = hhf_zalloc(HHF_ARRAYS_LEN /
-							  BITS_PER_BYTE);
+			q->hhf_valid_bits[i] = kvzalloc(HHF_ARRAYS_LEN /
+							  BITS_PER_BYTE, GFP_KERNEL);
 			if (!q->hhf_valid_bits[i]) {
 				/* Note: hhf_destroy() will be called
 				 * by our caller.
diff -puN net/sched/sch_netem.c~treewide-use-kvalloc-rather-than-opencoded-variants net/sched/sch_netem.c
--- a/net/sched/sch_netem.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/sched/sch_netem.c
@@ -702,15 +702,11 @@ static int get_dist_table(struct Qdisc *
 	spinlock_t *root_lock;
 	struct disttable *d;
 	int i;
-	size_t s;
 
 	if (n > NETEM_DIST_MAX)
 		return -EINVAL;
 
-	s = sizeof(struct disttable) + n * sizeof(s16);
-	d = kmalloc(s, GFP_KERNEL | __GFP_NOWARN);
-	if (!d)
-		d = vmalloc(s);
+	d = kvmalloc(sizeof(struct disttable) + n * sizeof(s16), GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;
 
diff -puN net/sched/sch_sfq.c~treewide-use-kvalloc-rather-than-opencoded-variants net/sched/sch_sfq.c
--- a/net/sched/sch_sfq.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/net/sched/sch_sfq.c
@@ -685,11 +685,7 @@ static int sfq_change(struct Qdisc *sch,
 
 static void *sfq_alloc(size_t sz)
 {
-	void *ptr = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN);
-
-	if (!ptr)
-		ptr = vmalloc(sz);
-	return ptr;
+	return  kvmalloc(sz, GFP_KERNEL);
 }
 
 static void sfq_free(void *addr)
diff -puN security/keys/keyctl.c~treewide-use-kvalloc-rather-than-opencoded-variants security/keys/keyctl.c
--- a/security/keys/keyctl.c~treewide-use-kvalloc-rather-than-opencoded-variants
+++ a/security/keys/keyctl.c
@@ -101,14 +101,9 @@ SYSCALL_DEFINE5(add_key, const char __us
 
 	if (_payload) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL | __GFP_NOWARN);
-		if (!payload) {
-			if (plen <= PAGE_SIZE)
-				goto error2;
-			payload = vmalloc(plen);
-			if (!payload)
-				goto error2;
-		}
+		payload = kvmalloc(plen, GFP_KERNEL);
+		if (!payload)
+			goto error2;
 
 		ret = -EFAULT;
 		if (copy_from_user(payload, _payload, plen) != 0)
@@ -1071,14 +1066,9 @@ long keyctl_instantiate_key_common(key_s
 
 	if (from) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL);
-		if (!payload) {
-			if (plen <= PAGE_SIZE)
-				goto error;
-			payload = vmalloc(plen);
-			if (!payload)
-				goto error;
-		}
+		payload = kvmalloc(plen, GFP_KERNEL);
+		if (!payload)
+			goto error;
 
 		ret = -EFAULT;
 		if (!copy_from_iter_full(payload, plen, from))
_

Patches currently in -mm which might be from mhocko@suse.com are



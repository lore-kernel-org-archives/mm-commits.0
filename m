Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D64C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiANWHK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48452 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWHJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C0A661FF0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3597FC36AE5;
        Fri, 14 Jan 2022 22:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198028;
        bh=0XSX5HzE+MIUOn3OaABCAvi1Gn2dMYH9+oMOYrdLJv0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lH6672N9ky1pUP1pyWqUisMmQNN37oFUSnAxmAL86v0U9kWYZtG1shKf5cW4mzF4v
         +iGJ+HdQpdhHELvprcjYyW+vn2NKNoujvr8bVDQPGYfcr7NZYnAoaqBwAtTEik45yj
         YTHvkLkRRTyaMZeDqYoTitabcJ699NN8JpWAfhNY=
Date:   Fri, 14 Jan 2022 14:07:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        david@fromorbit.com, hch@lst.de, idryomov@gmail.com,
        jlayton@kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org, urezki@gmail.com, vbabka@suse.cz
Subject:  [patch 076/146] mm: allow !GFP_KERNEL allocations for
 kvmalloc
Message-ID: <20220114220707.SD7dYB5br%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm: allow !GFP_KERNEL allocations for kvmalloc

Support for GFP_NO{FS,IO} and __GFP_NOFAIL has been implemented by
previous patches so we can allow the support for kvmalloc.  This will
allow some external users to simplify or completely remove their helpers.

GFP_NOWAIT semantic hasn't been supported so far but it hasn't been
explicitly documented so let's add a note about that.

ceph_kvmalloc is the first helper to be dropped and changed to kvmalloc.

Link: https://lkml.kernel.org/r/20211122153233.9924-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ceph/libceph.h |    1 -
 mm/util.c                    |   15 ++++-----------
 net/ceph/buffer.c            |    4 ++--
 net/ceph/ceph_common.c       |   27 ---------------------------
 net/ceph/crypto.c            |    2 +-
 net/ceph/messenger.c         |    2 +-
 net/ceph/messenger_v2.c      |    2 +-
 net/ceph/osdmap.c            |   12 ++++++------
 8 files changed, 15 insertions(+), 50 deletions(-)

--- a/include/linux/ceph/libceph.h~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/include/linux/ceph/libceph.h
@@ -295,7 +295,6 @@ extern bool libceph_compatible(void *dat
 
 extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
-extern void *ceph_kvmalloc(size_t size, gfp_t flags);
 
 struct fs_parameter;
 struct fc_log;
--- a/mm/util.c~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/mm/util.c
@@ -549,13 +549,10 @@ EXPORT_SYMBOL(vm_mmap);
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
- * Reclaim modifiers - __GFP_NORETRY and __GFP_NOFAIL are not supported.
+ * GFP_NOWAIT and GFP_ATOMIC are not supported, neither is the __GFP_NORETRY modifier.
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
- * Please note that any use of gfp flags outside of GFP_KERNEL is careful to not
- * fall back to vmalloc.
- *
  * Return: pointer to the allocated memory of %NULL in case of failure
  */
 void *kvmalloc_node(size_t size, gfp_t flags, int node)
@@ -564,13 +561,6 @@ void *kvmalloc_node(size_t size, gfp_t f
 	void *ret;
 
 	/*
-	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
-	 * so the given set of flags has to be compatible.
-	 */
-	if ((flags & GFP_KERNEL) != GFP_KERNEL)
-		return kmalloc_node(size, flags, node);
-
-	/*
 	 * We want to attempt a large physically contiguous block first because
 	 * it is less likely to fragment multiple larger blocks and therefore
 	 * contribute to a long term fragmentation less than vmalloc fallback.
@@ -582,6 +572,9 @@ void *kvmalloc_node(size_t size, gfp_t f
 
 		if (!(kmalloc_flags & __GFP_RETRY_MAYFAIL))
 			kmalloc_flags |= __GFP_NORETRY;
+
+		/* nofail semantic is implemented by the vmalloc fallback */
+		kmalloc_flags &= ~__GFP_NOFAIL;
 	}
 
 	ret = kmalloc_node(size, kmalloc_flags, node);
--- a/net/ceph/buffer.c~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/net/ceph/buffer.c
@@ -7,7 +7,7 @@
 
 #include <linux/ceph/buffer.h>
 #include <linux/ceph/decode.h>
-#include <linux/ceph/libceph.h> /* for ceph_kvmalloc */
+#include <linux/ceph/libceph.h> /* for kvmalloc */
 
 struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp)
 {
@@ -17,7 +17,7 @@ struct ceph_buffer *ceph_buffer_new(size
 	if (!b)
 		return NULL;
 
-	b->vec.iov_base = ceph_kvmalloc(len, gfp);
+	b->vec.iov_base = kvmalloc(len, gfp);
 	if (!b->vec.iov_base) {
 		kfree(b);
 		return NULL;
--- a/net/ceph/ceph_common.c~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/net/ceph/ceph_common.c
@@ -190,33 +190,6 @@ int ceph_compare_options(struct ceph_opt
 }
 EXPORT_SYMBOL(ceph_compare_options);
 
-/*
- * kvmalloc() doesn't fall back to the vmalloc allocator unless flags are
- * compatible with (a superset of) GFP_KERNEL.  This is because while the
- * actual pages are allocated with the specified flags, the page table pages
- * are always allocated with GFP_KERNEL.
- *
- * ceph_kvmalloc() may be called with GFP_KERNEL, GFP_NOFS or GFP_NOIO.
- */
-void *ceph_kvmalloc(size_t size, gfp_t flags)
-{
-	void *p;
-
-	if ((flags & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS)) {
-		p = kvmalloc(size, flags);
-	} else if ((flags & (__GFP_IO | __GFP_FS)) == __GFP_IO) {
-		unsigned int nofs_flag = memalloc_nofs_save();
-		p = kvmalloc(size, GFP_KERNEL);
-		memalloc_nofs_restore(nofs_flag);
-	} else {
-		unsigned int noio_flag = memalloc_noio_save();
-		p = kvmalloc(size, GFP_KERNEL);
-		memalloc_noio_restore(noio_flag);
-	}
-
-	return p;
-}
-
 static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 {
 	int i = 0;
--- a/net/ceph/crypto.c~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/net/ceph/crypto.c
@@ -147,7 +147,7 @@ void ceph_crypto_key_destroy(struct ceph
 static const u8 *aes_iv = (u8 *)CEPH_AES_IV;
 
 /*
- * Should be used for buffers allocated with ceph_kvmalloc().
+ * Should be used for buffers allocated with kvmalloc().
  * Currently these are encrypt out-buffer (ceph_buffer) and decrypt
  * in-buffer (msg front).
  *
--- a/net/ceph/messenger.c~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/net/ceph/messenger.c
@@ -1920,7 +1920,7 @@ struct ceph_msg *ceph_msg_new2(int type,
 
 	/* front */
 	if (front_len) {
-		m->front.iov_base = ceph_kvmalloc(front_len, flags);
+		m->front.iov_base = kvmalloc(front_len, flags);
 		if (m->front.iov_base == NULL) {
 			dout("ceph_msg_new can't allocate %d bytes\n",
 			     front_len);
--- a/net/ceph/messenger_v2.c~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/net/ceph/messenger_v2.c
@@ -308,7 +308,7 @@ static void *alloc_conn_buf(struct ceph_
 	if (WARN_ON(con->v2.conn_buf_cnt >= ARRAY_SIZE(con->v2.conn_bufs)))
 		return NULL;
 
-	buf = ceph_kvmalloc(len, GFP_NOIO);
+	buf = kvmalloc(len, GFP_NOIO);
 	if (!buf)
 		return NULL;
 
--- a/net/ceph/osdmap.c~mm-allow-gfp_kernel-allocations-for-kvmalloc
+++ a/net/ceph/osdmap.c
@@ -980,7 +980,7 @@ static struct crush_work *alloc_workspac
 	work_size = crush_work_size(c, CEPH_PG_MAX_SIZE);
 	dout("%s work_size %zu bytes\n", __func__, work_size);
 
-	work = ceph_kvmalloc(work_size, GFP_NOIO);
+	work = kvmalloc(work_size, GFP_NOIO);
 	if (!work)
 		return NULL;
 
@@ -1190,9 +1190,9 @@ static int osdmap_set_max_osd(struct cep
 	if (max == map->max_osd)
 		return 0;
 
-	state = ceph_kvmalloc(array_size(max, sizeof(*state)), GFP_NOFS);
-	weight = ceph_kvmalloc(array_size(max, sizeof(*weight)), GFP_NOFS);
-	addr = ceph_kvmalloc(array_size(max, sizeof(*addr)), GFP_NOFS);
+	state = kvmalloc(array_size(max, sizeof(*state)), GFP_NOFS);
+	weight = kvmalloc(array_size(max, sizeof(*weight)), GFP_NOFS);
+	addr = kvmalloc(array_size(max, sizeof(*addr)), GFP_NOFS);
 	if (!state || !weight || !addr) {
 		kvfree(state);
 		kvfree(weight);
@@ -1222,7 +1222,7 @@ static int osdmap_set_max_osd(struct cep
 	if (map->osd_primary_affinity) {
 		u32 *affinity;
 
-		affinity = ceph_kvmalloc(array_size(max, sizeof(*affinity)),
+		affinity = kvmalloc(array_size(max, sizeof(*affinity)),
 					 GFP_NOFS);
 		if (!affinity)
 			return -ENOMEM;
@@ -1503,7 +1503,7 @@ static int set_primary_affinity(struct c
 	if (!map->osd_primary_affinity) {
 		int i;
 
-		map->osd_primary_affinity = ceph_kvmalloc(
+		map->osd_primary_affinity = kvmalloc(
 		    array_size(map->max_osd, sizeof(*map->osd_primary_affinity)),
 		    GFP_NOFS);
 		if (!map->osd_primary_affinity)
_

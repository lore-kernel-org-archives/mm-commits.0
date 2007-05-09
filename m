From: akpm@linux-foundation.org
Subject: - dm-io-new-interface.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:56 -0700
Message-ID: <200705092148.l49Lmunb002643@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758133AbXEIVtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hjm@redhat.com, agk@redhat.com, mbroz@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm io: new interface
has been removed from the -mm tree.  Its filename was
     dm-io-new-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm io: new interface
From: Heinz Mauelshagen <hjm@redhat.com>

Add a new API to dm-io.c that uses a private mempool and bio_set for each
client.

The new functions to use are dm_io_client_create(), dm_io_client_destroy(),
dm_io_client_resize() and dm_io().

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-io.c |  122 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-io.h |   52 +++++++++++++++++-
 2 files changed, 173 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm-io.c~dm-io-new-interface drivers/md/dm-io.c
--- a/drivers/md/dm-io.c~dm-io-new-interface
+++ a/drivers/md/dm-io.c
@@ -103,6 +103,51 @@ void dm_io_put(unsigned int num_pages)
 	resize_pool(_num_ios - pages_to_ios(num_pages));
 }
 
+/*
+ * Create a client with mempool and bioset.
+ */
+struct dm_io_client *dm_io_client_create(unsigned num_pages)
+{
+	unsigned ios = pages_to_ios(num_pages);
+	struct dm_io_client *client;
+
+	client = kmalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return ERR_PTR(-ENOMEM);
+
+	client->pool = mempool_create_kmalloc_pool(ios, sizeof(struct io));
+	if (!client->pool)
+		goto bad;
+
+	client->bios = bioset_create(16, 16);
+	if (!client->bios)
+		goto bad;
+
+	return client;
+
+   bad:
+	if (client->pool)
+		mempool_destroy(client->pool);
+	kfree(client);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL(dm_io_client_create);
+
+int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client)
+{
+	return mempool_resize(client->pool, pages_to_ios(num_pages),
+			      GFP_KERNEL);
+}
+EXPORT_SYMBOL(dm_io_client_resize);
+
+void dm_io_client_destroy(struct dm_io_client *client)
+{
+	mempool_destroy(client->pool);
+	bioset_free(client->bios);
+	kfree(client);
+}
+EXPORT_SYMBOL(dm_io_client_destroy);
+
 /*-----------------------------------------------------------------
  * We need to keep track of which region a bio is doing io for.
  * In order to save a memory allocation we store this the last
@@ -236,6 +281,9 @@ static void bvec_dp_init(struct dpages *
 	dp->context_ptr = bvec;
 }
 
+/*
+ * Functions for getting the pages from a VMA.
+ */
 static void vm_get_page(struct dpages *dp,
 		 struct page **p, unsigned long *len, unsigned *offset)
 {
@@ -265,6 +313,31 @@ static void dm_bio_destructor(struct bio
 	bio_free(bio, bios(io->client));
 }
 
+/*
+ * Functions for getting the pages from kernel memory.
+ */
+static void km_get_page(struct dpages *dp, struct page **p, unsigned long *len,
+			unsigned *offset)
+{
+	*p = virt_to_page(dp->context_ptr);
+	*offset = dp->context_u;
+	*len = PAGE_SIZE - dp->context_u;
+}
+
+static void km_next_page(struct dpages *dp)
+{
+	dp->context_ptr += PAGE_SIZE - dp->context_u;
+	dp->context_u = 0;
+}
+
+static void km_dp_init(struct dpages *dp, void *data)
+{
+	dp->get_page = km_get_page;
+	dp->next_page = km_next_page;
+	dp->context_u = ((unsigned long) data) & (PAGE_SIZE - 1);
+	dp->context_ptr = data;
+}
+
 /*-----------------------------------------------------------------
  * IO routines that accept a list of pages.
  *---------------------------------------------------------------*/
@@ -451,6 +524,55 @@ int dm_io_async_vm(unsigned int num_regi
 	return async_io(NULL, num_regions, where, rw, &dp, fn, context);
 }
 
+static int dp_init(struct dm_io_request *io_req, struct dpages *dp)
+{
+	/* Set up dpages based on memory type */
+	switch (io_req->mem.type) {
+	case DM_IO_PAGE_LIST:
+		list_dp_init(dp, io_req->mem.ptr.pl, io_req->mem.offset);
+		break;
+
+	case DM_IO_BVEC:
+		bvec_dp_init(dp, io_req->mem.ptr.bvec);
+		break;
+
+	case DM_IO_VMA:
+		vm_dp_init(dp, io_req->mem.ptr.vma);
+		break;
+
+	case DM_IO_KMEM:
+		km_dp_init(dp, io_req->mem.ptr.addr);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * New collapsed (a)synchronous interface
+ */
+int dm_io(struct dm_io_request *io_req, unsigned num_regions,
+	  struct io_region *where, unsigned long *sync_error_bits)
+{
+	int r;
+	struct dpages dp;
+
+	r = dp_init(io_req, &dp);
+	if (r)
+		return r;
+
+	if (!io_req->notify.fn)
+		return sync_io(io_req->client, num_regions, where,
+			       io_req->bi_rw, &dp, sync_error_bits);
+
+	return async_io(io_req->client, num_regions, where, io_req->bi_rw,
+			&dp, io_req->notify.fn, io_req->notify.context);
+}
+EXPORT_SYMBOL(dm_io);
+
 EXPORT_SYMBOL(dm_io_get);
 EXPORT_SYMBOL(dm_io_put);
 EXPORT_SYMBOL(dm_io_sync);
diff -puN drivers/md/dm-io.h~dm-io-new-interface drivers/md/dm-io.h
--- a/drivers/md/dm-io.h~dm-io-new-interface
+++ a/drivers/md/dm-io.h
@@ -20,13 +20,47 @@ struct page_list {
 	struct page *page;
 };
 
-
 /*
  * 'error' is a bitset, with each bit indicating whether an error
  * occurred doing io to the corresponding region.
  */
 typedef void (*io_notify_fn)(unsigned long error, void *context);
 
+enum dm_io_mem_type {
+	DM_IO_PAGE_LIST,/* Page list */
+	DM_IO_BVEC,	/* Bio vector */
+	DM_IO_VMA,	/* Virtual memory area */
+	DM_IO_KMEM,	/* Kernel memory */
+};
+
+struct dm_io_memory {
+	enum dm_io_mem_type type;
+
+	union {
+		struct page_list *pl;
+		struct bio_vec *bvec;
+		void *vma;
+		void *addr;
+	} ptr;
+
+	unsigned offset;
+};
+
+struct dm_io_notify {
+	io_notify_fn fn;	/* Callback for asynchronous requests */
+	void *context;		/* Passed to callback */
+};
+
+/*
+ * IO request structure
+ */
+struct dm_io_client;
+struct dm_io_request {
+	int bi_rw;			/* READ|WRITE - not READA */
+	struct dm_io_memory mem;	/* Memory to use for io */
+	struct dm_io_notify notify;	/* Synchronous if notify.fn is NULL */
+	struct dm_io_client *client;	/* Client memory handler */
+};
 
 /*
  * Before anyone uses the IO interface they should call
@@ -39,6 +73,16 @@ int dm_io_get(unsigned int num_pages);
 void dm_io_put(unsigned int num_pages);
 
 /*
+ * For async io calls, users can alternatively use the dm_io() function below
+ * and dm_io_client_create() to create private mempools for the client.
+ *
+ * Create/destroy may block.
+ */
+struct dm_io_client *dm_io_client_create(unsigned num_pages);
+int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client);
+void dm_io_client_destroy(struct dm_io_client *client);
+
+/*
  * Synchronous IO.
  *
  * Please ensure that the rw flag in the next two functions is
@@ -71,4 +115,10 @@ int dm_io_async_bvec(unsigned int num_re
 int dm_io_async_vm(unsigned int num_regions, struct io_region *where, int rw,
 		   void *data, io_notify_fn fn, void *context);
 
+/*
+ * IO interface using private per-client pools.
+ */
+int dm_io(struct dm_io_request *io_req, unsigned num_regions,
+	  struct io_region *region, unsigned long *sync_error_bits);
+
 #endif
_

Patches currently in -mm which might be from hjm@redhat.com are

origin.patch

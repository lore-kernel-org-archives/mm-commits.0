From: akpm@linux-foundation.org
Subject: - dm-exception-store-update-dm-io-interface.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:00 -0700
Message-ID: <200705092149.l49Ln01U002651@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758115AbXEIVtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hjm@redhat.com, agk@redhat.com, mbroz@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm exception store: update dm io interface
has been removed from the -mm tree.  Its filename was
     dm-exception-store-update-dm-io-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm exception store: update dm io interface
From: Heinz Mauelshagen <hjm@redhat.com>

This patch ports dm-exception-store.c to the new, scalable dm_io() interface.

It replaces dm_io_get()/dm_io_put() by
dm_io_client_create()/dm_io_client_destroy() calls and
dm_io_sync_vm() by dm_io() to achive this.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-exception-store.c |   52 ++++++++++++++++--------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff -puN drivers/md/dm-exception-store.c~dm-exception-store-update-dm-io-interface drivers/md/dm-exception-store.c
--- a/drivers/md/dm-exception-store.c~dm-exception-store-update-dm-io-interface
+++ a/drivers/md/dm-exception-store.c
@@ -1,7 +1,8 @@
 /*
- * dm-snapshot.c
+ * dm-exception-store.c
  *
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2006 Red Hat GmbH
  *
  * This file is released under the GPL.
  */
@@ -123,6 +124,7 @@ struct pstore {
 	atomic_t pending_count;
 	uint32_t callback_count;
 	struct commit_callback *callbacks;
+	struct dm_io_client *io_client;
 };
 
 static inline unsigned int sectors_to_pages(unsigned int sectors)
@@ -159,14 +161,20 @@ static void free_area(struct pstore *ps)
  */
 static int chunk_io(struct pstore *ps, uint32_t chunk, int rw)
 {
-	struct io_region where;
-	unsigned long bits;
+	struct io_region where = {
+		.bdev = ps->snap->cow->bdev,
+		.sector = ps->snap->chunk_size * chunk,
+		.count = ps->snap->chunk_size,
+	};
+	struct dm_io_request io_req = {
+		.bi_rw = rw,
+		.mem.type = DM_IO_VMA,
+		.mem.ptr.vma = ps->area,
+		.client = ps->io_client,
+		.notify.fn = NULL,
+	};
 
-	where.bdev = ps->snap->cow->bdev;
-	where.sector = ps->snap->chunk_size * chunk;
-	where.count = ps->snap->chunk_size;
-
-	return dm_io_sync_vm(1, &where, rw, ps->area, &bits);
+	return dm_io(&io_req, 1, &where, NULL);
 }
 
 /*
@@ -213,17 +221,18 @@ static int read_header(struct pstore *ps
 		chunk_size_supplied = 0;
 	}
 
-	r = dm_io_get(sectors_to_pages(ps->snap->chunk_size));
-	if (r)
-		return r;
+	ps->io_client = dm_io_client_create(sectors_to_pages(ps->snap->
+							     chunk_size));
+	if (IS_ERR(ps->io_client))
+		return PTR_ERR(ps->io_client);
 
 	r = alloc_area(ps);
 	if (r)
-		goto bad1;
+		return r;
 
 	r = chunk_io(ps, 0, READ);
 	if (r)
-		goto bad2;
+		goto bad;
 
 	dh = (struct disk_header *) ps->area;
 
@@ -235,7 +244,7 @@ static int read_header(struct pstore *ps
 	if (le32_to_cpu(dh->magic) != SNAP_MAGIC) {
 		DMWARN("Invalid or corrupt snapshot");
 		r = -ENXIO;
-		goto bad2;
+		goto bad;
 	}
 
 	*new_snapshot = 0;
@@ -252,27 +261,22 @@ static int read_header(struct pstore *ps
 	       (unsigned long long)ps->snap->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
-	dm_io_put(sectors_to_pages(ps->snap->chunk_size));
 	free_area(ps);
 
 	ps->snap->chunk_size = chunk_size;
 	ps->snap->chunk_mask = chunk_size - 1;
 	ps->snap->chunk_shift = ffs(chunk_size) - 1;
 
-	r = dm_io_get(sectors_to_pages(chunk_size));
+	r = dm_io_client_resize(sectors_to_pages(ps->snap->chunk_size),
+				ps->io_client);
 	if (r)
 		return r;
 
 	r = alloc_area(ps);
-	if (r)
-		goto bad1;
-
-	return 0;
+	return r;
 
-bad2:
+bad:
 	free_area(ps);
-bad1:
-	dm_io_put(sectors_to_pages(ps->snap->chunk_size));
 	return r;
 }
 
@@ -405,7 +409,7 @@ static void persistent_destroy(struct ex
 {
 	struct pstore *ps = get_info(store);
 
-	dm_io_put(sectors_to_pages(ps->snap->chunk_size));
+	dm_io_client_destroy(ps->io_client);
 	vfree(ps->callbacks);
 	free_area(ps);
 	kfree(ps);
_

Patches currently in -mm which might be from hjm@redhat.com are

origin.patch

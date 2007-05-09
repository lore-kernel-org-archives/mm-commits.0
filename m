From: akpm@linux-foundation.org
Subject: + dm-kcopyd-update-dm-io-interface.patch added to -mm tree
Date: Tue, 08 May 2007 17:55:02 -0700
Message-ID: <200705090055.l490t4ac006409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968399AbXEIAzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mbroz@redhat.com, agk@redhat.com, hjm@redhat.com


The patch titled
     dm kcopyd: update dm io interface
has been added to the -mm tree.  Its filename is
     dm-kcopyd-update-dm-io-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm kcopyd: update dm io interface
From: Milan Broz <mbroz@redhat.com>

This patch ports kcopyd.c to the new, scalable dm_io() interface.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/kcopyd.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/md/kcopyd.c~dm-kcopyd-update-dm-io-interface drivers/md/kcopyd.c
--- a/drivers/md/kcopyd.c~dm-kcopyd-update-dm-io-interface
+++ a/drivers/md/kcopyd.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2006 Red Hat GmbH
  *
  * This file is released under the GPL.
  *
@@ -45,6 +46,8 @@ struct kcopyd_client {
 	unsigned int nr_pages;
 	unsigned int nr_free_pages;
 
+	struct dm_io_client *io_client;
+
 	wait_queue_head_t destroyq;
 	atomic_t nr_jobs;
 };
@@ -342,16 +345,20 @@ static void complete_io(unsigned long er
 static int run_io_job(struct kcopyd_job *job)
 {
 	int r;
+	struct dm_io_request io_req = {
+		.bi_rw = job->rw,
+		.mem.type = DM_IO_PAGE_LIST,
+		.mem.ptr.pl = job->pages,
+		.mem.offset = job->offset,
+		.notify.fn = complete_io,
+		.notify.context = job,
+		.client = job->kc->io_client,
+	};
 
 	if (job->rw == READ)
-		r = dm_io_async(1, &job->source, job->rw,
-				job->pages,
-				job->offset, complete_io, job);
-
+		r = dm_io(&io_req, 1, &job->source, NULL);
 	else
-		r = dm_io_async(job->num_dests, job->dests, job->rw,
-				job->pages,
-				job->offset, complete_io, job);
+		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
 
 	return r;
 }
@@ -670,8 +677,9 @@ int kcopyd_client_create(unsigned int nr
 		return r;
 	}
 
-	r = dm_io_get(nr_pages);
-	if (r) {
+	kc->io_client = dm_io_client_create(nr_pages);
+	if (IS_ERR(kc->io_client)) {
+		r = PTR_ERR(kc->io_client);
 		client_free_pages(kc);
 		kfree(kc);
 		kcopyd_exit();
@@ -691,7 +699,7 @@ void kcopyd_client_destroy(struct kcopyd
 	/* Wait for completion of all jobs submitted by this client. */
 	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
 
-	dm_io_put(kc->nr_pages);
+	dm_io_client_destroy(kc->io_client);
 	client_free_pages(kc);
 	client_del(kc);
 	kfree(kc);
_

Patches currently in -mm which might be from mbroz@redhat.com are

dm-crypt-disable-barriers.patch
dm-io-delay-dec_count.patch
dm-io-prepare-for-new-interface.patch
dm-io-new-interface.patch
dm-kcopyd-update-dm-io-interface.patch
dm-exception-store-update-dm-io-interface.patch
dm-log-update-dm-io-interface.patch
dm-raid1-update-dm-io-interface.patch
dm-io-remove-old-interface.patch
dm-bio-list-helpers.patch
dm-delay-target.patch

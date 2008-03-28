From: akpm@linux-foundation.org
Subject: + dm-io-write-error-bits-form-long-not-int.patch added to -mm tree
Date: Fri, 28 Mar 2008 03:34:24 -0700
Message-ID: <200803281034.m2SAYOSL018061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbYC1KfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 06:35:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agk@redhat.com, heiko.carstens@de.ibm.com


The patch titled
     dm io: write error bits form long not int
has been added to the -mm tree.  Its filename is
     dm-io-write-error-bits-form-long-not-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm io: write error bits form long not int
From: Alasdair G Kergon <agk@redhat.com>

write_err is an unsigned long used with set_bit() so should not be passed
around as unsigned int.

http://bugzilla.kernel.org/show_bug.cgi?id=10271

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-io.c    |    2 +-
 drivers/md/dm-raid1.c |    4 ++--
 drivers/md/dm-snap.c  |    2 +-
 drivers/md/kcopyd.c   |   10 +++++-----
 drivers/md/kcopyd.h   |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/md/dm-io.c~dm-io-write-error-bits-form-long-not-int drivers/md/dm-io.c
--- a/drivers/md/dm-io.c~dm-io-write-error-bits-form-long-not-int
+++ a/drivers/md/dm-io.c
@@ -114,7 +114,7 @@ static void dec_count(struct io *io, uns
 			wake_up_process(io->sleeper);
 
 		else {
-			int r = io->error;
+			unsigned long r = io->error;
 			io_notify_fn fn = io->callback;
 			void *context = io->context;
 
diff -puN drivers/md/dm-raid1.c~dm-io-write-error-bits-form-long-not-int drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-io-write-error-bits-form-long-not-int
+++ a/drivers/md/dm-raid1.c
@@ -753,7 +753,7 @@ out:
  * are in the no-sync state.  We have to recover these by
  * recopying from the default mirror to all the others.
  *---------------------------------------------------------------*/
-static void recovery_complete(int read_err, unsigned int write_err,
+static void recovery_complete(int read_err, unsigned long write_err,
 			      void *context)
 {
 	struct region *reg = (struct region *)context;
@@ -767,7 +767,7 @@ static void recovery_complete(int read_e
 	}
 
 	if (write_err) {
-		DMERR_LIMIT("Write error during recovery (error = 0x%x)",
+		DMERR_LIMIT("Write error during recovery (error = 0x%lx)",
 			    write_err);
 		/*
 		 * Bits correspond to devices (excluding default mirror).
diff -puN drivers/md/dm-snap.c~dm-io-write-error-bits-form-long-not-int drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~dm-io-write-error-bits-form-long-not-int
+++ a/drivers/md/dm-snap.c
@@ -804,7 +804,7 @@ static void commit_callback(void *contex
  * Called when the copy I/O has finished.  kcopyd actually runs
  * this code so don't block.
  */
-static void copy_callback(int read_err, unsigned int write_err, void *context)
+static void copy_callback(int read_err, unsigned long write_err, void *context)
 {
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_snapshot *s = pe->snap;
diff -puN drivers/md/kcopyd.c~dm-io-write-error-bits-form-long-not-int drivers/md/kcopyd.c
--- a/drivers/md/kcopyd.c~dm-io-write-error-bits-form-long-not-int
+++ a/drivers/md/kcopyd.c
@@ -169,7 +169,7 @@ struct kcopyd_job {
 	 * Error state of the job.
 	 */
 	int read_err;
-	unsigned int write_err;
+	unsigned long write_err;
 
 	/*
 	 * Either READ or WRITE
@@ -293,7 +293,7 @@ static int run_complete_job(struct kcopy
 {
 	void *context = job->context;
 	int read_err = job->read_err;
-	unsigned int write_err = job->write_err;
+	unsigned long write_err = job->write_err;
 	kcopyd_notify_fn fn = job->fn;
 	struct kcopyd_client *kc = job->kc;
 
@@ -396,7 +396,7 @@ static int process_jobs(struct list_head
 		if (r < 0) {
 			/* error this rogue job */
 			if (job->rw == WRITE)
-				job->write_err = (unsigned int) -1;
+				job->write_err = (unsigned long) -1L;
 			else
 				job->read_err = 1;
 			push(&_complete_jobs, job);
@@ -448,8 +448,8 @@ static void dispatch_job(struct kcopyd_j
 }
 
 #define SUB_JOB_SIZE 128
-static void segment_complete(int read_err,
-			     unsigned int write_err, void *context)
+static void segment_complete(int read_err, unsigned long write_err,
+			     void *context)
 {
 	/* FIXME: tidy this function */
 	sector_t progress = 0;
diff -puN drivers/md/kcopyd.h~dm-io-write-error-bits-form-long-not-int drivers/md/kcopyd.h
--- a/drivers/md/kcopyd.h~dm-io-write-error-bits-form-long-not-int
+++ a/drivers/md/kcopyd.h
@@ -32,8 +32,8 @@ void kcopyd_client_destroy(struct kcopyd
  * read_err is a boolean,
  * write_err is a bitset, with 1 bit for each destination region
  */
-typedef void (*kcopyd_notify_fn)(int read_err,
-				 unsigned int write_err, void *context);
+typedef void (*kcopyd_notify_fn)(int read_err, unsigned long write_err,
+				 void *context);
 
 int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
 		unsigned int num_dests, struct io_region *dests,
_

Patches currently in -mm which might be from agk@redhat.com are

dm-crypt-fix-ctx-pending.patch
dm-io-write-error-bits-form-long-not-int.patch
dm-raid1-bitops-bug.patch


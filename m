Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E55C944F
	for <mm-commits@vger.kernel.org>; Mon, 16 Feb 2026 21:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771278366; cv=none; b=mrgfc6ZbxuT43O1uHN17VvoEFlBmHUBBtesWlvYxLWonJHl/fAAgotpbXzzcm2ExNC0oUFpe6HfPeErbpUu4aVjdMtsXixTkQPcwJyoBXgM5Y3keHVP36ps7S6f3VKfgNMrTTdD8/b1uW1RWWf780Oy7LRU6AJWuen8OVCOY+Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771278366; c=relaxed/simple;
	bh=k1kHUTnuQtrxUQL8jSWd8Wn6EGpvzOrX9/0QfmvXJbc=;
	h=Date:To:From:Subject:Message-Id; b=CE1sLOnlfoAiWmctbLqgdI2D+L6CXN+HJtQ3SCORPEthAOkivcBkh36ZFTHF064VgearfxEcSFUGxxVzpaxYlkg/0zuXRSMSe8DGXIUMM2GE3YkeZIDaEemG+OuGiQQNcgZwGsL+88Es2smDrp7H8CKie+SoOycOblOGZ8TZUBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nXo/aXsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nXo/aXsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D667C116C6;
	Mon, 16 Feb 2026 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771278365;
	bh=k1kHUTnuQtrxUQL8jSWd8Wn6EGpvzOrX9/0QfmvXJbc=;
	h=Date:To:From:Subject:From;
	b=nXo/aXsg+hsjTVOLxaLWPq98HOpxIviQjswNgzhvCCHLE58v/owUQ5kTBvdtbXdYP
	 D3cMpffy3Ft3LgHL9VrXcQHJ1EiMPeiDbRkn+NxQAQW3Xoi6x1TXppTCsTxF4j8alK
	 P3ejjChy54wWqz9hkPBNdutETghn8yYuWFxmjAII=
Date: Mon, 16 Feb 2026 13:46:04 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_file-remember-retrieve-status.patch added to mm-nonmm-unstable branch
Message-Id: <20260216214605.7D667C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: luo_file: remember retrieve() status
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_file-remember-retrieve-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_file-remember-retrieve-status.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: liveupdate: luo_file: remember retrieve() status
Date: Mon, 16 Feb 2026 14:22:19 +0100

LUO keeps track of successful retrieve attempts on a LUO file.  It does so
to avoid multiple retrievals of the same file.  Multiple retrievals cause
problems because once the file is retrieved, the serialized data
structures are likely freed and the file is likely in a very different
state from what the code expects.

The retrieve boolean in struct luo_file keeps track of this, and is passed
to the finish callback so it knows what work was already done and what it
has left to do.

All this works well when retrieve succeeds.  When it fails,
luo_retrieve_file() returns the error immediately, without ever storing
anywhere that a retrieve was attempted or what its error code was.  This
results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
but nothing prevents it from trying this again.

The retry is problematic for much of the same reasons listed above.  The
file is likely in a very different state than what the retrieve logic
normally expects, and it might even have freed some serialization data
structures.  Attempting to access them or free them again is going to
break things.

For example, if memfd managed to restore 8 of its 10 folios, but fails on
the 9th, a subsequent retrieve attempt will try to call
kho_restore_folio() on the first folio again, and that will fail with a
warning since it is an invalid operation.

Apart from the retry, finish() also breaks.  Since on failure the
retrieved bool in luo_file is never touched, the finish() call on session
close will tell the file handler that retrieve was never attempted, and it
will try to access or free the data structures that might not exist, much
in the same way as the retry attempt.

There is no sane way of attempting the retrieve again.  Remember the error
retrieve returned and directly return it on a retry.  Also pass this
status code to finish() so it can make the right decision on the work it
needs to do.

This is done by changing the bool to an integer.  A value of 0 means
retrieve was never attempted, a positive value means it succeeded, and a
negative value means it failed and the error code is the value.

Link: https://lkml.kernel.org/r/20260216132221.987987-1-pratyush@kernel.org
Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h   |    9 ++++---
 kernel/liveupdate/luo_file.c |   41 ++++++++++++++++++++-------------
 mm/memfd_luo.c               |    7 ++++-
 3 files changed, 37 insertions(+), 20 deletions(-)

--- a/include/linux/liveupdate.h~liveupdate-luo_file-remember-retrieve-status
+++ a/include/linux/liveupdate.h
@@ -23,8 +23,11 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
- * @retrieved:        The retrieve status for the 'can_finish / finish'
- *                    operation.
+ * @retrieve_status:  The retrieve status for the 'can_finish / finish'
+ *                    operation. A value of 0 means the retrieve has not been
+ *                    attempted, a positive value means the retrieve was
+ *                    successful, and a negative value means the retrieve failed,
+ *                    and the value is the error code of the call.
  * @file:             The file object. For retrieve: [OUT] The callback sets
  *                    this to the new file. For other ops: [IN] The caller sets
  *                    this to the file being operated on.
@@ -40,7 +43,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
-	bool retrieved;
+	int retrieve_status;
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-remember-retrieve-status
+++ a/kernel/liveupdate/luo_file.c
@@ -134,9 +134,12 @@ static LIST_HEAD(luo_file_handler_list);
  *                 state that is not preserved. Set by the handler's .preserve()
  *                 callback, and must be freed in the handler's .unpreserve()
  *                 callback.
- * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
+ * @retrieve_status: Status code indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
- *                 multiple retrieval attempts.
+ *                 multiple retrieval attempts. A value of 0 means a retrieve()
+ *                 has not been attempted, a positive value means the retrieve()
+ *                 was successful, and a negative value means the retrieve()
+ *                 failed, and the value is the error code of the call.
  * @mutex:         A mutex that protects the fields of this specific instance
  *                 (e.g., @retrieved, @file), ensuring that operations like
  *                 retrieving or finishing a file are atomic.
@@ -161,7 +164,7 @@ struct luo_file {
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
-	bool retrieved;
+	int retrieve_status;
 	struct mutex mutex;
 	struct list_head list;
 	u64 token;
@@ -298,7 +301,6 @@ int luo_preserve_file(struct luo_file_se
 	luo_file->file = file;
 	luo_file->fh = fh;
 	luo_file->token = token;
-	luo_file->retrieved = false;
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
@@ -577,7 +579,12 @@ int luo_retrieve_file(struct luo_file_se
 		return -ENOENT;
 
 	guard(mutex)(&luo_file->mutex);
-	if (luo_file->retrieved) {
+	if (luo_file->retrieve_status < 0) {
+		/* Retrieve was attempted and it failed. Return the error code. */
+		return luo_file->retrieve_status;
+	}
+
+	if (luo_file->retrieve_status > 0) {
 		/*
 		 * Someone is asking for this file again, so get a reference
 		 * for them.
@@ -590,16 +597,19 @@ int luo_retrieve_file(struct luo_file_se
 	args.handler = luo_file->fh;
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
-	if (!err) {
-		luo_file->file = args.file;
-
-		/* Get reference so we can keep this file in LUO until finish */
-		get_file(luo_file->file);
-		*filep = luo_file->file;
-		luo_file->retrieved = true;
+	if (err) {
+		/* Keep the error code for later use. */
+		luo_file->retrieve_status = err;
+		return err;
 	}
 
-	return err;
+	luo_file->file = args.file;
+	/* Get reference so we can keep this file in LUO until finish */
+	get_file(luo_file->file);
+	*filep = luo_file->file;
+	luo_file->retrieve_status = 1;
+
+	return 0;
 }
 
 static int luo_file_can_finish_one(struct luo_file_set *file_set,
@@ -615,7 +625,7 @@ static int luo_file_can_finish_one(struc
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
-		args.retrieved = luo_file->retrieved;
+		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
 
@@ -632,7 +642,7 @@ static void luo_file_finish_one(struct l
 	args.handler = luo_file->fh;
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
-	args.retrieved = luo_file->retrieved;
+	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
 	luo_flb_file_finish(luo_file->fh);
@@ -788,7 +798,6 @@ int luo_file_deserialize(struct luo_file
 		luo_file->file = NULL;
 		luo_file->serialized_data = file_ser[i].data;
 		luo_file->token = file_ser[i].token;
-		luo_file->retrieved = false;
 		mutex_init(&luo_file->mutex);
 		list_add_tail(&luo_file->list, &file_set->files_list);
 	}
--- a/mm/memfd_luo.c~liveupdate-luo_file-remember-retrieve-status
+++ a/mm/memfd_luo.c
@@ -326,7 +326,12 @@ static void memfd_luo_finish(struct live
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 
-	if (args->retrieved)
+	/*
+	 * If retrieve was successful, nothing to do. If it failed, retrieve()
+	 * already cleaned up everything it could. So nothing to do there
+	 * either. Only need to clean up when retrieve was not called.
+	 */
+	if (args->retrieve_status)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-remember-retrieve-status.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBC03D76
	for <mm-commits@vger.kernel.org>; Fri, 23 May 2025 21:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748037006; cv=none; b=PnNq0pjY0/sjYrGpRTYelc3qih7nmUsXCfcjLIeaThLlMe8LTvVIRHW08wYBo1wCKZkLxcq4jCiNZeuqV/J+yv7jd9f0Y87omlGQjf+sC3lNLgkc7BLtzo7WE9DPWseykn+8L0kN7LvhCBOFKGqxHyWy9MKi6oDN9KqIoAQ1Tbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748037006; c=relaxed/simple;
	bh=8F7tiU+a0RgRYde82dtUnXh1AEXJcmLIDs/4L8putY4=;
	h=Date:To:From:Subject:Message-Id; b=WHqVBDU67agEDeOQr7G7yzzTODQVaOLCoaB0QogAte0ZFVSqqghRpyk5z5tXfDtdYn4q0fscXfDjvfWbHHbVTyjfgpbQQ4wudNcHdtNVAlJize2ixHTwDz0xKw2N4UpTj0I+x1zhMheWRRH0mMxMTc4Lfngto8Fo6kgi4CkYlwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TyulOl4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TyulOl4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7A3C4CEE9;
	Fri, 23 May 2025 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748037005;
	bh=8F7tiU+a0RgRYde82dtUnXh1AEXJcmLIDs/4L8putY4=;
	h=Date:To:From:Subject:From;
	b=TyulOl4zp3t0TUyUbMJ6TpZhT524MLMg9NSNngLQ//6lruukE7loe6fzmdoLylHCN
	 +WuWdTgvRMevv/9YLbebZ892PKc5pESF6q3sECu3tEz1bLhrSPXj3ak/sR33Ox4IPQ
	 EnuaNk3qH4v9WQwbb0dPcOJbl3PmSNB2DGwEtjWw=
Date: Fri, 23 May 2025 14:50:05 -0700
To: mm-commits@vger.kernel.org,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + llist-make-llist_add_batch-a-static-inline.patch added to mm-nonmm-unstable branch
Message-Id: <20250523215005.BB7A3C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: llist: make llist_add_batch() a static inline
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     llist-make-llist_add_batch-a-static-inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/llist-make-llist_add_batch-a-static-inline.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jens Axboe <axboe@kernel.dk>
Subject: llist: make llist_add_batch() a static inline
Date: Fri, 23 May 2025 13:13:11 -0600

The function is small enough that it should be, and it's a (very) hot path
for io_uring.  Doing this actually reduces my vmlinux text size for my
standard build/test box.

Before:
axboe@r7625 ~/g/linux (test)> size vmlinux
   text	   data	    bss	    dec	    hex		filename
19892174 5938310 2470432 28300916 1afd674	vmlinux

After:
axboe@r7625 ~/g/linux (test)> size vmlinux
   text	   data	    bss	    dec	    hex		filename
19891878 5938310 2470436 28300624 1afd550	vmlinux

Link: https://lkml.kernel.org/r/f1d104c6-7ac8-457a-a53d-6bb741421b2f@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   23 ++++++++++++++++++++---
 lib/llist.c           |   22 ----------------------
 2 files changed, 20 insertions(+), 25 deletions(-)

--- a/include/linux/llist.h~llist-make-llist_add_batch-a-static-inline
+++ a/include/linux/llist.h
@@ -223,9 +223,26 @@ static inline struct llist_node *llist_n
 	return node->next;
 }
 
-extern bool llist_add_batch(struct llist_node *new_first,
-			    struct llist_node *new_last,
-			    struct llist_head *head);
+/**
+ * llist_add_batch - add several linked entries in batch
+ * @new_first:	first entry in batch to be added
+ * @new_last:	last entry in batch to be added
+ * @head:	the head for your lock-less list
+ *
+ * Return whether list is empty before adding.
+ */
+static inline bool llist_add_batch(struct llist_node *new_first,
+				   struct llist_node *new_last,
+				   struct llist_head *head)
+{
+	struct llist_node *first = READ_ONCE(head->first);
+
+	do {
+		new_last->next = first;
+	} while (!try_cmpxchg(&head->first, &first, new_first));
+
+	return !first;
+}
 
 static inline bool __llist_add_batch(struct llist_node *new_first,
 				     struct llist_node *new_last,
--- a/lib/llist.c~llist-make-llist_add_batch-a-static-inline
+++ a/lib/llist.c
@@ -14,28 +14,6 @@
 #include <linux/export.h>
 #include <linux/llist.h>
 
-
-/**
- * llist_add_batch - add several linked entries in batch
- * @new_first:	first entry in batch to be added
- * @new_last:	last entry in batch to be added
- * @head:	the head for your lock-less list
- *
- * Return whether list is empty before adding.
- */
-bool llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
-		     struct llist_head *head)
-{
-	struct llist_node *first = READ_ONCE(head->first);
-
-	do {
-		new_last->next = first;
-	} while (!try_cmpxchg(&head->first, &first, new_first));
-
-	return !first;
-}
-EXPORT_SYMBOL_GPL(llist_add_batch);
-
 /**
  * llist_del_first - delete the first entry of lock-less list
  * @head:	the head for your lock-less list
_

Patches currently in -mm which might be from axboe@kernel.dk are

llist-make-llist_add_batch-a-static-inline.patch


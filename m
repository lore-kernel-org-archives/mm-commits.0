Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1971A199931
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 02:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748400057; cv=none; b=q7ZM/qvyDx7mbfbFkWV6N2ITDxSu4E9WKGlvSTCkYEcl3JxUSdqF9o5wtZN8YGzWCtvLSVVaRVAlpq23H+PgABell+tjcWLhnIk+Q7HvO2/4lLIDo2hhE83BeCCOi7dQ5C7ogEHt0fEaTmKg+0agA/9wLcTn71/6bj92aTv9Fig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748400057; c=relaxed/simple;
	bh=9rx1m8Otpol3uQuMqdSk1Kpy+hVeRXZLLDCr59gx0gQ=;
	h=Date:To:From:Subject:Message-Id; b=b0P/FPa0UVWG1coKuZHNC+rVdd0j2YZXi8Ae70g1GJFExZmuPQHliuUTmoS2DCf0DXJGf2bCCbAVOiy1yLAoRJfjk1X0o9X287IGIUj4NnQjsuW1U1kHGEVKVt3oRVROG9xa9NfwII3gNSObvlNbujCBybI/qbpB8SjKZp0soPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m7cwQ6cD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m7cwQ6cD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB876C4CEE9;
	Wed, 28 May 2025 02:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748400056;
	bh=9rx1m8Otpol3uQuMqdSk1Kpy+hVeRXZLLDCr59gx0gQ=;
	h=Date:To:From:Subject:From;
	b=m7cwQ6cDcrzJxxxRMnIEBhcjvNObdWyRdRfOsnxPLEaco/OdnCFWW4udM6ZNPynEV
	 9s/6ecRZrzyLfSI0HUWNlu2GzJ8RHNynb2cjMPOfQgG7EGP5BTVOiVy/dvkxdBv+KT
	 s8ZbjZrS8pCXy1Hv/ZiB7FhY5g+MuOQbQydn1Dl4=
Date: Tue, 27 May 2025 19:40:56 -0700
To: mm-commits@vger.kernel.org,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] llist-make-llist_add_batch-a-static-inline.patch removed from -mm tree
Message-Id: <20250528024056.DB876C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: llist: make llist_add_batch() a static inline
has been removed from the -mm tree.  Its filename was
     llist-make-llist_add_batch-a-static-inline.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEDD23816C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759872992; cv=none; b=Pxgxb1+e7VYxRx9aKt2f70K69OXpWBQst5AjdSxtU7sCApuzte91IMmURFnzeLQdYgGZ25znMQKAGkblUg8E9jWkXENBo+Ee5bK3H9K8cGrcTLc59w+KiiCZWWNObCpjijYGeUvDIbyLsckgTs9uFCK6vyMJhcYJOodLUHwlU40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759872992; c=relaxed/simple;
	bh=9nAwfCnw8WYnlBxUH31AZn1U1HunKMSv6DJAPWA/ep0=;
	h=Date:To:From:Subject:Message-Id; b=nNGsSdF7vaRGBBR2UN9AqH5r7HkVnTEcoNrd79qBRjnFMmvcc2q3N7263uva7EmMPQcr97KvbkoancuO5Klnw7LYugyzcIWk8L30uYmWg3ZCGp5OLbdj1Wroc1n8PKJG3wSEGQ+WmAeGeeQrfidLQIPjdG+DYDQhIO5DEW26Huc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OArJhErn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OArJhErn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99979C4CEF1;
	Tue,  7 Oct 2025 21:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872992;
	bh=9nAwfCnw8WYnlBxUH31AZn1U1HunKMSv6DJAPWA/ep0=;
	h=Date:To:From:Subject:From;
	b=OArJhErntjIARdOd+yJTAEHZqbcOY6ZgmnYcQAXrMbuEpo8RF4HVhbuGwRk8n/Y1a
	 qps1Pi0uthvVFgka7jD0nTo4JNYIfgVRsbOhmjEr1qppWp1toG4gLIb3liPFNGokGI
	 2/vfwy6rw50TLcw5ov4pkDqsZ1lVeG2hRny2lQQE=
Date: Tue, 07 Oct 2025 14:36:32 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch added to mm-new branch
Message-Id: <20251007213632.99979C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: defer freeing partly initialized vm_struct
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: defer freeing partly initialized vm_struct
Date: Tue, 7 Oct 2025 14:20:29 +0200

__vmalloc_area_node() may call free_vmap_area() or vfree() on error paths,
both of which can sleep.  This becomes problematic if the function is
invoked from an atomic context, such as when GFP_ATOMIC or GFP_NOWAIT is
passed via gfp_mask.

To fix this, unify error paths and defer the cleanup of partly initialized
vm_struct objects to a workqueue.  This ensures that freeing happens in a
process context and avoids invalid sleeps in atomic regions.

Link: https://lkml.kernel.org/r/20251007122035.56347-5-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    6 +++++-
 mm/vmalloc.c            |   34 +++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-defer-freeing-partly-initialized-vm_struct
+++ a/include/linux/vmalloc.h
@@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
 #endif
 
 struct vm_struct {
-	struct vm_struct	*next;
+	union {
+		struct vm_struct *next;	  /* Early registration of vm_areas. */
+		struct llist_node llnode; /* Asynchronous freeing on error paths. */
+	};
+
 	void			*addr;
 	unsigned long		size;
 	unsigned long		flags;
--- a/mm/vmalloc.c~mm-vmalloc-defer-freeing-partly-initialized-vm_struct
+++ a/mm/vmalloc.c
@@ -3687,6 +3687,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	return nr_allocated;
 }
 
+static LLIST_HEAD(pending_vm_area_cleanup);
+static void cleanup_vm_area_work(struct work_struct *work)
+{
+	struct vm_struct *area, *tmp;
+	struct llist_node *head;
+
+	head = llist_del_all(&pending_vm_area_cleanup);
+	if (!head)
+		return;
+
+	llist_for_each_entry_safe(area, tmp, head, llnode) {
+		if (!area->pages)
+			free_vm_area(area);
+		else
+			vfree(area->addr);
+	}
+}
+
+/*
+ * Helper for __vmalloc_area_node() to defer cleanup
+ * of partially initialized vm_struct in error paths.
+ */
+static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
+static void defer_vm_area_cleanup(struct vm_struct *area)
+{
+	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
+		schedule_work(&cleanup_vm_area);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3718,8 +3747,7 @@ static void *__vmalloc_area_node(struct
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
-		free_vm_area(area);
-		return NULL;
+		goto fail;
 	}
 
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
@@ -3796,7 +3824,7 @@ static void *__vmalloc_area_node(struct
 	return area->addr;
 
 fail:
-	vfree(area->addr);
+	defer_vm_area_cleanup(area);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch


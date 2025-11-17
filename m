Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C7E1FBEA2
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343083; cv=none; b=CauhLd6PbgoiQxxccO7n9W8AYUv4+hw/7xcHcKsD+c2j00EJLnjvqOqCd/EROcEwD1BDPigafE+s1vHqHMLTDS/BWyO9nfyZS+LRC9frfTrXNv4IvhEmjkxwr/Opae949NjbwFIkKxQAzEhYKAmJJUEVqWNjE55FZXludtFeK7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343083; c=relaxed/simple;
	bh=5Pt+WFkznOf7YeLY49Rqz/vLzFlCpa4ELmMxyplBTjE=;
	h=Date:To:From:Subject:Message-Id; b=mVGnwQpc2QrbV4RuMBXm/iruFDJmr/P+nzT+G7OGrcFm/ZT7JfPGtWrHtcdFfjNByyfZoJNOFX3WyEaRdSjl7pnunDP3z2h3mZj7Hqnm58gmXzAuX3ZYkJ9PhObghAQ3n93+lx6XTwtSjuN7jKx1HSseJ3W7fRa7wR3q5vPyfCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NORdN7/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NORdN7/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9060C4CEF1;
	Mon, 17 Nov 2025 01:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343082;
	bh=5Pt+WFkznOf7YeLY49Rqz/vLzFlCpa4ELmMxyplBTjE=;
	h=Date:To:From:Subject:From;
	b=NORdN7/TJAf+u698rSIqZmPAe0LQbvYVl/IFCB8LdU6h2ebaRmPvimu3+4ey1EPMw
	 o3vcoxvHY/9BSF+xcH+hs/OsHKUmVfGvXy47ETZbkT/O86VFyA0qn3RU6OeaItqcif
	 OcsEIiMrGN3NL4d0E0G4IBEO3bxrc5qNHT5M9nsk=
Date: Sun, 16 Nov 2025 17:31:22 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch removed from -mm tree
Message-Id: <20251117013122.C9060C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: defer freeing partly initialized vm_struct
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



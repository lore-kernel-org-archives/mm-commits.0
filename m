Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A894A3C
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739383; cv=none; b=Dnph/W/Axo0FLUxq3I2TV++smfNJtw+mJGl8gNCdYskRqnGRL5zqTuCm+OChcG/Jn5JvV70+wn73CekizDfGcxtrgGUPuwymFH4Lay5MMK7u2jHArLbiS50UJanXDbS6/pJ6ZQkmjby/u0VBOk9K82LrHQnAZY9Fj+2XC0pQARU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739383; c=relaxed/simple;
	bh=DCE7uaRNYKEg8ZQRK9KNMtI6Ss5tN1JvbsH3pT4DQ1g=;
	h=Date:To:From:Subject:Message-Id; b=W00pSSYFs0DFRn1Yru5ua2Q30WeilnIfIJSEgyMjsJji6e1cWj+sj9mpWNItCNF1YHhiwwdRVCw0+epysNQQMIlGOn1mJ+w9lZlj676Ci89vCrvVaH0WiyfyuFvaqnj0t4NbDsFJdIUp7vj5fLcl0zvbrq8zu8FQrcFylUMiXQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BdK5j3PZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BdK5j3PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A35C433C7;
	Sat, 24 Feb 2024 01:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739383;
	bh=DCE7uaRNYKEg8ZQRK9KNMtI6Ss5tN1JvbsH3pT4DQ1g=;
	h=Date:To:From:Subject:From;
	b=BdK5j3PZqVvrDermmCDUpmWqpkzLkNi9mDoCseu4LF6miV9WX1EuCHLwug7AAsvBJ
	 Cut//S3UqgfNwjOJXeH2aQ7HKn3+N+07AyBLUAG+D1o+h1Keg1w8ww59jVLWC7uly2
	 EfBWcR5X4x8NbBS8I1wOSceCTf+n5rApHJdk4nVc=
Date: Fri, 23 Feb 2024 17:49:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,hch@infradead.org,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-refactor-vmalloc_dump_obj-function.patch removed from -mm tree
Message-Id: <20240224014943.96A35C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: refactor vmalloc_dump_obj() function
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-refactor-vmalloc_dump_obj-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: refactor vmalloc_dump_obj() function
Date: Wed, 24 Jan 2024 19:09:20 +0100

This patch tends to simplify the function in question, by removing an
extra stack "objp" variable, returning back to an early exit approach if
spin_trylock() fails or VA was not found.

Link: https://lkml.kernel.org/r/20240124180920.50725-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-refactor-vmalloc_dump_obj-function
+++ a/mm/vmalloc.c
@@ -4696,34 +4696,35 @@ void pcpu_free_vm_areas(struct vm_struct
 #ifdef CONFIG_PRINTK
 bool vmalloc_dump_obj(void *object)
 {
-	void *objp = (void *)PAGE_ALIGN((unsigned long)object);
 	const void *caller;
+	struct vm_struct *vm;
 	struct vmap_area *va;
 	struct vmap_node *vn;
 	unsigned long addr;
 	unsigned int nr_pages;
-	bool success = false;
 
-	vn = addr_to_node((unsigned long)objp);
+	addr = PAGE_ALIGN((unsigned long) object);
+	vn = addr_to_node(addr);
 
-	if (spin_trylock(&vn->busy.lock)) {
-		va = __find_vmap_area((unsigned long)objp, &vn->busy.root);
-
-		if (va && va->vm) {
-			addr = (unsigned long)va->vm->addr;
-			caller = va->vm->caller;
-			nr_pages = va->vm->nr_pages;
-			success = true;
-		}
+	if (!spin_trylock(&vn->busy.lock))
+		return false;
 
+	va = __find_vmap_area(addr, &vn->busy.root);
+	if (!va || !va->vm) {
 		spin_unlock(&vn->busy.lock);
+		return false;
 	}
 
-	if (success)
-		pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
-			nr_pages, addr, caller);
+	vm = va->vm;
+	addr = (unsigned long) vm->addr;
+	caller = vm->caller;
+	nr_pages = vm->nr_pages;
+	spin_unlock(&vn->busy.lock);
+
+	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
+		nr_pages, addr, caller);
 
-	return success;
+	return true;
 }
 #endif
 
_

Patches currently in -mm which might be from urezki@gmail.com are



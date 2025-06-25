Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0659C1FBCB2
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 21:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750885970; cv=none; b=ur1PEVyboQ0XisPYB35NBWkpGQ1oh2VW90X9RzD64gX9s2AeNbVz6BzJxLgDTavPvrWA9l1gDni3+pHRVyxlTASqot0owAdzQJgpYUfGh4n6Kvs7UqUpgoTc71P5yZtrqTQe/uRH/Gl4xYcNb582uiUa9Gk+rV8dS8fb9eP3iAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750885970; c=relaxed/simple;
	bh=bKdFtw+UqdnyY/5VKn+nBfU26FYXWdOVhfwF9zPeRBg=;
	h=Date:To:From:Subject:Message-Id; b=actuICdWkAHtw8sXhA2cw4KAGT/gyUuIZ/JoGIR9CPdzoD3q3S4B1rULu4qRFtG2K5mSaBhk7/yZk5FNrIBjR4E5M4aPFh5IO59YFHeTrobFqFWk6eoW5SyGtr8C3QaWKv9YuwEeiwNoJij4j+DA4T66kcXQUHiDjjzGquaSvtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kdLdNiML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kdLdNiML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76524C4CEEA;
	Wed, 25 Jun 2025 21:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750885969;
	bh=bKdFtw+UqdnyY/5VKn+nBfU26FYXWdOVhfwF9zPeRBg=;
	h=Date:To:From:Subject:From;
	b=kdLdNiMLbzyOzhoSqn1kQMc6ZkedIV5/TecX3y02b40N7RZltOnKp4T+WHho05BBf
	 obgwO6vAxxx6iKoJLt8GldqUPM+TcX/N/mCBnMa9ZdKpcoRfmSIJGYCtNGtnmtxHJG
	 4U99AaHq8zLEqEzsAmxg6fHRF342Tu2/HVhwRjoA=
Date: Wed, 25 Jun 2025 14:12:48 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,vitaly.wool@konsulko.se,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch added to mm-new branch
Message-Id: <20250625211249.76524C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: allow to set node and align in vrealloc
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch

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
From: Vitaly Wool <vitaly.wool@konsulko.se>
Subject: mm/vmalloc: allow to set node and align in vrealloc
Date: Wed, 25 Jun 2025 08:30:13 +0200

Patch series "support large align and nid in Rust allocators".

This series provides the ability for Rust allocators to set NUMA node and
large alignment.


This patch (of 2):

Reimplement vrealloc() to be able to set node and alignment should a user
need to do so.  Rename the function to vrealloc_node() to better match
what it actually does now and introduce a macro for vrealloc() for
backward compatibility.

With that change we also provide the ability for the Rust part of the
kernel to set node and aligmnent in its allocations.

Link: https://lkml.kernel.org/r/20250625062917.3379804-1-vitaly.wool@konsulko.se
Link: https://lkml.kernel.org/r/20250625063013.3379896-1-vitaly.wool@konsulko.se
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    8 +++++---
 mm/nommu.c              |    3 ++-
 mm/vmalloc.c            |   16 +++++++++++++---
 3 files changed, 20 insertions(+), 7 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-allow-to-set-node-and-align-in-vrealloc
+++ a/include/linux/vmalloc.h
@@ -197,9 +197,11 @@ extern void *__vcalloc_noprof(size_t n,
 extern void *vcalloc_noprof(size_t n, size_t size) __alloc_size(1, 2);
 #define vcalloc(...)		alloc_hooks(vcalloc_noprof(__VA_ARGS__))
 
-void * __must_check vrealloc_noprof(const void *p, size_t size, gfp_t flags)
-		__realloc_size(2);
-#define vrealloc(...)		alloc_hooks(vrealloc_noprof(__VA_ARGS__))
+void *__must_check vrealloc_node_noprof(const void *p, size_t size,
+		unsigned long align, gfp_t flags, int nid) __realloc_size(2);
+#define vrealloc_noprof(p, s, f)	vrealloc_node_noprof(p, s, 1, f, NUMA_NO_NODE)
+#define vrealloc_node(...)		alloc_hooks(vrealloc_node_noprof(__VA_ARGS__))
+#define vrealloc(...)			alloc_hooks(vrealloc_noprof(__VA_ARGS__))
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
--- a/mm/nommu.c~mm-vmalloc-allow-to-set-node-and-align-in-vrealloc
+++ a/mm/nommu.c
@@ -119,7 +119,8 @@ void *__vmalloc_noprof(unsigned long siz
 }
 EXPORT_SYMBOL(__vmalloc_noprof);
 
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_noprof(const void *p, size_t size, unsigned long align,
+			   gfp_t flags, int nid)
 {
 	return krealloc_noprof(p, size, (flags | __GFP_COMP) & ~__GFP_HIGHMEM);
 }
--- a/mm/vmalloc.c~mm-vmalloc-allow-to-set-node-and-align-in-vrealloc
+++ a/mm/vmalloc.c
@@ -4089,10 +4089,12 @@ void *vzalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vrealloc - reallocate virtually contiguous memory; contents remain unchanged
+ * vrealloc_node - reallocate virtually contiguous memory; contents remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
+ * @align: requested alignment
  * @flags: the flags for the page level allocator
+ * @nid: node id
  *
  * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
  * @p is not a %NULL pointer, the object pointed to is freed.
@@ -4111,7 +4113,7 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * Return: pointer to the allocated memory; %NULL if @size is zero or in case of
  *         failure
  */
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_noprof(const void *p, size_t size, unsigned long align, gfp_t flags, int nid)
 {
 	struct vm_struct *vm = NULL;
 	size_t alloced_size = 0;
@@ -4135,6 +4137,13 @@ void *vrealloc_noprof(const void *p, siz
 		if (WARN(alloced_size < old_size,
 			 "vrealloc() has mismatched area vs requested sizes (%p)\n", p))
 			return NULL;
+		if (WARN(nid != NUMA_NO_NODE && nid != page_to_nid(vmalloc_to_page(p)),
+			 "vrealloc() has mismatched nids\n"))
+			return NULL;
+		if (WARN((uintptr_t)p & (align - 1),
+			 "will not reallocate with a bigger alignment (0x%lx)\n",
+			 align))
+			return NULL;
 	}
 
 	/*
@@ -4166,7 +4175,8 @@ void *vrealloc_noprof(const void *p, siz
 	}
 
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
-	n = __vmalloc_noprof(size, flags);
+	n = __vmalloc_node_noprof(size, align, flags, nid, __builtin_return_address(0));
+
 	if (!n)
 		return NULL;
 
_

Patches currently in -mm which might be from vitaly.wool@konsulko.se are

mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch
rust-support-align-and-numa-id-in-allocations.patch
mm-add-zblock-allocator.patch


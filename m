Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20659273FC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247658; cv=none; b=NINw8XB2uKqtTytA7itf7Ac1cFlqqI9iTm/EZ2E6R9miqX4wL3+W+tbdX4t4UB/E1Z/IsIT5kl53fz/4E2Cl+RVqBkQL1K/3SObVjxi5Fm+pvbWoe7eMdINgdqfnNm/jMZgQgw5Xt5ojMK7jcefAacis0fImYNnoDBOGPsvWamU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247658; c=relaxed/simple;
	bh=iqT0O8xdgehOCKlPRmRTBnFHigcYbuXt9lbxxSS34m4=;
	h=Date:To:From:Subject:Message-Id; b=b8DsLH5YCuqCxU15j09DEeFU7caD5np3FEkrJlJm+xjlYFHHQH8Y59SQP7GacwIK75mhxH9XCDZHLCE42i/wvsRJOuetIn3A+Kao38kLNDghJbFXx8sjB5O5fwb3M6/OrSaUV1ehlLpkk92GGGS5BZfuecru+jJ6qsd1UNS3gSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hArohm6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hArohm6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DD1C4CEC2;
	Mon,  2 Sep 2024 03:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247657;
	bh=iqT0O8xdgehOCKlPRmRTBnFHigcYbuXt9lbxxSS34m4=;
	h=Date:To:From:Subject:From;
	b=hArohm6Jn7YrCnLE/oBkORRwWe98ILGQVDlTZslaGu1Nqdm11dOELdn5sMTnkY9ms
	 aUw05/mT4aVzZwKvNcdWP+KnHLoFX1hTQf8MDYb8wsSPycEagiAhPnp7Warm4+7PWF
	 yS0To7ernH5n1k8NjGLSXOrlwNNGCVthuo0Hj//M=
Date: Sun, 01 Sep 2024 20:27:37 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,vbabka@suse.cz,urezki@gmail.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,oliver.upton@linux.dev,ojeda@kernel.org,mpe@ellerman.id.au,mhocko@suse.com,maz@kernel.org,kees@kernel.org,iamjoonsoo.kim@lge.com,hch@infradead.org,cl@linux.com,christian.koenig@amd.com,chandan.babu@oracle.com,42.hyeyoo@gmail.com,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-implement-vrealloc.patch removed from -mm tree
Message-Id: <20240902032737.B3DD1C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: implement vrealloc()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-implement-vrealloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: vmalloc: implement vrealloc()
Date: Mon, 22 Jul 2024 18:29:23 +0200

Patch series "Align kvrealloc() with krealloc()", v2.

Besides the obvious (and desired) difference between krealloc() and
kvrealloc(), there is some inconsistency in their function signatures and
behavior:

 - krealloc() frees the memory when the requested size is zero, whereas
   kvrealloc() simply returns a pointer to the existing allocation.

 - krealloc() behaves like kmalloc() if a NULL pointer is passed, whereas
   kvrealloc() does not accept a NULL pointer at all and, if passed, would fault
   instead.

 - krealloc() is self-contained, whereas kvrealloc() relies on the caller to
   provide the size of the previous allocation.

Inconsistent behavior throughout allocation APIs is error prone, hence
make kvrealloc() behave like krealloc(), which seems superior in all
mentioned aspects.

In order to be able to get rid of kvrealloc()'s oldsize parameter,
introduce vrealloc() and make use of it in kvrealloc().

Making use of vrealloc() in kvrealloc() also provides oppertunities to
grow (and shrink) allocations more efficiently.  For instance, vrealloc()
can be optimized to allocate and map additional pages to grow the
allocation or unmap and free unused pages to shrink the allocation.

Besides the above, those functions are required by Rust's allocator abstractons
[1] (rework based on this series in [2]). With `Vec` or `KVec` respectively,
potentially growing (and shrinking) data structures are rather common.

[1] https://lore.kernel.org/lkml/20240704170738.3621-1-dakr@redhat.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/dakr/linux.git/log/?h=rust/mm


This patch (of 2):

Implement vrealloc() analogous to krealloc().

Currently, krealloc() requires the caller to pass the size of the previous
memory allocation, which, instead, should be self-contained.

We attempt to fix this in a subsequent patch which, in order to do so,
requires vrealloc().

Besides that, we need realloc() functions for kernel allocators in Rust
too.  With `Vec` or `KVec` respectively, potentially growing (and
shrinking) data structures are rather common.

[dakr@kernel.org: fix missing nommu implementation]
  Link: https://lkml.kernel.org/r/20240725141227.13954-1-dakr@kernel.org
[dakr@kernel.org: document concurrency restrictions]
  Link: https://lkml.kernel.org/r/20240725125442.4957-1-dakr@kernel.org
[dakr@kernel.org: consider spare memory for __GFP_ZERO]
  Link: https://lkml.kernel.org/r/20240730185049.6244-3-dakr@kernel.org
[dakr@kernel.org: properly document __GFP_ZERO behavior]
  Link: https://lkml.kernel.org/r/20240730185049.6244-4-dakr@kernel.org
Link: https://lkml.kernel.org/r/20240722163111.4766-1-dakr@kernel.org
Link: https://lkml.kernel.org/r/20240722163111.4766-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++
 mm/nommu.c              |    5 ++
 mm/vmalloc.c            |   70 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

--- a/include/linux/vmalloc.h~mm-vmalloc-implement-vrealloc
+++ a/include/linux/vmalloc.h
@@ -189,6 +189,10 @@ extern void *__vcalloc_noprof(size_t n,
 extern void *vcalloc_noprof(size_t n, size_t size) __alloc_size(1, 2);
 #define vcalloc(...)		alloc_hooks(vcalloc_noprof(__VA_ARGS__))
 
+void * __must_check vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+		__realloc_size(2);
+#define vrealloc(...)		alloc_hooks(vrealloc_noprof(__VA_ARGS__))
+
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
--- a/mm/nommu.c~mm-vmalloc-implement-vrealloc
+++ a/mm/nommu.c
@@ -126,6 +126,11 @@ void *__vmalloc_noprof(unsigned long siz
 }
 EXPORT_SYMBOL(__vmalloc_noprof);
 
+void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+{
+	return krealloc_noprof(p, size, (flags | __GFP_COMP) & ~__GFP_HIGHMEM);
+}
+
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		unsigned long start, unsigned long end, gfp_t gfp_mask,
 		pgprot_t prot, unsigned long vm_flags, int node,
--- a/mm/vmalloc.c~mm-vmalloc-implement-vrealloc
+++ a/mm/vmalloc.c
@@ -4030,6 +4030,76 @@ void *vzalloc_node_noprof(unsigned long
 }
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
+/**
+ * vrealloc - reallocate virtually contiguous memory; contents remain unchanged
+ * @p: object to reallocate memory for
+ * @size: the size to reallocate
+ * @flags: the flags for the page level allocator
+ *
+ * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
+ * @p is not a %NULL pointer, the object pointed to is freed.
+ *
+ * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
+ * initial memory allocation, every subsequent call to this API for the same
+ * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
+ * __GFP_ZERO is not fully honored by this API.
+ *
+ * In any case, the contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.
+ *
+ * This function must not be called concurrently with itself or vfree() for the
+ * same memory allocation.
+ *
+ * Return: pointer to the allocated memory; %NULL if @size is zero or in case of
+ *         failure
+ */
+void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+{
+	size_t old_size = 0;
+	void *n;
+
+	if (!size) {
+		vfree(p);
+		return NULL;
+	}
+
+	if (p) {
+		struct vm_struct *vm;
+
+		vm = find_vm_area(p);
+		if (unlikely(!vm)) {
+			WARN(1, "Trying to vrealloc() nonexistent vm area (%p)\n", p);
+			return NULL;
+		}
+
+		old_size = get_vm_area_size(vm);
+	}
+
+	/*
+	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
+	 * would be a good heuristic for when to shrink the vm_area?
+	 */
+	if (size <= old_size) {
+		/* Zero out spare memory. */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + size, 0, old_size - size);
+
+		return (void *)p;
+	}
+
+	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
+	n = __vmalloc_noprof(size, flags);
+	if (!n)
+		return NULL;
+
+	if (p) {
+		memcpy(n, p, old_size);
+		vfree(p);
+	}
+
+	return n;
+}
+
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
 #define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)
 #elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch


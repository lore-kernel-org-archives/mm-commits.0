Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C930212DDAF
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824886; cv=none; b=tdJrS89677YMrwmEuXX227J8tUwibISRa3892zT7f6jR2uOr7Jkoel3AVrkPs2tgXQob0UB+4KQ4Gw8Ug33P77HCKghQCltVOd1DDUdyTishP2J5ZO7XO0UNJzsjOhvFsf2H39lyh714e1oQs8fAHmK2aLOV+L20m5Ae6bRBOR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824886; c=relaxed/simple;
	bh=M5EadN5Hl8Metwwh5zK9V7Tw+5ZmdV+ibLKMgZ6+83Q=;
	h=Date:To:From:Subject:Message-Id; b=UFiPEeVYbTQ7mv73VNNWlSD67n6TjqWqLk8QaQs05IPQDhgV1+w1KXPfsW6QVhn0u3Eoy2nx9RSwL+ofwrRE9XRoPEaGdDjLlyJzXzGoJZHyI35h0r6N+U2aF1xefV0mZkTKVOZP4euLptg85Q5y4sdTK0xSGsnX+NCrW7TY2Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yf5aT2NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yf5aT2NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A03C32782;
	Fri, 12 Jul 2024 22:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824886;
	bh=M5EadN5Hl8Metwwh5zK9V7Tw+5ZmdV+ibLKMgZ6+83Q=;
	h=Date:To:From:Subject:From;
	b=Yf5aT2NXKQd77GDA+L6JL0NPuxYn94cZ3hfJhP+1vcFRyW7T2QIqtYL5zePO/PRX0
	 +kYs53MN1wRe+rwZ0oMxgUreCi5BioEDwGglvCX0j0tC66wurcPC70H6o5TGz4XHf6
	 /r6MkHelNpq0bCiW4YDESspzb7LSesSaBDU0sosI=
Date: Fri, 12 Jul 2024 15:54:46 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,kent.overstreet@linux.dev,jack@suse.cz,hch@lst.de,christian.koenig@amd.com,akpm@linux-foundation.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch removed from -mm tree
Message-Id: <20240712225446.A1A03C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add comments for allocation helpers explaining why they are macros
has been removed from the -mm tree.  Its filename was
     mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: add comments for allocation helpers explaining why they are macros
Date: Wed, 3 Jul 2024 10:42:25 -0700

A number of allocation helper functions were converted into macros to
account them at the call sites.  Add a comment for each converted
allocation helper explaining why it has to be a macro and why we typecast
the return value wherever required.  The patch also moves
acpi_os_acquire_object() closer to other allocation helpers to group them
together under the same comment.  The patch has no functional changes.

Link: https://lkml.kernel.org/r/20240703174225.3891393-1-surenb@google.com
Fixes: 2c321f3f70bc ("mm: change inlined allocation helpers to account at the call site")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/iostat.h                   |    4 ++++
 include/acpi/platform/aclinuxex.h |    9 ++++++---
 include/linux/bpf.h               |    4 ++++
 include/linux/dma-fence-chain.h   |    4 ++++
 include/linux/hid_bpf.h           |    5 +++++
 include/linux/jbd2.h              |   10 ++++++++++
 include/linux/skbuff.h            |    8 ++++++++
 include/linux/skmsg.h             |    5 +++++
 8 files changed, 46 insertions(+), 3 deletions(-)

--- a/fs/nfs/iostat.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/fs/nfs/iostat.h
@@ -46,6 +46,10 @@ static inline void nfs_add_stats(const s
 	nfs_add_server_stats(NFS_SERVER(inode), stat, addend);
 }
 
+/*
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag).
+ */
 #define nfs_alloc_iostats()	alloc_percpu(struct nfs_iostats)
 
 static inline void nfs_free_iostats(struct nfs_iostats __percpu *stats)
--- a/include/acpi/platform/aclinuxex.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/include/acpi/platform/aclinuxex.h
@@ -46,6 +46,9 @@ acpi_status acpi_os_terminate(void);
  * Interrupts are off during resume, just like they are for boot.
  * However, boot has  (system_state != SYSTEM_RUNNING)
  * to quiet __might_sleep() in kmalloc() and resume does not.
+ *
+ * These specialized allocators have to be macros for their allocations to be
+ * accounted separately (to have separate alloc_tag).
  */
 #define acpi_os_allocate(_size)	\
 		kmalloc(_size, irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL)
@@ -53,14 +56,14 @@ acpi_status acpi_os_terminate(void);
 #define acpi_os_allocate_zeroed(_size)	\
 		kzalloc(_size, irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL)
 
+#define acpi_os_acquire_object(_cache)	\
+		kmem_cache_zalloc(_cache, irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL)
+
 static inline void acpi_os_free(void *memory)
 {
 	kfree(memory);
 }
 
-#define acpi_os_acquire_object(_cache)	\
-		kmem_cache_zalloc(_cache, irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL)
-
 static inline acpi_thread_id acpi_os_get_thread_id(void)
 {
 	return (acpi_thread_id) (unsigned long)current;
--- a/include/linux/bpf.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/include/linux/bpf.h
@@ -2261,6 +2261,10 @@ void *bpf_map_kvcalloc(struct bpf_map *m
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
 #else
+/*
+ * These specialized allocators have to be macros for their allocations to be
+ * accounted separately (to have separate alloc_tag).
+ */
 #define bpf_map_kmalloc_node(_map, _size, _flags, _node)	\
 		kmalloc_node(_size, _flags, _node)
 #define bpf_map_kzalloc(_map, _size, _flags)			\
--- a/include/linux/dma-fence-chain.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/include/linux/dma-fence-chain.h
@@ -85,6 +85,10 @@ dma_fence_chain_contained(struct dma_fen
  * dma_fence_chain_alloc
  *
  * Returns a new struct dma_fence_chain object or NULL on failure.
+ *
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag). The typecast is
+ * intentional to enforce typesafety.
  */
 #define dma_fence_chain_alloc()	\
 		((struct dma_fence_chain *)kmalloc(sizeof(struct dma_fence_chain), GFP_KERNEL))
--- a/include/linux/hid_bpf.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/include/linux/hid_bpf.h
@@ -152,6 +152,11 @@ static inline int hid_bpf_connect_device
 static inline void hid_bpf_disconnect_device(struct hid_device *hdev) {}
 static inline void hid_bpf_destroy_device(struct hid_device *hid) {}
 static inline void hid_bpf_device_init(struct hid_device *hid) {}
+/*
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag). The typecast is
+ * intentional to enforce typesafety.
+ */
 #define call_hid_bpf_rdesc_fixup(_hdev, _rdesc, _size)	\
 		((u8 *)kmemdup(_rdesc, *(_size), GFP_KERNEL))
 
--- a/include/linux/jbd2.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/include/linux/jbd2.h
@@ -1588,6 +1588,11 @@ void jbd2_journal_put_journal_head(struc
  */
 extern struct kmem_cache *jbd2_handle_cache;
 
+/*
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag). The typecast is
+ * intentional to enforce typesafety.
+ */
 #define jbd2_alloc_handle(_gfp_flags)	\
 		((handle_t *)kmem_cache_zalloc(jbd2_handle_cache, _gfp_flags))
 
@@ -1602,6 +1607,11 @@ static inline void jbd2_free_handle(hand
  */
 extern struct kmem_cache *jbd2_inode_cache;
 
+/*
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag). The typecast is
+ * intentional to enforce typesafety.
+ */
 #define jbd2_alloc_inode(_gfp_flags)	\
 		((struct jbd2_inode *)kmem_cache_alloc(jbd2_inode_cache, _gfp_flags))
 
--- a/include/linux/skbuff.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/include/linux/skbuff.h
@@ -3400,6 +3400,10 @@ static inline struct page *__dev_alloc_p
 }
 #define __dev_alloc_pages(...)	alloc_hooks(__dev_alloc_pages_noprof(__VA_ARGS__))
 
+/*
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag).
+ */
 #define dev_alloc_pages(_order) __dev_alloc_pages(GFP_ATOMIC | __GFP_NOWARN, _order)
 
 /**
@@ -3416,6 +3420,10 @@ static inline struct page *__dev_alloc_p
 }
 #define __dev_alloc_page(...)	alloc_hooks(__dev_alloc_page_noprof(__VA_ARGS__))
 
+/*
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag).
+ */
 #define dev_alloc_page()	dev_alloc_pages(0)
 
 /**
--- a/include/linux/skmsg.h~mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros
+++ a/include/linux/skmsg.h
@@ -414,6 +414,11 @@ void sk_psock_stop_verdict(struct sock *
 int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 			 struct sk_msg *msg);
 
+/*
+ * This specialized allocator has to be a macro for its allocations to be
+ * accounted separately (to have a separate alloc_tag). The typecast is
+ * intentional to enforce typesafety.
+ */
 #define sk_psock_init_link()	\
 		((struct sk_psock_link *)kzalloc(sizeof(struct sk_psock_link),	\
 						 GFP_ATOMIC | __GFP_NOWARN))
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch


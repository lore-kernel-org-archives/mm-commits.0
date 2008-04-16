From: akpm@linux-foundation.org
Subject: - relayfs-support-larger-relay-buffer.patch removed from -mm tree
Date: Wed, 16 Apr 2008 13:43:16 -0700
Message-ID: <200804162043.m3GKhHsM005948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbYDPUoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 16:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, dwilder@us.ibm.com, zanussi@comcast.net, mm-commits@vger.kernel.org


The patch titled
     relayfs: support larger relay buffer
has been removed from the -mm tree.  Its filename was
     relayfs-support-larger-relay-buffer.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relayfs: support larger relay buffer
From: Masami Hiramatsu <mhiramat@redhat.com>

Use vmalloc() and memset() instead of kcalloc() to allocate a page* array when
the array size is bigger than one page.  This enables relayfs to support
bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.

This is useful for a 64-bit system which has a plenty of memory (tens of giga
bytes) and a large kernel memory space.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: David Wilder <dwilder@us.ibm.com>
Cc: Tom Zanussi <zanussi@comcast.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN kernel/relay.c~relayfs-support-larger-relay-buffer kernel/relay.c
--- a/kernel/relay.c~relayfs-support-larger-relay-buffer
+++ a/kernel/relay.c
@@ -104,12 +104,20 @@ static int relay_mmap_buf(struct rchan_b
 static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 {
 	void *mem;
-	unsigned int i, j, n_pages;
+	unsigned int i, j, n_pages, pa_size;
 
 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;
+	pa_size = n_pages * sizeof(struct page *);
 
-	buf->page_array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+	if (pa_size > PAGE_SIZE) {
+		buf->page_array = vmalloc(pa_size);
+		if (buf->page_array)
+			memset(buf->page_array, 0, pa_size);
+	} else {
+		buf->page_array = kcalloc(n_pages, sizeof(struct page *),
+					  GFP_KERNEL);
+	}
 	if (!buf->page_array)
 		return NULL;
 
@@ -130,7 +138,10 @@ static void *relay_alloc_buf(struct rcha
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
-	kfree(buf->page_array);
+	if (pa_size > PAGE_SIZE)
+		vfree(buf->page_array);
+	else
+		kfree(buf->page_array);
 	return NULL;
 }
 
@@ -189,7 +200,10 @@ static void relay_destroy_buf(struct rch
 		vunmap(buf->start);
 		for (i = 0; i < buf->page_count; i++)
 			__free_page(buf->page_array[i]);
-		kfree(buf->page_array);
+		if (buf->page_count * sizeof(struct page *) > PAGE_SIZE)
+			vfree(buf->page_array);
+		else
+			kfree(buf->page_array);
 	}
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf->padding);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

git-x86.patch
git-ia64.patch
listh-add-list_singleton.patch
listh-add-list_singleton-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch
relayfs-support-larger-relay-buffer.patch
relayfs-support-larger-relay-buffer-take-3.patch


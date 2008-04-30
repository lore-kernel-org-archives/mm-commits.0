From: akpm@linux-foundation.org
Subject: - relayfs-support-larger-relay-buffer-take-3.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:44 -0700
Message-ID: <200804300549.m3U5niSl030027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbYD3F4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, dwilder@us.ibm.com, penberg@cs.helsinki.fi, zanussi@comcast.net, mm-commits@vger.kernel.org


The patch titled
     relayfs: support larger relay buffer
has been removed from the -mm tree.  Its filename was
     relayfs-support-larger-relay-buffer-take-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relayfs: support larger relay buffer
From: Masami Hiramatsu <mhiramat@redhat.com>

Use vmalloc() and memset() instead of kcalloc() to allocate a page* array when
the array size is bigger than one page.  This enables relayfs to support
bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Tom Zanussi <zanussi@comcast.net>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff -puN kernel/relay.c~relayfs-support-larger-relay-buffer-take-3 kernel/relay.c
--- a/kernel/relay.c~relayfs-support-larger-relay-buffer-take-3
+++ a/kernel/relay.c
@@ -65,6 +65,35 @@ static struct vm_operations_struct relay
 	.close = relay_file_mmap_close,
 };
 
+/*
+ * allocate an array of pointers of struct page
+ */
+static struct page **relay_alloc_page_array(unsigned int n_pages)
+{
+	struct page **array;
+	size_t pa_size = n_pages * sizeof(struct page *);
+
+	if (pa_size > PAGE_SIZE) {
+		array = vmalloc(pa_size);
+		if (array)
+			memset(array, 0, pa_size);
+	} else {
+		array = kzalloc(pa_size, GFP_KERNEL);
+	}
+	return array;
+}
+
+/*
+ * free an array of pointers of struct page
+ */
+static void relay_free_page_array(struct page **array)
+{
+	if (is_vmalloc_addr(array))
+		vfree(array);
+	else
+		kfree(array);
+}
+
 /**
  *	relay_mmap_buf: - mmap channel buffer to process address space
  *	@buf: relay channel buffer
@@ -109,7 +138,7 @@ static void *relay_alloc_buf(struct rcha
 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;
 
-	buf->page_array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+	buf->page_array = relay_alloc_page_array(n_pages);
 	if (!buf->page_array)
 		return NULL;
 
@@ -130,7 +159,7 @@ static void *relay_alloc_buf(struct rcha
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
-	kfree(buf->page_array);
+	relay_free_page_array(buf->page_array);
 	return NULL;
 }
 
@@ -189,7 +218,7 @@ static void relay_destroy_buf(struct rch
 		vunmap(buf->start);
 		for (i = 0; i < buf->page_count; i++)
 			__free_page(buf->page_array[i]);
-		kfree(buf->page_array);
+		relay_free_page_array(buf->page_array);
 	}
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf->padding);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch


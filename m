From: akpm@linux-foundation.org
Subject: + relayfs-support-larger-relay-buffer-take-3.patch added to -mm tree
Date: Wed, 16 Apr 2008 13:48:18 -0700
Message-ID: <200804162048.m3GKmJ8Q006148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYDPUtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 16:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, dwilder@us.ibm.com, penberg@cs.helsinki.fi, zanussi@comcast.net


The patch titled
     relayfs: support larger relay buffer
has been added to the -mm tree.  Its filename is
     relayfs-support-larger-relay-buffer-take-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relayfs: support larger relay buffer
From: Masami Hiramatsu <mhiramat@redhat.com>

Use vmalloc() and memset() instead of kcalloc() to allocate a page* array when
the array size is bigger than one page.  This enables relayfs to support
bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: David Wilder <dwilder@us.ibm.com>
Cc: Tom Zanussi <zanussi@comcast.net>
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
+	unsigned int pa_size = n_pages * sizeof(struct page *);
+
+	if (pa_size > PAGE_SIZE) {
+		array = vmalloc(pa_size);
+		if (array)
+			memset(array, 0, pa_size);
+	} else {
+		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
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

git-x86.patch
git-ia64.patch
listh-add-list_singleton.patch
listh-add-list_singleton-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch
relayfs-support-larger-relay-buffer-take-3.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch


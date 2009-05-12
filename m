From: akpm@linux-foundation.org
Subject: + videobuf-dma-contig-zero-copy-userptr-support-v3-comments.patch added to -mm tree
Date: Tue, 12 May 2009 14:49:11 -0700
Message-ID: <200905122149.n4CLnBrx005519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbZELVwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, hannes@cmpxchg.org, hverkuil@xs4all.nl, lethal@linux-sh.org, mchehab@infradead.org


The patch titled
     videobuf-dma-contig: zero copy USERPTR V3 comments
has been added to the -mm tree.  Its filename is
     videobuf-dma-contig-zero-copy-userptr-support-v3-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: videobuf-dma-contig: zero copy USERPTR V3 comments
From: Magnus Damm <damm@igel.co.jp>

This patch adds function descriptions to V3 of the V4L2
videobuf-dma-contig USERPTR zero copy patch.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-dma-contig.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3-comments drivers/media/video/videobuf-dma-contig.c
--- a/drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3-comments
+++ a/drivers/media/video/videobuf-dma-contig.c
@@ -110,6 +110,12 @@ static struct vm_operations_struct video
 	.close    = videobuf_vm_close,
 };
 
+/**
+ * videobuf_dma_contig_user_put() - reset pointer to user space buffer
+ * @mem: per-buffer private videobuf-dma-contig data
+ *
+ * This function resets the user space pointer 
+ */
 static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
 {
 	mem->is_userptr = 0;
@@ -117,6 +123,16 @@ static void videobuf_dma_contig_user_put
 	mem->size = 0;
 }
 
+/**
+ * videobuf_dma_contig_user_get() - setup user space memory pointer
+ * @mem: per-buffer private videobuf-dma-contig data
+ * @vb: video buffer to map
+ *
+ * This function validates and sets up a pointer to user space memory.
+ * Only physically contiguous pfn-mapped memory is accepted.
+ *
+ * Returns 0 if successful.
+ */
 static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 					struct videobuf_buffer *vb)
 {
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
videobuf-dma-contig-zero-copy-userptr-support-v3.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments.patch


From: akpm@linux-foundation.org
Subject: + dvb-make-struct-videobuf_queue_ops-constant.patch added to -mm tree
Date: Mon, 16 Nov 2009 14:59:22 -0800
Message-ID: <200911162259.nAGMxM97022451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbZKPW7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 17:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org


The patch titled
     dvb: make struct videobuf_queue_ops constant
has been added to the -mm tree.  Its filename is
     dvb-make-struct-videobuf_queue_ops-constant.patch

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
Subject: dvb: make struct videobuf_queue_ops constant
From: Jonathan Corbet <corbet@lwn.net>

The videobuf_queue_ops function vector is not declared constant, but
there's no need for the videobuf layer to ever change it.  Make it const
so that videobuf users can make their operations const without warnings.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-core.c       |    2 +-
 drivers/media/video/videobuf-dma-contig.c |    2 +-
 drivers/media/video/videobuf-dma-sg.c     |    2 +-
 drivers/media/video/videobuf-vmalloc.c    |    2 +-
 include/media/videobuf-core.h             |    4 ++--
 include/media/videobuf-dma-contig.h       |    2 +-
 include/media/videobuf-dma-sg.h           |    2 +-
 include/media/videobuf-vmalloc.h          |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/media/video/videobuf-core.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-core.c
--- a/drivers/media/video/videobuf-core.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-core.c
@@ -110,7 +110,7 @@ EXPORT_SYMBOL_GPL(videobuf_queue_to_vmal
 
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN drivers/media/video/videobuf-dma-contig.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-dma-contig.c
--- a/drivers/media/video/videobuf-dma-contig.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-dma-contig.c
@@ -428,7 +428,7 @@ static struct videobuf_qtype_ops qops = 
 };
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
-				    struct videobuf_queue_ops *ops,
+				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,
 				    spinlock_t *irqlock,
 				    enum v4l2_buf_type type,
diff -puN drivers/media/video/videobuf-dma-sg.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-dma-sg.c
--- a/drivers/media/video/videobuf-dma-sg.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-dma-sg.c
@@ -702,7 +702,7 @@ void *videobuf_sg_alloc(size_t size)
 }
 
 void videobuf_queue_sg_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN drivers/media/video/videobuf-vmalloc.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-vmalloc.c
--- a/drivers/media/video/videobuf-vmalloc.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-vmalloc.c
@@ -391,7 +391,7 @@ static struct videobuf_qtype_ops qops = 
 };
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN include/media/videobuf-core.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-core.h
--- a/include/media/videobuf-core.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-core.h
@@ -166,7 +166,7 @@ struct videobuf_queue {
 	enum v4l2_field            field;
 	enum v4l2_field            last;   /* for field=V4L2_FIELD_ALTERNATE */
 	struct videobuf_buffer     *bufs[VIDEO_MAX_FRAME];
-	struct videobuf_queue_ops  *ops;
+	const struct videobuf_queue_ops  *ops;
 	struct videobuf_qtype_ops  *int_ops;
 
 	unsigned int               streaming:1;
@@ -195,7 +195,7 @@ void *videobuf_queue_to_vmalloc (struct 
 				 struct videobuf_buffer *buf);
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN include/media/videobuf-dma-contig.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-dma-contig.h
--- a/include/media/videobuf-dma-contig.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-dma-contig.h
@@ -17,7 +17,7 @@
 #include <media/videobuf-core.h>
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
-				    struct videobuf_queue_ops *ops,
+				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,
 				    spinlock_t *irqlock,
 				    enum v4l2_buf_type type,
diff -puN include/media/videobuf-dma-sg.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-dma-sg.h
--- a/include/media/videobuf-dma-sg.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-dma-sg.h
@@ -103,7 +103,7 @@ struct videobuf_dmabuf *videobuf_to_dma 
 void *videobuf_sg_alloc(size_t size);
 
 void videobuf_queue_sg_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN include/media/videobuf-vmalloc.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-vmalloc.h
--- a/include/media/videobuf-vmalloc.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-vmalloc.h
@@ -30,7 +30,7 @@ struct videobuf_vmalloc_memory
 };
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
_

Patches currently in -mm which might be from corbet@lwn.net are

dvb-make-struct-videobuf_queue_ops-constant.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB53BA2D
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739467; cv=none; b=fH4j+Dkw1dUAk1+4iX7YFJVYmL+KxB04UDlWKzd+gKNmEBBE/dsT6sFJDHlxFp2fbJW5mLGpN5QRJYXGr4bz5ZYUyfJmtbhwghFht3qrJpo350AZG2ASLqU0HvyQRb8OUXKnXYnUpP+wXU8mulkXNVA6g9ezBdPfXwRnDAfabfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739467; c=relaxed/simple;
	bh=xn5tHAsQmiIaWvnIMWjQnfQBzzbT1XQt5k+vLJXIksc=;
	h=Date:To:From:Subject:Message-Id; b=LtPMHnT2lAzTYmAs+iGN3DdrXUL47DTASQemZA55kDrx+CR6uD+A2wgY//mwND6y2VaYHmNljgnxu+F32tgyc+e0cfJ2dQfJBRkYKIII3JmsYtXAIYDT7oQKz/60p/f/i2cWkPfhL7su2nGU0WdwHBqD9UIQXVglSlPyqClLG8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VjKDdnEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VjKDdnEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1683C43390;
	Sat, 24 Feb 2024 01:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739466;
	bh=xn5tHAsQmiIaWvnIMWjQnfQBzzbT1XQt5k+vLJXIksc=;
	h=Date:To:From:Subject:From;
	b=VjKDdnEazi52xlmAGyaXYd+JWxsqaG0j4VmaWIayqjoEP2lR3u2y45LXE4C78jZb6
	 xHuVAIVyi/YDgWxrKGQo5nleihLuZ2OXin9MmbbSTx0+XgjClPK14FXe/cjKtYb78Q
	 rrbme4wGM8b2HmdRO+uEVB8AB6nu3JPGp7RG92I0=
Date: Fri, 23 Feb 2024 17:51:06 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pagevec-add-ability-to-iterate-a-queue.patch removed from -mm tree
Message-Id: <20240224015106.C1683C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pagevec: add ability to iterate a queue
has been removed from the -mm tree.  Its filename was
     pagevec-add-ability-to-iterate-a-queue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: pagevec: add ability to iterate a queue
Date: Thu, 15 Feb 2024 07:36:45 +0100

Add a loop counter inside the folio_batch to let us iterate from 0-nr
instead of decrementing nr and treating the batch as a stack.  It would
generate some very weird and suboptimal I/O patterns for page writeback to
iterate over the batch as a stack.

Link: https://lkml.kernel.org/r/20240215063649.2164017-11-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/pagevec.h~pagevec-add-ability-to-iterate-a-queue
+++ a/include/linux/pagevec.h
@@ -27,6 +27,7 @@ struct folio;
  */
 struct folio_batch {
 	unsigned char nr;
+	unsigned char i;
 	bool percpu_pvec_drained;
 	struct folio *folios[PAGEVEC_SIZE];
 };
@@ -40,12 +41,14 @@ struct folio_batch {
 static inline void folio_batch_init(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
+	fbatch->i = 0;
 	fbatch->percpu_pvec_drained = false;
 }
 
 static inline void folio_batch_reinit(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
+	fbatch->i = 0;
 }
 
 static inline unsigned int folio_batch_count(struct folio_batch *fbatch)
@@ -75,6 +78,21 @@ static inline unsigned folio_batch_add(s
 	return folio_batch_space(fbatch);
 }
 
+/**
+ * folio_batch_next - Return the next folio to process.
+ * @fbatch: The folio batch being processed.
+ *
+ * Use this function to implement a queue of folios.
+ *
+ * Return: The next folio in the queue, or NULL if the queue is empty.
+ */
+static inline struct folio *folio_batch_next(struct folio_batch *fbatch)
+{
+	if (fbatch->i == fbatch->nr)
+		return NULL;
+	return fbatch->folios[fbatch->i++];
+}
+
 void __folio_batch_release(struct folio_batch *pvec);
 
 static inline void folio_batch_release(struct folio_batch *fbatch)
_

Patches currently in -mm which might be from willy@infradead.org are



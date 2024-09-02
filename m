Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FEB7DA9C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247808; cv=none; b=DAlw+pMODIwg1y2dv9TpRyDLHRmPTUzgyZXX+i3kuM94s/CclzuC9573qxr7LtxzSMVsjngDQPbaocVmq/fP+IVpe4G8frDceP1U9eGm6atBXn5s6JDYrAal17ullm7q/8gyddTjUVRcIUOJJpiv/I8aVa5pd10BhasV+C4nUEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247808; c=relaxed/simple;
	bh=sxoytxssOlxHBSwQXFgaL/0aZlsJZ/bYb+0jpSTkfzc=;
	h=Date:To:From:Subject:Message-Id; b=XctepDJZdGLOexkOjU3TRPeeda5u0bLyYa/LLrz7jqDytuILyda0W0iO4U1KnwgzMwMruJBqNcPqx84+XSnnxX49j9QgaWvBepUa2i+uAoQ0YcClUVOB1P81bNukBU4uZ1WqnKsy4pYAvtzhUlsiV22ZgnXOL+X0VKacq5DsCy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H0k5k4Hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H0k5k4Hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9322BC4CEC2;
	Mon,  2 Sep 2024 03:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247807;
	bh=sxoytxssOlxHBSwQXFgaL/0aZlsJZ/bYb+0jpSTkfzc=;
	h=Date:To:From:Subject:From;
	b=H0k5k4HzWsvPlIByXEbSb/Pd+yRMV1BK58wPPqdsASo0iiP2BlBMG52DJy6B3zL62
	 67HzV/M6FyRJ/UtvWF27QnHF45B58R2c/61yTsvZaVbtVpiZx2StgAu564ZfQewi9a
	 REPSQQjc7epJi9KxrU96NzMxpNdi8crYZtvVbzwM=
Date: Sun, 01 Sep 2024 20:30:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-reset-mas-index-and-mas-last-on-write-retries.patch removed from -mm tree
Message-Id: <20240902033007.9322BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: reset mas->index and mas->last on write retries
has been removed from the -mm tree.  Its filename was
     maple_tree-reset-mas-index-and-mas-last-on-write-retries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: reset mas->index and mas->last on write retries
Date: Mon, 12 Aug 2024 15:05:42 -0400

The following scenario can result in a race condition:

Consider a node with the following indices and values

	a<------->b<----------->c<--------->d
	    0xA        NULL          0xB

	CPU 1			  CPU 2
      ---------        		---------
	mas_set_range(a,b)
	mas_erase()
		-> range is expanded (a,c) because of null expansion

	mas_nomem()
	mas_unlock()
				mas_store_range(b,c,0xC)

The node now looks like:

	a<------->b<----------->c<--------->d
	    0xA        0xC          0xB

	mas_lock()
	mas_erase() <------ range of erase is still (a,c)

The node is now NULL from (a,c) but the write from CPU 2 should have been
retained and range (b,c) should still have 0xC as its value.  We can fix
this by re-intializing to the original index and last.  This does not need
a cc: Stable as there are no users of the maple tree which use internal
locking and this condition is only possible with internal locking.

Link: https://lkml.kernel.org/r/20240812190543.71967-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reset-mas-index-and-mas-last-on-write-retries
+++ a/lib/maple_tree.c
@@ -5451,14 +5451,19 @@ EXPORT_SYMBOL_GPL(mas_store);
  */
 int mas_store_gfp(struct ma_state *mas, void *entry, gfp_t gfp)
 {
+	unsigned long index = mas->index;
+	unsigned long last = mas->last;
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	mas_wr_store_setup(&wr_mas);
 	trace_ma_write(__func__, mas, 0, entry);
 retry:
 	mas_wr_store_entry(&wr_mas);
-	if (unlikely(mas_nomem(mas, gfp)))
+	if (unlikely(mas_nomem(mas, gfp))) {
+		if (!entry)
+			__mas_set_range(mas, index, last);
 		goto retry;
+	}
 
 	if (unlikely(mas_is_err(mas)))
 		return xa_err(mas->node);
@@ -6245,23 +6250,26 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
 void *mas_erase(struct ma_state *mas)
 {
 	void *entry;
+	unsigned long index = mas->index;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
 	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->status = ma_start;
 
-	/* Retry unnecessary when holding the write lock. */
+write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
 		return NULL;
 
-write_retry:
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
 	mas_wr_store_setup(&wr_mas);
 	mas_wr_store_entry(&wr_mas);
-	if (mas_nomem(mas, GFP_KERNEL))
+	if (mas_nomem(mas, GFP_KERNEL)) {
+		/* in case the range of entry changed when unlocked */
+		mas->index = mas->last = index;
 		goto write_retry;
+	}
 
 	return entry;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are



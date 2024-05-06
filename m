Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE472207A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957061; cv=none; b=lOmQlvPN9ClPviD3te17GJOt59aoQk9aZcW7FtY1Su1ZfZE2hVaV7Hw8MiyiMQ38826jcKpoj7BKJMoEHDtl89LnFP2fSj+uFgWn4glRJUOQ4aymWcsdR7/TpUe5Aqq+8qh93Bt8k/k3EnEKIgoBFlGYcVVtcKYHMCzHJzUtORE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957061; c=relaxed/simple;
	bh=44bY7O4DEsQS7zY3ayu6Hk6nBPZNlHuYAGqh9v4w3go=;
	h=Date:To:From:Subject:Message-Id; b=ory914IGZyqaBDdymHTyAPF0mx17d9sRG8BOzOvig5DQxwJfWNE5QI0yGJ1x8yGcVmIJb2Zap/Go7oKhk7YDvlYZw8BQC9tp9TVYdACuTkGrCJqJbeGSRfmWyezBuiTygA+JltGA407X2bCA7PUFLEFcKlDgEH5L6rYav8trzp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KtC95LUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KtC95LUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDE9C113CC;
	Mon,  6 May 2024 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957061;
	bh=44bY7O4DEsQS7zY3ayu6Hk6nBPZNlHuYAGqh9v4w3go=;
	h=Date:To:From:Subject:From;
	b=KtC95LUhepjehKoctfVuweqRLPjIZPUWW/H7ajnt3redCdy/AsfoPcVJbyhROVa/s
	 uZObqtldbBRHHdMwvp3MWfK3hq1et2SNBW3c6k//hwUH4KH7TZRHK2p+gZOjLzUIZ3
	 qJqJkzRT/vOpSUwAZklj2iVpXyPkLUJdZzBhxKTI=
Date: Sun, 05 May 2024 17:57:40 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-add-kernel-doc-for-bforget-and-__bforget.patch removed from -mm tree
Message-Id: <20240506005741.0FDE9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: add kernel-doc for bforget() and __bforget()
has been removed from the -mm tree.  Its filename was
     buffer-add-kernel-doc-for-bforget-and-__bforget.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: add kernel-doc for bforget() and __bforget()
Date: Tue, 16 Apr 2024 04:17:50 +0100

Distinguish these functions from brelse() and __brelse().

Link: https://lkml.kernel.org/r/20240416031754.4076917-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    9 ++++++---
 include/linux/buffer_head.h |   10 ++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/fs/buffer.c~buffer-add-kernel-doc-for-bforget-and-__bforget
+++ a/fs/buffer.c
@@ -1242,9 +1242,12 @@ void __brelse(struct buffer_head *bh)
 }
 EXPORT_SYMBOL(__brelse);
 
-/*
- * bforget() is like brelse(), except it discards any
- * potentially dirty data.
+/**
+ * __bforget - Discard any dirty data in a buffer.
+ * @bh: The buffer to forget.
+ *
+ * This variant of bforget() can be called if @bh is guaranteed to not
+ * be NULL.
  */
 void __bforget(struct buffer_head *bh)
 {
--- a/include/linux/buffer_head.h~buffer-add-kernel-doc-for-bforget-and-__bforget
+++ a/include/linux/buffer_head.h
@@ -325,6 +325,16 @@ static inline void brelse(struct buffer_
 		__brelse(bh);
 }
 
+/**
+ * bforget - Discard any dirty data in a buffer.
+ * @bh: The buffer to forget.
+ *
+ * Call this function instead of brelse() if the data written to a buffer
+ * no longer needs to be written back.  It will clear the buffer's dirty
+ * flag so writeback of this buffer will be skipped.
+ *
+ * Context: Any context.
+ */
 static inline void bforget(struct buffer_head *bh)
 {
 	if (bh)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


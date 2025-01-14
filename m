Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85D423A10F
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836952; cv=none; b=tn5jvHvN70zagxthEer6DvWEr48GkNUYFJclMywEiffASzLmLuWhjG0Jq1I544F2rve9FzNllAahdRsh1qd4BqJ92NVutpxt0Zyql6dxw8Jyuy+D6FS0trg1BmLnn71bM2n+Bv/9aHNlWSH69SC9s7Nay7lTD16xy1wlTEbTXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836952; c=relaxed/simple;
	bh=HV4/N9KHG4x/sh4/19npp5gvAs54bNiNHmN0ibo2Mpc=;
	h=Date:To:From:Subject:Message-Id; b=KZ+THi9WGfWeoxlJFWp6/2BRoJh4ANtivqS+SpR/J2MDwPmbOIPTADnCm7VZ0sk5hHF5zqEPNpY1GcrftMtKLmrpia864M3MvIPqFPJow14y8Tw90ATTdiuVTRhbw0a8gdXAOoDXw/Zdy/BvXWwbgikQ3S2b9gL/Luap7xg8YzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2cSBGuzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2cSBGuzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE649C4CEDD;
	Tue, 14 Jan 2025 06:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836952;
	bh=HV4/N9KHG4x/sh4/19npp5gvAs54bNiNHmN0ibo2Mpc=;
	h=Date:To:From:Subject:From;
	b=2cSBGuzVmByDKqkYVcvfGXzUse+XO/FrRB/TiZ0UDpEOLeJwe5b6pE+qOLF7KhLTL
	 waAsyDHJf6QSaGCc/xLpEJ6Tsb3L2fkxWAjf2nrF0oaIZjHqp9oVoDKQ6Di+5wzaNH
	 OAgUmW8aPqBohlHpXLL0eoxD3/V/a90X0VHSz/VI=
Date: Mon, 13 Jan 2025 22:42:32 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-unused-folio_add_wait_queue.patch removed from -mm tree
Message-Id: <20250114064232.AE649C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: remove unused folio_add_wait_queue
has been removed from the -mm tree.  Its filename was
     filemap-remove-unused-folio_add_wait_queue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: filemap: remove unused folio_add_wait_queue
Date: Sat, 16 Nov 2024 15:14:46 +0000

folio_add_wait_queue() has been unused since 2021's commit 850cba069c26
("cachefiles: Delete the cachefiles driver pending rewrite")

Remove it.

Link: https://lkml.kernel.org/r/20241116151446.95555-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 mm/filemap.c            |   19 -------------------
 2 files changed, 24 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-unused-folio_add_wait_queue
+++ a/include/linux/pagemap.h
@@ -1281,11 +1281,6 @@ void folio_wait_private_2(struct folio *
 int folio_wait_private_2_killable(struct folio *folio);
 
 /*
- * Add an arbitrary waiter to a page's wait queue
- */
-void folio_add_wait_queue(struct folio *folio, wait_queue_entry_t *waiter);
-
-/*
  * Fault in userspace address range.
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size);
--- a/mm/filemap.c~filemap-remove-unused-folio_add_wait_queue
+++ a/mm/filemap.c
@@ -1464,25 +1464,6 @@ static int folio_put_wait_locked(struct
 }
 
 /**
- * folio_add_wait_queue - Add an arbitrary waiter to a folio's wait queue
- * @folio: Folio defining the wait queue of interest
- * @waiter: Waiter to add to the queue
- *
- * Add an arbitrary @waiter to the wait queue for the nominated @folio.
- */
-void folio_add_wait_queue(struct folio *folio, wait_queue_entry_t *waiter)
-{
-	wait_queue_head_t *q = folio_waitqueue(folio);
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
-	__add_wait_queue_entry_tail(q, waiter);
-	folio_set_waiters(folio);
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-EXPORT_SYMBOL_GPL(folio_add_wait_queue);
-
-/**
  * folio_unlock - Unlock a locked folio.
  * @folio: The folio.
  *
_

Patches currently in -mm which might be from linux@treblig.org are



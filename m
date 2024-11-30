Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C6254727
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939309; cv=none; b=Ito7HrxImtmv0ZwvU3Um6jtN3nh2dHWGwCVEYzgnDyJHpEQ1HuTNJ2ot2aIrDbFPmNCxSDS4BOL1W5jdYLdjtAKOetYOemUJQN5+vsQFY4lFXfe3k7jQMeVjMi9t6YlFgCYeX/rB7A4tjXpoVFRw6w4WH+uqc2CMn07n5Ebr4Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939309; c=relaxed/simple;
	bh=s4jWCkCR8CCxjwClpGtFvDqfsJK/4q15jeaaGYyAv/E=;
	h=Date:To:From:Subject:Message-Id; b=hjqy1xjfFKrY97adjiXRbSYxXdNchtCCPjEk2NY27NSSoGa/AJczv0ZKU7okL6kjdp1Nwp+fPDAGooX/DMaehczyZuKtOMxaAcU70picJ9XD/uz89f2qBn4F3zh4tnfkEZDyaSdsB3rht8OdqeiegUmq3fTLuR//S3FevswVQuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zd15sgZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zd15sgZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27685C4CECC;
	Sat, 30 Nov 2024 04:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939309;
	bh=s4jWCkCR8CCxjwClpGtFvDqfsJK/4q15jeaaGYyAv/E=;
	h=Date:To:From:Subject:From;
	b=Zd15sgZOgeFYmABy3ccVxWsLfGpi7U1+dIhu8neXdzRileHeI8/G28tnu0oCZa1lW
	 84wq+W0ZfOnOdBksVtd7BZneiG1gtx3XFlRfTfwWlmkMOdqqT+MAobZJOrdHSAF8Wl
	 HdJaFsQvf4/mGfigBQ3KR/Bf2vG4xH1/uhfRo8E4=
Date: Fri, 29 Nov 2024 20:01:47 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-unused-folio_add_wait_queue.patch added to mm-unstable branch
Message-Id: <20241130040149.27685C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: remove unused folio_add_wait_queue
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-remove-unused-folio_add_wait_queue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-unused-folio_add_wait_queue.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1473,25 +1473,6 @@ static int folio_put_wait_locked(struct
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

filemap-remove-unused-folio_add_wait_queue.patch


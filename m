Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7CF6FBF;
	Fri,  6 Dec 2024 03:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457328; cv=none; b=bUcgUAbJu0/dPNlNNNHzluCAcLTiwVCb38dtoIdRZYnshqpRw6DfZWkTBc4VwupZ0JlZSWQ70hrBU3/rFw0g9QcsEY8MY3haW36uKuHJp6dyLZGPh9436FTb6cYHofc434ZkuLJ0YduQJQoEftoOkrkFoGNJtOTgPT5G//0tBvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457328; c=relaxed/simple;
	bh=ER/aDejDgsGI2vTIrCBUJMXDJAxwJH+KweeiIdWE5uY=;
	h=Date:To:From:Subject:Message-Id; b=N/48UnG1Ep+sx/25b0uf/R5WaZ/wjFjOmO7tiKXkgD9TNiWCGixnkAo6Dvo5E9pzcBinpW/Sxd4nKbAZL6k0t3D2wheejnxK9il0UWQ0uWlUqJiuMe323EWdcX+y1QxqoHsJXrf6jqPbV5LizlzG+Kj1+rKDZt3J5mYqtr2ifFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HEUm5bEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HEUm5bEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22D3C4CED1;
	Fri,  6 Dec 2024 03:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457327;
	bh=ER/aDejDgsGI2vTIrCBUJMXDJAxwJH+KweeiIdWE5uY=;
	h=Date:To:From:Subject:From;
	b=HEUm5bEz89sPzzzOVGy3BFwhhnhKu6b743sSktFEFb9S1l67eeuMab8hZl3jHR6R4
	 U9YJuG3fluDqZdo0/kotRi7n6UTw0VYRlH/MKJBcDtFArfCF5RQdyUwZJWtTN1nVBV
	 cJSKdsMCTPTebuIzlPkQ1zNROImJkcPmsV5oejyg=
Date: Thu, 05 Dec 2024 19:55:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,osalvador@suse.de,glider@google.com,dvyukov@google.com,bigeasy@linutronix.de,andreyknvl@gmail.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] stackdepot-fix-stack_depot_save_flags-in-nmi-context.patch removed from -mm tree
Message-Id: <20241206035527.B22D3C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stackdepot: fix stack_depot_save_flags() in NMI context
has been removed from the -mm tree.  Its filename was
     stackdepot-fix-stack_depot_save_flags-in-nmi-context.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: stackdepot: fix stack_depot_save_flags() in NMI context
Date: Fri, 22 Nov 2024 16:39:47 +0100

Per documentation, stack_depot_save_flags() was meant to be usable from
NMI context if STACK_DEPOT_FLAG_CAN_ALLOC is unset.  However, it still
would try to take the pool_lock in an attempt to save a stack trace in the
current pool (if space is available).

This could result in deadlock if an NMI is handled while pool_lock is
already held.  To avoid deadlock, only try to take the lock in NMI context
and give up if unsuccessful.

The documentation is fixed to clearly convey this.

Link: https://lkml.kernel.org/r/Z0CcyfbPqmxJ9uJH@elver.google.com
Link: https://lkml.kernel.org/r/20241122154051.3914732-1-elver@google.com
Fixes: 4434a56ec209 ("stackdepot: make fast paths lock-less again")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    6 +++---
 lib/stackdepot.c           |   10 +++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/include/linux/stackdepot.h~stackdepot-fix-stack_depot_save_flags-in-nmi-context
+++ a/include/linux/stackdepot.h
@@ -147,7 +147,7 @@ static inline int stack_depot_early_init
  * If the provided stack trace comes from the interrupt context, only the part
  * up to the interrupt entry is saved.
  *
- * Context: Any context, but setting STACK_DEPOT_FLAG_CAN_ALLOC is required if
+ * Context: Any context, but unsetting STACK_DEPOT_FLAG_CAN_ALLOC is required if
  *          alloc_pages() cannot be used from the current context. Currently
  *          this is the case for contexts where neither %GFP_ATOMIC nor
  *          %GFP_NOWAIT can be used (NMI, raw_spin_lock).
@@ -156,7 +156,7 @@ static inline int stack_depot_early_init
  */
 depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 					    unsigned int nr_entries,
-					    gfp_t gfp_flags,
+					    gfp_t alloc_flags,
 					    depot_flags_t depot_flags);
 
 /**
@@ -175,7 +175,7 @@ depot_stack_handle_t stack_depot_save_fl
  * Return: Handle of the stack trace stored in depot, 0 on failure
  */
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
-				      unsigned int nr_entries, gfp_t gfp_flags);
+				      unsigned int nr_entries, gfp_t alloc_flags);
 
 /**
  * __stack_depot_get_stack_record - Get a pointer to a stack_record struct
--- a/lib/stackdepot.c~stackdepot-fix-stack_depot_save_flags-in-nmi-context
+++ a/lib/stackdepot.c
@@ -630,7 +630,15 @@ depot_stack_handle_t stack_depot_save_fl
 			prealloc = page_address(page);
 	}
 
-	raw_spin_lock_irqsave(&pool_lock, flags);
+	if (in_nmi()) {
+		/* We can never allocate in NMI context. */
+		WARN_ON_ONCE(can_alloc);
+		/* Best effort; bail if we fail to take the lock. */
+		if (!raw_spin_trylock_irqsave(&pool_lock, flags))
+			goto exit;
+	} else {
+		raw_spin_lock_irqsave(&pool_lock, flags);
+	}
 	printk_deferred_enter();
 
 	/* Try to find again, to avoid concurrently inserting duplicates. */
_

Patches currently in -mm which might be from elver@google.com are



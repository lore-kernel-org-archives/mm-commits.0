Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17BD1E505;
	Thu, 28 Nov 2024 01:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757174; cv=none; b=pcvmDb8o7Kaf5aqNtHJFcPV0DNuE/qxRTC9xE+N5+tnB4MVWNqa7rRs/1Gf41U6qWARj+m2YgOfmCzgRTiXHgIPmVTyS6bTtLOQdfXUV7vBzIKO5TQn+rU257KjAFvsx366zja6SmgbG4AAmJQTnd1/QUvq0zxjnudEy+gF6jU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757174; c=relaxed/simple;
	bh=cAtlbA1U9J5Df6E73Oz5P0Fc9Pq5oq8EywQ9tQcrjOs=;
	h=Date:To:From:Subject:Message-Id; b=O5nKIeXkKlW5N60FQU3WXjedJ+TwraqalRZc26HJfkK1qe5GFd4Wu20uXTldq5UBEHDEma4HhojM03ExpH9tOBueXqGO5PMCxwkzNX9Ca4gCaGhx8A7LZG4SCRMn79qYqRquaags0stoAbtmW0ckQXLOun291sNHZyTNZPwLEWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hpmd7MjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hpmd7MjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B632C4CECC;
	Thu, 28 Nov 2024 01:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732757174;
	bh=cAtlbA1U9J5Df6E73Oz5P0Fc9Pq5oq8EywQ9tQcrjOs=;
	h=Date:To:From:Subject:From;
	b=Hpmd7MjZYc61HmpUM1R2J4uuEpO7giqQFD0GgWiZJvq9Tfj/cbE11RDu9ifkrtvx/
	 HQXgsAkPL9WyxVQS6ZtxC4GNZtc+cpbGFxJqg3CNLfmh17prHLkE+Pf28BiagVPizf
	 Le5QGuih45GRaMdGSBb2C5mHc9ZxY9eLaZLvf8ow=
Date: Wed, 27 Nov 2024 17:26:13 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,osalvador@suse.de,glider@google.com,dvyukov@google.com,bigeasy@linutronix.de,andreyknvl@gmail.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-fix-stack_depot_save_flags-in-nmi-context.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128012614.6B632C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stackdepot: fix stack_depot_save_flags() in NMI context
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     stackdepot-fix-stack_depot_save_flags-in-nmi-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-fix-stack_depot_save_flags-in-nmi-context.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

stackdepot-fix-stack_depot_save_flags-in-nmi-context.patch


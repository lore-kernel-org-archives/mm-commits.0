Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB49A18EA9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UWFVbIu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE11C433F1;
	Fri, 12 Jan 2024 23:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101693;
	bh=9SmAT0DL2JVGfUTKgcjIa6tfgF/QbBfW0U4O3UmmVD4=;
	h=Date:To:From:Subject:From;
	b=UWFVbIu7n5wru586a7dF3H0s0Q5sjxkuor3btctpzpIVLjervxuy+UK1lP+bWT8d0
	 qGClfvt1GeG/D4XWVC3pS6yt9ctirlDR44nT2b9v9xEG5Tz5XtHlpDUjUJqroFj1wm
	 gM4tJd5ihs7y1K3xL+VrEe44roHlR3l8Ks3W1NIw=
Date: Fri, 12 Jan 2024 15:21:32 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,paulmck@kernel.org,Liam.Howlett@oracle.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-avoid-resetting-aux_lock.patch removed from -mm tree
Message-Id: <20240112232133.0CE11C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: avoid resetting aux_lock
has been removed from the -mm tree.  Its filename was
     kasan-avoid-resetting-aux_lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: avoid resetting aux_lock
Date: Tue, 9 Jan 2024 23:12:34 +0100

With commit 63b85ac56a64 ("kasan: stop leaking stack trace handles"),
KASAN zeroes out alloc meta when an object is freed.  The zeroed out data
purposefully includes alloc and auxiliary stack traces but also
accidentally includes aux_lock.

As aux_lock is only initialized for each object slot during slab creation,
when the freed slot is reallocated, saving auxiliary stack traces for the
new object leads to lockdep reports when taking the zeroed out aux_lock.

Arguably, we could reinitialize aux_lock when the object is reallocated,
but a simpler solution is to avoid zeroing out aux_lock when an object
gets freed.

Link: https://lkml.kernel.org/r/20240109221234.90929-1-andrey.konovalov@linux.dev
Fixes: 63b85ac56a64 ("kasan: stop leaking stack trace handles")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Closes: https://lore.kernel.org/linux-next/5cc0f83c-e1d6-45c5-be89-9b86746fe731@paulmck-laptop/
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/kasan/generic.c~kasan-avoid-resetting-aux_lock
+++ a/mm/kasan/generic.c
@@ -487,6 +487,7 @@ void kasan_init_object_meta(struct kmem_
 		__memset(alloc_meta, 0, sizeof(*alloc_meta));
 
 		/*
+		 * Prepare the lock for saving auxiliary stack traces.
 		 * Temporarily disable KASAN bug reporting to allow instrumented
 		 * raw_spin_lock_init to access aux_lock, which resides inside
 		 * of a redzone.
@@ -510,8 +511,13 @@ static void release_alloc_meta(struct ka
 	stack_depot_put(meta->aux_stack[0]);
 	stack_depot_put(meta->aux_stack[1]);
 
-	/* Zero out alloc meta to mark it as invalid. */
-	__memset(meta, 0, sizeof(*meta));
+	/*
+	 * Zero out alloc meta to mark it as invalid but keep aux_lock
+	 * initialized to avoid having to reinitialize it when another object
+	 * is allocated in the same slot.
+	 */
+	__memset(&meta->alloc_track, 0, sizeof(meta->alloc_track));
+	__memset(meta->aux_stack, 0, sizeof(meta->aux_stack));
 }
 
 static void release_free_meta(const void *object, struct kasan_free_meta *meta)
_

Patches currently in -mm which might be from andreyknvl@gmail.com are



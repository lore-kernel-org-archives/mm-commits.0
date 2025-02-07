Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E43A1A01C6
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738972283; cv=none; b=u7WWDPy4UaPXXk7e5rfkxNWIoeRXir28GfhTWxyB6UHFgcyFnPqzOy77bqq4EGsodsZgUmML6xl2LMEuIyDqUoIXgnQ6B1hZ63+FNXqy7Nm9bJ7OGLhfcjd4u2XEPk6KSzgccy/h6tdPZMdrD9rfrf8sbJtZk7QNZSw4IlKewoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738972283; c=relaxed/simple;
	bh=qMonobQAljkjWiZEN9w/baxTikGVDC6rf4+QZg9MeIQ=;
	h=Date:To:From:Subject:Message-Id; b=m77SBxv1NW5acqvF3zLYQQahtV1eyt+g9+fXL9nltEgUpYUNVB2fUVWj6r3UHx5+Y5CXGwFtC5oVZ8JaavM9HrKGlJPmczrLUdMWHbiPnSlZ9gqhJjTzXkWiY67A0vJF4GowHnp0adCasEtopZ86Kcasd5L5q2UWA5efp08c8Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h3I1zrNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h3I1zrNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1100CC4CED1;
	Fri,  7 Feb 2025 23:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738972283;
	bh=qMonobQAljkjWiZEN9w/baxTikGVDC6rf4+QZg9MeIQ=;
	h=Date:To:From:Subject:From;
	b=h3I1zrNPW/AeeEPfFiiy1jxqTGJq2vRThHUhUhiGwno4pjrT4qYrKKB8KaU/AJEOz
	 98fXWWjW/jqswy272Q3nGpAqc1o0rT0UwVnyrldfZX7zgzojPVOM6bw+4BvGwcPDzi
	 j7INyU+jYeaouyJ8OMnywAOebhrx+xC+uklfzwcA=
Date: Fri, 07 Feb 2025 15:51:22 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,urezki@gmail.com,tglx@linutronix.de,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,mengensun@tencent.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch added to mm-nonmm-unstable branch
Message-Id: <20250207235123.1100CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucount: replace get_ucounts_or_wrap() with atomic_inc_not_zero()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: ucount: replace get_ucounts_or_wrap() with atomic_inc_not_zero()
Date: Mon, 3 Feb 2025 16:05:23 +0100

get_ucounts_or_wrap() increments the counter and if the counter is
negative then it decrements it again in order to reset the previous
increment.  This statement can be replaced with atomic_inc_not_zero() to
only increment the counter if it is not yet 0.

This simplifies the get function because the put (if the get failed) can
be removed.  atomic_inc_not_zero() is implement as a cmpxchg() loop which
can be repeated several times if another get/put is performed in parallel.
This will be optimized later.

Increment the reference counter only if not yet dropped to zero.

Link: https://lkml.kernel.org/r/20250203150525.456525-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Acked-by:Thomas Gleixner <tglx@linutronix.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mengen Sun <mengensun@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: YueHong Wu <yuehongwu@tencent.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/kernel/ucount.c~ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero
+++ a/kernel/ucount.c
@@ -146,25 +146,16 @@ static void hlist_add_ucounts(struct uco
 	spin_unlock_irq(&ucounts_lock);
 }
 
-static inline bool get_ucounts_or_wrap(struct ucounts *ucounts)
-{
-	/* Returns true on a successful get, false if the count wraps. */
-	return !atomic_add_negative(1, &ucounts->count);
-}
-
 struct ucounts *get_ucounts(struct ucounts *ucounts)
 {
-	if (!get_ucounts_or_wrap(ucounts)) {
-		put_ucounts(ucounts);
-		ucounts = NULL;
-	}
-	return ucounts;
+	if (atomic_inc_not_zero(&ucounts->count))
+		return ucounts;
+	return NULL;
 }
 
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
-	bool wrapped;
 	struct ucounts *ucounts, *new = NULL;
 
 	spin_lock_irq(&ucounts_lock);
@@ -189,14 +180,11 @@ struct ucounts *alloc_ucounts(struct use
 			return new;
 		}
 	}
-
-	wrapped = !get_ucounts_or_wrap(ucounts);
+	if (!atomic_inc_not_zero(&ucounts->count))
+		ucounts = NULL;
 	spin_unlock_irq(&ucounts_lock);
 	kfree(new);
-	if (wrapped) {
-		put_ucounts(ucounts);
-		return NULL;
-	}
+
 	return ucounts;
 }
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch
ucount-use-rcu-for-ucounts-lookups.patch
ucount-use-rcuref_t-for-reference-counting.patch


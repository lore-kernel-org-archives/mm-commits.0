Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79401A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161340; cv=none; b=HykHN1qDMIJptwm07PPXsFtVLytM7+weeFpChAKLQdVnLNjLuNUDoQ8/tBe8hCFVDoJWimp3+0ERoKV2skgMxiZS809u4vJc7tPdiqng4F0ECns9cdoQqbd+vwMr9QMr7GrJGDF65TPdETqLFjv5rQBsZeGZV24Z+W+GN5b+c8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161340; c=relaxed/simple;
	bh=jRglxKVwg7hNqQkkPqbzEqaikk+RP6kJTOYPOlakhRE=;
	h=Date:To:From:Subject:Message-Id; b=hdL2Y5FBtAv90YMHTtAPwF8FtU4GK1e8/EENUZ9giuqNyF3cjObVWxZSxAmnWKdTf6wcGPSj4hMrJ7Cg6WO9ZlaqH4hBzEqisO5TwjHwAXKu3r0NxBsYIaWGcFS3UnOgAbmQl3LzAUqsxcl4v1iJAxCP6d0Ev0jflM+Gyj/kjfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cAx4sfqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cAx4sfqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82135C4CEEF;
	Sat,  2 Aug 2025 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161340;
	bh=jRglxKVwg7hNqQkkPqbzEqaikk+RP6kJTOYPOlakhRE=;
	h=Date:To:From:Subject:From;
	b=cAx4sfqYm44MssjWhFxg5p09DqhqA0DPtR3iasblEFyG42dv6O5NjnRwDWflHOoEm
	 HvYhGK3eFeZJ3spaB+myJi0r5aVIYD7kGtGpIBwsbT1FKOrN+RK6D1VC5y3RYpfMHM
	 +pKSxhVBl2N3tV4phRfjsib4L0u734aMo/w+v3RY=
Date: Sat, 02 Aug 2025 12:02:20 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,paulmck@kernel.org,mengensun@tencent.com,linux@weissschuh.net,legion@kernel.org,bigeasy@linutronix.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below.patch removed from -mm tree
Message-Id: <20250802190220.82135C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucount: use atomic_long_try_cmpxchg() in atomic_long_inc_below()
has been removed from the -mm tree.  Its filename was
     ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: ucount: use atomic_long_try_cmpxchg() in atomic_long_inc_below()
Date: Mon, 21 Jul 2025 19:45:58 +0200

Use atomic_long_try_cmpxchg() instead of
atomic_long_cmpxchg (*ptr, old, new) == old in atomic_long_inc_below().
x86 CMPXCHG instruction returns success in ZF flag, so this change saves
a compare after cmpxchg (and related move instruction in front of cmpxchg).

Also, atomic_long_try_cmpxchg implicitly assigns old *ptr value to "old"
when cmpxchg fails, enabling further code simplifications.

No functional change intended.

Link: https://lkml.kernel.org/r/20250721174610.28361-2-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: MengEn Sun <mengensun@tencent.com>
Cc: "Thomas Weißschuh" <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/kernel/ucount.c~ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below
+++ a/kernel/ucount.c
@@ -201,16 +201,14 @@ void put_ucounts(struct ucounts *ucounts
 
 static inline bool atomic_long_inc_below(atomic_long_t *v, long u)
 {
-	long c, old;
-	c = atomic_long_read(v);
-	for (;;) {
+	long c = atomic_long_read(v);
+
+	do {
 		if (unlikely(c >= u))
 			return false;
-		old = atomic_long_cmpxchg(v, c, c+1);
-		if (likely(old == c))
-			return true;
-		c = old;
-	}
+	} while (!atomic_long_try_cmpxchg(v, &c, c+1));
+
+	return true;
 }
 
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
_

Patches currently in -mm which might be from ubizjak@gmail.com are



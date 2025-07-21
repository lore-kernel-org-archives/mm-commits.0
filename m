Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6A223A9A0
	for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2025 22:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753137864; cv=none; b=uqWXS9RqyyjurvLHY+pnIjVzoLw2vWeonas2+4Sv5/3okzXBzLlpAh5ibsYeVBHTXSVChh66pKqkNGJVYSDA+rv8gEQ802w9QJ0oUYX6wcH1B3jRkyosmm+TIuD3N+o06ZpYPmPa/KKQMp9oBjgxaCnTEcS2yP4QExmAhDV7o1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753137864; c=relaxed/simple;
	bh=GJ9+UNA/wcXzy4G1Fox4tNrsyBN4HvkXgF0Hji32cKI=;
	h=Date:To:From:Subject:Message-Id; b=W644F4jmg4Pwt7omOtVl1KulVJ24C3lbvZmkTgY7X/TvjdeY/sALMHmyzgq1vqqL/tDAXCOD4HhudTie+PNDiUzGNkzqiWgOx/Yr4NiGovZ6q1ULwZePEhQcc7YchzWyOvTf7JVOPfxGQ7hrJMeXJDQ0EmzVdvL1Q/D37L+OcXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lG5tX3an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lG5tX3an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495AAC4CEED;
	Mon, 21 Jul 2025 22:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753137864;
	bh=GJ9+UNA/wcXzy4G1Fox4tNrsyBN4HvkXgF0Hji32cKI=;
	h=Date:To:From:Subject:From;
	b=lG5tX3and0zcXxTBKomI/dZHl3Iw6xwc/YjpuSEYcK9Q2BLdOwa3myiAsdCd81gyW
	 de1NB1P68WFYQ8OJUOgm7qmIPU9ejBYO9lGtDcJG7u0q39OO2CthEbxoUDCTUUuOmb
	 uE2W3jVV1zYkBF2Fzq5PurPbH5WbsgFUIZWkQtUI=
Date: Mon, 21 Jul 2025 15:44:23 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,paulmck@kernel.org,mengensun@tencent.com,linux@weissschuh.net,legion@kernel.org,bigeasy@linutronix.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below.patch added to mm-nonmm-unstable branch
Message-Id: <20250721224424.495AAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucount: use atomic_long_try_cmpxchg() in atomic_long_inc_below()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below.patch

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

ucount-fix-atomic_long_inc_below-argument-type.patch
ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below.patch


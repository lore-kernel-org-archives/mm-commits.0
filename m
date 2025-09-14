Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311EE39FD9
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810097; cv=none; b=sxMturodjGx8ncJ/vN3zlebd3QGieszRwKv/rwnSDWVbTqD9S1/E9tzdcQDdgiPC8lzW8jnRGknAgDbDpOG2AygrGPwqJquobTj8hJkCYp9mr/e60oMdUjBra8jbmLUujFACvPZr1H4TPQnospEvV8sTPNfCG2XloNRsJ1lF7iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810097; c=relaxed/simple;
	bh=kXknjnFYE7zvh4Xkrr4d2Gftfd+PrO0qJ69kkUFgjqU=;
	h=Date:To:From:Subject:Message-Id; b=jVxAg6DvR9zmr6nxQxMfcFxIkg9a0IgukSByJuRSqOKd5zgen7uMuj7MN6sOHUTTedyyeRl6bywhFm3a5Fbpj+qYQSOgk+FZA5NUpHp1+PHez2gjbdz/RBfxQQCS/b3MDYPcjuw0Y263Fkok9exKxMYeC6hx42j0vqPC4506T2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GQowTCSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GQowTCSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C90EC4CEEB;
	Sun, 14 Sep 2025 00:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810096;
	bh=kXknjnFYE7zvh4Xkrr4d2Gftfd+PrO0qJ69kkUFgjqU=;
	h=Date:To:From:Subject:From;
	b=GQowTCSda4gnuYEfFWAZYJnjYJIWVRMTmchriVJMIx3/qAVqEiRV2aKUsfLWiNzfK
	 NF3CnhgO2BzAvkvoN2+5wt1RP3LNi5hRd7dG2gpfteqBF7+J4ia8NmOOeyiJtW+yLk
	 AXmlmoPkosWijfh0ZD+px35vF5U6jXtvPCE1dfO0=
Date: Sat, 13 Sep 2025 17:34:56 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,arnd@arndb.de,andreyknvl@gmail.com,soham.bagchi@utah.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch removed from -mm tree
Message-Id: <20250914003456.9C90EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: use write memory barrier after memcpy() in kcov_move_area()
has been removed from the -mm tree.  Its filename was
     kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Soham Bagchi <soham.bagchi@utah.edu>
Subject: kcov: use write memory barrier after memcpy() in kcov_move_area()
Date: Mon, 28 Jul 2025 12:43:17 -0600

KCOV Remote uses two separate memory buffers, one private to the kernel
space (kcov_remote_areas) and the second one shared between user and
kernel space (kcov->area).  After every pair of kcov_remote_start() and
kcov_remote_stop(), the coverage data collected in the kcov_remote_areas
is copied to kcov->area so the user can read the collected coverage data. 
This memcpy() is located in kcov_move_area().

The load/store pattern on the kernel-side [1] is:

```
/* dst_area === kcov->area, dst_area[0] is where the count is stored */
dst_len = READ_ONCE(*(unsigned long *)dst_area);
...
memcpy(dst_entries, src_entries, ...);
...
WRITE_ONCE(*(unsigned long *)dst_area, dst_len + entries_moved);
```

And for the user [2]:

```
/* cover is equivalent to kcov->area */
n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
```

Without a write-memory barrier, the atomic load for the user can
potentially read fresh values of the count stored at cover[0], but
continue to read stale coverage data from the buffer itself.  Hence, we
recommend adding a write-memory barrier between the memcpy() and the
WRITE_ONCE() in kcov_move_area().

Link: https://lkml.kernel.org/r/20250728184318.1839137-1-soham.bagchi@utah.edu
Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/kernel/kcov.c?h=master#n978 [1]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/dev-tools/kcov.rst#n364 [2]
Signed-off-by: Soham Bagchi <soham.bagchi@utah.edu>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/kcov.c~kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area
+++ a/kernel/kcov.c
@@ -978,6 +978,15 @@ static void kcov_move_area(enum kcov_mod
 	memcpy(dst_entries, src_entries, bytes_to_move);
 	entries_moved = bytes_to_move >> entry_size_log;
 
+	/*
+	 * A write memory barrier is required here, to ensure
+	 * that the writes from the memcpy() are visible before
+	 * the count is updated. Without this, it is possible for
+	 * a user to observe a new count value but stale
+	 * coverage data.
+	 */
+	smp_wmb();
+
 	switch (mode) {
 	case KCOV_MODE_TRACE_PC:
 		WRITE_ONCE(*(unsigned long *)dst_area, dst_len + entries_moved);
_

Patches currently in -mm which might be from soham.bagchi@utah.edu are



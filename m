Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566BF13AF2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 19:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753732022; cv=none; b=ezK+d/xTBR9fmTEi15sIuxsy0JTbXM2zetpBSxXa7pIP0PoxsB2phEk2US/O7SK32J5Ud9RqHQaCKYZUKxOc1/T3vkYVG5UOWGG2Lfl85o5ecxvv76QNdw2cMSoqhel8Ja7t8+FG79v0MhQAyv87Q66UyCHSAdsyYGkl6OVktF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753732022; c=relaxed/simple;
	bh=j55vcwPYmaH0fe4EvxO0Q0XQf+7cvMfRNRcqe52P0ok=;
	h=Date:To:From:Subject:Message-Id; b=kqpg2c3J6fgUX2UbtlOvWuV464H3eXWFNv+oMH7I6dBx1rYKl/evJ8/wrTqtHDqGWtK+v3d2dfvDPA326mmzEU4nbfEd2yZkFw9ThzgrkP40MSVh77JAA2MlQN3AkWxN4E7c9KF2V71wSEQloM0YSYRD5/+Ay3Ep9/Ufm0wLx38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LmrGujBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LmrGujBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EA0C4CEE7;
	Mon, 28 Jul 2025 19:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753732021;
	bh=j55vcwPYmaH0fe4EvxO0Q0XQf+7cvMfRNRcqe52P0ok=;
	h=Date:To:From:Subject:From;
	b=LmrGujBCkLvqaxbTAzP2jB62tHwSMcxB2ckqXdpSiB2TnlitOL4fOZpnu9uujX851
	 TGHnEZ9wgIAVf2PLFv0ACQbP5FeYSvCbzdtQI9qu2h0zV9dTARMh+Ihlz4hwkWEr6s
	 0f+v/7b/lEdWGtKhRtFFTIZvnJKicWsga2Mp/sXw=
Date: Mon, 28 Jul 2025 12:47:01 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,arnd@arndb.de,andreyknvl@gmail.com,soham.bagchi@utah.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch added to mm-nonmm-unstable branch
Message-Id: <20250728194701.D8EA0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: use write memory barrier after memcpy() in kcov_move_area()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Macro Elver <elver@google.com>
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

kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch
kcov-load-acquire-coverage-count-in-user-space-code.patch


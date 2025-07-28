Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A515713AF2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 19:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753732023; cv=none; b=RfxAz3J2NMGyxIARxfU9ZsgRa4xNlSCuHD7AXagmTYbh3HjgWowoPiLCzRQT5vj5e15uDR+SvtZZGAfn3ogqwUYGl+rVt1mJiBtAqRyybVED7vf7LlimkdzLyjNFoz1W4v6cBttuW6u/uikXcISNk5PZ1RdQgpMl71iz0OtWumI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753732023; c=relaxed/simple;
	bh=/NqAsn6NGy2r1hrmARbLkPfdzUY9xZGQSJkBB+evjPY=;
	h=Date:To:From:Subject:Message-Id; b=E8yBwSa9enKgslTef2uEGe6Dzh8zRiklVw/SwCtf0vJ4irvyxAYG45Rh8gPo9yeLvlAL0jzpEpxf0dXo5zzulQk4yXGgFb5hbucRKxnyOiGL3GAvDaXp+qA8PUQ0Eg1J52ZiAvKJWB/T7jd84ma+9Fo5bbRHr6XcoHdSIDGo2LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ENi0nOzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ENi0nOzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29510C4CEE7;
	Mon, 28 Jul 2025 19:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753732023;
	bh=/NqAsn6NGy2r1hrmARbLkPfdzUY9xZGQSJkBB+evjPY=;
	h=Date:To:From:Subject:From;
	b=ENi0nOzLY+df2OKqttAxkL4qu8p3m29qXDXmJjFPDuIiMzcWy/66elLMkfP0qJJdE
	 YL5LXaYDQ68KEHHmnciin3orMXQojc9iIF9t+02eaaCw4AAuL/i5CBSSt6lXcOmYmq
	 kawZYuhf997gh8SKysVFUOGIhd562y/HgYRXobiU=
Date: Mon, 28 Jul 2025 12:47:02 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,arnd@arndb.de,andreyknvl@gmail.com,soham.bagchi@utah.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-load-acquire-coverage-count-in-user-space-code.patch added to mm-nonmm-unstable branch
Message-Id: <20250728194703.29510C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: load acquire coverage count in user-space code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-load-acquire-coverage-count-in-user-space-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-load-acquire-coverage-count-in-user-space-code.patch

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
Subject: kcov: load acquire coverage count in user-space code
Date: Mon, 28 Jul 2025 12:43:18 -0600

Updating the KCOV documentation to use a load-acquire
operation for the first element of the shared memory
buffer between kernel-space and user-space.

The load-acquire pairs with the write memory barrier
used in kcov_move_area()

Link: https://lkml.kernel.org/r/20250728184318.1839137-2-soham.bagchi@utah.edu
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

 Documentation/dev-tools/kcov.rst |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/kcov.rst~kcov-load-acquire-coverage-count-in-user-space-code
+++ a/Documentation/dev-tools/kcov.rst
@@ -287,6 +287,11 @@ handle instance id.
 The following program demonstrates using KCOV to collect coverage from both
 local tasks spawned by the process and the global task that handles USB bus #1:
 
+The user-space code for KCOV should also use an acquire to fetch the count
+of coverage entries in the shared buffer. This acquire pairs with the
+corresponding write memory barrier (smp_wmb()) on the kernel-side in
+kcov_move_area().
+
 .. code-block:: c
 
     /* Same includes and defines as above. */
@@ -361,7 +366,7 @@ local tasks spawned by the process and t
 	 */
 	sleep(2);
 
-	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
+	n = __atomic_load_n(&cover[0], __ATOMIC_ACQUIRE);
 	for (i = 0; i < n; i++)
 		printf("0x%lx\n", cover[i + 1]);
 	if (ioctl(fd, KCOV_DISABLE, 0))
_

Patches currently in -mm which might be from soham.bagchi@utah.edu are

kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch
kcov-load-acquire-coverage-count-in-user-space-code.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AEA611E
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 00:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754527064; cv=none; b=aRtDvz7aVN5OShiFOEIIis5TRoakqQ6/+8vp9RqnruslZAZeDYtJsVKeT+D7XzxOZqGnWLaw8ss/eQeEP3b1E19gbGvBqKz/J0YOhKLWVZKFhP51rCyLsA7VeTn+BWWCO7HWGJFTLOv0luZ1rUwrxDA9ouzgXbGHiTj9C9h7ELQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754527064; c=relaxed/simple;
	bh=M9+qywDIuShHyJTk6iWmTkRZpNakIv5FLntOm4hY91Q=;
	h=Date:To:From:Subject:Message-Id; b=h6ILsVrhPW3JeAdqaTYnErTlcciRE9BIBDZZbSeuiU5lJDRMR8l6U0hWVK4TkHfIGa1DNvcYzMg+VFNrgyGZxMtYQB28xxKPw28dsrJGjTiR1lSjhLr42hj19oMQ+oj1I5MNEO8ksGjbS1iu1to3TKeoTj0/6YdIbkKV2MQ+K7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LEFfHzq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LEFfHzq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DDEC4CEE7;
	Thu,  7 Aug 2025 00:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754527062;
	bh=M9+qywDIuShHyJTk6iWmTkRZpNakIv5FLntOm4hY91Q=;
	h=Date:To:From:Subject:From;
	b=LEFfHzq2x+W/LJ+uyjeOIBcs2f+u4vH9qq7JIE+YNJ/7moJVrwf6AeZaNVjs9r6zR
	 +iUW/NFROmXLmHD0aPbympS1aaakRp8iOQpN/7cHAxS9lGNJjNuIsNNdnx1uZr4HGy
	 BtyCeKTr5ofEkEt9mCBK+VZ+sn4BSKMn80TVUTMA=
Date: Wed, 06 Aug 2025 17:37:42 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,arnd@arndb.de,andreyknvl@gmail.com,soham.bagchi@utah.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-load-acquire-coverage-count-in-user-space-code-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20250807003742.B8DDEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov-load-acquire-coverage-count-in-user-space-code-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-load-acquire-coverage-count-in-user-space-code-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-load-acquire-coverage-count-in-user-space-code-v2.patch

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
Subject: kcov-load-acquire-coverage-count-in-user-space-code-v2
Date: Sun, 3 Aug 2025 12:05:58 -0600

note for load-acquire shifted to block comment in code rather than in the
preceding paragraphs, per Marco

Link: https://lkml.kernel.org/r/20250803180558.2967962-1-soham.bagchi@utah.edu
Signed-off-by: Soham Bagchi <soham.bagchi@utah.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/dev-tools/kcov.rst~kcov-load-acquire-coverage-count-in-user-space-code-v2
+++ a/Documentation/dev-tools/kcov.rst
@@ -287,11 +287,6 @@ handle instance id.
 The following program demonstrates using KCOV to collect coverage from both
 local tasks spawned by the process and the global task that handles USB bus #1:
 
-The user-space code for KCOV should also use an acquire to fetch the count
-of coverage entries in the shared buffer. This acquire pairs with the
-corresponding write memory barrier (smp_wmb()) on the kernel-side in
-kcov_move_area().
-
 .. code-block:: c
 
     /* Same includes and defines as above. */
@@ -366,6 +361,11 @@ kcov_move_area().
 	 */
 	sleep(2);
 
+        /*
+         * The load to the coverage count should be an acquire to pair with
+         * pair with the corresponding write memory barrier (smp_wmb()) on
+         * the kernel-side in kcov_move_area().
+         */
 	n = __atomic_load_n(&cover[0], __ATOMIC_ACQUIRE);
 	for (i = 0; i < n; i++)
 		printf("0x%lx\n", cover[i + 1]);
_

Patches currently in -mm which might be from soham.bagchi@utah.edu are

kcov-use-write-memory-barrier-after-memcpy-in-kcov_move_area.patch
kcov-load-acquire-coverage-count-in-user-space-code.patch
kcov-load-acquire-coverage-count-in-user-space-code-v2.patch


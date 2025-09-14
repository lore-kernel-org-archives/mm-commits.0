Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCC2946A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757808889; cv=none; b=nH9unVKlmJTK9Z+f2p9T2nV+jEHrFJDZtZ4mBIX0W2djCviz+vVE8dz6d3yeCVF8bt/riDsx1VyI4hbv6TfNK2Udm1R2ulO9XcdER2VJD3pqah7WtyEZeJln+poy8RUGgS5DTnGVLO58R44850tpyS9DNMhAfnB6v1kPkCsnxoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757808889; c=relaxed/simple;
	bh=0qcg3uSXApC5QsqXNbKz5u0FgetOpivVh6qpznhY1dM=;
	h=Date:To:From:Subject:Message-Id; b=okv4YkftS2bhHv1TXBxWTIuaRXYnPafIon9EP8LuHu390NPfxT/OSV544VnYHkZdMo7ji/rxbyjrslYltSPzhUHQZPwS2r5fVjo7mgG9XSVAdznvXm0nMK4V3rWD+a+3eEdPRVf7Hp4r74M1B0/N/LeFh5EvCAoK1vnIxXIqx9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S7aH3MiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S7aH3MiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA005C4CEEB;
	Sun, 14 Sep 2025 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757808888;
	bh=0qcg3uSXApC5QsqXNbKz5u0FgetOpivVh6qpznhY1dM=;
	h=Date:To:From:Subject:From;
	b=S7aH3MiNx/gEuKnqvrOsEF5C9uoKpGfdAoy1ACaTPntS5Bkbg3YyiQQjhXondu1vB
	 1LXrUJVKDzgJFZfS/TGhgFjqfUvCbdTjd3RSu2bq+bJjwxfxJC+Tbkshxmc44hJ+8m
	 5Ty6VFAsSlUOWi+byZFKMmf+9ZZzQ7gKlI6w/4S4=
Date: Sat, 13 Sep 2025 17:14:48 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,arnd@arndb.de,andreyknvl@gmail.com,soham.bagchi@utah.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kcov-load-acquire-coverage-count-in-user-space-code-v2.patch removed from -mm tree
Message-Id: <20250914001448.DA005C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov-load-acquire-coverage-count-in-user-space-code-v2
has been removed from the -mm tree.  Its filename was
     kcov-load-acquire-coverage-count-in-user-space-code-v2.patch

This patch was dropped because it was folded into kcov-load-acquire-coverage-count-in-user-space-code.patch

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


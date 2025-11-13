Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FD78405C
	for <mm-commits@vger.kernel.org>; Thu, 13 Nov 2025 22:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763072353; cv=none; b=J2H5Qi3aXOYte/a4ugoC1ya+jeIdqWyXVpAdri/5n5+Vp3I0EudYWnb0GDxm6xOlUYIgyxBacAUbVQ7Ijb9lmSJwj4v24lonuHjnok1ohbZOAaDWQSqr5NgoLR0YR6/gDgEuuFvWrvv3XU33/n2zX0hwEoiiFQlx18RP1AAtIts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763072353; c=relaxed/simple;
	bh=1/z+KlbIuCe0VnuoAvvaC8qA9HSuhlgmy9C0aX8GbZc=;
	h=Date:To:From:Subject:Message-Id; b=jvOx6mmOMHi8ltdUP0E+4K/iNOLl89yQGUagmH59p6Mbb4+TkOcM4Vx9XrMdLAl4P4dP1A9koV2SykgWvZWU+Sq0KJBlvxb7yb1yRgkNJcFvy1qiCXeiAUQZH+7wSnX/Nv05GaZcvAJVEqk9b3c1dmWqO4eFHf0ypvmVaCp9pHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Si6pWhvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Si6pWhvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D703DC4CEF5;
	Thu, 13 Nov 2025 22:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763072353;
	bh=1/z+KlbIuCe0VnuoAvvaC8qA9HSuhlgmy9C0aX8GbZc=;
	h=Date:To:From:Subject:From;
	b=Si6pWhvq4kprrE+rlstpY7EZHPF2X8tSECEWJxv1L3M3FyIe8A4DiChUSnJ7WjOcS
	 jzGkirNmclbAMqYRIG8m7xkuToY54fhYmX33KKIVoKM0juTEhv36fj696hdeVVeHqM
	 IFy+4HqkmcKJoZT6Q+Q0zMlTBm4nsj6pT3aoHcSY=
Date: Thu, 13 Nov 2025 14:19:12 -0800
To: mm-commits@vger.kernel.org,richard120310@gmail.com,mingo@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-lib-plistc-enforce-memory-ordering-in-plist_check_list.patch added to mm-nonmm-unstable branch
Message-Id: <20251113221912.D703DC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "lib/plist.c: enforce memory ordering in plist_check_list"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     revert-lib-plistc-enforce-memory-ordering-in-plist_check_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-lib-plistc-enforce-memory-ordering-in-plist_check_list.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: Revert "lib/plist.c: enforce memory ordering in plist_check_list"
Date: Thu, 13 Nov 2025 19:34:13 +0000

This reverts commit 7abcb84f953df037d40fad66f2109db318dd155b.

The introduction of WRITE_ONCE() calls for the 'prev' and 'next' variables
inside plist_check_list() was a misapplication.  WRITE_ONCE() is
fundamentally a compiler barrier designed to prevent compiler
optimizations (like caching or reordering) on shared memory locations. 
However, the variables 'prev' and 'next' are local, stack-allocated
pointers accessed only by the current thread's invocation of the function.

Since these pointers are thread-local and are never accessed concurrently,
applying WRITE_ONCE() to them is semantically incorrect and unnecessary. 
Furthermore, the use of WRITE_ONCE() on local variables prevents the
compiler from performing standard optimizations, such as keeping these
variables cached solely in CPU registers throughout the loop, potentially
introducing performance overhead.  Restore the conventional C assignment
for local loop variables, allowing the compiler to generate optimal code.

Link: https://lkml.kernel.org/r/20251113193413.499309-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: I Hsin Cheng <richard120310@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/plist.c~revert-lib-plistc-enforce-memory-ordering-in-plist_check_list
+++ a/lib/plist.c
@@ -47,8 +47,8 @@ static void plist_check_list(struct list
 
 	plist_check_prev_next(top, prev, next);
 	while (next != top) {
-		WRITE_ONCE(prev, next);
-		WRITE_ONCE(next, prev->next);
+		prev = next;
+		next = prev->next;
 		plist_check_prev_next(top, prev, next);
 	}
 }
_

Patches currently in -mm which might be from visitorckw@gmail.com are

revert-lib-plistc-enforce-memory-ordering-in-plist_check_list.patch


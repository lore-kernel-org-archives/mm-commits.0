Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0446344052
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305525; cv=none; b=ZmPDgcKeQ/hTZ0IcAFoG+goiMqeK4Vs61awhuI7g0wouXgJqnSDGRC5n+hMgz3r9ktglqSMQmG3TtjydpOrcrlI8fxrBiLQJhWY0Xk3dN1m7aH6vfh0+Eli8Jfh9KT34YGhVm45266zexZ2fcSsZumX/4EBsX5E38RZfsNARNUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305525; c=relaxed/simple;
	bh=ucOooo3YISoix1cN2nRF/RAEl9yoiqpmw15hAIpYFhg=;
	h=Date:To:From:Subject:Message-Id; b=YdCCZuDzyRw7OwgHCVgZ78wyht+nQWQJzeedv/UAnTcSJNb+pN1qtWYq05RD1RKxIgGLrhkAN9MszlmK44r81bI1i9Ux/XslNnz7Zg9CasXrZlFl0sCklX3EgT68lomvkmtzgyX28duMCYz2EWYSFMX5IAlaH+GC1fjlYDInluo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Orr8NjGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Orr8NjGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74221C19425;
	Mon, 27 Apr 2026 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777305525;
	bh=ucOooo3YISoix1cN2nRF/RAEl9yoiqpmw15hAIpYFhg=;
	h=Date:To:From:Subject:From;
	b=Orr8NjGhmz/lIqse7DBKfmDjUi+qIV/GAvm4+Ht2bR0whJ+BWpYgZXuc0PxJrh3uU
	 z+uIufjuX7Ml9syqSGWa8rXNFT3Zfwi5gDmlmFXVb6sq+FJr1+oyUfdETHNYdn3Pg5
	 7bVlAIWX0u+stdAZPn2PMCSQv3s5PYI8XFAhn468=
Date: Mon, 27 Apr 2026 08:58:44 -0700
To: mm-commits@vger.kernel.org,vmalik@redhat.com,rdunlap@infradead.org,peterz@infradead.org,mathieu.desnoyers@efficios.com,chleroy@kernel.org,arnd@arndb.de,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uaccess-minimize-inline_copy_user-related-ifdefery.patch added to mm-nonmm-unstable branch
Message-Id: <20260427155845.74221C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uaccess: minimize INLINE_COPY_USER-related ifdefery
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uaccess-minimize-inline_copy_user-related-ifdefery.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uaccess-minimize-inline_copy_user-related-ifdefery.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: uaccess: minimize INLINE_COPY_USER-related ifdefery
Date: Fri, 24 Apr 2026 22:08:57 -0400

Now that we've got the same config selecting inline vs outline
copy_to_user() and copy_from_user(), we can simplify the corresponding
logic in the uaccess.h.

Link: https://lore.kernel.org/20260425020857.356850-4-ynorov@nvidia.com
Fixes: 1f9a8286bc0c ("uaccess: always export _copy_[from|to]_user with CONFIG_RUST")
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/include/linux/uaccess.h~uaccess-minimize-inline_copy_user-related-ifdefery
+++ a/include/linux/uaccess.h
@@ -190,10 +190,6 @@ fail:
 	memset(to + (n - res), 0, res);
 	return res;
 }
-#ifndef INLINE_COPY_USER
-extern __must_check unsigned long
-_copy_from_user(void *, const void __user *, unsigned long);
-#endif
 
 static inline __must_check unsigned long
 _inline_copy_to_user(void __user *to, const void *from, unsigned long n)
@@ -207,7 +203,13 @@ _inline_copy_to_user(void __user *to, co
 	}
 	return n;
 }
-#ifndef INLINE_COPY_USER
+#ifdef INLINE_COPY_USER
+# define _copy_to_user _inline_copy_to_user
+# define _copy_from_user _inline_copy_from_user
+#else
+extern __must_check unsigned long
+_copy_from_user(void *, const void __user *, unsigned long);
+
 extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
 #endif
@@ -217,11 +219,7 @@ copy_from_user(void *to, const void __us
 {
 	if (!check_copy_size(to, n, false))
 		return n;
-#ifdef INLINE_COPY_USER
-	return _inline_copy_from_user(to, from, n);
-#else
 	return _copy_from_user(to, from, n);
-#endif
 }
 
 static __always_inline unsigned long __must_check
@@ -229,12 +227,7 @@ copy_to_user(void __user *to, const void
 {
 	if (!check_copy_size(from, n, true))
 		return n;
-
-#ifdef INLINE_COPY_USER
-	return _inline_copy_to_user(to, from, n);
-#else
 	return _copy_to_user(to, from, n);
-#endif
 }
 
 #ifndef copy_mc_to_kernel
_

Patches currently in -mm which might be from ynorov@nvidia.com are

rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch
uaccess-unify-inline-vs-outline-copy_fromto_user-selection.patch
uaccess-minimize-inline_copy_user-related-ifdefery.patch


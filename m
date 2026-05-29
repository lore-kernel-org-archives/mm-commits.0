Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F93E372661
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028760; cv=none; b=jz7RFEQl9pXQ4MqKBK4MFNDjT48Axp7ByHk0s50wo+LIMx+Nv3hEzmCuwsUBPUut9AoTPVgMx5jroYseVbsVDvhd/sNz+KHOOviHJGuapSSr4g7aicPNrp9yoryn1JbdvJ4r7IEqQM2UJcXWwrBv4+olicd5ICTM3B9ulf/KevM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028760; c=relaxed/simple;
	bh=iq8Ysn5BYHpreI1JW5N6E4on7RLaAaAdGynXO8wXAWM=;
	h=Date:To:From:Subject:Message-Id; b=B1V7N2p+35NlChhcg9qnQvBhIdU4M1qU0boGJot90MRVeewPKxqyvSTEBzwc3qz6FWBDQ/QC6LBS59vdjo6QJ6vaD0+YeclLwBYdFlIaI/odWrosw8Ozo5Jf6rxYJJi0JJBmDS7a5g0TmbUCMqr2cJXPwp9zjwyyXqFxDFmEMi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uf28Wg3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uf28Wg3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158091F00893;
	Fri, 29 May 2026 04:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028759;
	bh=akN1i7qp6X3PmXpQ7NbLdMS1vw44MvQ3Fk1dFJ3lQKM=;
	h=Date:To:From:Subject;
	b=uf28Wg3mit6fPxs36LtMisd6xed5ip5+W6w9m2PhGFkf8edlKcg/6y2o3kkJD40aD
	 B+zojMu6NTJlbGP2KgQfOsX72Bt+rrzekpX4JGlTzxeKy7mmkYUJqRAWthJtSm7/ui
	 ltnRM7nlTVb2A25B1ek7wPJiv9HCm4e7tukH6WRg=
Date: Thu, 28 May 2026 21:25:58 -0700
To: mm-commits@vger.kernel.org,vmalik@redhat.com,rdunlap@infradead.org,peterz@infradead.org,mathieu.desnoyers@efficios.com,chleroy@kernel.org,arnd@arndb.de,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] uaccess-minimize-inline_copy_user-related-ifdefery.patch removed from -mm tree
Message-Id: <20260529042559.158091F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uaccess: minimize INLINE_COPY_USER-related ifdefery
has been removed from the -mm tree.  Its filename was
     uaccess-minimize-inline_copy_user-related-ifdefery.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



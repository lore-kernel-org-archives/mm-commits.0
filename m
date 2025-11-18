Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C11FA859
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 22:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504534; cv=none; b=nAKerBgvsUbKU03SWeveZYqf1DqClduKCXAFc01KAM9E9tJmniZZZfzbIICgGhOdO6M+QcO875/QCGMbWVtk5fMbgA7r8j/OQUK9Wc7rqUNZ7/UPZo1nePvRy6E66DGU3f03Bc2C7h/XB31lH0HGC/DAl0QpZqVCMy0fhUllfjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504534; c=relaxed/simple;
	bh=/YQydsdIe0NtYBnzVYBkwFV5aCU11vzJwrEAJpRYMps=;
	h=Date:To:From:Subject:Message-Id; b=dc3+tUAl/qmoCqtDMmGA4kxKfjPt6A0koHD0MfZO4gLwN5/DQ8M5cz+RvZLmTgKGxFfYbUzfUHNQqkgNjRBsLmDfJF90s4pKXlbcdSE9MBCEjL4gJ8vOhqptofx7rwYHjpZUlgrrX7ZoHy4IHXyMs+Rl/pazqMLC2AzzoayCE+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ebss9+4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ebss9+4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13025C4CEFB;
	Tue, 18 Nov 2025 22:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763504533;
	bh=/YQydsdIe0NtYBnzVYBkwFV5aCU11vzJwrEAJpRYMps=;
	h=Date:To:From:Subject:From;
	b=ebss9+4ghGvqyrpdZ/kQHO2bGEEb3GBNz088nlHvpISJpUBFjg9FwNyxBa7ZPGXJM
	 ofwD/KoHB5gyjY9izm2CM9u7ybLZMYGBNd1YyROs3jKoum+Yq6bQi49UHvrAsIEjTA
	 UYiRCmuBKxWLsGoiu/bKA10RsdvNLz9m7CaJcQZM=
Date: Tue, 18 Nov 2025 14:22:11 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uaccess-gate-_copy__user-on-inline_copy_from_user.patch added to mm-nonmm-unstable branch
Message-Id: <20251118222213.13025C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uaccess: gate _copy_[to|from]_user on !INLINE_COPY_FROM_USER
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uaccess-gate-_copy__user-on-inline_copy_from_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uaccess-gate-_copy__user-on-inline_copy_from_user.patch

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
From: Alice Ryhl <aliceryhl@google.com>
Subject: uaccess: gate _copy_[to|from]_user on !INLINE_COPY_FROM_USER
Date: Tue, 18 Nov 2025 17:32:50 +0000

These methods only exist when INLINE_COPY_FROM_USER is disabled, so update
the header file to reflect that.

This fixes the following error on builds that enable both RUST and
INLINE_COPY_FROM_USER.

ERROR: modpost: "_copy_from_user" [samples/rust/rust_misc_device.ko] undefined!
ERROR: modpost: "_copy_to_user" [samples/rust/rust_misc_device.ko] undefined!

This error is triggered because when a method is available both as a
rust_helper_* and normal method, Rust will call the normal method.

Link: https://lkml.kernel.org/r/20251118173250.2821388-1-aliceryhl@google.com
Fixes: d99dc586ca7c ("uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/uaccess.h~uaccess-gate-_copy__user-on-inline_copy_from_user
+++ a/include/linux/uaccess.h
@@ -181,8 +181,10 @@ fail:
 	memset(to + (n - res), 0, res);
 	return res;
 }
+#ifndef INLINE_COPY_FROM_USER
 extern __must_check unsigned long
 _copy_from_user(void *, const void __user *, unsigned long);
+#endif
 
 static inline __must_check unsigned long
 _inline_copy_to_user(void __user *to, const void *from, unsigned long n)
@@ -196,8 +198,10 @@ _inline_copy_to_user(void __user *to, co
 	}
 	return n;
 }
+#ifndef INLINE_COPY_FROM_USER
 extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
+#endif
 
 static __always_inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long n)
_

Patches currently in -mm which might be from aliceryhl@google.com are

uaccess-gate-_copy__user-on-inline_copy_from_user.patch


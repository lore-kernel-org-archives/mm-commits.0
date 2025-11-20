Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6149A2FB96A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676298; cv=none; b=VmgE/RQyuYLBy+sdC+P7XrVMhWgZdZSMriwVMAQ64lyXaO5jFtizdGyrXP7aRYdeFJ3VbfhEF04RRo82KiXqRn+XFSOrXzqg6BLGYY+UuVvCftdFiy/PcRLMqCOMxn99GOO9hIDlnwvIFzqV9R4LSAOVAXZiIZaFoiuxlVbRLqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676298; c=relaxed/simple;
	bh=mAabK+g9HZcjLH9w3H8G3W2Wk0619+Yw/d8aetW4Nag=;
	h=Date:To:From:Subject:Message-Id; b=twjKkfaQxp4ZzMWUz8OzOa4TLWcNFLJM48C3pqNocB09UO9yynmUQZyiIhuK3n/00e1joMSnNvg31n3Q3cMLsDs79EmgSfEM6q8Pzm2EP568KWGU7KAZWGvQv+khJLSmgTiO4enIrA6eRJh12OBsR+CwW1fqOyMRVPdkfyGgEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LpK0VI6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LpK0VI6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F57C4CEF1;
	Thu, 20 Nov 2025 22:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676298;
	bh=mAabK+g9HZcjLH9w3H8G3W2Wk0619+Yw/d8aetW4Nag=;
	h=Date:To:From:Subject:From;
	b=LpK0VI6ssZNEyf20E8NLVgWVAMErJdsL9VOFHRwlsJHpdErOhq2Wu9sbPps8RapRP
	 f3STyOBPk763l/jbsi3KEcPOpNgTZiOj4ITT662B2arXqGdgD3hGbtcQQedyR2d3cq
	 QXd66TxV37duoMm+8vIOcgcPLuooV5LNe60PWyMY=
Date: Thu, 20 Nov 2025 14:04:57 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] uaccess-gate-_copy__user-on-inline_copy_from_user.patch removed from -mm tree
Message-Id: <20251120220458.34F57C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uaccess: gate _copy_[to|from]_user on !INLINE_COPY_FROM_USER
has been removed from the -mm tree.  Its filename was
     uaccess-gate-_copy__user-on-inline_copy_from_user.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: s/INLINE_COPY_FROM_USER/INLINE_COPY_TO_USER/, per Alice]
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
+#ifndef INLINE_COPY_TO_USER
 extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
+#endif
 
 static __always_inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long n)
_

Patches currently in -mm which might be from aliceryhl@google.com are



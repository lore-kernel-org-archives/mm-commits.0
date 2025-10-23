Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06011F0E3E
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249753; cv=none; b=OXC2ABbL5eEsobxaAFnDH1edHjGg+YE/v/6Q2kmue4GA7kbVjH1yHNyICKrI0GNjXBa/pN424suNsQkFkOIsob3RjMW28sdX7ISltfci3ZqB4e2JNivDbZCIVcywPsrjRDIvgAqpUQUDKpTuosM5k5s8/jDC9atHEfTAYsVtUlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249753; c=relaxed/simple;
	bh=8Ww8Yr6ZTdIGmRwJdoSgvvdqsuYMPfNtgmZ44u0q/0o=;
	h=Date:To:From:Subject:Message-Id; b=nhI26esHa/Mmuib0oDRpUJGvqPRLyjifbX9FCs6jLdkeh3mbbMpNs04N8VYt0RAYtudy8iMJ550+xLbqBwvlFitmNVs1a/fGc2sE5oL0DUXMizI7ghQCm3OQozd9ez0mE0Lwk+A2jzbKXFpKPaUzIRIsRXqFYkl/vb3swRMDiKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NJSVF3cU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJSVF3cU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57186C4CEE7;
	Thu, 23 Oct 2025 20:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761249752;
	bh=8Ww8Yr6ZTdIGmRwJdoSgvvdqsuYMPfNtgmZ44u0q/0o=;
	h=Date:To:From:Subject:From;
	b=NJSVF3cULZI/6lv7Et5AHKOEz+k3OKyqJHlqsCCXHgWO4beA9aLbDZTIb4pTkZyjr
	 AcdI/YRi109EUdc9hIUPHN0cicBXLQ+fN6VKqI2CkuV4mpvdrADH9lI9CY7DDYz3zF
	 gpFNAOPROjUOSw+m/r9QXoMvClcfc72aJEiIVwVQ=
Date: Thu, 23 Oct 2025 13:02:31 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uaccess-decouple-inline_copy_from_user-and-config_rust.patch added to mm-nonmm-unstable branch
Message-Id: <20251023200232.57186C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uaccess-decouple-inline_copy_from_user-and-config_rust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uaccess-decouple-inline_copy_from_user-and-config_rust.patch

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
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
Date: Thu, 23 Oct 2025 13:16:06 -0400

Commit 1f9a8286bc0c ("uaccess: always export _copy_[from|to]_user with
CONFIG_RUST") exports _copy_{from,to}_user() unconditionally, if RUST is
enabled.  This pollutes exported symbols namespace, and spreads RUST
ifdefery in core files.

It's better to declare a corresponding helper under the rust/helpers,
similarly to how non-underscored copy_{from,to}_user() is handled.

Link: https://lkml.kernel.org/r/20251023171607.1171534-1-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/usercopy.c         |    4 ++--
 rust/helpers/uaccess.c |   12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/lib/usercopy.c~uaccess-decouple-inline_copy_from_user-and-config_rust
+++ a/lib/usercopy.c
@@ -12,7 +12,7 @@
 
 /* out-of-line parts */
 
-#if !defined(INLINE_COPY_FROM_USER) || defined(CONFIG_RUST)
+#if !defined(INLINE_COPY_FROM_USER)
 unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	return _inline_copy_from_user(to, from, n);
@@ -20,7 +20,7 @@ unsigned long _copy_from_user(void *to,
 EXPORT_SYMBOL(_copy_from_user);
 #endif
 
-#if !defined(INLINE_COPY_TO_USER) || defined(CONFIG_RUST)
+#if !defined(INLINE_COPY_TO_USER)
 unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	return _inline_copy_to_user(to, from, n);
--- a/rust/helpers/uaccess.c~uaccess-decouple-inline_copy_from_user-and-config_rust
+++ a/rust/helpers/uaccess.c
@@ -13,3 +13,15 @@ unsigned long rust_helper_copy_to_user(v
 {
 	return copy_to_user(to, from, n);
 }
+
+#ifdef INLINE_COPY_FROM_USER
+unsigned long rust_helper__copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	return _inline_copy_from_user(to, from, n);
+}
+
+unsigned long rust_helper__copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	return _inline_copy_to_user(to, from, n);
+}
+#endif
_

Patches currently in -mm which might be from yury.norov@gmail.com are

uaccess-decouple-inline_copy_from_user-and-config_rust.patch


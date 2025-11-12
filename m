Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEFC14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908598; cv=none; b=EwC+W55ga9DHJuSpl6YE3PkUkEdehX7ZNjPV9fBmQtglIcHZDVkL5wgAdZFUzkwmTGaII13K1PTIaD+4MD8SxxDNuspHl1NE1HLrw1QuMZ8RGcqqy8t1HV/FP+9/Gwqz1BZrbOUet0z8Y7uRsrfEFxJi6UluH8igFNHxVw0UQKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908598; c=relaxed/simple;
	bh=OlYZ7SrAF0Q3TElPe7yl/MTLerfgJObioAl2r1upeCk=;
	h=Date:To:From:Subject:Message-Id; b=tZDBq0wq3mkWjDnbxlFIw5WLSvcPU2iPBJIDXbm11aBiVs3qHhRJs6Ui5kbj/7sDbngtINvO3fWwePMBqxDXMDj7YyfIHhm7r0yAb+Ze5aYa9vKunBSpRLOn5crnK19klEp1xMUy2nFc3feFO7WBKenkIJLRfRV8G/iqiYobb5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQcU9/Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQcU9/Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EE6C4CEFB;
	Wed, 12 Nov 2025 00:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908597;
	bh=OlYZ7SrAF0Q3TElPe7yl/MTLerfgJObioAl2r1upeCk=;
	h=Date:To:From:Subject:From;
	b=HQcU9/KwNl97s6r8Ez4gLFc/6yA60/sOzUAM1OdLvp1pvtgCL/OkTq2FJ0nNh4QQC
	 F6RPnqdWYGf3sRFGLKs0Myyer6NfjSoI3+L1EDOi6ujxtlgX5f5A4KBypdWRue/Kpr
	 LrAzLsvyDQVMSUlgI0KyZFSgQrLr3op+4T1JOVI4=
Date: Tue, 11 Nov 2025 16:49:56 -0800
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] uaccess-decouple-inline_copy_from_user-and-config_rust.patch removed from -mm tree
Message-Id: <20251112004957.C0EE6C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
has been removed from the -mm tree.  Its filename was
     uaccess-decouple-inline_copy_from_user-and-config_rust.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[yury.norov@gmail.com: drop rust part of comment for _copy_from_user(), per Alice]
  Link: https://lkml.kernel.org/r/20251024154754.99768-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20251023171607.1171534-1-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    2 --
 lib/usercopy.c          |    4 ++--
 rust/helpers/uaccess.c  |   12 ++++++++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/include/linux/uaccess.h~uaccess-decouple-inline_copy_from_user-and-config_rust
+++ a/include/linux/uaccess.h
@@ -152,8 +152,6 @@ __copy_to_user(void __user *to, const vo
  * directly in the normal copy_to/from_user(), the other ones go
  * through an extern _copy_to/from_user(), which expands the same code
  * here.
- *
- * Rust code always uses the extern definition.
  */
 static inline __must_check unsigned long
 _inline_copy_from_user(void *to, const void __user *from, unsigned long n)
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



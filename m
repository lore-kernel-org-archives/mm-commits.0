Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A564A33
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908357; cv=none; b=eeLUR5fuXd9FEfOjjjeJhNm5dGLC0HIbb4YYPaUmD2Xrw/Cn92C3MmeUxGaj4oMH+pevB15PLy/8kdGb4vVmxcaRLFpzMNv0Mz+wQGL0X1ISLWjZrrlkMXrdItSzzW3Rx+hHgGxZWi58p2VBmXMJVaJA59tWh8Bg4JBrjZED4xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908357; c=relaxed/simple;
	bh=EC4AWIlT5ujKdeibiiqEmxF9Cvl9W6Cc/57YmxTGVEg=;
	h=Date:To:From:Subject:Message-Id; b=tdlaTFUlHylayyu5UxbDL25kQDBSPGenyTzBcK2xOGP7TRqk4PjzDPJV6/sMe5WTcvBaEywW3yMSng53JYhyOM7fJnFKdLBjCXnkmdkcFCYxQNRcbCqmyg7zH+Vay16CyDgfmOprYskqvIz2Qha5c5H3mM0M4hq8aL2WT/9v1lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IryTHTO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IryTHTO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741BCC19424;
	Wed, 12 Nov 2025 00:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908356;
	bh=EC4AWIlT5ujKdeibiiqEmxF9Cvl9W6Cc/57YmxTGVEg=;
	h=Date:To:From:Subject:From;
	b=IryTHTO+0nM+z+3k+oPa/sxgCF54HEXuVIS6Z/flt6XlpqKhCC353YXBEgluRe+uU
	 hwWLwCDGoKrhnrSmEHzWJMi+BqwEG1SlqNYq9pjWojBPaC4u24wR+MV2sZ8MbbsDsg
	 9WmIZhX0nfNQijAp7OHtbbMAALHO/wE3Q+k5NDq8=
Date: Tue, 11 Nov 2025 16:45:55 -0800
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] uaccess-decouple-inline_copy_from_user-and-config_rust-v2.patch removed from -mm tree
Message-Id: <20251112004556.741BCC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
has been removed from the -mm tree.  Its filename was
     uaccess-decouple-inline_copy_from_user-and-config_rust-v2.patch

This patch was dropped because it was folded into uaccess-decouple-inline_copy_from_user-and-config_rust.patch

------------------------------------------------------
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
Date: Fri, 24 Oct 2025 11:47:53 -0400

drop rust part of comment for _copy_from_user(), per Alice

Link: https://lkml.kernel.org/r/20251024154754.99768-1-yury.norov@gmail.com
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
 1 file changed, 2 deletions(-)

--- a/include/linux/uaccess.h~uaccess-decouple-inline_copy_from_user-and-config_rust-v2
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
_

Patches currently in -mm which might be from yury.norov@gmail.com are

uaccess-decouple-inline_copy_from_user-and-config_rust.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4BA19E968
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761452111; cv=none; b=Bq6lduKXDizsgqhPlDtNFsliRGDZWLeF2iHKqQh7vC3UU9w41mkiSnqMS78gWwA1ZK36UHXVcFCYXzvHVHmPk8+ayBpusQ4ExLUI3qL8ilnkqoVfkZSTMCi6ild+DBz/QvYgUA3JXZ4pZZtqFR5uF8zTFrvhwnGMLuTQX0odVRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761452111; c=relaxed/simple;
	bh=hjK9cCUBrb/BO9ENAS6Kvm8H6cQcMrLogFv8MD5QkrQ=;
	h=Date:To:From:Subject:Message-Id; b=I+egzew2ACWa2kIaEZYHtTO62mvZWo1QfnIV9bPuCCz9u7vnquKF+5bGNfssx6A8jdmNYpQuOaCB60ZpM+N7GwMki3WmFTBsUb5TMPlUln5H1jlicvZ9Ix936mvEQfoSGlnL8mch3A22aVigBAM880BbJEpK9AO5UgN6+xFN+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YGTjoWkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YGTjoWkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04360C4CEE7;
	Sun, 26 Oct 2025 04:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761452111;
	bh=hjK9cCUBrb/BO9ENAS6Kvm8H6cQcMrLogFv8MD5QkrQ=;
	h=Date:To:From:Subject:From;
	b=YGTjoWkSWTJmfvcesS18+dOcMbiA/1ZZIuxr5G+VsvZ3Re/N+PCSUimaPR67sn9Bi
	 68B1m+OGAqpE3cd9xnWSgSZQiJl4Jg47bKTt8IWAiSpBN21xRWYyk3JSjjV2CCLTZI
	 CIkq9Bn8lkR1sXjAyBVC/Fm+MV4hH2ghgyqnO8Ik=
Date: Sat, 25 Oct 2025 21:15:10 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uaccess-decouple-inline_copy_from_user-and-config_rust-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20251026041511.04360C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uaccess-decouple-inline_copy_from_user-and-config_rust-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uaccess-decouple-inline_copy_from_user-and-config_rust-v2.patch

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
uaccess-decouple-inline_copy_from_user-and-config_rust-v2.patch


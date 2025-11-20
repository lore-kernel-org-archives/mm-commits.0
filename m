Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6F5182B7
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675630; cv=none; b=aHVv5X5UqDT0L0TFw/Wh4gisolYZWgCR6hVgnue5g67hXWEmsOCR3QEiqqVxMyu9NeE3b8LX8Vqgeu6ReL7rnLGdEyMyxjkoF9aMnLObrf4O/l4BHzxeLoZpox12IdQ68gdzLbSGv7aCTPUiAJbPpYfzN6giGuPAqRgVDZTlBK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675630; c=relaxed/simple;
	bh=TraM49d0PwspKnVDTZCHXPkiM3rTe4o/Dnsdgr8urng=;
	h=Date:To:From:Subject:Message-Id; b=R1hKBmeGYfN1l8elQ1z8vy4puR/a+kgY31rp2giih0/FuVKpbSxWWivQa0GLYbZBeZKM6ziIrVvo/IGHrmCosWNgm3zPGK16oK18A40v/4aDKOvlTW5wacLkXuladKKNzQP+nAXB/dg4i7127VPu7d/JEw97N54YJEw4sShmlQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+TGMwuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+TGMwuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC16BC4CEF1;
	Thu, 20 Nov 2025 21:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675629;
	bh=TraM49d0PwspKnVDTZCHXPkiM3rTe4o/Dnsdgr8urng=;
	h=Date:To:From:Subject:From;
	b=A+TGMwuh6zqxQCwsNhOenWdX392jERwIl4XurXwNA/0vLRd/6d6HuJtJIafFZQe7Z
	 HMk+kFx209xiP0Kk+A5ubmXIFygwav+r92nxS9PWy3Me/MB1sAlKVxU1AVqPH5xSau
	 EWtUjDkVCH0mCcL6TKqqSB6eCDniUb/6HKUfXL/s=
Date: Thu, 20 Nov 2025 13:53:49 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch removed from -mm tree
Message-Id: <20251120215349.CC16BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uaccess-gate-_copy__user-on-inline_copy_from_user-fix
has been removed from the -mm tree.  Its filename was
     uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

This patch was dropped because it was folded into uaccess-gate-_copy__user-on-inline_copy_from_user.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: uaccess-gate-_copy__user-on-inline_copy_from_user-fix
Date: Tue Nov 18 02:20:00 PM PST 2025

s/INLINE_COPY_FROM_USER/INLINE_COPY_TO_USER/, per Alice

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
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/uaccess.h~uaccess-gate-_copy__user-on-inline_copy_from_user-fix
+++ a/include/linux/uaccess.h
@@ -198,7 +198,7 @@ _inline_copy_to_user(void __user *to, co
 	}
 	return n;
 }
-#ifndef INLINE_COPY_FROM_USER
+#ifndef INLINE_COPY_TO_USER
 extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157241FA859
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 22:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504537; cv=none; b=i3z8O7iOcYhvY73ko81sXYVO8dgcRV8NzsEUi2GQgoZdO6O8xDR+SCQn5mXQ/OkjGOaLivBfJTRyV/NN8E/MNB2wPp7GFFNHp3/0tQTeRGpPSU0aorBujaLptE/NfV9EUapUACYzkd/bqdJmEmNndCUpuFtO/2lW7Q0knp7Fm/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504537; c=relaxed/simple;
	bh=UmubAxw8zF5y3JAUcOf3myMJjIHljLE5Vnulo8kWBDQ=;
	h=Date:To:From:Subject:Message-Id; b=tOu0tspXnTI6KgCbz5Ii7EuoKO6ZlEBgOuZFmjLr2I9buqfFx2M1+nv3ZnJCgAtQRW2oOJozq5aWA6M1Q9oU/ltHT7tQ0MLmz41P/hl75XtsyIVv57aigJcEw+9PEbAnIfpKyhuLbxjdrQWtYPMi60z+9W7Pt/DKgV+YCmoARE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YNKeGC9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YNKeGC9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F9DC4AF0B;
	Tue, 18 Nov 2025 22:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763504536;
	bh=UmubAxw8zF5y3JAUcOf3myMJjIHljLE5Vnulo8kWBDQ=;
	h=Date:To:From:Subject:From;
	b=YNKeGC9DlH/VNa+ifVGKfD604YSNh6HnEIo/bil5avDnwsF0iE+9YEDG4edQ2j/OO
	 A8S+Wr15ZM/CzVkW/dIpcAO0v2tQqoshfqwookX2Jc8WUrD+wDQf7+gIt600MX5I4Y
	 FpHHuJtzgrGjw+a7Ec5JMvDr3G4lfnezi1tSn/ik=
Date: Tue, 18 Nov 2025 14:22:14 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,tmgross@umich.edu,ojeda@kernel.org,jhubbard@nvidia.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,arnd@arndb.de,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251118222216.22F9DC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uaccess-gate-_copy__user-on-inline_copy_from_user-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

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

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch


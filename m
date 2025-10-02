Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A4E846F
	for <mm-commits@vger.kernel.org>; Thu,  2 Oct 2025 22:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759445022; cv=none; b=Cb6kqqcC9pGRVwEYg+/ms7c5fV6+x7abTE1Ew7FSESLqsKxN2dH0z9oiNL2IMLuKdcGTRgUIMNHsle8LTGd3SVG+QC3ilwc1SjOmrhVcn6EuRlD2lME/0KwMsi1nScKw8keTgYpMC64c+XzaC80VMXSI+LawnmoTJGQr1q4v08o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759445022; c=relaxed/simple;
	bh=BI3ADF2iybxPuFxfpzcLO1rhejksWtAzjkPlxqL8+TI=;
	h=Date:To:From:Subject:Message-Id; b=mxwgOz47QdDxS40dOP5xaGbWcndVeBngrGJEMh5S5wqSkhe4oLMikHHVQ6oxMervVBeW2qTxflb/TS6kwAnJBNJYrV9bB4OoDKATn/4eASjFtc97H2f0tZE/6yH2GfYFxjBMP95VsKNkm6W0ztt1qOWzTSfyYhw8ms/xTLkzt8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YIn8JJLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YIn8JJLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFDCC4CEF4;
	Thu,  2 Oct 2025 22:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759445022;
	bh=BI3ADF2iybxPuFxfpzcLO1rhejksWtAzjkPlxqL8+TI=;
	h=Date:To:From:Subject:From;
	b=YIn8JJLWLyfQacrlABgx2ynOuiVaIH/kMqx8Z23rqEwRSMaXBZaHGKbMjw/kUosGJ
	 qCwrKL0r9/WepALiGolQk/8kMXa9y0LIZP6a+1CfdOmObG0brbP2xbSN4fr50Q8YzE
	 H8FqZOKdAB3zzgOsr1c4JlFZTEeSgNeQsT40nywg=
Date: Thu, 02 Oct 2025 15:43:41 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,sj@kernel.org,peterx@redhat.com,miguel.ojeda.sandonis@gmail.com,lkp@intel.com,david@redhat.com,chengming.zhou@linux.dev,axelrasmussen@google.com,aliceryhl@google.com,acsjakub@amazon.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20251002224342.2CFDCC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
Date: Thu Oct  2 03:37:47 PM PDT 2025

Rust bindgen wasn't able to handle the BIT() macro.  Add a helper (from
Miguel) to fix this.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@intel.com/
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jakub Acs <acsjakub@amazon.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/bindings/bindings_helper.h |    1 +
 1 file changed, 1 insertion(+)

--- a/rust/bindings/bindings_helper.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
+++ a/rust/bindings/bindings_helper.h
@@ -99,3 +99,4 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRE
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
+const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch


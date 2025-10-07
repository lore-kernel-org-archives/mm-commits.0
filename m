Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C4B225762
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 20:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870721; cv=none; b=ouABnbS0iycPUTDNKMGXkHg+G6CwfaSO8+G5LT6pOvNxhEJjdaxNLn2i0HlD2Ps9v/N1WSR2haIICiD2NrXGI9QHS6j0A8pwgE/00uVjw62/NdgmwmZTzxyktrpi2QqovoIw01Dz/o77bM31SbLf7mOmxdtMdS10tAousESafpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870721; c=relaxed/simple;
	bh=8vfJdlTDlJhUwiiGYEYCOyraQ01EGQCszPGcvrho9L8=;
	h=Date:To:From:Subject:Message-Id; b=QQ8gSNaooHmAntiUWBrP+X2U8XTpKPNHmo5L2RXzKYTLcXUSv5xQItHLAXw6DRspUaVVQlJ3BhRFtuO+Gxvt/Ir4WnL90OCMJikSZod2HIziIe+r1OQzttysvC8oj0V7L5dXN7T/foqARTaJbb+NuBwqtqRflGtE1x/TjWVg+PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cfAQc7O8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cfAQc7O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F1FC4CEF1;
	Tue,  7 Oct 2025 20:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870720;
	bh=8vfJdlTDlJhUwiiGYEYCOyraQ01EGQCszPGcvrho9L8=;
	h=Date:To:From:Subject:From;
	b=cfAQc7O8khMIwX8KcX5vgAsHNjP5MI1TnXAkAOUtrMgdQ7S8upC9Kyvo95t8hh3av
	 iPohxJltKvwlIIK0TVHtm0z2+F64TvEiRFVcyzOb+c054HOX0JCo0dWGsMBUKWsQBr
	 j4GeqwQ7+DPw0MZ8NNAhwamxvaA4kgWpTVsQGv6c=
Date: Tue, 07 Oct 2025 13:58:39 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,sj@kernel.org,peterx@redhat.com,miguel.ojeda.sandonis@gmail.com,lkp@intel.com,david@redhat.com,chengming.zhou@linux.dev,axelrasmussen@google.com,aliceryhl@google.com,acsjakub@amazon.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix.patch removed from -mm tree
Message-Id: <20251007205840.68F1FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix.patch

This patch was dropped because it was folded into mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
Date: Thu Oct  2 03:37:47 PM PDT 2025

Rust bindgen wasn't able to handle the BIT() macro.  Add a helper (from
Miguel) to fix this.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@intel.com/
Tested-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jakub Acs <acsjakub@amazon.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/bindings/bindings_helper.h |    1 +
 1 file changed, 1 insertion(+)

--- a/rust/bindings/bindings_helper.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
+++ a/rust/bindings/bindings_helper.h
@@ -108,6 +108,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRE
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
+const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 
 #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)
 #include "../../drivers/android/binder/rust_binder.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4597512B94
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 01:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749432277; cv=none; b=sj1PXEmXBfSzTPfFRQ4sALkGDM3pgp59FxU0LFbrbjVm1TPmM/+NQQM/itNUpx5vIPRqqUCNLQiF4E7KUYSKmqOKudV81G1KFv0XHKbmqEEYU4GO5UrtRTbo4I+Ls3DdLyAckzmXANFivRabkVR6XxqYVMdnECWLKq6xAR27N4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749432277; c=relaxed/simple;
	bh=F6/3pNZgJmTrSXR8HGDc5U9TfJypSnfWjJz6EyERsaE=;
	h=Date:To:From:Subject:Message-Id; b=qIUNdj6jlCVfLBOmax/ks0LTfcrUEemwVcs3nopvDNVqQYxBkIAMAH+RajxzxxW9J54s6OCOEF1/7+hvnIUZO+JoBB54fum+R3g127jdmnBGAWtpm8SgOxvLOCgyR5AH+cqCIybY0LItu/Ocwhg0nQs6lvYFT5JKmzeWefi4Sis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K7z38Erp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K7z38Erp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5732C4CEEE;
	Mon,  9 Jun 2025 01:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749432276;
	bh=F6/3pNZgJmTrSXR8HGDc5U9TfJypSnfWjJz6EyERsaE=;
	h=Date:To:From:Subject:From;
	b=K7z38ErpolGkfqBa/W+EdEAwiiY0tXJZqaIGCSUyR2O2cWfxhNH0Ny9ErTSBd4Wz3
	 oSy2Xz//hwYQZ8Mj0hT9t91M82szQrOAIGFhQU1mywv/MC9VpR+Uwtb+jE/Kq2m3NW
	 NG4w+fj2NmlSVXqA0ZCAThcWjlQCfwLC3/pl+WqE=
Date: Sun, 08 Jun 2025 18:24:36 -0700
To: mm-commits@vger.kernel.org,ojeda@kernel.org,kees@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch removed from -mm tree
Message-Id: <20250609012436.B5732C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler_types: remove unnecessary indirection in compiletime_assert()
has been removed from the -mm tree.  Its filename was
     compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: compiler_types: remove unnecessary indirection in compiletime_assert()
Date: Sat, 07 Jun 2025 03:23:55 -0400

compiletime_assert() is the only user of _compiletime_assert(), which uses
__compiletime_assert() directly with no modification to arguments.  Remove
_compiletime_assert() and use __compiletime_assert() directly.

Link: https://lkml.kernel.org/r/20250607-compiletime_assert-v1-1-a8991a9be729@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Kees Cook <kees@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/compiler_types.h~compiler_types-remove-unnecessary-indirection-in-compiletime_assert
+++ a/include/linux/compiler_types.h
@@ -552,9 +552,6 @@ struct ftrace_likely_data {
 # define __compiletime_assert(condition, msg, prefix, suffix) ((void)(condition))
 #endif
 
-#define _compiletime_assert(condition, msg, prefix, suffix) \
-	__compiletime_assert(condition, msg, prefix, suffix)
-
 /**
  * compiletime_assert - break build and emit msg if condition is false
  * @condition: a compile-time constant condition to check
@@ -565,7 +562,7 @@ struct ftrace_likely_data {
  * compiler has support to do so.
  */
 #define compiletime_assert(condition, msg) \
-	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
+	__compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
 
 #define compiletime_assert_atomic_type(t)				\
 	compiletime_assert(__native_word(t),				\
_

Patches currently in -mm which might be from tz2294@columbia.edu are

userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch
userfaultfd-remove-vm_bug_ons.patch
userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch
userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch


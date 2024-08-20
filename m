Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C28B36B0D
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724131733; cv=none; b=WV5jdkK967A8N5Upv8rnOQUdP4vBlTTIMCaKFXbZwFV4/Ub+aIBtI0YzTAAE0d7KaCmAAOs7bjRTQ6C5WQTUFX2aI4czbopCtJXpDvVrLPbxaEQiIAN/PFQ7yBuFfq3JQHpY1tNZ7G4zoCWzV7Ii8MYDn9vU26N+cfZ5WCB5uQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724131733; c=relaxed/simple;
	bh=CoL1tK86vUtDfXQ1qTJoRcR0Qi149XsOpoy+fl5R91s=;
	h=Date:To:From:Subject:Message-Id; b=U00DEC7ye+WaekFq99YYtZh9XhUDTiAcU8tFrbFzXjf+loTDvpRBrXdpcD/sqe6TZp63hl3EGndpXxes7KMd3z7EWr53BNTL7Jvpvvwd5hPMMy5rLmRLPQ3AprYVwAtOtK+04av2MOhk+cC9D7fgBlPkomht1QKT9rQbLNUTqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=va/Qgqvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="va/Qgqvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB380C4AF0B;
	Tue, 20 Aug 2024 05:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724131732;
	bh=CoL1tK86vUtDfXQ1qTJoRcR0Qi149XsOpoy+fl5R91s=;
	h=Date:To:From:Subject:From;
	b=va/QgqvzUOP9BYW0xnmltIogG6BrsUCr1sTrWRZNVDFVuLLAwKDv/LmP9CdoUIus8
	 gA9jU0AOTkcuHR8IZ5BafAXZfKuYf/uzVsU1vSzkRfU3Y/oOxLnsru/BMVAjaZD3Br
	 s1oyu8Dhz6ugNo93tMGRUHQq7f/TztT32Ct2f/k8=
Date: Mon, 19 Aug 2024 22:28:52 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20240820052852.CB380C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: err.h: add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: err.h: add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
Date: Sun, 18 Aug 2024 23:01:51 +0200

Add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros that operate
on pointers in the percpu address space.

These macros remove the need for (__force void *) function argument casts
(to avoid sparse -Wcast-from-as warnings).

The patch will also avoid future build errors due to pointer address space
mismatch with enabled strict percpu address space checks.

Link: https://lkml.kernel.org/r/20240818210235.33481-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/err.h~errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros
+++ a/include/linux/err.h
@@ -41,6 +41,9 @@ static inline void * __must_check ERR_PT
 	return (void *) error;
 }
 
+/* Return the pointer in the percpu address space. */
+#define ERR_PTR_PCPU(error) ((void __percpu *)(unsigned long)ERR_PTR(error))
+
 /**
  * PTR_ERR - Extract the error code from an error pointer.
  * @ptr: An error pointer.
@@ -51,6 +54,9 @@ static inline long __must_check PTR_ERR(
 	return (long) ptr;
 }
 
+/* Read an error pointer from the percpu address space. */
+#define PTR_ERR_PCPU(ptr) (PTR_ERR((const void *)(__force const unsigned long)(ptr)))
+
 /**
  * IS_ERR - Detect an error pointer.
  * @ptr: The pointer to check.
@@ -61,6 +67,9 @@ static inline bool __must_check IS_ERR(_
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+/* Read an error pointer from the percpu address space. */
+#define IS_ERR_PCPU(ptr) (IS_ERR((const void *)(__force const unsigned long)(ptr)))
+
 /**
  * IS_ERR_OR_NULL - Detect an error pointer or a null pointer.
  * @ptr: The pointer to check.
_

Patches currently in -mm which might be from ubizjak@gmail.com are

mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch
lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch
errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch


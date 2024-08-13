Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CAB37E
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723572397; cv=none; b=nFZTqI+j3CnKnmPtkSg5xR4H9iSy9EL9WQmuInpwUIECVHawoaMqMF0VLvWYesnrdDJOqo4ZPPpKfIdwbGLaGlEE/0IHUqnHW7BoaEjg0ArOmB4kIjj7b769IlIjuUAheaKPMe2Rk5pKNaJlq0CAHZXSVkJ2tBP5lMiul9JgOVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723572397; c=relaxed/simple;
	bh=Vq/xI76+MZ02xFXYm73mLzEZQTYaFx7d+fJLVwbhyQI=;
	h=Date:To:From:Subject:Message-Id; b=YNX4VpF8TYLCiiOLZoiIUYarEmKkOwxXoQxLXX7Rv3WbCwWM9m5JffPadYipeDTZOytIHOPz2tN14HBaRN48toipOIfqQw00ftpK/ZxN1qfEE67ZyPW71RFDYR7Bu4cCHH/oJ+bcygTAXhbZ16+TG7nbYwWM2ZM/0089Xv8YxNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CkDFXWEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CkDFXWEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B58C32782;
	Tue, 13 Aug 2024 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723572397;
	bh=Vq/xI76+MZ02xFXYm73mLzEZQTYaFx7d+fJLVwbhyQI=;
	h=Date:To:From:Subject:From;
	b=CkDFXWECHRcDLFhsF/npTQPWdYf0Jt19k22CeYaLVeFP41BwPQEHjzuILai71QLCk
	 od/5NpwVm/Q2MZJcKg/mHKP2pEK+nU5eMQfeS5cUo3mhouVsnLCdC8R/uUjjRJfl8B
	 Iix+kJJHE6PPJMgy8/jR6JzHERXmUNUW788tGrPI=
Date: Tue, 13 Aug 2024 11:06:36 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions.patch added to mm-unstable branch
Message-Id: <20240813180636.E9B58C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: err.h: add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() functions
has been added to the -mm mm-unstable branch.  Its filename is
     errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions.patch

This patch will later appear in the mm-unstable branch at
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
Subject: err.h: add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() functions
Date: Tue, 13 Aug 2024 19:25:10 +0200

Add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() functions that
operate on pointers in the percpu address space.

These functions remove the need for (__force void *) function argument
casts (to avoid sparse -Wcast-from-as warnings).

The patch will also avoid future build errors due to pointer address space
mismatch with enabled strict percpu address space checks.

Link: https://lkml.kernel.org/r/20240813172543.38411-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/include/linux/err.h~errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions
+++ a/include/linux/err.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 
 #include <asm/errno.h>
+#include <asm/percpu.h>
 
 /*
  * Kernel pointers have redundant information, so we can use a
@@ -42,6 +43,22 @@ static inline void * __must_check ERR_PT
 }
 
 /**
+ * ERR_PTR_PCPU - Create an error pointer in the percpu address space.
+ * @error: A negative error code.
+ *
+ * Encodes @error into a pointer value in the percpu address space.
+ * Users should consider the result opaque and not assume anything
+ * about how the error is encoded.
+ *
+ * Return: A pointer in the percpu address space with @error encoded
+ *	   within its value.
+ */
+static inline void __percpu * __must_check ERR_PTR_PCPU(long error)
+{
+	return (void __percpu *) error;
+}
+
+/**
  * PTR_ERR - Extract the error code from an error pointer.
  * @ptr: An error pointer.
  * Return: The error code within @ptr.
@@ -52,6 +69,17 @@ static inline long __must_check PTR_ERR(
 }
 
 /**
+ * PTR_ERR_PCPU - Extract the error code from an error pointer in the
+ *		  percpu address space.
+ * @ptr: An error pointer in the percpu address space.
+ * Return: The error code within @ptr.
+ */
+static inline long __must_check PTR_ERR_PCPU(const void __percpu *ptr)
+{
+	return (__force long) ptr;
+}
+
+/**
  * IS_ERR - Detect an error pointer.
  * @ptr: The pointer to check.
  * Return: true if @ptr is an error pointer, false otherwise.
@@ -62,6 +90,16 @@ static inline bool __must_check IS_ERR(_
 }
 
 /**
+ * IS_ERR_PCPU - Detect an error pointer in the percpu address space.
+ * @ptr: The pointer in the percpu address space to check.
+ * Return: true if @ptr is an error pointer, false otherwise.
+ */
+static inline bool __must_check IS_ERR_PCPU(const void __percpu *ptr)
+{
+	return IS_ERR_VALUE((__force unsigned long)ptr);
+}
+
+/**
  * IS_ERR_OR_NULL - Detect an error pointer or a null pointer.
  * @ptr: The pointer to check.
  *
_

Patches currently in -mm which might be from ubizjak@gmail.com are

mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch
errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch


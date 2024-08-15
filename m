Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C43B644
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723680172; cv=none; b=u9zw7+hAKyOLdQAx6hKfMhkxF4e28qNRF6h/8ALTvqz6mNoD8BER+ImvjV/V+DLQHBdAMac7yc2b5n1tPjwHO2lL2NFxw/SDreNRX3OWVN+jTWEo1KtTY9RMH06glDGlbAzXa1/TfvIvg/IcKD3SW4rZ4hCwwrLb4oxeEI0RJ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723680172; c=relaxed/simple;
	bh=hdL51+D73ler8k/xhuAneCI7D4H1+ciLmD/gMfbzAbc=;
	h=Date:To:From:Subject:Message-Id; b=hmhfM7S3+XI8CLHQyGaLl1viAk5czFf3u+B86WxfhPxFnDfmU/9iLSzlgfjIwrEzDT5rxCPESzPpk5wR+7/D9wdXEA3jnhGCzmRgv9KW+183GVeoSYYzqE2S0FNuFm2ecDhpi6EiC2WE8cD2GgdduGW9hEHmeTF+01Ia7VQMdJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QOekK6PV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QOekK6PV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20B5C116B1;
	Thu, 15 Aug 2024 00:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723680172;
	bh=hdL51+D73ler8k/xhuAneCI7D4H1+ciLmD/gMfbzAbc=;
	h=Date:To:From:Subject:From;
	b=QOekK6PVUxRrk+TMhErrkhOjt/CS8szZw9gfaCUBiuWKPfuobYSvqu5VaG+3PhqHK
	 CMKBs/v3W+9WNWnIUmaftGlNum4yfgd8nzKvDGf5xI40k1d5EvlBlyovXQjVXXOi6w
	 Xfmn62QGq+Uf1Y4Zfu/tx7fc3TaDhE9VLNreLD1I=
Date: Wed, 14 Aug 2024 17:02:51 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions.patch removed from -mm tree
Message-Id: <20240815000251.E20B5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: err.h: add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() functions
has been removed from the -mm tree.  Its filename was
     errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions.patch

This patch was dropped because an updated version will be issued

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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch
lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch


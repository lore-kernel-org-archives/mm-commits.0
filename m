Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516667406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423496; cv=none; b=gjkAXBAuvqa51VnLZ7w8+JJViX2x0dNd0sL8d27bs6cttPjJ+b4xkAnLSacanhY/Kfkpy79J0rX4fR9uwCwZ6kgyGoyBnnhZlvogI97HRWzJlKcD1M/hlAA223sNUhxIt+2a4h8WjnHqsQ01Nwb/K4pKNImz/0Fh0xdgVib1skI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423496; c=relaxed/simple;
	bh=K7u1FqbPcJewoyHtPBzNXArFAy1uvTWvArL38+5jmOQ=;
	h=Date:To:From:Subject:Message-Id; b=FjEDMAThrmS5YZxtrCL39iAkiFsiz0LsjoWWYgSJxBM4wOKSyzlF84v+2T70wD4XssXOUyphyMuQJyfOwwsVNHiw0w8gZkRwZ3PFM8QjFpLlM6iMWaEJd1V7qlc2MYGJiuCz7FXoRmRj9TSjzu3Ssq25IpjbtM5q5L1dscu5ac8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kApy2dlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kApy2dlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E7AC4CEC3;
	Wed,  4 Sep 2024 04:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423496;
	bh=K7u1FqbPcJewoyHtPBzNXArFAy1uvTWvArL38+5jmOQ=;
	h=Date:To:From:Subject:From;
	b=kApy2dluxjh2dOihYn3Z7AKilACJcLMcN3qzbyOm1irrrZXzYH1+QW86twxjkagA7
	 nBLRMAw3GjNSrcFvqvvF8eq5F19Gv9xE98MJ/uO/uY2KiKM9vATIAdX4VkzAUr0EjX
	 K3mn1R4mgP5BD2Ex08ZzayhgyFbpNPt5sA+QZinA=
Date: Tue, 03 Sep 2024 21:18:15 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch removed from -mm tree
Message-Id: <20240904041816.25E7AC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: err.h: add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
has been removed from the -mm tree.  Its filename was
     errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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

squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch


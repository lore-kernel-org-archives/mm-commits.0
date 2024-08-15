Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E867D625
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 00:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723680174; cv=none; b=at53xPxkDtHKOOAHy5CZauCCRqZ3nTYhbeOXx+aILO/dgdK9PHgUKDh31u5iufpDRpiI+PYzs9aTyfOI6bRZlbKtWUQmNkFEuBg3QTBgxO3uTFUUk0KYJNwwDqEVKN9TmMJRfr9efzLll4zX3nCrTHRFgFdqD2KN4b339j6fMq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723680174; c=relaxed/simple;
	bh=sho+qQNMqUbXgAdVSz4kh5B5WxyDgEs4P0h7KGqV9eU=;
	h=Date:To:From:Subject:Message-Id; b=DlC50RtIQmmSUoyC/N3u1NB7QPAWJ29M0oTHIXfo+EdcKI1yVCOya4i5OVIa72T8QrWi2FN1Cc2pq6W8Ve2UF88O4mV1ybnLR97U1DbogEkWjeEbz2AX4T0tImS/0en+6yPUixIw/UEbRRnsNbklGYoeLGX5f4CRDoXj8N7aMRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tMYdyqOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tMYdyqOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4098AC116B1;
	Thu, 15 Aug 2024 00:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723680173;
	bh=sho+qQNMqUbXgAdVSz4kh5B5WxyDgEs4P0h7KGqV9eU=;
	h=Date:To:From:Subject:From;
	b=tMYdyqORsNvkdbu0P088FckWUikEseYxjs1hoGJyorywm8CfxTWvzMUVx5XMu1Qam
	 UjFoj2zyyqZjUYjVLtKLVJSH0TC0zB2lRbM+YIJ9gdubWIYzY6aEcs+inYCKINZ6zG
	 XWLE/Mu/dcIZCJK7XdWcmS0s9dmbHLl/AA4uXuSM=
Date: Wed, 14 Aug 2024 17:02:52 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch removed from -mm tree
Message-Id: <20240815000253.4098AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space
Date: Tue, 13 Aug 2024 19:25:11 +0200

Use IS_ERR_PCPU() instead of IS_ERR() for pointers in the percpu address
space.  The patch also fixes following sparse warnings:

kmemleak.c:1063:39: warning: cast removes address space '__percpu' of expression
kmemleak.c:1138:37: warning: cast removes address space '__percpu' of expression

Link: https://lkml.kernel.org/r/20240813172543.38411-2-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space
+++ a/mm/kmemleak.c
@@ -1070,8 +1070,8 @@ void __ref kmemleak_alloc_percpu(const v
 {
 	pr_debug("%s(0x%px, %zu)\n", __func__, ptr, size);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
-		create_object_percpu((unsigned long)ptr, size, 1, gfp);
+	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
+		create_object_percpu((__force unsigned long)ptr, size, 1, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
 
@@ -1145,8 +1145,8 @@ void __ref kmemleak_free_percpu(const vo
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
-		delete_object_full((unsigned long)ptr, OBJECT_PERCPU);
+	if (kmemleak_free_enabled && ptr && !IS_ERR_PCPU(ptr))
+		delete_object_full((__force unsigned long)ptr, OBJECT_PERCPU);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_percpu);
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch
lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch


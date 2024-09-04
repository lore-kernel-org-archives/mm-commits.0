Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAAA7406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423497; cv=none; b=lhyQNQX6PxW9xbcrLSg3QjcORzDZj15hlpu+/dh6M7vpvFKUiq5i2sIUekVhaETUWmshD2Ldp66cRLDJftmKi5OdCyq4hMJTmpgMAUDRjCGps3MGz/e1QjtK2pwyMDttvdRa+ozbY0snBWk9C8Q2K+baoo5qGJZ9yFO1mdt8UBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423497; c=relaxed/simple;
	bh=l43nYyol9fgoOcD4Aa/Ue5yapSz/38NfkXfJdlEz4nk=;
	h=Date:To:From:Subject:Message-Id; b=JXlGD0U4lXUVYxyi6G0bHexsZmcYNX4AOsOOuP2GnExmZWfLJtAAJWokUAWxZG/qiQx6VFD2sd246mmNxhuWnLv/+CrYvT1Yx5rLDNNqHh8cf638CXO/a1X31+4bIlhiw5O46ZiLKUx/JNeT+LYN8EAHJ7UNcxqblBFEt9tRcfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lOq/hKR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lOq/hKR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BDDC4CEC2;
	Wed,  4 Sep 2024 04:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423497;
	bh=l43nYyol9fgoOcD4Aa/Ue5yapSz/38NfkXfJdlEz4nk=;
	h=Date:To:From:Subject:From;
	b=lOq/hKR0reAWzrqmh5VvY/Hs4VM5ea5G18Dll9WoHj2dZnjpygKT9N33Xy5Vtldzo
	 VqDtdfTnlo9+e2AIu2DMb1dDdu4AKI6DMs8Q1XUM3LjW0UhUvEeKK6Nt0JpaueldiJ
	 bPrHxi/Bac/YPR/upJC1pBV8zGeKbxK77J/imhnc=
Date: Tue, 03 Sep 2024 21:18:16 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch removed from -mm tree
Message-Id: <20240904041817.34BDDC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space
Date: Sun, 18 Aug 2024 23:01:52 +0200

Use IS_ERR_PCPU() instead of IS_ERR() for pointers in the percpu address
space.  The patch also fixes following sparse warnings:

kmemleak.c:1063:39: warning: cast removes address space '__percpu' of expression
kmemleak.c:1138:37: warning: cast removes address space '__percpu' of expression

Link: https://lkml.kernel.org/r/20240818210235.33481-2-ubizjak@gmail.com
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
+		create_object_percpu((__force unsigned long)ptr, size, 0, gfp);
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

squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch


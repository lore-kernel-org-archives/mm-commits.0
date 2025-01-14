Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D301DFDE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836284; cv=none; b=JdGclf4TOPOXLYrHJ305ljslR8P7LjnyBBBMdOKIfZkyQhQZopvYwohYf/jG7Jspb0GCdRqMMNBff1tBNOChHTjBLS+NMy+lJMq81p+iXnA7Rn/CQDu8jfsKxQeETpcLpv1H0bBs5pdYfS4yMMRC4snvSACcIWg45H8R3gVvUB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836284; c=relaxed/simple;
	bh=R22QZMVRkRZh/KYmZvmIkppwwAgAHXxM2yI+jj0uG58=;
	h=Date:To:From:Subject:Message-Id; b=nwu2hot38pgkC06cBEjVy1RmkneZjqtvgz9kvlFnIxiHUix5TvUtax2nzQFKmLGW34kLCiM5la+KJ4wVHv+cu+S0AxTcFjsJOaSrqde6+qW8ojIuzatCI1p+GJt22H+PxiN1B8cQcSuKZ263gi4aGXLeDkTlBTLm7ClBMJaV+Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vNs+RAon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vNs+RAon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6051C4CEDD;
	Tue, 14 Jan 2025 06:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836283;
	bh=R22QZMVRkRZh/KYmZvmIkppwwAgAHXxM2yI+jj0uG58=;
	h=Date:To:From:Subject:From;
	b=vNs+RAonJ5bunnI3BXLXMzTsLj1+3YG8gkyKT3CLR1/220uCt9IQRPQqXIirYbEpr
	 9CiyKbB29aRrY0zlLhN1G66gjW6PFjAGa8ZCWJZsOBK1CSxDWvvXhwxJyC/HurL8fJ
	 WrXSEiAlS28lH1kxF4a21q1L5TqOjthrD42vOcps=
Date: Mon, 13 Jan 2025 22:31:23 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,alexjlzheng@tencent.com,alexjlzheng@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch removed from -mm tree
Message-Id: <20250114063123.C6051C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch

This patch was dropped because it was folded into mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix
Date: Fri Dec 13 04:35:29 PM PST 2024

s/mmap_Lock/mmap_lock/, per Liam

Cc: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix
+++ a/mm/memory.c
@@ -6141,7 +6141,7 @@ static vm_fault_t sanitize_fault_flags(s
 
 /*
  * By the time we get here, we already hold either the VMA lock or the
- * mmap_Lock (FAULT_FLAG_VMA_LOCK tells you which).
+ * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
  *
  * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch


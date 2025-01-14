Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A25243348
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837081; cv=none; b=Kch6t7f5qDP99V8s1AHiGsQcQif7HzOv82orFvQk+FQKjY7itVb9qbtC1+QlKPzsNm0JQKAMTdm7gBCn6yJ4BxxOasSCLLzOP0JQyWBpA306GdexMKmhXxxLZnUkyxADtZcIOt5fhnp0swJ6u3y3sAbjMtBIj7gUSaJnXk61edM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837081; c=relaxed/simple;
	bh=joihCsW24QRwStAgGtc3X52l1orfawVYBXmsvuFGLDs=;
	h=Date:To:From:Subject:Message-Id; b=ZOv7AQLup3CTxVIimAcO0kr/UD4RuczyqP2Xu+vprV4K3GgNsmHsdjJ54u/c5Du1NqVxsQMmRFDt6WLSaPpSKrxkhpEiCdatlM86Gsinn1gd3Gn3Us23EWxZcmHRd8lkVnp8Kuoc7A0EGNhMZ3N4oGuguDxLuto91S9fS3U9P90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J7rAWCdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J7rAWCdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F71C4CEE4;
	Tue, 14 Jan 2025 06:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837081;
	bh=joihCsW24QRwStAgGtc3X52l1orfawVYBXmsvuFGLDs=;
	h=Date:To:From:Subject:From;
	b=J7rAWCdPkvS3xto6jtnbQMaOOKvewTgKF6ITDXAMADz9JhPzjMta1Hdsmqh9T4gmP
	 VFgf8YXhHlLCQxi6kYmeHWFK0kx4l5tcJ1vtVYJhg6QwI12La/Ti7Z5i0bxQ06T/dw
	 8YMmXvQovSSriV4w9iYTmDc10elNAPkpdVgqk1yI=
Date: Mon, 13 Jan 2025 22:44:40 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,alexjlzheng@tencent.com,alexjlzheng@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch removed from -mm tree
Message-Id: <20250114064441.05F71C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix outdated incorrect code comments for handle_mm_fault()
has been removed from the -mm tree.  Its filename was
     mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinliang Zheng <alexjlzheng@gmail.com>
Subject: mm: fix outdated incorrect code comments for handle_mm_fault()
Date: Fri, 13 Dec 2024 11:18:20 +0800

[akpm@linux-foundation.org: s/mmap_Lock/mmap_lock/, per Liam]
Link: https://lkml.kernel.org/r/20241213031820.778342-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault
+++ a/mm/memory.c
@@ -6140,7 +6140,8 @@ static vm_fault_t sanitize_fault_flags(s
 }
 
 /*
- * By the time we get here, we already hold the mm semaphore
+ * By the time we get here, we already hold either the VMA lock or the
+ * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
  *
  * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
_

Patches currently in -mm which might be from alexjlzheng@gmail.com are



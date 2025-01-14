Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBF21DDEA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736819650; cv=none; b=VoSci7vyDAkZKtik1IR6PnwDyK5v6aYbHILtuMz1C0cnKrfHXSB3vNSg15i8H8ERf4ZxS4mjFvmArsZBn0hXDDijE5aBxdqEypnhVCZKW91LJWxPfX5Nt84QXOBSplJWwMGN1zMy+PqqY84py6DBXIOf0h/IDwp5HcdO5yWzMrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736819650; c=relaxed/simple;
	bh=WEhvxBrThEPoiuj152694pHNsExqjGv0KBE3pcdyCLE=;
	h=Date:To:From:Subject:Message-Id; b=RvifR5f+pXXhpuPLrT+Les6jbrfrLBmZ1vIjxLypWZpv+SzXKM+4gSDBiOwkR/ZOoO6Kugokh3It60r1G0CR9sIixv3mjP6Ct3wir9ilmJVyKZ4UH0mt0DskdgMz0RxD5bXW8T1haGMI8IwIt4TXvWBXLkBPZKB4j2hfRISPewo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uLTmFjAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uLTmFjAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861FFC4CED6;
	Tue, 14 Jan 2025 01:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736819649;
	bh=WEhvxBrThEPoiuj152694pHNsExqjGv0KBE3pcdyCLE=;
	h=Date:To:From:Subject:From;
	b=uLTmFjAY83NtfI7l0T/f9//SFJ8I/uMgYCM8nUWOJjeUwCUr59t1bf4DegWHn1Gdt
	 EyF3bqDBdPWousHJFwVv28d1uDFkMHDjKmJpkftBnvSCIYcU5HqWa5jJL8o/xyJyKf
	 nfOoKZ68eC58EYjkMFElADi9Q1c0Af3YtLrtHKjo=
Date: Mon, 13 Jan 2025 17:54:08 -0800
To: mm-commits@vger.kernel.org,frederic@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kthread-modify-kernel-doc-function-name-to-match-code.patch removed from -mm tree
Message-Id: <20250114015409.861FFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kthread: modify kernel-doc function name to match code
has been removed from the -mm tree.  Its filename was
     kthread-modify-kernel-doc-function-name-to-match-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kthread: modify kernel-doc function name to match code
Date: Fri, 10 Jan 2025 22:30:08 -0800

kthread.c:1073: warning: expecting prototype for kthread_create_worker(). Prototype was for kthread_create_worker_on_node() instead

Link: https://lkml.kernel.org/r/20250111063008.910712-1-rdunlap@infradead.org
Fixes: b1e125dcbcea ("kthread: Unify kthread_create_on_cpu() and kthread_create_worker_on_cpu() automatic format")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kthread.c~kthread-modify-kernel-doc-function-name-to-match-code
+++ a/kernel/kthread.c
@@ -900,7 +900,7 @@ fail_task:
 }
 
 /**
- * kthread_create_worker - create a kthread worker
+ * kthread_create_worker_on_node - create a kthread worker
  * @flags: flags modifying the default behavior of the worker
  * @namefmt: printf-style name for the kthread worker (task).
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix.patch
kasan-use-correct-kernel-doc-format.patch
latencytop-use-correct-kernel-doc-format-for-func-params.patch
gcov-clang-use-correct-function-param-names.patch
ipc-utilc-complete-the-kernel-doc-function-descriptions.patch


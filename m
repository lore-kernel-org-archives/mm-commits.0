Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714731D5160
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908136; cv=none; b=EJa6VNkSUiQwg4a/74iGjn2wy9FmKHPV/hAJVrxSsopR1B9BudXuZcbvjemi3pIp90HMRsOohsP39K3vJnRb+840JIZ5kyvAORsolkU6sk5dB4zfrPlX/VYltc/0GOLFLWP2p5sWqQad7el2v+SyP++kJT39bzUyRBslxco+pIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908136; c=relaxed/simple;
	bh=2APxiukJckWthDvaQ4X/gH3Ld6xErvBTXaof1iCI8AI=;
	h=Date:To:From:Subject:Message-Id; b=bNoxt5RLWui0q2Z/k6RCsUqOxVwLCmIb/OoeDoEYJ7qRKaTYQl7Sz2zMUDjIfvSWzoZyD2GY1ksJ0NUn3ysEjyiAaDkJhUk6qYuwwITnbQFndFZCNPXokz754h4IictDq1P7NvUdcLTCsssu0r5Bc6XkHjKobIgpCVnkMKdJ1Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PEnirmu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PEnirmu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8944C4CEF5;
	Wed, 12 Nov 2025 00:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908135;
	bh=2APxiukJckWthDvaQ4X/gH3Ld6xErvBTXaof1iCI8AI=;
	h=Date:To:From:Subject:From;
	b=PEnirmu120zPbrXEr/pDYmxo0USqkR3qWgqIZFc2j8YPouBWzEDgNuwa47oR9XwUT
	 esjk+UUWYxtNYg1cuCoaBSataK1+umj5IeZOEoykPQa5sBivMF3KdQiDmCqYaVovlt
	 N4Q3Z5nPtyMbvRR0/WApbzlAFeQzPqgStF8kPNuU=
Date: Tue, 11 Nov 2025 16:42:15 -0800
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,mpdesouza@suse.com,mario.limonciello@amd.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,andriy.shevchenko@intel.com,jbouron@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3.patch removed from -mm tree
Message-Id: <20251112004215.D8944C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3
has been removed from the -mm tree.  Its filename was
     kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3.patch

This patch was dropped because it was folded into kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

------------------------------------------------------
From: Justinien Bouron <jbouron@amazon.com>
Subject: kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3
Date: Fri, 24 Oct 2025 08:50:09 -0700

Removed unused variable in kimage_load_cma_segment() which was causing a
warning and failing build with `make W=1`.  Thanks Andy Shevchenko for
finding this issue

Link: https://lkml.kernel.org/r/20251024155009.39502-1-jbouron@amazon.com
Signed-off-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/kexec_core.c~kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3
+++ a/kernel/kexec_core.c
@@ -742,7 +742,6 @@ static int kimage_load_cma_segment(struc
 	struct kexec_segment *segment = &image->segment[idx];
 	struct page *cma = image->segment_cma[idx];
 	char *ptr = page_address(cma);
-	unsigned long maddr;
 	size_t ubytes, mbytes;
 	int result = 0;
 	unsigned char __user *buf = NULL;
@@ -754,7 +753,6 @@ static int kimage_load_cma_segment(struc
 		buf = segment->buf;
 	ubytes = segment->bufsz;
 	mbytes = segment->memsz;
-	maddr = segment->mem;
 
 	/* Then copy from source buffer to the CMA one */
 	while (mbytes) {
@@ -782,7 +780,6 @@ static int kimage_load_cma_segment(struc
 		}
 
 		ptr    += mchunk;
-		maddr  += mchunk;
 		mbytes -= mchunk;
 
 		cond_resched();
_

Patches currently in -mm which might be from jbouron@amazon.com are

kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch


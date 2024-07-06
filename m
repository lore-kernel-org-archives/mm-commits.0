Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8AD13CA8C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292058; cv=none; b=muIiXGzu/vj9LnWhuG7S6oEOpUA2GCIr0/SPsK7Z7NY47tPOgKgX0L3+v4l1EEN+oCi3bxQcxePNhvMwg6KzW83sYtIMwaaiBXJBxYLk4JEqxnVKn7CdurYdYZrY/VOe8FJPn3RQ8pcS55/VuVtO4OOmgVJ9gVIjX3T4+WZmaNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292058; c=relaxed/simple;
	bh=Tvhl4aKE95UBvNU4uqxEGshW7FFxOcpFd/U3xTSy5eQ=;
	h=Date:To:From:Subject:Message-Id; b=L5/zXpm5XdTz37WwH1ayakm4wwYlxtHywXQQ4pihxbsaOAXplMPg5t25WulxXKZxIN1c+lSq14MZIIx4xsu152GbOZSv9vAk1Udfu3OZIg/PXT3o6X2GNuE4sQfH6irGquWYJrqaslr/m5FIMaanfRpUHU3aVpNSWhcUOwK7UU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kIXhCGPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kIXhCGPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DBAC2BD10;
	Sat,  6 Jul 2024 18:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292058;
	bh=Tvhl4aKE95UBvNU4uqxEGshW7FFxOcpFd/U3xTSy5eQ=;
	h=Date:To:From:Subject:From;
	b=kIXhCGPovJ0xaXj1Lf5oERdTKFCAUklachDMplInGwP6OHM9Bo5cFoqABqg+4spWv
	 UFi0yu3gPDZn+A7GsgFXYsk3LtGxBYbnUu3zANwEFp33sBDMRaIaEhL7trK0fO5sfm
	 9nobf1WNAnLfevMushoI3qdidRpYXg1L9XJuTm78=
Date: Sat, 06 Jul 2024 11:54:17 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,oleg@redhat.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch removed from -mm tree
Message-Id: <20240706185418.02DBAC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/fork.c: get totalram_pages from memblock to calculate max_threads
has been removed from the -mm tree.  Its filename was
     kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: kernel/fork.c: get totalram_pages from memblock to calculate max_threads
Date: Mon, 1 Jul 2024 01:34:09 +0000

Since we plan to move the accounting into __free_pages_core(),
totalram_pages may not represent the total usable pages on system at this
point when defer_init is enabled.

Instead we can get the total usable pages from memblock directly.

Link: https://lkml.kernel.org/r/20240701013410.17260-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads
+++ a/kernel/fork.c
@@ -44,6 +44,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/memblock.h>
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
@@ -999,7 +1000,7 @@ void __init __weak arch_task_cache_init(
 static void set_max_threads(unsigned int max_threads_suggested)
 {
 	u64 threads;
-	unsigned long nr_pages = totalram_pages();
+	unsigned long nr_pages = PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size());
 
 	/*
 	 * The number of threads shall be limited such that the thread
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch
mm-use-zonelist_zone-to-get-zone.patch


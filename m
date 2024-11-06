Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B31815B12F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854782; cv=none; b=h2jTYgFo/f9sun7y3CB6h7CVejPD9QuD8V0HNVuG+4GRUi52oksdBsQXF741O6yNhhCyX3qMT93eAGoeVDohWGH8D9PJKEvpi+aWCEGc6Y7qfgdHi/2RvdxLLvR6yOhh8IwiUPE6NFwAFSL/81dvNUmk1Aakw3y4comeuhjlo4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854782; c=relaxed/simple;
	bh=Ai5AQd+M4tzuNMuR246iwZ21HDNGXPJcZeBm4EC4bkQ=;
	h=Date:To:From:Subject:Message-Id; b=oEPC+yEbh8AnXKU5NIzMIo1a7azmlQNS1GkoHGzv1r5Tw2sa/62F8pJegTXB8JbE8mSdGsDoWSZO0SxXIKZOmN6KtQgO6nd2fjUsOcU4Y8Al/UxjU+Y6eH+OjX99qurdyk2ZkLMU+3JwALyB04wOEsiNJTJR6SBjQdpepINm7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s7JxzbvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s7JxzbvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52485C4CECF;
	Wed,  6 Nov 2024 00:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854782;
	bh=Ai5AQd+M4tzuNMuR246iwZ21HDNGXPJcZeBm4EC4bkQ=;
	h=Date:To:From:Subject:From;
	b=s7JxzbvZPRHjmoocU/N64W75ln01KNfzf3LBO7bijVkCF6+bZD0HYh68RkFAEgLT8
	 RZPsYR797pnlMi+l65TM2k4IgUdaqJwPMU1+q92MKYm1dxvJ8vxjgYeg9myvXm3cdM
	 qbeGxgrK1AC3TEVl08WP58JuHj1PXAZx2WevZwJw=
Date: Tue, 05 Nov 2024 16:59:41 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,oliver.sang@intel.com,cl@linux.com,dennis@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-fix-data-race-with-pcpu_nr_empty_pop_pages.patch removed from -mm tree
Message-Id: <20241106005942.52485C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: fix data race with pcpu_nr_empty_pop_pages
has been removed from the -mm tree.  Its filename was
     percpu-fix-data-race-with-pcpu_nr_empty_pop_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dennis Zhou <dennis@kernel.org>
Subject: percpu: fix data race with pcpu_nr_empty_pop_pages
Date: Mon, 7 Oct 2024 17:19:42 -0700

Fixes the data race by moving the read to be behind the pcpu_lock. This
is okay because the code (initially) above it will not increase the
empty populated page count because it is populating backing pages that
already have allocations served out of them.

Link: https://lkml.kernel.org/r/20241008001942.8114-1-dennis@kernel.org
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407191651.f24e499d-oliver.sang@intel.com
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~percpu-fix-data-race-with-pcpu_nr_empty_pop_pages
+++ a/mm/percpu.c
@@ -1864,6 +1864,10 @@ restart:
 
 area_found:
 	pcpu_stats_area_alloc(chunk, size);
+
+	if (pcpu_nr_empty_pop_pages < PCPU_EMPTY_POP_PAGES_LOW)
+		pcpu_schedule_balance_work();
+
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	/* populate if not all pages are already there */
@@ -1891,9 +1895,6 @@ area_found:
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
 
-	if (pcpu_nr_empty_pop_pages < PCPU_EMPTY_POP_PAGES_LOW)
-		pcpu_schedule_balance_work();
-
 	/* clear the areas and return address relative to base address */
 	for_each_possible_cpu(cpu)
 		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
_

Patches currently in -mm which might be from dennis@kernel.org are



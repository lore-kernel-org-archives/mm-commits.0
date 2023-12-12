Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7682C80028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J1WkQH18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8F2C433C8;
	Tue, 12 Dec 2023 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407593;
	bh=UnMDIhPfXnjbs815y4EU4lejfz8UiMCFASNrODixw1o=;
	h=Date:To:From:Subject:From;
	b=J1WkQH1847f4g+I2ohYVhUzHbFPkdDOvBmU9jVNf+SeK6oUE3neG2HdtF2Rlda+g9
	 zh7VFc+R2LD2ivhz7Spoa6oKmwyn1ijFtTxFwxcDEpWZhFVnxx1C9jtetgmABHEE48
	 0nzKxt7ZiMCYyLVHZ8HRKin9eRq3GPr/bWDOEBbU=
Date: Tue, 12 Dec 2023 10:59:52 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foudation.org,zeming@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-remove-unnecessary-initialization-of-ret.patch removed from -mm tree
Message-Id: <20231212185952.DC8F2C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cma: remove unnecessary initialization of ret
has been removed from the -mm tree.  Its filename was
     mm-cma-remove-unnecessary-initialization-of-ret.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: mm: cma: remove unnecessary initialization of ret
Date: Tue, 5 Dec 2023 10:17:51 +0800

The ret variable can be defined without assigning a value, as it is
assigned before use.

Link: https://lkml.kernel.org/r/20231205021751.100459-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-remove-unnecessary-initialization-of-ret
+++ a/mm/cma.c
@@ -244,7 +244,7 @@ int __init cma_declare_contiguous_nid(ph
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
 	phys_addr_t highmem_start;
-	int ret = 0;
+	int ret;
 
 	/*
 	 * We can't use __pa(high_memory) directly, since high_memory
_

Patches currently in -mm which might be from zeming@nfschina.com are



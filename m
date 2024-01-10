Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1104CB22
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZX9bqCiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8291EC433F1;
	Wed, 10 Jan 2024 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704903216;
	bh=x1cbn8P+ZsxeGhbWfccz/pPv55nOzOpGwubSryIapdc=;
	h=Date:To:From:Subject:From;
	b=ZX9bqCiHXvd8s504AImK3y4EPjqzPWhvpIA0y+JGXsA5LuCGOz0bUAXAZu8ga3l5n
	 K6DSWu2IFux3wfEmYRJxsTJw4NJ8W3LRcvRbz49DptiqkdRBbe1RiBjR3a7+xt+6KL
	 W2UUkVrCKTG9709+51ylM4V7rbVZ62EaVhkJCvJs=
Date: Wed, 10 Jan 2024 08:13:36 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,riel@surriel.com,oliver.sang@intel.com,fengwei.yin@intel.com,cl@linux.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch added to mm-unstable branch
Message-Id: <20240110161336.8291EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mmap: no need to call khugepaged_enter_vma() for stack
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: mmap: no need to call khugepaged_enter_vma() for stack
Date: Wed, 20 Dec 2023 22:59:42 -0800

We avoid allocating THP for temporary stack, even tnough
khugepaged_enter_vma() is called for stack VMAs, it actualy returns false.
So no need to call it in the first place at all.

Link: https://lkml.kernel.org/r/20231221065943.2803551-1-shy828301@gmail.com
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack
+++ a/mm/mmap.c
@@ -2049,7 +2049,6 @@ static int expand_upwards(struct vm_area
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
 	validate_mm(mm);
 	return error;
@@ -2143,7 +2142,6 @@ int expand_downwards(struct vm_area_stru
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
 	validate_mm(mm);
 	return error;
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are

mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch
mm-mmap-map-map_stack-to-vm_nohugepage.patch


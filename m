Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FFD4CB22
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ULAwTu+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C52C433F1;
	Wed, 10 Jan 2024 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704903218;
	bh=DC1KrK9zZHOGFWhnL1Oq8gaqMqREWs/jlLvYBcCVczI=;
	h=Date:To:From:Subject:From;
	b=ULAwTu+kZxO41peilyRI62vJoFQx6NVbOQtocx++p0QSK050relYAhKKmZmdK40lI
	 Zx3tH7zscFung+U/ITKDQDI/6itpOBX4dDFusbd0qBclEE0xd3WoHdMrVMFA/h9noJ
	 3mBHq2/pKCkpQ1ED/4UuriIycxCUPSEY8RobH3RA=
Date: Wed, 10 Jan 2024 08:13:37 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,riel@surriel.com,oliver.sang@intel.com,fengwei.yin@intel.com,cl@linux.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-map-map_stack-to-vm_nohugepage.patch added to mm-unstable branch
Message-Id: <20240110161338.78C52C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-map-map_stack-to-vm_nohugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-map-map_stack-to-vm_nohugepage.patch

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
Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE
Date: Wed, 20 Dec 2023 22:59:43 -0800

commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") incured regression for stress-ng pthread benchmark [1].  It
is because THP get allocated to pthread's stack area much more possible
than before.  Pthread's stack area is allocated by mmap without
VM_GROWSDOWN or VM_GROWSUP flag, so kernel can't tell whether it is a
stack area or not.

The MAP_STACK flag is used to mark the stack area, but it is a no-op on
Linux.  Mapping MAP_STACK to VM_NOHUGEPAGE to prevent from allocating THP
for such stack area.

With this change the stack area looks like:

fffd18e10000-fffd19610000 rw-p 00000000 00:00 0
Size:               8192 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:                  12 kB
Pss:                  12 kB
Pss_Dirty:            12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:           12 kB
Anonymous:            12 kB
KSM:                   0 kB
LazyFree:              0 kB
AnonHugePages:         0 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:         0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
Locked:                0 kB
THPeligible:           0
VmFlags: rd wr mr mw me ac nh

The "nh" flag is set.

[1] https://lore.kernel.org/linux-mm/202312192310.56367035-oliver.sang@intel.com/

Link: https://lkml.kernel.org/r/20231221065943.2803551-2-shy828301@gmail.com
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Tested-by: Oliver Sang <oliver.sang@intel.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Huang, Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mman.h~mm-mmap-map-map_stack-to-vm_nohugepage
+++ a/include/linux/mman.h
@@ -156,6 +156,7 @@ calc_vm_flag_bits(unsigned long flags)
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
+	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
 	       arch_calc_vm_flag_bits(flags);
 }
 
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are

mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch
mm-mmap-map-map_stack-to-vm_nohugepage.patch


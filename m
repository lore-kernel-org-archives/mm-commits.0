Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151BC3EBF34
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 00:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772064298; cv=none; b=u9FWy2AFcGaECvDmw1jt1L3jwN3LBVZCE9LpqqnJeFw0i9sioa7wUme1DzarDW/BuHcmVyEPWBurIUpGRXK1tFeLdD4FsSOHleoF81NlSicOhH5n/85OF2Bk+msYLgOn7C8AFzsfvLQlejC298SXVFnZnxCSFaUNTrw9+nPnMsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772064298; c=relaxed/simple;
	bh=PD/Q/wgKxofnmzSGtXILFnzVjKvAsqXSNgECACLIQOE=;
	h=Date:To:From:Subject:Message-Id; b=XYRPjtAcExvY5HJYEkkDq3MjtHZbfuS92MKimJlUaH0/EbyhA+h8JpCNbF8Cd4smN3B7OMwj2cyJ1pgJmIyUzZNa47dalgmqjZoIDyrQSU+tTd/Mxtmon1QxLZfnjRQ8g4jK4HNl/LNBGaooPIL+Jv+muvYpLSYJG7YLj0M0z4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HKzGZqDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HKzGZqDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9553BC116D0;
	Thu, 26 Feb 2026 00:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772064297;
	bh=PD/Q/wgKxofnmzSGtXILFnzVjKvAsqXSNgECACLIQOE=;
	h=Date:To:From:Subject:From;
	b=HKzGZqDrt68asBoBcwKyLXYGlt3hJtudm91LlXabxuf6zSEvvjOVDYtUgiqK8luaq
	 VffGLpNIJEvp0CnXx+WDndyAVPz320mzobdiL0801g6kHorXvIrvU9mXwZxsI3AevJ
	 ksbKLfwcxQSMmsgR2uNg8im8rC5iu8aWtpvPKo5E=
Date: Wed, 25 Feb 2026 16:04:56 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pratyush@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-export-clear_vm_uninitialized_flag.patch added to mm-new branch
Message-Id: <20260226000457.9553BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: export clear_vm_uninitialized_flag()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-export-clear_vm_uninitialized_flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-export-clear_vm_uninitialized_flag.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/vmalloc: export clear_vm_uninitialized_flag()
Date: Wed, 25 Feb 2026 17:38:56 -0500

Patch series "Fix KASAN support for KHO restored vmalloc regions".

When KHO restores a vmalloc area, it maps existing physical pages into a
newly allocated virtual memory area.  However, because these areas were
not properly unpoisoned, KASAN would treat any access to the restored
region as out-of-bounds, as seen in the following trace:

BUG: KASAN: vmalloc-out-of-bounds in kho_test_restore_data.isra.0+0x17b/0x2cd
Read of size 8 at addr ffffc90000025000 by task swapper/0/1
[...]
Call Trace:
[...]
kasan_report+0xe8/0x120
kho_test_restore_data.isra.0+0x17b/0x2cd
kho_test_init+0x15a/0x1f0
do_one_initcall+0xd5/0x4b0

The fix involves deferring KASAN's default poisoning by using the
VM_UNINITIALIZED flag during allocation, manually unpoisoning the memory
once it is correctly mapped, and then clearing the uninitialized flag
using a newly exported helper.


This patch (of 2):

Make clear_vm_uninitialized_flag() available to other parts of the kernel
that need to manage vmalloc areas manually, such as KHO for restoring
vmallocs.

Link: https://lkml.kernel.org/r/20260225220223.1695350-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20260225223857.1714801-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 ++
 mm/vmalloc.c  |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-vmalloc-export-clear_vm_uninitialized_flag
+++ a/mm/internal.h
@@ -1469,6 +1469,8 @@ int __must_check vmap_pages_range_noflus
 }
 #endif
 
+void clear_vm_uninitialized_flag(struct vm_struct *vm);
+
 int __must_check __vmap_pages_range_noflush(unsigned long addr,
 			       unsigned long end, pgprot_t prot,
 			       struct page **pages, unsigned int page_shift);
--- a/mm/vmalloc.c~mm-vmalloc-export-clear_vm_uninitialized_flag
+++ a/mm/vmalloc.c
@@ -3183,7 +3183,7 @@ void __init vm_area_register_early(struc
 	kasan_populate_early_vm_area_shadow(vm->addr, vm->size);
 }
 
-static void clear_vm_uninitialized_flag(struct vm_struct *vm)
+void clear_vm_uninitialized_flag(struct vm_struct *vm)
 {
 	/*
 	 * Before removing VM_UNINITIALIZED,
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-vmalloc-export-clear_vm_uninitialized_flag.patch
kho-fix-kasan-support-for-restored-vmalloc-regions.patch


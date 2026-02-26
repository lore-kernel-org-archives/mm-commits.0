Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B244C2BB13
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 00:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772064300; cv=none; b=BSaOkOHY+iU3/msZo449esZ6JYmD0jnpcAHIr/hEGFc05cmZWDEk86oqcDXKfK6cXx66Za+YvFZQrXgQB/VxYJ9m07C42yQWvQ75kKmzRGiV8RSE4WCNj0RzgVMrleTmng2lnIPxnwlKLzja3rMHE38ptSYxY7eQeZmV3ZBEng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772064300; c=relaxed/simple;
	bh=uL7wuTznZGGQGqAIwzru7veXcGOgE52anPqii6E3GgA=;
	h=Date:To:From:Subject:Message-Id; b=jeHj+f1oVJKyJzpvepFtdI/tiJf47td02p2ASOtYVxuBuEpwh8smozXZy2zB9WsnidtHZTTvCujliiwXY1g8Y7wuc3SFWcYoLxiNJQq/u0odNB7c8bnIDhdtHnDwDA37MNqtH/hqUiIpW5mLsm+ytg+70MwuQcDCWfDWuaaEaNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1oAG+8zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1oAG+8zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC06C116D0;
	Thu, 26 Feb 2026 00:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772064300;
	bh=uL7wuTznZGGQGqAIwzru7veXcGOgE52anPqii6E3GgA=;
	h=Date:To:From:Subject:From;
	b=1oAG+8ztzUrXDrR9jIpOuqGtn2ArEolucvUy5xBZlJV8klDNyZ6Qau8dgPhV176bo
	 ER/1o+tM6x0AtiYMHkivNgMjHJp+0r/4wRGzvjtKWGDQWTVGPRN5RaI8obAtfjkotz
	 61dVk2LkzNfSj+KCCJS2jdah6jYhfq/cTPun0A+A=
Date: Wed, 25 Feb 2026 16:04:59 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pratyush@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-kasan-support-for-restored-vmalloc-regions.patch added to mm-new branch
Message-Id: <20260226000500.4EC06C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix KASAN support for restored vmalloc regions
has been added to the -mm mm-new branch.  Its filename is
     kho-fix-kasan-support-for-restored-vmalloc-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-kasan-support-for-restored-vmalloc-regions.patch

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
Subject: kho: fix KASAN support for restored vmalloc regions
Date: Wed, 25 Feb 2026 17:38:57 -0500

Restored vmalloc regions are currently not properly marked for KASAN,
causing KASAN to treat accesses to these regions as out-of-bounds.

Fix this by properly unpoisoning the restored vmalloc area using
kasan_unpoison_vmalloc().  This requires setting the VM_UNINITIALIZED flag
during the initial area allocation and clearing it after the pages have
been mapped and unpoisoned, using the clear_vm_uninitialized_flag()
helper.

Link: https://lkml.kernel.org/r/20260225223857.1714801-3-pasha.tatashin@soleen.com
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-kasan-support-for-restored-vmalloc-regions
+++ a/kernel/liveupdate/kexec_handover.c
@@ -14,6 +14,7 @@
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
+#include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho_radix_tree.h>
@@ -1102,6 +1103,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 {
 	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
 	unsigned int align, order, shift, vm_flags;
 	unsigned long total_pages, contig_pages;
 	unsigned long addr, size;
@@ -1153,7 +1155,8 @@ void *kho_restore_vmalloc(const struct k
 		goto err_free_pages_array;
 
 	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
-				  vm_flags, VMALLOC_START, VMALLOC_END,
+				  vm_flags | VM_UNINITIALIZED,
+				  VMALLOC_START, VMALLOC_END,
 				  NUMA_NO_NODE, GFP_KERNEL,
 				  __builtin_return_address(0));
 	if (!area)
@@ -1168,6 +1171,13 @@ void *kho_restore_vmalloc(const struct k
 	area->nr_pages = total_pages;
 	area->pages = pages;
 
+	if (vm_flags & VM_ALLOC)
+		kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
+
+	area->addr = kasan_unpoison_vmalloc(area->addr, total_pages * PAGE_SIZE,
+					    kasan_flags);
+	clear_vm_uninitialized_flag(area);
+
 	return area->addr;
 
 err_free_vm_area:
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-vmalloc-export-clear_vm_uninitialized_flag.patch
kho-fix-kasan-support-for-restored-vmalloc-regions.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AC8364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388618; cv=none; b=lHIrJg1i9DEJTWC7LbqkTIojR9gNbm6S5N693thpMr/LCva/zVcam7hP6l6kRm+mMhXXq5RGQbwmrAk//wcSo8ghV2sP/M32GKJD2cHMclbHuuQqIZSMEqfjr+/MeI5DD0G3MNWV1wDUa811Vm6/wyzaa1rJPRHFP0qGyuSIgmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388618; c=relaxed/simple;
	bh=LzWkYIHF3+uTTe5MOLlMpwEuqGYN9gxIcvT5SQhbHaw=;
	h=Date:To:From:Subject:Message-Id; b=PuMdXBOLKqlg99xaAbpUxbO4rCKyFw+BqPoPYly8tmfKZvYXy3qorhPfb7oXTy2FYkHVmGZWMOY152CAndUsDuHk5ePWxz/gpzyXtjlEANPI2WtI5rf3SiwwZQV2zHKSyIVFho/34QXj29llMykIQkuDKeu9ZRtA/nvqYEplg1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HX2hA3Q7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HX2hA3Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AB3C19424;
	Tue, 24 Mar 2026 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388618;
	bh=LzWkYIHF3+uTTe5MOLlMpwEuqGYN9gxIcvT5SQhbHaw=;
	h=Date:To:From:Subject:From;
	b=HX2hA3Q7+UM8Oc6isMYWFccKBBvhtjwfk5CgfU8NWm56MaYI3blIY6eThrMqzGPfV
	 TYvA+cChHcsqDkGFFoFhzPfSlkth8lhHRVGtySpFFya7aUP4KJ0W8LoUDj4hx97GdO
	 3tiAvPQ3EHEat3HFKHjtIRTfrPMRLFOzr45LCZJs=
Date: Tue, 24 Mar 2026 14:43:37 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pratyush@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-export-clear_vm_uninitialized_flag.patch removed from -mm tree
Message-Id: <20260324214338.68AB3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: export clear_vm_uninitialized_flag()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-export-clear_vm_uninitialized_flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-rwsem.patch
liveupdate-remove-file-handler-module-refcounting.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-prevent-double-management-of-files.patch
selftests-liveupdate-add-test-for-double-preservation.patch


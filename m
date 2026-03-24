Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF97364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388620; cv=none; b=uZ+MU/2tq4FV/4ZAS2CZWN0jOz3IASU+R5nKsd63XwhiX2i2L4p3K+dA/qOmhRad3a9NjYgNqzue/Ct47PQ4pthVfpviRtpRwjbjlXm8mlQN9+j5knTNm+F/z+SwWslM3ci5o6iKC0aPvitfatULe6RzqAqQuWxieMpM+yvtDrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388620; c=relaxed/simple;
	bh=8x3sng6W1oyMtCL7uzBNVLjkJpBOt7Kq/k1Q7WLt6Ro=;
	h=Date:To:From:Subject:Message-Id; b=pM31UwOxPG+YfeVWdZPb+nJ2QAJlI7ajcD8UfaYLM//E/gy3nZDFnPbLG0EKApqBU/KUkmeBWg7+GKum1cndn7ejA0tDCgFOrCfzJ/VJtRUyzhE+dT3Ccye1wtFLRAk6FwReKnygFMwVFPwf+2Nj40D/m0S0ds+B4ha0V5/XgSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kRxSTN5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kRxSTN5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F36C19424;
	Tue, 24 Mar 2026 21:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388619;
	bh=8x3sng6W1oyMtCL7uzBNVLjkJpBOt7Kq/k1Q7WLt6Ro=;
	h=Date:To:From:Subject:From;
	b=kRxSTN5JthMBKQiJ1qCo6NaP06j6yU7Vd2mXcDcjkBqbkK+AYDKhQPz1dtMRAnZXP
	 +YTN/6VhWGEzfpZPi/c1TYKIwlM76CZphDgd5XbuArXj/toRh74qDfvuiwJq1MBs7J
	 ybyu/42qFQaxmKeTN2qvCZBXNsBNP+zQnKiwfTVI=
Date: Tue, 24 Mar 2026 14:43:39 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pratyush@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-fix-kasan-support-for-restored-vmalloc-regions.patch removed from -mm tree
Message-Id: <20260324214339.A9F36C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix KASAN support for restored vmalloc regions
has been removed from the -mm tree.  Its filename was
     kho-fix-kasan-support-for-restored-vmalloc-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Tested-by: Pratyush Yadav (Google) <pratyush@kernel.org>
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
@@ -1077,6 +1078,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 {
 	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
 	unsigned int align, order, shift, vm_flags;
 	unsigned long total_pages, contig_pages;
 	unsigned long addr, size;
@@ -1128,7 +1130,8 @@ void *kho_restore_vmalloc(const struct k
 		goto err_free_pages_array;
 
 	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
-				  vm_flags, VMALLOC_START, VMALLOC_END,
+				  vm_flags | VM_UNINITIALIZED,
+				  VMALLOC_START, VMALLOC_END,
 				  NUMA_NO_NODE, GFP_KERNEL,
 				  __builtin_return_address(0));
 	if (!area)
@@ -1143,6 +1146,13 @@ void *kho_restore_vmalloc(const struct k
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


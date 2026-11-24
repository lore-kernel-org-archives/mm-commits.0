Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541613;
	b=FKfXl65y98/OT95r8bxFaell7jqxH6fh8mbdtLo+S2XaiGKpK3JZQnBc6N5malPfRHwl
	 APG6XUk/3pqoKnWsJAmVwFiRixrfpdss7g/ME1XXgj79oSnAz0wio+WlUf+NMkIhX70mg
	 Dq3K4a8/DH2qvAUEZvAp+d0BJ5YDcbz6kPyZt0bq45+idgdZPd+v6ayJvZhgN7rDBc7l5
	 OVonkNppe2z+U5Ow8IzEr4H+D/+KVRiR1ZhOooTGducws3+9UsGmQymtGfTvtsx87CLoG
	 0YSla2lHtGLLMFQFjDdcuA6z7Cp9nvKs+mjjywR4/KiiZovL5kdSjb7+exe/y/JSjPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541613;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=KRKcH0psMs5K4ny2BULIFxZ1CWt3hzDKA8Zb3Ov9cVg=;
	b=aCemTqm3DUZ0vVN5Yr73CrPGDHqqbV3JKYT2OLP+gfe4mUyeTvLF8MoDLPDBDkHXLbz6
	 kvNu7ZF9yJBOW8csmLTkt9YxnNrEmnUb349d10B4QXpTursX+7AXUzBQWtxkbYYN3koSL
	 08xUfKR3SKjo0tFHY9tKesOQIB5YakmVQKIPcbafQUw7D1wBIbcXwk0fAI8SjVl883U4G
	 oz6jU9SyrSujxrc9zMfa1sYGqmSJFLQr+ht3ZIbC1npkaezk0MABNzumcjrEn0eh5YOTf
	 Z1+mvkDL1GoJssprwZf7bPtIq8eiek/RnjurekwCT7MtlvQRQ6i9gdJkmNShiT++SUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uzZyr3OW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9190606A33E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uzZyr3OW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488B91F000F0;
	Tue, 24 Nov 2026 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541613;
	bh=KRKcH0psMs5K4ny2BULIFxZ1CWt3hzDKA8Zb3Ov9cVg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=uzZyr3OWT4kVMoHV/hiNP6kVMJEaxvP/pfH1VRqRIgFnVFyh6C+a1KPS8ajbrx7WE
	 S25sVQkQUoQujMVLhlINgAC7FxpsbTlvntmcSsZzXZSNSLydThaxC4UC7cm9b9/351
	 Byy/9A7pc0rpS8DBuz5qpVI/Dof+ScvWR8cOj614=
Date: Tue, 24 Nov 2026 09:33:32 -0800
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <awXHR007d8MlhJUC@gremlin>
References: <awXHR007d8MlhJUC@gremlin>
Subject: + mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20261124173333.488B91F000F0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-vma-drop-mm-asynchronously-in-vma_start_read-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-drop-mm-asynchronously-in-vma_start_read-fix
Date: Tue Nov 24 09:31:33 AM PST 2026

tweak comment, per Lorenzo

Link: https://lore.kernel.org/awXHR007d8MlhJUC@gremlin
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

 mm/mmap_lock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap_lock.c~mm-vma-drop-mm-asynchronously-in-vma_start_read-fix
+++ a/mm/mmap_lock.c
@@ -300,7 +300,7 @@ err:
 err_unstable:
 	/*
 	 * If vma got attached to another mm from under us, that mm is not
-	 * stable and can be freed in the narrow window after vma->vm_refcnt
+	 * stable and can be reused in the narrow window after vma->vm_refcnt
 	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
 	 * releasing vma->vm_refcnt.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
selftests-mm-hmm-speed-up-migrate_remap_fault.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


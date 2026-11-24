Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795560715;
	b=bTKhrdF4iU8OC2vofg96yhHxIZweVMpr86intuakmW/bCdZHtpgRXBRAbYP4MXDotvZa
	 CyOJamdi/rwc9tFWKddhQPJxcek8Z3lk74V/M3SKwBzlP6Oc76rLthhZI5WPwYQJ78Nr+
	 FRGzVgH/hjIZ3d8ZY4KWuRyWkNgKDitxXGSlCuU735qTGZtwm8H+56z5kdou1snsXnKSd
	 UAfLGbtTcV0dJZYYVJctKr1VHpyi0sB5gvgMmeMfcVzlPa10xtmIFqmafkCtCA+OGptMN
	 JbxCYxHHEqml15ZIpjhc8o+P/SuIcYKLMWDkxENDrL4PRE0WAkLJaJXcTfFzjph8fhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560715;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pgZRn5oxP3c/c4VBeQ6F0Ee6rFHCzoj/ohejXfs27kU=;
	b=XSCfqneYk2c45aQAgMxaRnH9pwtgiJoGVqg4FrPpHZZbnyPB4x693IqxyEyPq0iSIiDj
	 W3Kp2lOd2ut878bPWM1pzHB59AvgxQ5g+oMwkelkhQiGWq67KyaPN5q7lWfCfZSfvClO/
	 WUlid8bD85f9nij4W1hmwga2UyblMYc7balWG0XcGZ5BBYghtoTMFYi43aZ/enQBI2nXW
	 ahRGJ4+Z9cbQ7q17vYzOgFkryEVHZMyk5lXyeZ7s7Fl8vf2HhKhUF9HTGs1ZzdKaNQ7Pm
	 BrEzE9kHzfIG3wyYYJsQ6hh5eznNU7Rp8MQHtRmhvhDd7HACd5oxshcx3yQbkDX9SDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TL4UfOXb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE57606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 22:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TL4UfOXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C751F000C4;
	Tue, 24 Nov 2026 22:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795560714;
	bh=pgZRn5oxP3c/c4VBeQ6F0Ee6rFHCzoj/ohejXfs27kU=;
	h=Date:To:From:Subject;
	b=TL4UfOXbi/aVzqaRMhUNszhy5eClynKdvhmbbR8BkYpwuiQalipAOiGlkJMWkIlNx
	 WqygZMSl8uiC0NeSSKm2yTQDsTAbdPDlCEZfTn+hgz5s1EUBE3KWSbdFDsLNjwKBsy
	 oB31/E8IzmslkkJXvWb3TaXSb1eE0V8RnXDXfOtk=
Date: Tue, 24 Nov 2026 14:51:53 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20261124225154.06C751F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch

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
Subject: mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2
Date: Tue Nov 24 02:50:40 PM PST 2026

comment fixup, per Suren

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>

 mm/mmap_lock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap_lock.c~mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2
+++ a/mm/mmap_lock.c
@@ -304,7 +304,7 @@ err_unstable:
 	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
 	 * releasing vma->vm_refcnt.
 	 */
-	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
+	other_mm = vma->vm_mm; /* use a copy as vma can be reused after we drop vm_refcnt */
 
 	mmgrab(other_mm);
 	vma_refcount_put(vma);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch
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
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F393A3CB8E9
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149807; cv=none; b=kISyf8zBgslJwd3FuPxKvV8M+pXhrmoTzlrLNRuhD9rPmIDhvFBITqo72VXORBJVIAwlQ/sj325HCLxPdgbzpU22S7u/goVIzRdXt6KTwhyKbUMtuH/LUwityKrq5IQ5iIAYRw9VXVqJeG9gwgYqLJf9bBbem+FxYCnmL19IS+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149807; c=relaxed/simple;
	bh=kZn8+BHCQy1UKlNU5jxJrAZv14JcwB7ER7Nrm5A6IIY=;
	h=Date:To:From:Subject:Message-Id; b=fEmE/wX2PWIqdRgjbfjRSEJUAEKpewwtag/lSwb1OZatSTaoiVXgF73IF5doOAQbAg0X88SnLBt7FI59YLza+G89lDdZhc7BlqH1BkaChOggG0fbC4O8L/I2wZ5fNY0W+/r9qN/o9wdfiB7huQ2I2S8V4mM5CDYi0NVypvvth2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IQi5fMyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IQi5fMyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67FE1F000E9;
	Wed, 15 Jul 2026 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784149805;
	bh=18kNYwRUC/x3A7LMpN1KtKLRBim/T2XrpNSEVb149zw=;
	h=Date:To:From:Subject;
	b=IQi5fMyKUD4aWPhJt5iMUS2RZb/eIa2mCpOPcUDrbO/tH3JvgxpKaPxM/aptML/xY
	 Ja8ncLs4fEjvrImRSGEvnoPYgSPjpa6Y5KSpv0sVZAqoVi8TDgS3IzKh7Zi4EQByP+
	 pLaqtqxE+6AW5n4rrOEbdLpXzwXoY3czwPjICo7Q=
Date: Wed, 15 Jul 2026 14:10:05 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support-fix.patch removed from -mm tree
Message-Id: <20260715211005.C67FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support-fix
has been removed from the -mm tree.  Its filename was
     mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support-fix
Date: Tue, 14 Jul 2026 15:21:28 -0700

The hmm_range_fault_unlocked_timeout() example checks for a concurrent
mmu_interval_notifier invalidation after the HMM fault has succeeded.  The
sequence number used for that check is stored in range->notifier_seq by
hmm_range_fault_unlocked_timeout(), so the retry check should use the same
notifier stored in range as well.

Update the example to pass range.notifier to mmu_interval_read_retry(),
and spell out that the retry check uses the notifier and sequence number
stored in range by the HMM fault helper.  This makes the relationship
between the HMM walk and the later invalidation check explicit.

Link: https://lore.kernel.org/178406768885.1106335.9955379956617151440.stgit@skinsburskii
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lizhi Hou <lizhi.hou@amd.com>
Cc: Long Li <longli@microsoft.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lyude <lyude@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hmm.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/mm/hmm.rst~mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support-fix
+++ a/Documentation/mm/hmm.rst
@@ -206,7 +206,7 @@ The usage pattern is::
           goto out_put;
 
       take_lock(driver->update);
-      if (mmu_interval_read_retry(&interval_sub, range.notifier_seq)) {
+      if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -225,7 +225,8 @@ The usage pattern is::
 The driver->update lock is the same lock that the driver takes inside its
 invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
-update.
+update. The retry check must use the same notifier and sequence number stored
+in ``range`` by ``hmm_range_fault_unlocked_timeout()``.
 
 Holding the mmap lock across HMM faults
 =======================================
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
selftests-mm-add-hmm-test-for-mmap-lock-dropping-faults.patch
mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


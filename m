Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630877;
	b=ZncJ0gGMFpN8vZoyE1/BUooa31aNh5UklXAI/fSFg9ZcTj+Q3ReYbM8vMi9myTJBDTSt
	 nktnlw/MoGmDyR1Zfp5Cd6MYaX7u9+cc+dCTPip1aSbyz1qkFuj0tPrNm9mSRPpK9Lr79
	 mX9YjIrjgYcPSeYrOKyuvpM6tvvlmVcWNs+cKXSsjL95XI5NnDstSgK2p6tzlrkRRUV3d
	 mqOUlj1bIY2wW0ttRQeWEjrJ0Q2Ca2gQNL4N/LIUljsHN2DOGFRpUguIJtKE6ALEQSKQj
	 k//ydNazsiZ8cBcit+d+/NOnrC7cXG8EaWycxp3SRfHwD0OngXowxD0pzNuEgsR05Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630877;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KCvVvonM0Zd8/VCuQOmPf9PYyxMPJYZd22vHQ7gCj/M=;
	b=CHAULfpTIl8K4gunGSszToMdVZll2UAEN7s1JwCIuHkLxr2kfN5psJRiFKrtKY1oBFjg
	 mMNTWYQmD1yO8u+MBLM/6q9PSpbCXyhgL4RJfeYZ6Nv0PEh5MWShW8YGf91A86QxvU/+B
	 ivkS0pE+KyfDE5tljnt/a7/Kj2Z2o2rxXkWU0Kq1F+ubsq11mbL5FQ0ijD12sblwF/jsa
	 6U329mxhgIWaHsFs61r8/uem/7jG2bbLw7qdKH/WpsltEDs2ixL4HRIpAM07+GH2YkPsd
	 UF0msj8hsKK20RFOUa+W3ivGWqk97NviJWQvvcfsaWCDn2WKQ8vm9+UyT8WXl4r9UtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UBmXbZKg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961C2606A31E;
	Wed, 25 Nov 2026 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UBmXbZKg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1C71F000CF;
	Wed, 25 Nov 2026 18:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795630877;
	bh=KCvVvonM0Zd8/VCuQOmPf9PYyxMPJYZd22vHQ7gCj/M=;
	h=Date:To:From:Subject;
	b=UBmXbZKgq+x/ilicwkWrHVE/YO+Q2DUCLSnRa/jHRY1yN93iw0eWhgX4eCnUjbK/V
	 ZiM4BI3yTA7TXPTA2ah0hFh9EhHoya7RyY2rrntp9bBtZL0LOfAj+bdULXsWQ9zK1b
	 ohYBIcYnxWj+jE1cpCnP6bV0RF1REKyPG1Y+SWeQ=
Date: Wed, 25 Nov 2026 10:21:16 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	shuah@kernel.org,rppt@kernel.org,rcampbell@nvidia.com,mpenttil@redhat.com,
	mhocko@suse.com,liam@infradead.org,leon@kernel.org,jm5905938@gmail.com,
	jgg@ziepe.ca,david@kernel.org,alexandru.elisei@arm.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch removed from -mm tree
Message-Id: <20261125182116.EE1C71F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib/test_hmm: invalidate all mirrors on device-private migration
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_hmm: invalidate all mirrors on device-private migration
Date: Sun, 22 Nov 2026 08:53:12 -0800

When one open of the fake HMM device migrates a folio to device-private
memory, a second open can fault the same address into its mirror page
table. The second mirror then stores the inaccessible device page, which
can oops the kernel when dmirror_do_read() copies from it. Store the
corresponding RAM backing subpage instead.

That conversion also makes the backing page's lifetime significant to
the second mirror. migrate_vma_setup() notifies all mirrors before CPU
faultback, but dmirror_interval_invalidate() skips the notification for
every open on the same device. The faulting open clears only its own
XArray entry. The other open can read or write the backing page after
migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
and stale data through the second open.

Handle migration invalidation for every mirror under its mutex. This
clears pointers before faultback can free the backing pages and waits
for an active mirror read or write. During system-to-device migration,
the migrating open installs new entries after migration; other opens
refault on their next access. Remove the now redundant XArray erase
from the faultback copy loop.

Extend the PMD migration selftest to read its last device-private
subpage through a second open, then fault it back to RAM, change it,
and read the new value through that open. The trigger is available to
a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
enabled; it does not depend on physical GPU hardware.

[akpm@linux-foundation.org: fix device-private backing subpage selection]
Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org
Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-reply@b4
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Aveline Noir <jm5905938@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>

 lib/test_hmm.c                         |   20 +++++++-----------
 tools/testing/selftests/mm/hmm-tests.c |   25 +++++++++++++++++++++++
 2 files changed, 33 insertions(+), 12 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
+++ a/lib/test_hmm.c
@@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
 		page = hmm_pfn_to_page(*pfns);
 		WARN_ON(!page);
 
+		if (is_device_private_page(page)) {
+			struct folio *folio = page_folio(page);
+			struct page *backing = BACKING_PAGE(&folio->page);
+
+			page = backing + folio_page_idx(folio, page);
+		}
 		entry = page;
 		if (*pfns & HMM_PFN_WRITE)
 			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
@@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
 {
 	struct dmirror *dmirror = container_of(mni, struct dmirror, notifier);
 
-	/*
-	 * Ignore invalidation callbacks for device private pages since
-	 * the invalidation is handled as part of the migration process.
-	 */
-	if (range->event == MMU_NOTIFY_MIGRATE &&
-	    range->owner == dmirror->mdevice)
-		return true;
-
 	if (mmu_notifier_range_blockable(range))
 		mutex_lock(&dmirror->mutex);
 	else if (!mutex_trylock(&dmirror->mutex))
@@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
 
 			src_page = pfn_to_page(page_to_pfn(spage) + i);
 
-			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
 			addr += PAGE_SIZE;
 			copy_highpage(dst_page, src_page);
 		}
@@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
 	}
 	migrate_vma_pages(&args);
 	/*
-	 * No device finalize step is needed since
-	 * dmirror_devmem_fault_alloc_and_copy() will have already
-	 * invalidated the device page table.
+	 * The migration notifier has invalidated all mirror page tables
+	 * before the backing pages can be freed.
 	 */
 	migrate_vma_finalize(&args);
 err:
--- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	void *old_ptr;
 	void *map;
 	int pagemap_fd;
+	int fd2 = -1;
 	int *ptr;
 	int ret;
 
@@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
 		}
 
 		close(pagemap_fd);
+
+		/* Read a device-private subpage through another open. */
+		fd2 = hmm_open(variant->device_number);
+		ASSERT_GE(fd2, 0);
+		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
+		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr = map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(*(int *)buffer->mirror,
+			  (npages - 1) * self->page_size / sizeof(int));
 	}
 
 	/* Fault pages back to system memory and check them. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
 
+	if (fd2 >= 0) {
+		/* This open must not retain the freed device backing page. */
+		ptr[(npages - 1) * self->page_size / sizeof(*ptr)] = -1;
+		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
+		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr = map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(buffer->faults, 1);
+		ASSERT_EQ(*(int *)buffer->mirror, -1);
+		ASSERT_EQ(close(fd2), 0);
+	}
+
 	buffer->ptr = old_ptr;
 	hmm_buffer_free(buffer);
 }
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
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
proc-dont-lock-task-inodes-whose-owner-has-not-changed.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


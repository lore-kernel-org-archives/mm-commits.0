Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367671;
	b=OYGPnIYBjEaHGcTODP0w7wNF11NSZ5tkryC3kQTvFn6RZcEHfILsaY3X6zt+B8SPpYpR
	 obek3Ro26OSD0C24vi6xizX8Z/yqPmGw2RzckTckiyd0ETosl4AbBmSUjs+mnpaTACGXs
	 cthz6e3ukVcqrBmazsl8mFzWGTV9LXDpW+Lrux6V471L47Zmq/lw8GF7ydpHE3IbkPf8Q
	 Afnd6Eyuxp8LK+bzSC0E0VDhX0w4fj8tE/3hvhRzMAt3NNUEHOyZfhkW8EE9DmtOaiLTn
	 HgYTuqKy0qC1eRE60mTLdnE6r0G7kZuB2cd0sB3G9D5En6Zm8RosKK1MQbV38RGkVnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367671;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dU4AnwmLGZcCLEgn4j/Dnq8k5fc0kQq7mg6yNhHToxo=;
	b=oYh/bS6soSWltLZRBKLAOa6rBQQ0Af7COXIFB4YBUeG25Tlyl7GhoRhiR2dnKXC1WwJm
	 SoeqOJaPvidQrlYmAnX5RyaQZH6U9k+VH/UZdP7HJT+FUPIPP7ib5GQmyfIJcI1M0SA7H
	 1G6Kep1dvz7vvrDc0t+MJRp3qSbJu2SqHUeog/g86wflOtc2oEto9yidpSK/4dh2/+JpS
	 MbiulpFBSEJmqbpj9Hzsr7/UCjoA6c49CSTp0GSnAmy3NZc3WM1txzNehu/bEtaxSeDev
	 Sxx0cqunzdEI17XZBymXq8B3QY8BtPiCqLSyuw9LCP22Pq6lsnDWX8cj33TQJ0jNHng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PQZnsF96;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F733606A32A;
	Sun, 22 Nov 2026 17:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PQZnsF96
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624241F000C0;
	Sun, 22 Nov 2026 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795367670;
	bh=dU4AnwmLGZcCLEgn4j/Dnq8k5fc0kQq7mg6yNhHToxo=;
	h=Date:To:From:Subject;
	b=PQZnsF96mlHKqYI50Q/1D3eKgeAaa0Qu8o9y2WLS7zwPvftoap5/2eF/abZhd72GK
	 HfhFSJWMe+4LUS5ftYsStqcbnC7YGtT/axS2+IrTG0bXgd1dzT6+MOmNyUMZxkeN03
	 8/3OH27iyTl6Nv7MMS5eE3Tv61vXfytTZClnXY0s=
Date: Sun, 22 Nov 2026 09:14:29 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	shuah@kernel.org,rppt@kernel.org,rcampbell@nvidia.com,mpenttil@redhat.com,
	mhocko@suse.com,liam@infradead.org,leon@kernel.org,jm5905938@gmail.com,
	jgg@ziepe.ca,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch added to mm-unstable branch
Message-Id: <20261122171430.624241F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/test_hmm: invalidate all mirrors on device-private migration
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch

This patch will later appear in the mm-unstable branch at
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
+
+			page = BACKING_PAGE(&folio->page) +
+				folio_page_idx(folio, page);
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

maintainers-add-page_exth-to-memory-management-page-allocator.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
selinux-recheck-backing-file-permissions-on-remap_file_pages.patch
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix.patch
mm-highmem-reject-previously-poisoned-pages-in-machine-check-copies.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


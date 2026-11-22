Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795341240;
	b=2B667ZMLE/O0F/6Kl0hmU5TD9uMSxlUzYPalq9BvoXYPVQ6ltp2QCdeoIFPt08+QE2ag
	 avEmkB8fL0g88JfU5PXR1K1oAdqkf/Moi/YFSZd6zRKKgF2jcTSJpaBQ2nlU6n444gWyW
	 DTmQ0glnD6XSom6h35j6xHJaZF/IKNAZqK73u3W59oasCpAFW0Kutn76K4dCtDcdHY6L6
	 vMctEjtkVAmiHjSkFVJz1s69ShGHPJ05+Zd9/60tlIrYs52VYgUvM9Ri1XT/ce1JDF5Ix
	 d7GJKR5/R7G/8Y5YvnhqjJOnCULRQbOYN0nIkc39yQTYP/odyEc2Dve3JVMcqvL7q/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795341240;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/TJieyUKGdG1gIA3jftlvGU9QA5o6LdGVm+821X58yQ=;
	b=C1OUYiYGYtd+vg/lCd4Vja0IizngAbep5YE9p4YhyesYfsAnzhZ4iy5bK9SfWZxLAKCL
	 6/W9okAafVbEaaqaAUV9Pp7Fr311Vi1iM5njLtqPNCAZl4a+Ni0/15PIYV8rzZsvWssf7
	 IK7WbCVvq12ap6NzSxHlaeWaHX+SSqubMvS4HTudJ61j2FoL+5a9WPV/jXAEG9DqLrhLE
	 OA8mu9JJYpoPu2ESuvEfD7WNSJy0+pMIuFKpYXAFADVEeuWtcnU0fQYwDtzZ7KDy4axAc
	 nJj08ZxaDW0/9IvVt9jXovIfZWwFcjaCxCDa6J1qg0K7aeG90gFpiTHweFBkS/Li4uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QfEBkMTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64ED606A320;
	Sun, 22 Nov 2026 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QfEBkMTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FB31F000C4;
	Sun, 22 Nov 2026 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795341240;
	bh=/TJieyUKGdG1gIA3jftlvGU9QA5o6LdGVm+821X58yQ=;
	h=Date:To:From:Subject;
	b=QfEBkMTdUddnWQkuxdQFZ4mP2VTCH0sIlJ5D1yTfu44UAQBMBFf5dUH/EDvEqnA+/
	 ybIpsXP1hGEfq7C7I6KCivbIeAzOG173RBnOZOpNYQ1ZWqjOdNZdRgJohJmJwTJy21
	 T2XgS3xEZz6OxjjRpbj6GpDVLkUtp/7LVcZnbXXo=
Date: Sun, 22 Nov 2026 01:53:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,
	mpenttil@redhat.com,leon@kernel.org,jgg@ziepe.ca,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-use-backing-pages-for-device-private-mirror-faults.patch added to mm-unstable branch
Message-Id: <20261122095400.05FB31F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/test_hmm: use backing pages for device-private mirror faults
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-use-backing-pages-for-device-private-mirror-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-use-backing-pages-for-device-private-mirror-faults.patch

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
Subject: lib/test_hmm: use backing pages for device-private mirror faults
Date: Sat, 21 Nov 2026 17:06:45 -0800

When one hmm_dmirror descriptor migrates memory to device-private and a
second descriptor reads it, dmirror_do_fault() stores the device page in
the second descriptor's page table.  dmirror_do_read() then passes that
page to memcpy_from_page(), which can oops the kernel.  This was
reproduced with an unprivileged process using the fake device in a QEMU
guest.

Store the corresponding RAM backing page instead.  For a large device
folio, retain the subpage offset when selecting the backing page; using
the backing folio's head for every entry would return the wrong data. 
Extend the existing PMD migration selftest to read the last subpage
through a second open before faulting the memory back to RAM.

Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: <stable@vger.kernel.org>
---
tl;dr: The unpatched kernel oopsed when an unprivileged process opened the
fake HMM device twice, migrated an anonymous 2 MB PMD to device-private
memory through one descriptor, then accessed its last page through the
other.  The patched kernel returned the expected bytes on all three ioctl
paths.

A was reproduced and saved before B was built.  As uid 65534, a static
userspace program verified that all 512 pages were device-private PMD
entries.  A READ of the last page through the second descriptor produced a
KASAN-enabled kernel Oops in dmirror_do_read().  Independent A boots also
oopsed on WRITE and READ_UNLOCKED at the same last-page access.

With only this patch added, READ and READ_UNLOCKED returned the expected
0x0a byte, and WRITE returned the expected 0xa5 byte after migration back
to RAM.  The modified in-tree hmm_device_private.migrate_anon_huge_fault
selftest also passed (1/1).

This reproduces a userspace-triggered kernel Oops in the fake HMM device
used by test_hmm; it does not establish reachability through physical GPU
hardware.  QEMU guests used matching kernel configurations with
CONFIG_TEST_HMM=y and KASAN.  The guest device permissions were set for
uid 65534.

 lib/test_hmm.c                         |    7 +++++++
 tools/testing/selftests/mm/hmm-tests.c |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

--- a/lib/test_hmm.c~lib-test_hmm-use-backing-pages-for-device-private-mirror-faults
+++ a/lib/test_hmm.c
@@ -292,6 +292,13 @@ static int dmirror_do_fault(struct dmirr
 		page = hmm_pfn_to_page(*pfns);
 		WARN_ON(!page);
 
+		if (is_device_private_page(page)) {
+			struct folio *folio = page_folio(page);
+			struct page *backing = BACKING_PAGE(&folio->page);
+
+			page = folio_page(page_folio(backing),
+					  folio_page_idx(folio, page));
+		}
 		entry = page;
 		if (*pfns & HMM_PFN_WRITE)
 			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
--- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-use-backing-pages-for-device-private-mirror-faults
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	void *old_ptr;
 	void *map;
 	int pagemap_fd;
+	int fd2 = -1;
 	int *ptr;
 	int ret;
 
@@ -2143,12 +2144,25 @@ TEST_F(hmm, migrate_anon_huge_fault)
 		}
 
 		close(pagemap_fd);
+
+		/* A second open must read the last device-private subpage. */
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
 
+	if (fd2 >= 0)
+		ASSERT_EQ(close(fd2), 0);
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
lib-test_hmm-use-backing-pages-for-device-private-mirror-faults.patch
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


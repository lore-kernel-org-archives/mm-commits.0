From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch added to -mm tree
Date: Thu, 09 Jul 2020 16:46:36 -0700
Message-ID: <20200709234636.33ICykpjo%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgGIXqi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:46:38 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.ibm.com, hch@lst.de, jgg@mellanox.com, jglisse@redhat.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org


The patch titled
     Subject: mm/migrate: add migrate-shared test for migrate_vma_*()
has been added to the -mm tree.  Its filename is
     mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: add migrate-shared test for migrate_vma_*()

Add a migrate_vma_*() self test for mmap(MAP_SHARED) to verify that
!vma_anonymous() ranges won't be migrated.

Link: http://lkml.kernel.org/r/20200709165711.26584-3-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Bharata B Rao" <bharata@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |   35 +++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/tools/testing/selftests/vm/hmm-tests.c~mm-migrate-add-migrate-shared-test-for-migrate_vma_
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -932,6 +932,41 @@ TEST_F(hmm, migrate_fault)
 }
 
 /*
+ * Migrate anonymous shared memory to device private memory.
+ */
+TEST_F(hmm, migrate_shared)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	int ret;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_SHARED | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Migrate memory to device. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_MIGRATE, buffer, npages);
+	ASSERT_EQ(ret, -ENOENT);
+
+	hmm_buffer_free(buffer);
+}
+
+/*
  * Try to migrate various memory types to device private memory.
  */
 TEST_F(hmm2, migrate_mixed)
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-remove-redundant-check-non_swap_entry.patch
mm-migrate-optimize-migrate_vma_setup-for-holes.patch
mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475F6C25B0E
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 00:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiHQACV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbiHQACU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 20:02:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3707092F5D
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 17:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBF0860C79
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 00:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1540EC433D6;
        Wed, 17 Aug 2022 00:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660694538;
        bh=4UqCp4fvqR4b2Z/DGqkLnfUnKEggGQlH+ONOWX/jcJQ=;
        h=Date:To:From:Subject:From;
        b=imF1C96BnhRcEEa/ltGKSJ3kXk7EjjrBymmhXXLYQWrqiS4xebxl07jspGZlhzEdy
         gARB5IPhTv5PjrZybf3MT1wCLFhMouUu5IgX0YYFcQ+8Sf4+jt106A5wO0O9q0vzl4
         EAiM3fcsRl4MMVGiVsyIhn2yK+czs7ymLjQYWLP0=
Date:   Tue, 16 Aug 2022 17:02:17 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rcampbell@nvidia.com, peterx@redhat.com,
        paulus@ozlabs.org, lyude@redhat.com, logang@deltatee.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jgg@nvidia.com,
        felix.kuehling@amd.com, david@redhat.com, bskeggs@redhat.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-hmm-tests-add-test-for-dirty-bits.patch added to mm-unstable branch
Message-Id: <20220817000218.1540EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/hmm-tests: add test for dirty bits
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-hmm-tests-add-test-for-dirty-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-hmm-tests-add-test-for-dirty-bits.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: selftests/hmm-tests: add test for dirty bits
Date: Tue, 16 Aug 2022 17:39:25 +1000

We were not correctly copying PTE dirty bits to pages during
migrate_vma_setup() calls.  This could potentially lead to data loss, so
add a test for this.

Link: https://lkml.kernel.org/r/23069a5c6e07d16d4c4f0951ff003591ffc4f656.1660635033.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |  124 +++++++++++++++++++++++
 1 file changed, 124 insertions(+)

--- a/tools/testing/selftests/vm/hmm-tests.c~selftests-hmm-tests-add-test-for-dirty-bits
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -1240,6 +1240,130 @@ TEST_F(hmm, migrate_multiple)
 	}
 }
 
+static char cgroup[] = "/sys/fs/cgroup/hmm-test-XXXXXX";
+static int write_cgroup_param(char *cgroup_path, char *param, long value)
+{
+	int ret;
+	FILE *f;
+	char *filename;
+
+	if (asprintf(&filename, "%s/%s", cgroup_path, param) < 0)
+		return -1;
+
+	f = fopen(filename, "w");
+	if (!f) {
+		ret = -1;
+		goto out;
+	}
+
+	ret = fprintf(f, "%ld\n", value);
+	if (ret < 0)
+		goto out1;
+
+	ret = 0;
+
+out1:
+	fclose(f);
+out:
+	free(filename);
+
+	return ret;
+}
+
+static int setup_cgroup(void)
+{
+	pid_t pid = getpid();
+	int ret;
+
+	if (!mkdtemp(cgroup))
+		return -1;
+
+	ret = write_cgroup_param(cgroup, "cgroup.procs", pid);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int destroy_cgroup(void)
+{
+	pid_t pid = getpid();
+	int ret;
+
+	ret = write_cgroup_param("/sys/fs/cgroup/cgroup.procs",
+				"cgroup.proc", pid);
+	if (ret)
+		return ret;
+
+	if (rmdir(cgroup))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Try and migrate a dirty page that has previously been swapped to disk. This
+ * checks that we don't loose dirty bits.
+ */
+TEST_F(hmm, migrate_dirty_page)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int tmp = 0;
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
+	ASSERT_EQ(setup_cgroup(), 0);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = 0;
+
+	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
+
+	/* Fault pages back in from swap as clean pages */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		tmp += ptr[i];
+
+	/* Dirty the pte */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/*
+	 * Attempt to migrate memory to device, which should fail because
+	 * hopefully some pages are backed by swap storage.
+	 */
+	ASSERT_TRUE(hmm_migrate_sys_to_dev(self->fd, buffer, npages));
+
+	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
+
+	/* Check we still see the updated data after restoring from swap. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+	destroy_cgroup();
+}
+
 /*
  * Read anonymous memory multiple times.
  */
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch


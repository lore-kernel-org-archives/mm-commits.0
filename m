Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5642CCCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiGRARG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiGRAQs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E24B4A4
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36AAAB80EE9
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F77C341C0;
        Mon, 18 Jul 2022 00:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103400;
        bh=X9rgh/uXJlSrsGx7hi3ZNr2fbNLlguix6V3EjT/CY74=;
        h=Date:To:From:Subject:From;
        b=nQN7OtmDvxoRnIq/eI9mLBrqfB/58b6wfXAOvcbkibaUfsfqLPnVlEU9NPglqkIfy
         yk8oKRjU1U2v+t4h0QyVlKSSywkmulvL7K3/PEyf5S8oVUS1UVHXbR8vqAUbbv7Rpm
         4Td1H2/lE1iqHhojxtHU6f57qE2/3w7XI+JxOFSc=
Date:   Sun, 17 Jul 2022 17:16:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-add-selftests-to-hmm-for-cow-in-device-memory.patch removed from -mm tree
Message-Id: <20220718001639.E0F77C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools: add selftests to hmm for COW in device memory
has been removed from the -mm tree.  Its filename was
     tools-add-selftests-to-hmm-for-cow-in-device-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: tools: add selftests to hmm for COW in device memory
Date: Fri, 15 Jul 2022 10:05:21 -0500

The objective is to test device migration mechanism in pages marked as
COW, for private and coherent device type.  In case of writing to COW
private page(s), a page fault will migrate pages back to system memory
first.  Then, these pages will be duplicated.  In case of COW device
coherent type, pages are duplicated directly from device memory.

Link: https://lkml.kernel.org/r/20220715150521.18165-15-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |   80 +++++++++++++++++++++++
 1 file changed, 80 insertions(+)

--- a/tools/testing/selftests/vm/hmm-tests.c~tools-add-selftests-to-hmm-for-cow-in-device-memory
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -1874,4 +1874,84 @@ TEST_F(hmm, hmm_gup_test)
 	close(gup_fd);
 	hmm_buffer_free(buffer);
 }
+
+/*
+ * Test copy-on-write in device pages.
+ * In case of writing to COW private page(s), a page fault will migrate pages
+ * back to system memory first. Then, these pages will be duplicated. In case
+ * of COW device coherent type, pages are duplicated directly from device
+ * memory.
+ */
+TEST_F(hmm, hmm_cow_in_device)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+	unsigned char *m;
+	pid_t pid;
+	int status;
+
+	npages = 4;
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
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	pid = fork();
+	if (pid == -1)
+		ASSERT_EQ(pid, 0);
+	if (!pid) {
+		/* Child process waitd for SIGTERM from the parent. */
+		while (1) {
+		}
+		perror("Should not reach this\n");
+		exit(0);
+	}
+	/* Parent process writes to COW pages(s) and gets a
+	 * new copy in system. In case of device private pages,
+	 * this write causes a migration to system mem first.
+	 */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Terminate child and wait */
+	EXPECT_EQ(0, kill(pid, SIGTERM));
+	EXPECT_EQ(pid, waitpid(pid, &status, 0));
+	EXPECT_NE(0, WIFSIGNALED(status));
+	EXPECT_EQ(SIGTERM, WTERMSIG(status));
+
+	/* Take snapshot to CPU pagetables */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+	m = buffer->mirror;
+	for (i = 0; i < npages; i++)
+		ASSERT_EQ(HMM_DMIRROR_PROT_WRITE, m[i]);
+
+	hmm_buffer_free(buffer);
+}
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from alex.sierra@amd.com are



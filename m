Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E29BC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 20:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347678AbiEaUXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 16:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347730AbiEaUXd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 16:23:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AA458E5A
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 13:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 796BBB815F8
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 20:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E23BC385A9;
        Tue, 31 May 2022 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654028608;
        bh=D6++Q0jP5e6Vcm3seecvL70BXWHTTJybf9Ye981QDMo=;
        h=Date:To:From:Subject:From;
        b=QuTf1KbcslwfKIOOzk4Q8dr1aImNYEMuk5XvC0azQCH+hYHAXTk18uwqlH2v+X22V
         pr142MJ17/9T+8j4QiDuOAsszbhnq/tZjP3MY3xZm+9eQeY6LzGRzqxcqINKNA11Rb
         E++MT0ZCOkQ3pLMRYOpVVZPaaqIYpSg/23APVN5U=
Date:   Tue, 31 May 2022 13:23:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-add-selftests-to-hmm-for-cow-in-device-memory.patch added to mm-unstable branch
Message-Id: <20220531202328.1E23BC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: add selftests to hmm for COW in device memory
has been added to the -mm mm-unstable branch.  Its filename is
     tools-add-selftests-to-hmm-for-cow-in-device-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-add-selftests-to-hmm-for-cow-in-device-memory.patch

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
From: Alex Sierra <alex.sierra@amd.com>
Subject: tools: add selftests to hmm for COW in device memory
Date: Tue, 31 May 2022 15:00:41 -0500

The objective is to test device migration mechanism in pages marked as
COW, for private and coherent device type.  In case of writing to COW
private page(s), a page fault will migrate pages back to system memory
first.  Then, these pages will be duplicated.  In case of COW device
coherent type, pages are duplicated directly from device memory.

Link: https://lkml.kernel.org/r/20220531200041.24904-14-alex.sierra@amd.com
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
@@ -1869,4 +1869,84 @@ TEST_F(hmm, hmm_gup_test)
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

mm-add-zone-device-coherent-type-memory-support.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
drm-amdkfd-add-spm-support-for-svm.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch
tools-add-hmm-gup-tests-for-device-coherent-type.patch
tools-add-selftests-to-hmm-for-cow-in-device-memory.patch


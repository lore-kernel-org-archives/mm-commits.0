Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767C8C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiG3BJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239733AbiG3BI4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079198723B
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9577C61C3C
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E959FC433C1;
        Sat, 30 Jul 2022 01:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143323;
        bh=J/jDGBBXSjXI+OZYdzWhEzxrknKpdASPPU/1gPSsHvU=;
        h=Date:To:From:Subject:From;
        b=kQGdL5o7UVHw/qER9lSlp0D5c+vd7U5sKNZzr6HGdgpzlDrx90urCmex2d1xaKfd4
         9VsoixD6Eq8yWr4fCr1S6LmdPWeJdPdsaZ5mHeuHPBlpO0sNWqrK8NcfEp7bcg/scD
         XWKd6AlBOymxw0Rx8rWiw98FwCydKLvHGqRe4m0k=
Date:   Fri, 29 Jul 2022 18:08:42 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-soft-dirty-add-test-for-mprotect.patch removed from -mm tree
Message-Id: <20220730010842.E959FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: soft-dirty: add test for mprotect
has been removed from the -mm tree.  Its filename was
     selftests-soft-dirty-add-test-for-mprotect.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests: soft-dirty: add test for mprotect
Date: Mon, 25 Jul 2022 10:20:47 -0400

Add two soft-dirty test cases for mprotect() on both anon or file.

Link: https://lkml.kernel.org/r/20220725142048.30450-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/soft-dirty.c |   67 +++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/soft-dirty.c~selftests-soft-dirty-add-test-for-mprotect
+++ a/tools/testing/selftests/vm/soft-dirty.c
@@ -121,13 +121,76 @@ static void test_hugepage(int pagemap_fd
 	free(map);
 }
 
+static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
+{
+	const char *type[] = {"file", "anon"};
+	const char *fname = "./soft-dirty-test-file";
+	int test_fd;
+	char *map;
+
+	if (anon) {
+		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
+			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+		if (!map)
+			ksft_exit_fail_msg("anon mmap failed\n");
+	} else {
+		test_fd = open(fname, O_RDWR | O_CREAT);
+		if (test_fd < 0) {
+			ksft_test_result_skip("Test %s open() file failed\n", __func__);
+			return;
+		}
+		unlink(fname);
+		ftruncate(test_fd, pagesize);
+		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
+			   MAP_SHARED, test_fd, 0);
+		if (!map)
+			ksft_exit_fail_msg("file mmap failed\n");
+	}
+
+	*map = 1;
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-%s dirty bit of new written page\n",
+			 __func__, type[anon]);
+	clear_softdirty();
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 0,
+			 "Test %s-%s soft-dirty clear after clear_refs\n",
+			 __func__, type[anon]);
+	mprotect(map, pagesize, PROT_READ);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 0,
+			 "Test %s-%s soft-dirty clear after marking RO\n",
+			 __func__, type[anon]);
+	mprotect(map, pagesize, PROT_READ|PROT_WRITE);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 0,
+			 "Test %s-%s soft-dirty clear after marking RW\n",
+			 __func__, type[anon]);
+	*map = 2;
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-%s soft-dirty after rewritten\n",
+			 __func__, type[anon]);
+
+	munmap(map, pagesize);
+
+	if (!anon)
+		close(test_fd);
+}
+
+static void test_mprotect_anon(int pagemap_fd, int pagesize)
+{
+	test_mprotect(pagemap_fd, pagesize, true);
+}
+
+static void test_mprotect_file(int pagemap_fd, int pagesize)
+{
+	test_mprotect(pagemap_fd, pagesize, false);
+}
+
 int main(int argc, char **argv)
 {
 	int pagemap_fd;
 	int pagesize;
 
 	ksft_print_header();
-	ksft_set_plan(5);
+	ksft_set_plan(15);
 
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
@@ -138,6 +201,8 @@ int main(int argc, char **argv)
 	test_simple(pagemap_fd, pagesize);
 	test_vma_reuse(pagemap_fd, pagesize);
 	test_hugepage(pagemap_fd, pagesize);
+	test_mprotect_anon(pagemap_fd, pagesize);
+	test_mprotect_file(pagemap_fd, pagesize);
 
 	close(pagemap_fd);
 
_

Patches currently in -mm which might be from peterx@redhat.com are



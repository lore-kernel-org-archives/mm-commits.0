Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4A0C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbiGYWLK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiGYWLB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:11:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD616248EF
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46FEA61337
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925B0C341C6;
        Mon, 25 Jul 2022 22:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658787059;
        bh=Jy4esPFMt+ecN940bEi2sR6e2aXbPCvOC1jI+UmnoIY=;
        h=Date:To:From:Subject:From;
        b=DWJ5QCW01LuwsxUMh4H45gvb8ZTyY2KHhNGLiWQs2Ao+VyJAeKqn47QSDsBj1tZCv
         qLSkTnaaGmZR+4RjxFWFzU0tH/bjuBbm2XeF56oLkLAcivob2lMMG4Dn9vy6B7Jyar
         56cI/Ire6ADFfeFxyBGw+YRlrjCHWrGRsTB4PRv0=
Date:   Mon, 25 Jul 2022 15:10:58 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-soft-dirty-add-test-for-mprotect.patch added to mm-unstable branch
Message-Id: <20220725221059.925B0C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: soft-dirty: add test for mprotect
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-soft-dirty-add-test-for-mprotect.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-soft-dirty-add-test-for-mprotect.patch

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

mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch
selftests-soft-dirty-add-test-for-mprotect.patch
selftests-add-soft-dirty-into-run_vmtestssh.patch


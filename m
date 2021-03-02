Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F416BC433E6
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6E1964E02
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbhCCNXu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhCBXwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:52:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46BAD64F2B;
        Tue,  2 Mar 2021 23:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614728368;
        bh=yxB5Wjt/RLrZWFxUjSRHvhjzS41rpwfuzwJ4Ghft3P4=;
        h=Date:From:To:Subject:From;
        b=sT8qN2fgasrkhkjwcKdmJ2OJLYsZAcgrYnWDz0FJok1SZT3MVYVi6QyTq4/zIF5BP
         SDsZ2fDXgXHiiRTA4DUusOAsvKXfQ8OvznmzPtD5jB8hs+mIp323M7u7U7a8CQVdAS
         y3ZgtxQMtV2HaK6X9QIk3d27MCl5LvvIEGVzPs0I=
Date:   Tue, 02 Mar 2021 15:39:26 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com,
        cannonmatthews@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, lokeshgidra@google.com,
        mm-commits@vger.kernel.org, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rppt@linux.vnet.ibm.com, shli@fb.com,
        shuah@kernel.org, viro@zeniv.linux.org.uk, walken@google.com,
        wangqing@vivo.com
Subject:  +
 userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch added to
 -mm tree
Message-ID: <20210302233926.241bJHJvF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: use memfd_create for shmem test type
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: use memfd_create for shmem test type

This is a preparatory commit.  In the future, we want to be able to setup
alias mappings for area_src and area_dst in the shmem test, like we do in
the hugetlb_shared test.  With a VMA obtained via mmap(MAP_ANONYMOUS |
MAP_SHARED), it isn't clear how to do this.

So, mmap() with an fd, so we can create alias mappings.  Use memfd_create
instead of actually passing in a tmpfs path like hugetlb does, since it's
more convenient / simpler to run, and works just as well.

Future commits will:

1. Setup the alias mappings.
2. Extend our tests to actually take advantage of this, to test new
   userfaultfd behavior being introduced in this series.

Also, a small fix in the area we're changing: when the hugetlb setup fails
in main(), pass in the right argv[] so we actually print out the hugetlb
file path.

Link: https://lkml.kernel.org/r/20210302000133.272579-3-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   35 ++++++++++++++++++---
 1 file changed, 30 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-use-memfd_create-for-shmem-test-type
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -85,6 +85,7 @@ static bool test_uffdio_wp = false;
 static bool test_uffdio_minor = false;
 
 static bool map_shared;
+static int shm_fd;
 static int huge_fd;
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
@@ -297,12 +298,20 @@ static int shmem_release_pages(char *rel
 
 static void shmem_allocate_area(void **alloc_area)
 {
+	unsigned long offset =
+		alloc_area == (void **)&area_src ? 0 : nr_pages * page_size;
+
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-			   MAP_ANONYMOUS | MAP_SHARED, -1, 0);
+			   MAP_SHARED, shm_fd, offset);
 	if (*alloc_area == MAP_FAILED) {
-		fprintf(stderr, "shared memory mmap failed\n");
-		*alloc_area = NULL;
+		perror("mmap of memfd failed");
+		goto fail;
 	}
+
+	return;
+
+fail:
+	*alloc_area = NULL;
 }
 
 struct uffd_test_ops {
@@ -1672,15 +1681,31 @@ int main(int argc, char **argv)
 			usage();
 		huge_fd = open(argv[4], O_CREAT | O_RDWR, 0755);
 		if (huge_fd < 0) {
-			fprintf(stderr, "Open of %s failed", argv[3]);
+			fprintf(stderr, "Open of %s failed", argv[4]);
 			perror("open");
 			exit(1);
 		}
 		if (ftruncate(huge_fd, 0)) {
-			fprintf(stderr, "ftruncate %s to size 0 failed", argv[3]);
+			fprintf(stderr, "ftruncate %s to size 0 failed", argv[4]);
 			perror("ftruncate");
 			exit(1);
 		}
+	} else if (test_type == TEST_SHMEM) {
+		shm_fd = memfd_create(argv[0], 0);
+		if (shm_fd < 0) {
+			perror("memfd_create");
+			exit(1);
+		}
+		if (ftruncate(shm_fd, nr_pages * page_size * 2)) {
+			perror("ftruncate");
+			exit(1);
+		}
+		if (fallocate(shm_fd,
+			      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
+			      nr_pages * page_size * 2)) {
+			perror("fallocate");
+			exit(1);
+		}
 	}
 	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
 	       nr_pages, nr_pages_per_cpu);
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch
userfaultfd-support-minor-fault-handling-for-shmem.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch


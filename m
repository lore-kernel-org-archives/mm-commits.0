From: akpm@linux-foundation.org
Subject: [patch 092/119] memfd-test: run fuse test on hugetlb
 backend memory
Date: Wed, 31 Jan 2018 16:19:44 -0800
Message-ID: <20180201001944.nYOO-lhj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755813AbeBAATq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:19:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dh.herrmann@gmail.com, hughd@google.com, marcandre.lureau@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: memfd-test: run fuse test on hugetlb backend memory

Link: http://lkml.kernel.org/r/20171107122800.25517-10-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/fuse_test.c      |   38 +++++++++++----
 tools/testing/selftests/memfd/run_fuse_test.sh |    2 
 tools/testing/selftests/memfd/run_tests.sh     |    1 
 3 files changed, 32 insertions(+), 9 deletions(-)

diff -puN tools/testing/selftests/memfd/fuse_test.c~memfd-test-run-fuse-test-on-hugetlb-backend-memory tools/testing/selftests/memfd/fuse_test.c
--- a/tools/testing/selftests/memfd/fuse_test.c~memfd-test-run-fuse-test-on-hugetlb-backend-memory
+++ a/tools/testing/selftests/memfd/fuse_test.c
@@ -38,6 +38,8 @@
 #define MFD_DEF_SIZE 8192
 #define STACK_SIZE 65536
 
+static size_t mfd_def_size = MFD_DEF_SIZE;
+
 static int mfd_assert_new(const char *name, loff_t sz, unsigned int flags)
 {
 	int r, fd;
@@ -123,7 +125,7 @@ static void *mfd_assert_mmap_shared(int
 	void *p;
 
 	p = mmap(NULL,
-		 MFD_DEF_SIZE,
+		 mfd_def_size,
 		 PROT_READ | PROT_WRITE,
 		 MAP_SHARED,
 		 fd,
@@ -141,7 +143,7 @@ static void *mfd_assert_mmap_private(int
 	void *p;
 
 	p = mmap(NULL,
-		 MFD_DEF_SIZE,
+		 mfd_def_size,
 		 PROT_READ | PROT_WRITE,
 		 MAP_PRIVATE,
 		 fd,
@@ -174,7 +176,7 @@ static int sealing_thread_fn(void *arg)
 	usleep(200000);
 
 	/* unmount mapping before sealing to avoid i_mmap_writable failures */
-	munmap(global_p, MFD_DEF_SIZE);
+	munmap(global_p, mfd_def_size);
 
 	/* Try sealing the global file; expect EBUSY or success. Current
 	 * kernels will never succeed, but in the future, kernels might
@@ -224,7 +226,7 @@ static void join_sealing_thread(pid_t pi
 
 int main(int argc, char **argv)
 {
-	static const char zero[MFD_DEF_SIZE];
+	char *zero;
 	int fd, mfd, r;
 	void *p;
 	int was_sealed;
@@ -235,6 +237,25 @@ int main(int argc, char **argv)
 		abort();
 	}
 
+	if (argc >= 3) {
+		if (!strcmp(argv[2], "hugetlbfs")) {
+			unsigned long hpage_size = default_huge_page_size();
+
+			if (!hpage_size) {
+				printf("Unable to determine huge page size\n");
+				abort();
+			}
+
+			hugetlbfs_test = 1;
+			mfd_def_size = hpage_size * 2;
+		} else {
+			printf("Unknown option: %s\n", argv[2]);
+			abort();
+		}
+	}
+
+	zero = calloc(sizeof(*zero), mfd_def_size);
+
 	/* open FUSE memfd file for GUP testing */
 	printf("opening: %s\n", argv[1]);
 	fd = open(argv[1], O_RDONLY | O_CLOEXEC);
@@ -245,7 +266,7 @@ int main(int argc, char **argv)
 
 	/* create new memfd-object */
 	mfd = mfd_assert_new("kern_memfd_fuse",
-			     MFD_DEF_SIZE,
+			     mfd_def_size,
 			     MFD_CLOEXEC | MFD_ALLOW_SEALING);
 
 	/* mmap memfd-object for writing */
@@ -264,7 +285,7 @@ int main(int argc, char **argv)
 	 * This guarantees that the receive-buffer is pinned for 1s until the
 	 * data is written into it. The racing ADD_SEALS should thus fail as
 	 * the pages are still pinned. */
-	r = read(fd, p, MFD_DEF_SIZE);
+	r = read(fd, p, mfd_def_size);
 	if (r < 0) {
 		printf("read() failed: %m\n");
 		abort();
@@ -291,10 +312,10 @@ int main(int argc, char **argv)
 	 * enough to avoid any in-flight writes. */
 
 	p = mfd_assert_mmap_private(mfd);
-	if (was_sealed && memcmp(p, zero, MFD_DEF_SIZE)) {
+	if (was_sealed && memcmp(p, zero, mfd_def_size)) {
 		printf("memfd sealed during read() but data not discarded\n");
 		abort();
-	} else if (!was_sealed && !memcmp(p, zero, MFD_DEF_SIZE)) {
+	} else if (!was_sealed && !memcmp(p, zero, mfd_def_size)) {
 		printf("memfd sealed after read() but data discarded\n");
 		abort();
 	}
@@ -303,6 +324,7 @@ int main(int argc, char **argv)
 	close(fd);
 
 	printf("fuse: DONE\n");
+	free(zero);
 
 	return 0;
 }
diff -puN tools/testing/selftests/memfd/run_fuse_test.sh~memfd-test-run-fuse-test-on-hugetlb-backend-memory tools/testing/selftests/memfd/run_fuse_test.sh
--- a/tools/testing/selftests/memfd/run_fuse_test.sh~memfd-test-run-fuse-test-on-hugetlb-backend-memory
+++ a/tools/testing/selftests/memfd/run_fuse_test.sh
@@ -10,6 +10,6 @@ set -e
 
 mkdir mnt
 ./fuse_mnt ./mnt
-./fuse_test ./mnt/memfd
+./fuse_test ./mnt/memfd $@
 fusermount -u ./mnt
 rmdir ./mnt
diff -puN tools/testing/selftests/memfd/run_tests.sh~memfd-test-run-fuse-test-on-hugetlb-backend-memory tools/testing/selftests/memfd/run_tests.sh
--- a/tools/testing/selftests/memfd/run_tests.sh~memfd-test-run-fuse-test-on-hugetlb-backend-memory
+++ a/tools/testing/selftests/memfd/run_tests.sh
@@ -60,6 +60,7 @@ fi
 # Run the hugetlbfs test
 #
 ./memfd_test hugetlbfs
+./run_fuse_test.sh hugetlbfs
 
 #
 # Give back any huge pages allocated for the test
_

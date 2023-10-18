Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6E8C41513
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 20:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjJRU11 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 16:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjJRU1P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 16:27:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFC69F
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 13:27:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0900AC433C9;
        Wed, 18 Oct 2023 20:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697660833;
        bh=NzrVOC6JbrOvC763QdlnK47INIcCKqEHbU+7VdfFu2k=;
        h=Date:To:From:Subject:From;
        b=E14jVlpMk2SbVfNp48Kb5S0/7TKdfo2PkyaA6Vog5DZ5Qs/nEP44GMtGOOJztE0hs
         hHRjC8LMuAV0j9Gu9J1dHTTp/jAcoVjg6nSiDzuirF+Zqkqfslg62akmzoHG5HDZ15
         z/69PKcPPVfY+srBOypL+rnG/yc4Vczucr9uHFQ4=
Date:   Wed, 18 Oct 2023 13:27:12 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        mike.kravetz@oracle.com, kraxel@redhat.com,
        junxiao.chang@intel.com, jgg@nvidia.com, hughd@google.com,
        dongwon.kim@intel.com, david@redhat.com, daniel.vetter@ffwll.ch,
        vivek.kasireddy@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-dma-buf-udmabuf-add-tests-to-verify-data-after-page-migration.patch removed from -mm tree
Message-Id: <20231018202713.0900AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/dma-buf/udmabuf: add tests to verify data after page migration
has been removed from the -mm tree.  Its filename was
     selftests-dma-buf-udmabuf-add-tests-to-verify-data-after-page-migration.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: selftests/dma-buf/udmabuf: add tests to verify data after page migration
Date: Tue, 3 Oct 2023 00:44:47 -0700

Since the memfd pages associated with a udmabuf may be migrated as part of
udmabuf create, we need to verify the data coherency after successful
migration.  The new tests added in this patch try to do just that using 4k
sized pages and also 2 MB sized huge pages for the memfd.

Successful completion of the tests would mean that there is no disconnect
between the memfd pages and the ones associated with a udmabuf.  And,
these tests can also be augmented in the future to test newer udmabuf
features (such as handling memfd hole punch).

Based on a patch by Mike Kravetz.

Link: https://lkml.kernel.org/r/20231003074447.3245729-4-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/drivers/dma-buf/udmabuf.c |  151 +++++++++++-
 1 file changed, 147 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/drivers/dma-buf/udmabuf.c~selftests-dma-buf-udmabuf-add-tests-to-verify-data-after-page-migration
+++ a/tools/testing/selftests/drivers/dma-buf/udmabuf.c
@@ -9,26 +9,132 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <malloc.h>
+#include <stdbool.h>
 
 #include <sys/ioctl.h>
 #include <sys/syscall.h>
+#include <sys/mman.h>
 #include <linux/memfd.h>
 #include <linux/udmabuf.h>
 
 #define TEST_PREFIX	"drivers/dma-buf/udmabuf"
 #define NUM_PAGES       4
+#define NUM_ENTRIES     4
+#define MEMFD_SIZE      1024 /* in pages */
 
-static int memfd_create(const char *name, unsigned int flags)
+static unsigned int page_size;
+
+static int create_memfd_with_seals(off64_t size, bool hpage)
+{
+	int memfd, ret;
+	unsigned int flags = MFD_ALLOW_SEALING;
+
+	if (hpage)
+		flags |= MFD_HUGETLB;
+
+	memfd = memfd_create("udmabuf-test", flags);
+	if (memfd < 0) {
+		printf("%s: [skip,no-memfd]\n", TEST_PREFIX);
+		exit(77);
+	}
+
+	ret = fcntl(memfd, F_ADD_SEALS, F_SEAL_SHRINK);
+	if (ret < 0) {
+		printf("%s: [skip,fcntl-add-seals]\n", TEST_PREFIX);
+		exit(77);
+	}
+
+	ret = ftruncate(memfd, size);
+	if (ret == -1) {
+		printf("%s: [FAIL,memfd-truncate]\n", TEST_PREFIX);
+		exit(1);
+	}
+
+	return memfd;
+}
+
+static int create_udmabuf_list(int devfd, int memfd, off64_t memfd_size)
+{
+	struct udmabuf_create_list *list;
+	int ubuf_fd, i;
+
+	list = malloc(sizeof(struct udmabuf_create_list) +
+		      sizeof(struct udmabuf_create_item) * NUM_ENTRIES);
+	if (!list) {
+		printf("%s: [FAIL, udmabuf-malloc]\n", TEST_PREFIX);
+		exit(1);
+	}
+
+	for (i = 0; i < NUM_ENTRIES; i++) {
+		list->list[i].memfd  = memfd;
+		list->list[i].offset = i * (memfd_size / NUM_ENTRIES);
+		list->list[i].size   = getpagesize() * NUM_PAGES;
+	}
+
+	list->count = NUM_ENTRIES;
+	list->flags = UDMABUF_FLAGS_CLOEXEC;
+	ubuf_fd = ioctl(devfd, UDMABUF_CREATE_LIST, list);
+	free(list);
+	if (ubuf_fd < 0) {
+		printf("%s: [FAIL, udmabuf-create]\n", TEST_PREFIX);
+		exit(1);
+	}
+
+	return ubuf_fd;
+}
+
+static void write_to_memfd(void *addr, off64_t size, char chr)
 {
-	return syscall(__NR_memfd_create, name, flags);
+	int i;
+
+	for (i = 0; i < size / page_size; i++) {
+		*((char *)addr + (i * page_size)) = chr;
+	}
+}
+
+static void *mmap_fd(int fd, off64_t size)
+{
+	void *addr;
+
+	addr = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		printf("%s: ubuf_fd mmap fail\n", TEST_PREFIX);
+		exit(1);
+	}
+
+	return addr;
+}
+
+static int compare_chunks(void *addr1, void *addr2, off64_t memfd_size)
+{
+	off64_t off;
+	int i = 0, j, k = 0, ret = 0;
+	char char1, char2;
+
+	while (i < NUM_ENTRIES) {
+		off = i * (memfd_size / NUM_ENTRIES);
+		for (j = 0; j < NUM_PAGES; j++, k++) {
+			char1 = *((char *)addr1 + off + (j * getpagesize()));
+			char2 = *((char *)addr2 + (k * getpagesize()));
+			if (char1 != char2) {
+				ret = -1;
+				goto err;
+			}
+		}
+		i++;
+	}
+err:
+	munmap(addr1, memfd_size);
+	munmap(addr2, NUM_ENTRIES * NUM_PAGES * getpagesize());
+	return ret;
 }
 
 int main(int argc, char *argv[])
 {
 	struct udmabuf_create create;
 	int devfd, memfd, buf, ret;
-	off_t size;
-	void *mem;
+	off64_t size;
+	void *addr1, *addr2;
 
 	devfd = open("/dev/udmabuf", O_RDWR);
 	if (devfd < 0) {
@@ -90,6 +196,9 @@ int main(int argc, char *argv[])
 	}
 
 	/* should work */
+	page_size = getpagesize();
+	addr1 = mmap_fd(memfd, size);
+	write_to_memfd(addr1, size, 'a');
 	create.memfd  = memfd;
 	create.offset = 0;
 	create.size   = size;
@@ -98,6 +207,40 @@ int main(int argc, char *argv[])
 		printf("%s: [FAIL,test-4]\n", TEST_PREFIX);
 		exit(1);
 	}
+	munmap(addr1, size);
+	close(buf);
+	close(memfd);
+
+	/* should work (migration of 4k size pages)*/
+	size = MEMFD_SIZE * page_size;
+	memfd = create_memfd_with_seals(size, false);
+	addr1 = mmap_fd(memfd, size);
+	write_to_memfd(addr1, size, 'a');
+	buf = create_udmabuf_list(devfd, memfd, size);
+	addr2 = mmap_fd(buf, NUM_PAGES * NUM_ENTRIES * getpagesize());
+	write_to_memfd(addr1, size, 'b');
+	ret = compare_chunks(addr1, addr2, size);
+	if (ret < 0) {
+		printf("%s: [FAIL,test-5]\n", TEST_PREFIX);
+		exit(1);
+	}
+	close(buf);
+	close(memfd);
+
+	/* should work (migration of 2MB size huge pages)*/
+	page_size = getpagesize() * 512; /* 2 MB */
+	size = MEMFD_SIZE * page_size;
+	memfd = create_memfd_with_seals(size, true);
+	addr1 = mmap_fd(memfd, size);
+	write_to_memfd(addr1, size, 'a');
+	buf = create_udmabuf_list(devfd, memfd, size);
+	addr2 = mmap_fd(buf, NUM_PAGES * NUM_ENTRIES * getpagesize());
+	write_to_memfd(addr1, size, 'b');
+	ret = compare_chunks(addr1, addr2, size);
+	if (ret < 0) {
+		printf("%s: [FAIL,test-6]\n", TEST_PREFIX);
+		exit(1);
+	}
 
 	fprintf(stderr, "%s: ok\n", TEST_PREFIX);
 	close(buf);
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are



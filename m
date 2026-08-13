Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CC23D0932
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786643748; cv=none; b=icRDxzyZnGcFuRu4yt8Ov/vqZYuci7P6s+Pskm6X4lNxW1mLdvLJEMEklrDCtxZkDVBYhHZU2EDuw4SxQI8kcfdPNvgnBlu9vj8vS2G5uUX++iPsCY9JZEQ1Q8C6tfLH0iwKUrRGMwFBrv1HexOZe5+6TdPv8i1fNWZ8EqcyjNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786643748; c=relaxed/simple;
	bh=25eGcEiWHkAwE34jqMMS8tioTj0ikVMDbNyZP8SGMO8=;
	h=Date:To:From:Subject:Message-Id; b=anbmQHmUV28EXQdILQFUSiwI+5llbg1hf1kS92BEpjkO/LL/I6gZfIgPMOTnAkHsDiKoQySm+YLoujd1sHdWcTXim9NFk9CCp19Jo4aGOmtlIXyh3W8WKRscGiN6kGOXfLvBD1hQlgNnKkBlUJNMfudh1F2ioNUf87Tg8SK5q0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LWwbSNpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LWwbSNpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05921F000E9;
	Thu, 13 Aug 2026 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786643739;
	bh=PVxA+u26vwhP4KB+CVfs5xVnrZernntiHwArtILlioU=;
	h=Date:To:From:Subject;
	b=LWwbSNpYBDaSTiud9+/KDC+ABK4ygte2a8KaGUIgkv62hQHbgT7x/laAH3bTxD+3+
	 B+GURL7/8SHsMScUM+LSqK42xgtZEN3tRVsiAymJrn1sP9TY50s+DWE4NEXVEHMOqs
	 8P1XPWJjgTdQhpOxmyTGtY5zZah7/XhEWiF/FkkA=
Date: Thu, 13 Aug 2026 10:55:39 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch removed from -mm tree
Message-Id: <20260813175539.D05921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
Date: Thu, 06 Aug 2026 21:21:44 +0100

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add
a VMA userland test to assert that this is the case and everything is as
we would expect for an anonymous mapping.

Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-19-ab318a350404@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price (Meta) <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: <syzbot@syzkaller.appspotmail.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |    1 
 tools/testing/vma/tests/mmap.c  |   50 ++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

--- a/tools/testing/vma/include/dup.h~tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon
+++ a/tools/testing/vma/include/dup.h
@@ -20,6 +20,7 @@ struct task_struct *get_current(void);
 
 #define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+#define MKDEV(ma, mi)	(((ma) << MINORBITS) | (mi))
 
 #define S_IFMT  00170000
 #define S_IFCHR  0020000
--- a/tools/testing/vma/tests/mmap.c~tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon
+++ a/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,57 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static int dummy_mmap_prepare(struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	const struct file_operations f_op = {
+		.mmap_prepare = dummy_mmap_prepare,
+	};
+	struct inode inode = {
+		.i_mode = S_IFCHR,
+		.i_rdev = MKDEV(MEM_MAJOR, DEVZERO_MINOR),
+	};
+	struct file file = {
+		.f_inode = &inode,
+		.f_op = &f_op,
+	};
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/*
+	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
+	 * offset of 0x10, which we expect to be reset to the anonymous page
+	 * offset.
+	 */
+	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Assert that it truly is an anonymous mapping. */
+	vma = vma_lookup(&mm, addr);
+	ASSERT_NE(vma, NULL);
+	ASSERT_TRUE(vma_is_anonymous(vma));
+	ASSERT_EQ(vma->vm_file, NULL);
+	ASSERT_EQ(vma->vm_private_data, NULL);
+	/* Expect anonymous page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(pure_anon_dev_zero);
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch
maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch


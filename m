Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454FB33A9E2
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622305; cv=none; b=LJMugytRtfz80HaPbwcsWelTZmfp700Iqrl2PSUDt1FCdVe3/WbdlTh6lSp5qxR++9KDNGZ0C/kWaB86xD0ZDgZYIZzEI2DHZz3Z40I2PW1GLOhJ9Zw0xXXAiDh2ptdMrA4Fb9l9l/79PTlRbKhIxNblaiaipFTmXpinLrb9UxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622305; c=relaxed/simple;
	bh=x4QJpSGFFm5paxdkxqOO1J/Xk24ryhbhG6vNU5gPdWc=;
	h=Date:To:From:Subject:Message-Id; b=blZTOl4LXhitfbYvDq/I5E+iIc568Q3KC/veSR00uA7sCRtT52F9JRiaNgQG1HnsHLHN8ET/8NL0s98eEro7rzw6nTasP/ShlwB66rK0S9QXGs08JIH7r/cdIp4JP5qIuH67dbF7IVFZCW+d+SuaFUMnNdV6rqTgRtVeWopvOI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pWOpeFpA reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWOpeFpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F711F00A3A;
	Tue, 25 Aug 2026 01:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622303;
	bh=lA35SuDUjp/6Bdp9rHozxMGxlWTZM4SjARJTcd2Ucjk=;
	h=Date:To:From:Subject;
	b=pWOpeFpA/uWLQozVdrJg63hGEJ7U80nwRmzTdypTNb0Sw07QI5JwtGuPvOPsDRxEp
	 fn6Nzhyyu4YTOWHIOqej24DP/d4Ct19Cq3/43fR/bYWjuYfkqizn+rcSlZFKFtQwpl
	 m5H2MI9XG0GS1m3/R62sYwxkyaHzGRdqPufdZLS4=
Date: Mon, 24 Aug 2026 18:45:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,vbabka@kernel.org,tzimmermann@suse.de,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,surenb@google.com,steven.price@arm.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,rodrigo.vivi@intel.com,riel@surriel.com,Ray.Huang@amd.com,rakie.kim@sk.com,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,oleg@redhat.com,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mingo@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,matthew.auld@intel.com,mark.rutland@arm.com,maarten.lankhorst@linux.intel.com,liviu.dudau@arm.com,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,jolsa@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.clark@linaro.org,jack@suse.cz,iroger
 s@google.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,harry@kernel.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@kernel.org,christian.koenig@amd.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,borntraeger@linux.ibm.com,boris.brezillon@collabora.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,apopple@nvidia.com,alexander.shishkin@linux.intel.com,alexander.deucher@amd.com,airlied@gmail.com,agordeev@linux.ibm.com,adrian.hunter@intel.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch removed from -mm tree
Message-Id: <20260825014503.15F711F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests/mm: test anonymous page offset merge behaviour
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/selftests/mm: test anonymous page offset merge behaviour
Date: Thu, 13 Aug 2026 18:32:33 +0100

While maintaining anonymous page offsets for VMAs has no impact for most
merge cases, it does impact MAP_PRIVATE-mapped file-backed mappings which
happen to have matching page offset but not matching anonymous page
offset.

Assert this behaviour by attempting to map an unfaulted MAP_PRIVATE-memfd
region with a faulted one with compatible file page offsets but
incompatible anonymous page offsets.

Link: https://lore.kernel.org/20260813-b4-scalable-cow-virt-pgoff-v5-16-c21581c0c3c8@kernel.org
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
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   57 +++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour
+++ a/tools/testing/selftests/mm/merge.c
@@ -1305,6 +1305,63 @@ TEST_F(merge, merge_vmas_with_mseal)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
+TEST_F(merge, anon_and_page_offset_mismatch_memfd)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd;
+
+	/* Create a 10 page memfd descriptor. */
+	fd = memfd_create("anon_page_offset_test", MFD_CLOEXEC);
+	ASSERT_NE(fd, -1);
+	ASSERT_EQ(ftruncate(fd, 10 * page_size), 0);
+
+	/* Map a region using the memfd at page offset 0. */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Map another separately and trigger a CoW fault at page offset 5:
+	 *
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 */
+	ptr2 = mmap(&carveout[10 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd, 5 * page_size);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr2[0] = 'x';
+
+	/*
+	 * Now move it in place:
+	 *
+	 *                   |----------|
+	 *                   |          |
+	 *                   v          |
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 *
+	 * Because the anonymous page offset of the faulted region is now
+	 * &carveout[10 * page_size], despite the two regions being mergeable
+	 * due to file page offset, they are NOT mergeable due to anonymous
+	 * page offset.
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED,
+			  &carveout[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they did not merge. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
_

Patches currently in -mm which might be from ljs@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F57C22154B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126331; cv=none; b=VSldXcILSYupBHmlnGKrtQ8N8JPAjSww5tcSlbhK9znCyGBNH984uf8aChkC/p6PIUpeAzUP5eerEiIswXMx8mZn3BD26FxUNx8mHbuQCRr0Zz0vzp3tYnxV6bRbSlajvZYa+4VG/p8JKoxjZDwOw3Hl24w9Z+jYeD31YbC2eNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126331; c=relaxed/simple;
	bh=w4kaHwHAcAJdeVSIzNLynHEfG9GTtvkKyc0uGHFlwFE=;
	h=Date:To:From:Subject:Message-Id; b=R7+kOC+eZYJ7FkhxejbIgfGgoiEVFzh2KwBi7beiOac5+nEMS5HngaatDySzjRQ2cX4c0Eb5jYBS0KNcguQ25X3ybLPFok62lg8338wXBOb0VOMIOiaE7RfmLHm8I/tm0Nq/+MGzcPgpi2DxPLOnf9yUe5Ph58hY68YkgwZyxuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FOehcXWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FOehcXWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149D2C4CEE3;
	Thu, 10 Jul 2025 05:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126331;
	bh=w4kaHwHAcAJdeVSIzNLynHEfG9GTtvkKyc0uGHFlwFE=;
	h=Date:To:From:Subject:From;
	b=FOehcXWn7I6Iw3F5UdBup1lRpJ2suZ/UwyCikCzShcZa+pR51d1HpYUiPYAHLDBb4
	 wkB8HCe2IIr5vRE6j9pIrQejVAOwvJ65LqJOJVhgtUnuUgVLhCuWZUUewWvarUgHqP
	 yJEXmA6LI0z9NpdrgO176/NbtDPm+i35LemvGSXg=
Date: Wed, 09 Jul 2025 22:45:30 -0700
To: mm-commits@vger.kernel.org,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,kraxel@redhat.com,david@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch removed from -mm tree
Message-Id: <20250710054531.149D2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/udmabuf: add a test to pin first before writing to memfd
has been removed from the -mm tree.  Its filename was
     selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: selftests/udmabuf: add a test to pin first before writing to memfd
Date: Tue, 17 Jun 2025 22:30:55 -0700

Unlike the existing tests, this new test will create a memfd (backed by
hugetlb) and pin the folios in it (a small subset) before writing/
populating it with data.  This is a valid use-case that invokes the
memfd_alloc_folio() kernel API and is expected to work unless there aren't
enough hugetlb folios to satisfy the allocation needs.

Link: https://lkml.kernel.org/r/20250618053415.1036185-4-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Steve Sistare <steven.sistare@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/drivers/dma-buf/udmabuf.c |   20 +++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/drivers/dma-buf/udmabuf.c~selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd
+++ a/tools/testing/selftests/drivers/dma-buf/udmabuf.c
@@ -138,7 +138,7 @@ int main(int argc, char *argv[])
 	void *addr1, *addr2;
 
 	ksft_print_header();
-	ksft_set_plan(6);
+	ksft_set_plan(7);
 
 	devfd = open("/dev/udmabuf", O_RDWR);
 	if (devfd < 0) {
@@ -250,6 +250,24 @@ int main(int argc, char *argv[])
 
 	close(buf);
 	close(memfd);
+
+	/* same test as above but we pin first before writing to memfd */
+	page_size = getpagesize() * 512; /* 2 MB */
+	size = MEMFD_SIZE * page_size;
+	memfd = create_memfd_with_seals(size, true);
+	buf = create_udmabuf_list(devfd, memfd, size);
+	addr2 = mmap_fd(buf, NUM_PAGES * NUM_ENTRIES * getpagesize());
+	addr1 = mmap_fd(memfd, size);
+	write_to_memfd(addr1, size, 'a');
+	write_to_memfd(addr1, size, 'b');
+	ret = compare_chunks(addr1, addr2, size);
+	if (ret < 0)
+		ksft_test_result_fail("%s: [FAIL,test-7]\n", TEST_PREFIX);
+	else
+		ksft_test_result_pass("%s: [PASS,test-7]\n", TEST_PREFIX);
+
+	close(buf);
+	close(memfd);
 	close(devfd);
 
 	ksft_print_msg("%s: ok\n", TEST_PREFIX);
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are



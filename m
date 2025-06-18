Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A4717D2
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750290781; cv=none; b=La8k0b7LocNFocP94mR+3P7faEmOml7mSN19gZc598qCi4EQHu6jTdMVMTOg/6jZbblEjV+7ClFmgAdPqh6zjmCqvHlIP8O5z5bIVCF5Y1bo0KGfazRPOLBh6GWhQpGLzICqfW8OgcxoBku+uVard9Jj2QUgeEh0/azwgd8/Fzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750290781; c=relaxed/simple;
	bh=knySjgXb8hWmkAI/EWuJGyo4W/JXwegjuY3hjZTREnc=;
	h=Date:To:From:Subject:Message-Id; b=DZJxBGt93B0VNJTO+3EEp6SwLrAdYSC2vKV/fglLMpxexUbQjW/EL0dt9x/xC6rdPSHPKCTkNJ7ZlVCfSUjaLDViSlvXu+R/X421qanSVakhhXyI86KyJAXZn7O97UWhjiH30FnuBGQBgUrS6kcQyQuSTmli6r0JoJGOyBEqtAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n4iTJ7Uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n4iTJ7Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57737C4CEE7;
	Wed, 18 Jun 2025 23:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750290781;
	bh=knySjgXb8hWmkAI/EWuJGyo4W/JXwegjuY3hjZTREnc=;
	h=Date:To:From:Subject:From;
	b=n4iTJ7UcsqEhQmO6+wCayFGO4Nn+jVbBe2vEMqlllMW3aeCDrTEkA0TaLvebSztgH
	 ar3EZF9cRvZiQGC9JnILQsrYsX4jXvOXzhN+xIPyM+JHCaFDmzGa7OAYwJ4VMeQzd+
	 rH9XMvWB2MvMZLausdwIf0NTKgOT1GaOtMkvjNrM=
Date: Wed, 18 Jun 2025 16:53:00 -0700
To: mm-commits@vger.kernel.org,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,kraxel@redhat.com,david@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch added to mm-new branch
Message-Id: <20250618235301.57737C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/udmabuf: add a test to pin first before writing to memfd
has been added to the -mm mm-new branch.  Its filename is
     selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch
mm-memfd-reserve-hugetlb-folios-before-allocation.patch
selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD86E37D124
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082832; cv=none; b=JuZXgSMRpWIDWdZfD4kMJQ+NVxmN2myzjhE9BG2My9mDch/i+zPgqvm8mY/Jr3voDm3emyVivOnUPZDlUk0poGvFssbq7fRIo0KrqOCqOGfnhLAW3hME3jTQKzJsvqNpQ4YG21wQl7RgNCKDxGR17+uoHsYynCydEHIGLVMnHQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082832; c=relaxed/simple;
	bh=T1sZvPztHCxCLZjyy47iqlbuyXlfTzhiXFLvTR7Gbmo=;
	h=Date:To:From:Subject:Message-Id; b=c2yqt16pdW2p/oii5CK+IdKrNWfXlVcgKTmC5sYOhmL+tixnnm6m2DJhsPQklo9HC61GWJ5Xi0+Am8ZUog5Ep8ju5WfSGaNYDCB6IpFc7MJgu6M31ifUWpvsvQHbslgeiY3YfC1M/85XKFTvtEWlUJ2wl/fJz122vynTbpoY1bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NwkCOSnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NwkCOSnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEA91F008A1;
	Thu, 10 Sep 2026 23:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789082830;
	bh=BLGfMRrRPlUF0cfo4v5whu5Uqo8RyKyeuqUr2hyasP0=;
	h=Date:To:From:Subject;
	b=NwkCOSnZ17yj1Idf17Uq96dsz1sEvAV2KvI4VIb4FUrFca9JgWpJII4OYhD2cVIkw
	 ooBFvqEb1kd0bv+fpHHcFHGyN20LCI2zUZF08La6FU0pd6a2px27NKk0F1sxzy0xuU
	 RRUTCIdL8j/3naffd2bQXC8fHWBxZG5QNJBEYG/Y=
Date: Thu, 10 Sep 2026 16:27:10 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch added to mm-new branch
Message-Id: <20260910232710.6AEA91F008A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: selftests: adjust the MADV_COLLAPSE uffd-minor selftests
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: James Houghton <jthoughton@google.com>
Subject: mm: selftests: adjust the MADV_COLLAPSE uffd-minor selftests
Date: Thu, 10 Sep 2026 02:34:11 +0000

The behavior of MADV_COLLAPSE with uffd-minor VMAs has changed:
MADV_COLLAPSE will no longer install PTEs where none existed before. 
Update the selftest to demonstrate this new behavior.

On an unpatched kernel, the test will hit "unexpected memory contents
after collapse".

If the selftest is left unpatched but the kernel is patched, the selftest
will SKIP when it gets EINVAL back from MADV_COLLAPSE.

Link: https://lore.kernel.org/20260910023411.514987-2-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   75 +++++++++++++++--
 1 file changed, 68 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -518,19 +518,34 @@ static void uffd_wp_fork_pin_with_event_
 	uffd_wp_fork_pin_test_common(gopts, args, true);
 }
 
-static void check_memory_contents(uffd_global_test_opts_t *gopts, char *p)
+static int __check_memory_contents(unsigned long offset,
+				   unsigned long nr_pages,
+				   uffd_global_test_opts_t *gopts,
+				   char *p)
 {
 	unsigned long i, j;
 	uint8_t expected_byte;
 
-	for (i = 0; i < gopts->nr_pages; ++i) {
+	if (nr_pages + offset < nr_pages)
+		err("overflow in memory check");
+	if (nr_pages + offset > gopts->nr_pages)
+		err("out of bounds memory check");
+
+	for (i = offset; i < offset + nr_pages; ++i) {
 		expected_byte = ~((uint8_t)(i % ((uint8_t)-1)));
 		for (j = 0; j < gopts->page_size; j++) {
 			uint8_t v = *(uint8_t *)(p + (i * gopts->page_size) + j);
 			if (v != expected_byte)
-				err("unexpected page contents");
+				return 1;
 		}
 	}
+
+	return 0;
+}
+
+static int check_memory_contents(uffd_global_test_opts_t *gopts, char *p)
+{
+	return __check_memory_contents(0, gopts->nr_pages, gopts, p);
 }
 
 static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_collapse, bool test_wp)
@@ -539,6 +554,8 @@ static void uffd_minor_test_common(uffd_
 	pthread_t uffd_mon;
 	char c = '\0';
 	struct uffd_args args = { 0 };
+	unsigned long checked = 0;
+	bool bad_contents;
 	args.gopts = gopts;
 
 	/*
@@ -564,24 +581,65 @@ static void uffd_minor_test_common(uffd_
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	if (test_collapse) {
+		/*
+		 * Read just a single page and try collapsing. The collapse
+		 * should either be rejected or be a no-op.
+		 */
+		if (__check_memory_contents(0, 1, gopts, gopts->area_dst_alias))
+			err("unexpected memory contents before collapse");
+
+		/* MADV_COLLAPSE might return EINVAL for uffd-minor VMAs. */
+		madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
+			MADV_COLLAPSE);
+		/*
+		 * If the above collapse mapped pages that were not explicitly
+		 * CONTINUE'd, the below __check_memory_contents() will not
+		 * fault on some pages, resulting in incorrect contents. The
+		 * PTE for the first page may get retracted, so avoid checking
+		 * that page, as we might take a second fault, flipping the
+		 * contents a second time.
+		 */
+		checked = 1;
+	}
+
 	/*
 	 * Read each of the pages back using the UFFD-registered mapping. We
 	 * expect that the first time we touch a page, it will result in a minor
 	 * fault. uffd_poll_thread will resolve the fault by bit-flipping the
 	 * page's contents, and then issuing a CONTINUE ioctl.
 	 */
-	check_memory_contents(gopts, gopts->area_dst_alias);
+	bad_contents = !!__check_memory_contents(checked, gopts->nr_pages - checked,
+						    gopts, gopts->area_dst_alias);
 
 	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
 		err("pipe write");
 	if (pthread_join(uffd_mon, NULL))
 		err("join() failed");
 
+	if (bad_contents && test_collapse) {
+		uffd_test_fail("unexpected memory contents after collapse");
+		return;
+	}
+
+	if (bad_contents) {
+		uffd_test_fail("unexpected memory contents");
+		return;
+	}
+
 	if (test_collapse) {
+		/*
+		 * MADV_COLLAPSE will fail unless userfaultfd-minor is
+		 * unregistered.
+		 */
+		if (uffd_unregister(gopts->uffd, gopts->area_dst_alias,
+				    gopts->nr_pages * gopts->page_size))
+			err("uffd_unregister before MADV_COLLAPSE failed");
+
+		/* MADV_COLLAPSE should succeed with userfaultfd unregistered. */
 		if (madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
 			    MADV_COLLAPSE)) {
-			/* It's fine to fail for this one... */
-			uffd_test_skip("MADV_COLLAPSE failed");
+			uffd_test_fail("MADV_COLLAPSE failed");
 			return;
 		}
 
@@ -593,7 +651,10 @@ static void uffd_minor_test_common(uffd_
 		 * This won't cause uffd-fault - it purely just makes sure there
 		 * was no corruption.
 		 */
-		check_memory_contents(gopts, gopts->area_dst_alias);
+		if (check_memory_contents(gopts, gopts->area_dst_alias)) {
+			uffd_test_fail("unexpected memory contents");
+			return;
+		}
 	}
 
 	if (args.missing_faults != 0 || args.minor_faults != gopts->nr_pages)
_

Patches currently in -mm which might be from jthoughton@google.com are

mm-khugepaged-never-install-pmds-in-uffd-minor-registered-vmas.patch
mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch


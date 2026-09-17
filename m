Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0578275870
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 05:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789623480; cv=none; b=iNh/UNRHLNXt78Go+nKfT+9zVpXfSVyFI+V1Uf8Ou+9jWB88Ex7rVIehuhPMs5IH//NMJMEwsLz54ZUnew5pwrP+IE+IRDOTicRQ0XmVlxNrzSDpx7VFUMRLahEnZtAKsUfgh/lfxmAUrey/dPfOOP+wxEkeiCBCxoNFdOHhvB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789623480; c=relaxed/simple;
	bh=PWH9dmYd58JIAqpcVg+cnbL2DO2qVuJO1sJbEcYlP5w=;
	h=Date:To:From:Subject:Message-Id; b=HezkerVJcuJuo3Exhj3GizTg8pbq6PwiYUaBBy3G70Ba55ZnvmcBa926kzx4+ooTrL5Al9xGPoLA45DP7XgbdFGLQtJ5I+sA+f4ne7SrY7kV3jqg9RYyRZDlSsfrOFGUWG8HUTEMRU4jVEOGzPVnUqWQ/2DpJdwEOSo6VYSuJlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nyaywn1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nyaywn1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827CF1F00893;
	Thu, 17 Sep 2026 05:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789623478;
	bh=mPCpEv0qmZw2SS+2Md5MBmgpTlUOSephiA3dcn3PjyA=;
	h=Date:To:From:Subject;
	b=Nyaywn1Th7SiZ74qsR/ovbrD53tpMSovJiFp1aPJXuCA3I7TmExz0bDRbuVymSrUf
	 vDhEaVvYbukeIAqNLOa0O7w8uPtYE6+mNZRrzynL+R/Ejv9/VMPC8yCfsxbszEVwJq
	 wn6QWMF9I8M2QflbQYLNyvZBpVfrZ22UjotnG3x4=
Date: Wed, 16 Sep 2026 22:37:58 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch removed from -mm tree
Message-Id: <20260917053758.827CF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: selftests: adjust the MADV_COLLAPSE uffd-minor selftests
has been removed from the -mm tree.  Its filename was
     mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch

This patch was dropped because an updated version will be issued

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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



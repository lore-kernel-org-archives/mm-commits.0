Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BB54B0482
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786060238; cv=none; b=moTixgL+Q1pOi38d3XX95xv4wL1hZZKMHg8JMw60vhr/9ofXtIpDIBG77PxKirBycjUrO1VRUxxNx3KFfucAbw5RrIfVP1r/23QYcDTXBAenY6wvt1u51Uqe57jxrbOhoJeBWHDnwQWblPr+IpZwG4cO94P7TNrIStqNvmWmVK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786060238; c=relaxed/simple;
	bh=mQCXGfb4G2SxSJ8KAUr27LN1YzrByWeeJur2/Z0ehvI=;
	h=Date:To:From:Subject:Message-Id; b=oHmXgeelYCofMPSl8685gehWLWGYdku4b10HFq1gzFZoaw9F5E0fb/Ip5/ejHG0xMoIWFukZnh3Cot1my8Q0Uk2zMnLsm/Mbax0VgX6nRfBmHQ6gX+2KJi8/PUXVikaOpw0rEKVpzejhdFXztUs13bFSA/1RpmolhRVIbk3CtHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JfI0wFuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JfI0wFuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B45A1F000E9;
	Thu,  6 Aug 2026 23:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786060236;
	bh=kf/xwj/dmiBa5ExlbefH6ZocKXb46ShQ8JiDlLLWbNE=;
	h=Date:To:From:Subject;
	b=JfI0wFuz8M2aIi09B169wzCHabJ4ozSkolqXhII0irPP6kw1+zUSSUE5D9vFs5hA5
	 pzAk7gCDeZiQrLh/ACjGL3Q3guYoem3Z9l6wGXQFxs9KzrmSX8ludXS4ftbDdgRX/9
	 0mZI2aSO+uQb0UO5TnQyHDC072u77eDW7zNr3hvI=
Date: Thu, 06 Aug 2026 16:50:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,raquini@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,colin.i.king@gmail.com,avagin@google.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-soft-dirty-kselftest-supported-check.patch added to mm-new branch
Message-Id: <20260806235036.4B45A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix soft-dirty kselftest supported check
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

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
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm: fix soft-dirty kselftest supported check
Date: Thu, 6 Aug 2026 14:17:04 -0400

On architectures with separate user address space, such as s390 or those
without an MMU, the soft-dirty kselftest may fail when checking to see if
the feature is supported.

  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..15
  # Bail out! PAGEMAP_SCAN succeeded unexpectedly
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 soft-dirty # exit=1
  # SUMMARY: PASS=0 SKIP=0 FAIL=1

The soft-dirty test will initate an ioctl with the PAGEMAP_SCAN flag with
an invalid address for the page_region.  This is done intentionally to
have the ioctl return with an expected EFAULT and with the correct
categories returned.

However, on architectures with separate user address space, such as s390
or those without an MMU, the call to __access_ok (used to validate the
variables provided with the ioctl) will always return true and we will not
fail as expected.

        if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
            !IS_ENABLED(CONFIG_MMU))
                return true;

Let's simplify the check for PAGEMAP_SCAN and provide a valid page_region
address so that we get a non-errno return if it is supported.

Link: https://lore.kernel.org/20260806181843.1839943-3-audra@redhat.com
Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-soft-dirty-kselftest-supported-check
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -69,20 +69,25 @@ static uint64_t pagemap_scan_get_categor
 }
 
 /* `start` is any valid address. */
-static bool pagemap_scan_supported(int fd, char *start)
+static bool pagemap_scan_supported(int fd)
 {
+	const size_t pagesize = getpagesize();
 	static int supported = -1;
-	int ret;
+	struct page_region r;
+	void *test_area;
 
 	if (supported != -1)
 		return supported;
 
-	/* Provide an invalid address in order to trigger EFAULT. */
-	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
-	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
-
-	supported = errno == EFAULT;
+	test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (test_area == MAP_FAILED) {
+		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
+		supported = 0;
+	} else {
+		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
+		munmap(test_area, pagesize);
+	}
 
 	return supported;
 }
@@ -92,7 +97,7 @@ static bool page_entry_is(int fd, char *
 {
 	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
 
-	if (pagemap_scan_supported(fd, start)) {
+	if (pagemap_scan_supported(fd)) {
 		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
 
 		if (m == s)
_

Patches currently in -mm which might be from audra@redhat.com are

correct-__pagemap_scan_get_categories-return-value.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B86158DCF
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 19:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774033315; cv=none; b=PbybWGrberW+jcG4a0YWn4HdZi2wmQrKuwe4+gpNxUf8gcEjdoU2mkpxEw/vnSzFl9nY8Zs/NhzZrUfFTcoHCLzYw20K3gS2f28bvsLBtG62Y6r9II6zlND7DFv6BjU7aikmkAcYQoouNKpBWvlF9ZhYz9CZRHHNDpmtwRiJGaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774033315; c=relaxed/simple;
	bh=m9LwAlzwJXWYhv9Lu0sIAcI5TeLTx99q4Du8+8nwp7I=;
	h=Date:To:From:Subject:Message-Id; b=BJab6g1UOlQbqIRhRmc0kof5j4nioxGkWSncL8NmwuqhufCTo5Bldrcvp+DePKk003cfcgpVA/lTtCXtEwOFF87Vu3RIiMqJ8LRCocwtQyyghlneIlAl51tyeOPqNe5/IN/4R7pqTjQw2/UfcLRZUEBemXfAtPewow3HzgBsp/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGfGaotF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGfGaotF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709F1C4CEF7;
	Fri, 20 Mar 2026 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774033314;
	bh=m9LwAlzwJXWYhv9Lu0sIAcI5TeLTx99q4Du8+8nwp7I=;
	h=Date:To:From:Subject:From;
	b=UGfGaotFvOp9awLDzvxtwVY9fKRtiYxJqp8V2e2bCajEzmzsIrNSTQV5+mfyKn2+A
	 dulzXBb8XCVlABvcqPNn2vsi6LblLYKC3Vjt5OUPoSYwOGS9oTT4m+g06sOyjCpoAY
	 L6ibIUK439If4Lu5cOsjHvO90G1TVgclumFY8QeA=
Date: Fri, 20 Mar 2026 12:01:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,liam.howlett@oracle.com,david@kernel.org,colin.i.king@gmail.com,avagin@google.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-soft-dirty-kselftest-supported-check.patch added to mm-unstable branch
Message-Id: <20260320190154.709F1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix soft-dirty kselftest supported check
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Fri, 20 Mar 2026 14:39:15 -0400

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

Link: https://lkml.kernel.org/r/20260320184010.759461-2-audra@redhat.com
Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-soft-dirty-kselftest-supported-check
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -67,20 +67,26 @@ static uint64_t pagemap_scan_get_categor
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
+			MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (test_area == MAP_FAILED) {
+		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
+		supported = 0;
+	} else {
+		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
+		ksft_print_msg("errno: %d\n", errno);
+		munmap(test_area, pagesize);
+	}
 
 	return supported;
 }
@@ -90,7 +96,7 @@ static bool page_entry_is(int fd, char *
 {
 	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
 
-	if (pagemap_scan_supported(fd, start)) {
+	if (pagemap_scan_supported(fd)) {
 		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
 
 		if (m == s)
_

Patches currently in -mm which might be from audra@redhat.com are

selftests-mm-fix-soft-dirty-kselftest-supported-check.patch


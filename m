Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019F33009CA
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763398909; cv=none; b=mTzFx+M9ojXC8kK+K5lBAz3rP1hLpuXFGWOBocY2wLkd36nR1P6/sgSKDMJGES2iF2/PDFIpPMfrbHMRGsLy+XYo8TtOQzuxVv2QqPqNywXU24Vl1hHzP00fW30j/juAxjYMPeGCxM6qNcgT71eN1M9UjoABXs33YYAf5sV0bJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763398909; c=relaxed/simple;
	bh=QEHYpgAm818i1kXaiqvBnWP7HyparbAR1wiOT4F8C0s=;
	h=Date:To:From:Subject:Message-Id; b=Ry+2B+rbyxUrqTVHHX/1Zby3g+rDwMzs9IGVo/DfFdenLqA+7g85SquQCmiwfqlyKKVu50lrV7iOpUKLd9tvvJynXIehumzzWbhhW93O0l+ub+Jx8yhimginZpqA4eDgMwMsvez323eIIF0ihEFpZ11CMZaKIiQw5UBglzEBGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SLytFIhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SLytFIhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63512C2BCAF;
	Mon, 17 Nov 2025 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763398907;
	bh=QEHYpgAm818i1kXaiqvBnWP7HyparbAR1wiOT4F8C0s=;
	h=Date:To:From:Subject:From;
	b=SLytFIhEKvaCuGi2RJndZVQvLXEpGaq6IlDTqcst9GajUi+1zW8yLMOs2SnL7fg0z
	 xEWCKwbIys87r3rdulUFZEcOuh3Z/PhuMRiYTnx5QrdQVyCG1UH3YzzLNc/ssoQYhm
	 ZBYCakQ/7YNmeG+g4XuuiQGiOhqs4RJS7GD0uCXg=
Date: Mon, 17 Nov 2025 09:01:46 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,dan.j.williams@intel.com,peng8420.li@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_test-stop-testing-foll_touch.patch added to mm-new branch
Message-Id: <20251117170147.63512C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: gup_test: stop testing FOLL_TOUCH
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-gup_test-stop-testing-foll_touch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_test-stop-testing-foll_touch.patch

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
From: Peng Li <peng8420.li@gmail.com>
Subject: selftests/mm: gup_test: stop testing FOLL_TOUCH
Date: Mon, 17 Nov 2025 23:40:11 +0800

commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.

This causes a warning to fire when running gup_test, for example:

    $ ./gup_test -L -r 100 -z

dmesg:
    WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c

Therefore, remove the "FOLL_TOUCH" test code from gup_test.c.

Link: https://lkml.kernel.org/r/20251117154012.197499-1-peng8420.li@gmail.com
Signed-off-by: Peng Li <peng8420.li@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-gup_test-stop-testing-foll_touch
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -19,7 +19,6 @@
 
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
-#define FOLL_TOUCH	0x02	/* mark page accessed */
 
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
 
@@ -93,7 +92,7 @@ int main(int argc, char **argv)
 {
 	struct gup_test gup = { 0 };
 	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
-	int flags = MAP_PRIVATE, touch = 0;
+	int flags = MAP_PRIVATE;
 	char *file = "/dev/zero";
 	pthread_t *tid;
 	char *p;
@@ -170,10 +169,6 @@ int main(int argc, char **argv)
 		case 'H':
 			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
 			break;
-		case 'z':
-			/* fault pages in gup, do not fault in userland */
-			touch = 1;
-			break;
 		default:
 			ksft_exit_fail_msg("Wrong argument\n");
 		}
@@ -244,18 +239,9 @@ int main(int argc, char **argv)
 	else if (thp == 0)
 		madvise(p, size, MADV_NOHUGEPAGE);
 
-	/*
-	 * FOLL_TOUCH, in gup_test, is used as an either/or case: either
-	 * fault pages in from the kernel via FOLL_TOUCH, or fault them
-	 * in here, from user space. This allows comparison of performance
-	 * between those two cases.
-	 */
-	if (touch) {
-		gup.gup_flags |= FOLL_TOUCH;
-	} else {
-		for (; (unsigned long)p < gup.addr + size; p += psize())
-			p[0] = 0;
-	}
+	/* Fault them in here, from user space. */
+	for (; (unsigned long)p < gup.addr + size; p += psize())
+		p[0] = 0;
 
 	tid = malloc(sizeof(pthread_t) * nthreads);
 	assert(tid);
_

Patches currently in -mm which might be from peng8420.li@gmail.com are

selftests-mm-gup_test-stop-testing-foll_touch.patch
selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD942F7AAC
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025853; cv=none; b=gZL77h4nrT+re7kfTkp2XQzxR9fkyCdwyygk/N/jxcZeIIejK+SyBDNB1aQMqqdlc1XBKqZSjm0ci/4gw3S9clwYPnsO1JJYtzwkLUCxZ//VsYG3TUsmNg5Pa5tSgjYpu6aAwt2yJ8CFkLis27ZqtrQp4dQyktrTBGm4Yc+3sfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025853; c=relaxed/simple;
	bh=nqz3ZMPGdpfj/nnqh+kbDgyvIPldeXcscZXz1ajb0+M=;
	h=Date:To:From:Subject:Message-Id; b=ZVUBrQVUtelBjCouq+krXiqXQOHUnOoXlxB70GWmB+YD2NngwqZJgCC2/RiZoSFgTEA5bBhiYs/dSSHGB9sz2lZ7rLi6IzTvwQ9juXtzmnfnGtRSdCFnwxEzG58jPWpFLKxVWugrfnTawXKheKLMOV+0t0yvuyG4kjGFyXK90iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z3EOeI8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z3EOeI8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE96C4CEF1;
	Mon, 24 Nov 2025 23:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025852;
	bh=nqz3ZMPGdpfj/nnqh+kbDgyvIPldeXcscZXz1ajb0+M=;
	h=Date:To:From:Subject:From;
	b=Z3EOeI8g9cNYuSg8Ojtkb/i9jeaSIK3brInbskuqva87cwZ5zgXkbIL180em8Ga7b
	 XN6lswcDHQxSDrPvKOU76n3zA+C4gvihxewf3/9cyZfFVzsLH42QGhMeTMgBt6VCXC
	 W2EiXtqH1wpzZ7ZLNgYgKKko3SUZgJ8UQogNJTWE=
Date: Mon, 24 Nov 2025 15:10:52 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,dan.j.williams@intel.com,peng8420.li@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_test-stop-testing-foll_touch.patch removed from -mm tree
Message-Id: <20251124231052.BEE96C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: gup_test: stop testing FOLL_TOUCH
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_test-stop-testing-foll_touch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch added to -mm
 tree
Date: Mon, 06 Jul 2020 16:36:44 -0700
Message-ID: <20200706233644.v2Q58_ifN%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgGFXgp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:36:45 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, thunder.leizhen@huawei.com


The patch titled
     Subject: mm/mmap: optimize a branch judgment in ksys_mmap_pgoff()
has been added to the -mm tree.  Its filename is
     mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/mmap: optimize a branch judgment in ksys_mmap_pgoff()

Look at the pseudo code below.  It's very clear that, the judgement
"!is_file_hugepages(file)" at 3) is duplicated to the one at 1), we can
use "else if" to avoid it.  And the assignment "retval = -EINVAL" at 2) is
only needed by the branch 3), because "retval" will be overwritten at 4).

No functional change, but it can reduce the code size. Maybe more clearer?
Before:
text    data     bss     dec     hex filename
28733    1590       1   30324    7674 mm/mmap.o

After:
text    data     bss     dec     hex filename
28701    1590       1   30292    7654 mm/mmap.o

====pseudo code====:
	if (!(flags & MAP_ANONYMOUS)) {
		...
1)		if (is_file_hugepages(file))
			len = ALIGN(len, huge_page_size(hstate_file(file)));
2)		retval = -EINVAL;
3)		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
			goto out_fput;
	} else if (flags & MAP_HUGETLB) {
		...
	}
	...

4)	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
out_fput:
	...
	return retval;

Link: http://lkml.kernel.org/r/20200705080112.1405-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff
+++ a/mm/mmap.c
@@ -1562,11 +1562,12 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		file = fget(fd);
 		if (!file)
 			return -EBADF;
-		if (is_file_hugepages(file))
+		if (is_file_hugepages(file)) {
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
-		retval = -EINVAL;
-		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
+		} else if (unlikely(flags & MAP_HUGETLB)) {
+			retval = -EINVAL;
 			goto out_fput;
+		}
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
 		struct hstate *hs;
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch

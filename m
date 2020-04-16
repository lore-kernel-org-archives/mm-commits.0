From: akpm@linux-foundation.org
Subject: + hugetlb_cgroup-remove-unused-variable-i.patch added to
 -mm tree
Date: Wed, 15 Apr 2020 17:32:37 -0700
Message-ID: <20200416003237.sZMs5UPKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404155AbgDPAci (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 20:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: tools/testing/selftests/vm/write_to_hugetlbfs.c: remove unused variable 'i'
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-remove-unused-variable-i.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-remove-unused-variable-i.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-remove-unused-variable-i.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: tools/testing/selftests/vm/write_to_hugetlbfs.c: remove unused variable 'i'

Compiling tests in tools/testing/selftests/vm/ results in a C compiler
warning:

write_to_hugetlbfs.c: In function `main':
write_to_hugetlbfs.c:77:16: warning: unused variable `i'
   77 |  unsigned long i;

Delete the unused variable.

Link: http://lkml.kernel.org/r/20200416002616.1456-1-rcampbell@nvidia.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/write_to_hugetlbfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/vm/write_to_hugetlbfs.c~hugetlb_cgroup-remove-unused-variable-i
+++ a/tools/testing/selftests/vm/write_to_hugetlbfs.c
@@ -74,8 +74,6 @@ int main(int argc, char **argv)
 	int write = 0;
 	int reserve = 1;
 
-	unsigned long i;

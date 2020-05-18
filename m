From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch added to
 -mm tree
Date: Mon, 18 May 2020 15:06:58 -0700
Message-ID: <20200518220658.uEm4h8rc9%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgERWHA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 18:07:00 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, bgeffon@google.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, shuah@kernel.org


The patch titled
     Subject: selftests/vm/write_to_hugetlbfs.c: fix unused variable warning
has been added to the -mm tree.  Its filename is
     selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm/write_to_hugetlbfs.c: fix unused variable warning

Remove unused variable "i", which was triggering a compiler warning.

Link: http://lkml.kernel.org/r/20200517001245.361762-2-jhubbard@nvidia.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-By: Mina Almasry <almasrymina@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/write_to_hugetlbfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/vm/write_to_hugetlbfs.c~selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning
+++ a/tools/testing/selftests/vm/write_to_hugetlbfs.c
@@ -74,8 +74,6 @@ int main(int argc, char **argv)
 	int write = 0;
 	int reserve = 1;
 
-	unsigned long i;

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3EE83CB2
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708546682; cv=none; b=uTL/9YGZQQzvdXfnzGH3OThueMJ7xT9OcQdmK4noqZb8nDtOaq8PfWncXnfcIYn52rOMcL6t9tvRaPqTTliBH5PXXmDEhJawhmPSlu1zN2KumEglTcEiVyvlCwovkRuycW6Bt45YFL52t8umgaVGeTkNjpMO6ll/1T+m81UFzR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708546682; c=relaxed/simple;
	bh=6v8VB4PEpNYAG6C0bME40SvBvceikOUBCwqW+RmtL/0=;
	h=Date:To:From:Subject:Message-Id; b=TGSaDMBfLqOs0HJ17Em28oTPeMvjM3jZVpXlh5yUbTYoIoLtjymGX3b03Ed49VCjsWcZLisd2jxxjGziR7RIpx60kBc9itzzirhmV7rgAHtD1CcNpfM99Cr7CjsBrM2OhKmG1WuPwS7ZvpbKRSN1mjPVDESlNiiAzX2Puq/dZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XiOF2Hxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XiOF2Hxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4ACC433F1;
	Wed, 21 Feb 2024 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708546682;
	bh=6v8VB4PEpNYAG6C0bME40SvBvceikOUBCwqW+RmtL/0=;
	h=Date:To:From:Subject:From;
	b=XiOF2HxrBczFSbAbgezXvybFlE7o6SBkJCQkrsQhoqGk5oSFb1wihoVnH0enEDD8+
	 dsRKHmDlXkpNxd44c4+Qcs9iqjYhwdiPwxorWuEOwJ4gof6TEODv0/2MsLNPfiXopJ
	 t+R73mKl/j7pPmz7xLAXUsd73wR4ZZtP07NMiaPA=
Date: Wed, 21 Feb 2024 12:18:01 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,liuyongqiang13@huawei.com,david@redhat.com,mcassell411@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-utilc-added-page-count-to-__vm_enough_memory-failure-warning.patch added to mm-unstable branch
Message-Id: <20240221201802.0A4ACC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/util.c: add page count to __vm_enough_memory failure warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-utilc-added-page-count-to-__vm_enough_memory-failure-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-utilc-added-page-count-to-__vm_enough_memory-failure-warning.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Matthew Cassell <mcassell411@gmail.com>
Subject: mm/util.c: add page count to __vm_enough_memory failure warning
Date: Wed, 21 Feb 2024 16:02:35 +0000

Commit 44b414c8715c5dcf53288 ("mm/util.c: add warning if
__vm_enough_memory fails") adds debug information which gives the process
id and executable name should __vm_enough_memory() fail.  Adding the
number of pages to the failure message would benefit application
developers and system administrators in debugging overambitious memory
requests by providing a point of reference to the amount of memory causing
__vm_enough_memory() to fail.

1. Set appropriate kernel tunable to reach code path for failure
   message:

	# echo 2 > /proc/sys/vm/overcommit_memory

2. Test program to generate failure - requests 1 gibibyte per iteration:

	#include <stdlib.h>
	#include <stdio.h>

	int main(int argc, char **argv) {
		for(;;) {
			if(malloc(1<<30) == NULL)
				break;

			printf("allocated 1 GiB\n");
		}

		return 0;
	}

3. Output:

	Before:

	__vm_enough_memory: pid: 1218, comm: a.out, not enough
memory for the allocation

	After:

	__vm_enough_memory: pid: 1141, comm: a.out, pages: 262145, not
enough memory for the allocation

Link: https://lkml.kernel.org/r/20240221160235.1771-1-mcassell411@gmail.com
Signed-off-by: Matthew Cassell <mcassell411@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/util.c~mm-utilc-added-page-count-to-__vm_enough_memory-failure-warning
+++ a/mm/util.c
@@ -976,8 +976,8 @@ int __vm_enough_memory(struct mm_struct
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
 error:
-	pr_warn_ratelimited("%s: pid: %d, comm: %s, not enough memory for the allocation\n",
-			    __func__, current->pid, current->comm);
+	pr_warn_ratelimited("%s: pid: %d, comm: %s, pages: %ld, not enough memory for the allocation\n",
+			    __func__, current->pid, current->comm, pages);
 	vm_unacct_memory(pages);
 
 	return -ENOMEM;
_

Patches currently in -mm which might be from mcassell411@gmail.com are

mm-utilc-added-page-count-to-__vm_enough_memory-failure-warning.patch


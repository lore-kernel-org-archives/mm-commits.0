From: akpm@linux-foundation.org
Subject: + mm-merging-memory-blocks-resets-mempolicy.patch added to -mm tree
Date: Wed, 20 Mar 2013 15:05:20 -0700
Message-ID: <20130320220520.8FA4E31C0A5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:40651 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3CTWFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 18:05:22 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so205215vcb.2
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 15:05:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steven.t.hampson@intel.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: mm: merging memory blocks resets mempolicy
has been added to the -mm tree.  Its filename is
     mm-merging-memory-blocks-resets-mempolicy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Hampson, Steven T" <steven.t.hampson@intel.com>
Subject: mm: merging memory blocks resets mempolicy

Using mbind to change the mempolicy to MPOL_BIND on several adjacent
mmapped blocks may result in a reset of the mempolicy to MPOL_DEFAULT in
vma_adjust.

Test code.  Correct result is three lines containing "OK".

#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <numaif.h>
#include <errno.h>

/* gcc mbind_test.c -lnuma -o mbind_test -Wall */
#define MAXNODE 4096

void allocate()
{
	int ret;
	int len;
	int policy = -1;
	unsigned char *p;
	unsigned long mask[MAXNODE] = { 0 };
	unsigned long retmask[MAXNODE] = { 0 };

	len = getpagesize() * 0x2fc00;
	p = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
		 -1, 0);
	if (p == MAP_FAILED)
		printf("mbind err: %d\n", errno);

	mask[0] = 1;
	ret = mbind(p, len, MPOL_BIND, mask, MAXNODE, 0);
	if (ret < 0)
		printf("mbind err: %d %d\n", ret, errno);
	ret = get_mempolicy(&policy, retmask, MAXNODE, p, MPOL_F_ADDR);
	if (ret < 0)
		printf("get_mempolicy err: %d %d\n", ret, errno);

	if (policy == MPOL_BIND)
		printf("OK\n");
	else
		printf("ERROR: policy is %d\n", policy);
}

int main()
{
	allocate();
	allocate();
	allocate();
	return 0;
}

Signed-off-by: Steven T Hampson <steven.t.hampson@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-merging-memory-blocks-resets-mempolicy mm/mmap.c
--- a/mm/mmap.c~mm-merging-memory-blocks-resets-mempolicy
+++ a/mm/mmap.c
@@ -829,7 +829,7 @@ again:			remove_next = 1 + (end > next->
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
 		mm->map_count--;
-		mpol_put(vma_policy(next));
+		vma_set_policy(vma, vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
_

Patches currently in -mm which might be from steven.t.hampson@intel.com are

mm-merging-memory-blocks-resets-mempolicy.patch


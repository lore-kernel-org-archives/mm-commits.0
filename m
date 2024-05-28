Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9963A17F36F;
	Tue, 28 May 2024 20:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716927728; cv=none; b=utD7/1XePUqN6uFw8gstfVVZBLX/mu+ELCWa0wjI+dPkMQd15YXyY+fwHmMet1qsbv/f72AMJyIqPqnHIu8WbDxX2JKQhzYaHq4BBw9yxLn5YB3rfgmUbPANWr6gKRrXkvgC+7APwjPF6HmsR8y9pLMfDLdH1Q0A+IPKFdGP3eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716927728; c=relaxed/simple;
	bh=tL01danyZoZ73UTH3BxMCR78xP9vJT2kgF+A4lQ1DgM=;
	h=Date:To:From:Subject:Message-Id; b=djDyKlQrIHFesnnnYp9fGKKyS7+5mT47j95iv9PrJXrGW1gsebIpbeRwI5lViXJOHbu5Wm2b+ddOfPD8cJcEHjmnVNatU5WrpHzC+nsld9R8E7Zx/mdIeMfiVBAXEEmy8nn1hbxrQYiSPQ5H0iLB77LKdmCG+mP2jIowj2H1rWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lCn9SZao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lCn9SZao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CFAC3277B;
	Tue, 28 May 2024 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716927728;
	bh=tL01danyZoZ73UTH3BxMCR78xP9vJT2kgF+A4lQ1DgM=;
	h=Date:To:From:Subject:From;
	b=lCn9SZaoGOFFn/X5S88dMPCKArpy7gKsKCwbYpmv4YHQkK+TVTKsy4+I33dwfrBxA
	 PoqBBFixvO7YEOf55Ayq8c+nS0W+RolJSYisDlPlWggb8GV6TbmpYJgilAX442v0DN
	 Cv8FeCRfbdSja7xnu3ruW/qE1nUQX7Rn7IZTT4YA=
Date: Tue, 28 May 2024 13:22:07 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,stable@vger.kernel.org,shr@devkernel.io,ran.xiaokai@zte.com.cn,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-ksm_pages_scanned-accounting.patch added to mm-hotfixes-unstable branch
Message-Id: <20240528202208.01CFAC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix ksm_pages_scanned accounting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-ksm_pages_scanned-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-ksm_pages_scanned-accounting.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: fix ksm_pages_scanned accounting
Date: Tue, 28 May 2024 13:15:21 +0800

Patch series "mm/ksm: fix some accounting problems", v3.

We encountered some abnormal ksm_pages_scanned and ksm_zero_pages during
some random tests.

1. ksm_pages_scanned unchanged even ksmd scanning has progress.
2. ksm_zero_pages maybe -1 in some rare cases.


This patch (of 2):

During testing, I found ksm_pages_scanned is unchanged although the
scan_get_next_rmap_item() did return valid rmap_item that is not NULL.

The reason is the scan_get_next_rmap_item() will return NULL after a full
scan, so ksm_do_scan() just return without accounting of the
ksm_pages_scanned.

Fix it by just putting ksm_pages_scanned accounting in that loop, and it
will be accounted more timely if that loop would last for a long time.

Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-0-34bb358fdc13@linux.dev
Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-1-34bb358fdc13@linux.dev
Fixes: b348b5fe2b5f ("mm/ksm: add pages scanned metric")
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-ksm_pages_scanned-accounting
+++ a/mm/ksm.c
@@ -2753,18 +2753,16 @@ static void ksm_do_scan(unsigned int sca
 {
 	struct ksm_rmap_item *rmap_item;
 	struct page *page;
-	unsigned int npages = scan_npages;
 
-	while (npages-- && likely(!freezing(current))) {
+	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
 			return;
 		cmp_and_merge_page(page, rmap_item);
 		put_page(page);
+		ksm_pages_scanned++;
 	}
-
-	ksm_pages_scanned += scan_npages - npages;
 }
 
 static int ksmd_should_run(void)
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-ksm-fix-ksm_pages_scanned-accounting.patch
mm-ksm-fix-ksm_zero_pages-accounting.patch


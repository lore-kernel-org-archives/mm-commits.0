Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483671A6828
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788047939; cv=none; b=SawYqKZb6xgdwXjS2OmJU9NVGxlcn/lqMbLtSOOzKdIXrp3UkJlPwEhocC3rZox4PQigbk3liB5BSsqHbfOk4p47rEaoTl4Q/sEd3BsGDsBsQI6fJ8mTL0iZHdBn/0LTipN91CR2vliCsncJOR/Css/76+O8AZaGV3nWyYyArSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788047939; c=relaxed/simple;
	bh=H+Vj8V9C1AQm+nE6L+dzohe5SiKIOWBzWk3aL8L5eOg=;
	h=Date:To:From:Subject:Message-Id; b=OfjUQQBy5ZJ/uN/KA2H85Ohq9Q1FdVkb24LBo+hg+R1vwFOT3jTQljWLvWMhFClwv/RsHelMdUiPH5YzP54PwjIttVP9ta307FETcX/5Eiyhd+PO7kG5ysIoZjdh+y0rlJWXxDBY8lcn3qaVoFMfiVkmtKTs2GfrAT5KjQJ2J9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P0aGAi8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P0aGAi8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D313E1F000E9;
	Sat, 29 Aug 2026 23:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788047937;
	bh=9FE3fK43Vn2IPR0aF9oqcwbfd3fzIRROPZ/MgOEW4wQ=;
	h=Date:To:From:Subject;
	b=P0aGAi8dHjP1/h35bVYXgCjzNRLFjorJ0l9KoFE1B2EWPdcjXk2/7XIA04H9hcAlQ
	 fZD5tRmYCvv82X/2YuExkTehxzdUBKmIFjRFLcw1ElOSMUkSdJT1Srq1iGZn853NfY
	 snkU3Be1zz87Q+TK0obKiAd2dwg84P9vQqhwXmmM=
Date: Sat, 29 Aug 2026 16:58:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch added to mm-new branch
Message-Id: <20260829235857.D313E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fail the fault on a malformed swap entry instead of retrying it
has been added to the -mm mm-new branch.  Its filename is
     mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: fail the fault on a malformed swap entry instead of retrying it
Date: Tue, 18 Aug 2026 03:06:24 -0700

do_swap_page() returns 0 when get_swap_device() fails, which the fault
handler reads as "handled".  For an entry that can never become valid the
retry takes the same fault again, so the thread spins forever, retrying on
the same fault.

Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
called at get_swap_device()).

Link: https://lore.kernel.org/20260818-swap-v3-2-d3fa52598a59@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it
+++ a/mm/memory.c
@@ -4958,8 +4958,11 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* Prevent swapoff from happening to us, and reject a bad entry. */
 	si = get_swap_device(entry);
-	if (IS_ERR_OR_NULL(si))
+	if (IS_ERR_OR_NULL(si)) {
+		if (IS_ERR(si))
+			ret = VM_FAULT_SIGBUS;
 		goto out;
+	}
 
 	folio = swap_cache_get_folio(entry);
 	if (folio)
_

Patches currently in -mm which might be from leitao@debian.org are

mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch
mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch


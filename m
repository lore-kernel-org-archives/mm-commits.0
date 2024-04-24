Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC214745CB
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713992937; cv=none; b=BHseDPm5Rf65Acwy3Wy1VNH3zlh1hT5I0ahQ1kDrNHN+4GO6pYcFRKRVWSuEA2NO+DgHxi58i4S8EkzkpQW3gnDyiCtOBKlPhlDfwpws5ErF2eHlKLwebvSshmY4Jj8oLDk6BjtPEz2aQ+4ZFNlCmfiDC3l73UnWvxSi4d9XDM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713992937; c=relaxed/simple;
	bh=TvxqdvHswTRCbfsH5lVXDGSrzy4s8U00nEYP5gqYmj0=;
	h=Date:To:From:Subject:Message-Id; b=LAGDRYWCWJ0bALoxnyG/UO3wogARjP2niMC7kZiVvfqACsIng/RIZkl56SvD+Z+QDmCMf9d7T1Dp51apN5tnvAOGiU2V27WwX9L4oV74mJ05M2WY5X/XWpnEZkSNJFR474uUFGlzf6E9zQz2Rm1MIbW6h2n0Qw8k2IQqvwXgQns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IxbbK85H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IxbbK85H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50577C113CD;
	Wed, 24 Apr 2024 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713992936;
	bh=TvxqdvHswTRCbfsH5lVXDGSrzy4s8U00nEYP5gqYmj0=;
	h=Date:To:From:Subject:From;
	b=IxbbK85HbrgoqY9gLgUwFHj1V9Ef4XymaYfYg/6ZgOlgM1k5s3kS48JjLPLNdZLSF
	 SkrSgfP0e6kTs2YAbnxuKo+7Nd6I/Oa731PpI+CpTcVzJmn8hVcIAN+zCtphVtjBz6
	 vU8JGNSNtBH+tCcSaO/uvh3oMocmcupB3Nxwx+Cc=
Date: Wed, 24 Apr 2024 14:08:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,r.thapliyal@samsung.com,osalvador@suse.de,lstoakes@gmail.com,hch@infradead.org,hariom1.p@samsung.com,maninder1.s@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-fixing-wrong-information-in-dump_page_owner.patch added to mm-hotfixes-unstable branch
Message-Id: <20240424210856.50577C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_owner: fix wrong information in dump_page_owner
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_owner-fixing-wrong-information-in-dump_page_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-fixing-wrong-information-in-dump_page_owner.patch

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
From: Maninder Singh <maninder1.s@samsung.com>
Subject: mm: page_owner: fix wrong information in dump_page_owner
Date: Wed, 24 Apr 2024 16:48:37 +0530

With commit ea4b5b33bf8a ("mm,page_owner: update metadata for tail
pages"), new API __update_page_owner_handle was introduced and arguemnt
was passed in wrong order from __set_page_owner and thus page_owner is
giving wrong data.

[   15.982420] page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_KERNEL), pid 80, tgid -1210279584 (insmod), ts 80, free_ts 0

Fixing the same.
Correct output:
[   14.556482] page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_KERNEL), pid 80, tgid 80 (insmod), ts 14552004992, free_ts 0

Link: https://lkml.kernel.org/r/20240424111838.3782931-1-hariom1.p@samsung.com
Fixes: ea4b5b33bf8a ("mm,page_owner: update metadata for tail pages")
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Hariom Panthi <hariom1.p@samsung.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Rohit Thapliyal <r.thapliyal@samsung.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-fixing-wrong-information-in-dump_page_owner
+++ a/mm/page_owner.c
@@ -328,7 +328,7 @@ noinline void __set_page_owner(struct pa
 	if (unlikely(!page_ext))
 		return;
 	__update_page_owner_handle(page_ext, handle, order, gfp_mask, -1,
-				   current->pid, current->tgid, ts_nsec,
+				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	page_ext_put(page_ext);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

mm-page_owner-fixing-wrong-information-in-dump_page_owner.patch


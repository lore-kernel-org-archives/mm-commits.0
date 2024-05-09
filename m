Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5C279F2
	for <mm-commits@vger.kernel.org>; Thu,  9 May 2024 18:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715279489; cv=none; b=Lv22+oQtD/ZbBiNGR6dnv8SV7nCkY+1uZ/X3AXhWJ7atl53Kioutu5f+Txsx9obRqD2c52iORemFlETiFRhUWLF1htkz/N3eEicmy+DsKxGMzBY17N5Js0a1nLsAYN3fImmA6vUsXcIEIDkRKEhptYcLOTXRsHGrhEYbirlDl0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715279489; c=relaxed/simple;
	bh=+EUPR2pB1/6G+Fjpqe7GD0y/Fg8n3qNbyn8ckX6LsoI=;
	h=Date:To:From:Subject:Message-Id; b=T+ljon3kNstYqBrDICdx9Y7GSWzgf6LIi9CQ0J7kFiS28R04Q5eaY2hLE3WsCFnLQux1IVe1XiDNBmNbxed7hjOwFz0mqe/ZQ4N+njEeno+sKKVe0v1EXseXDqlCH8BOtRmThFzrXJdAcWG9P3IawYncUljePMVeEZEf9ydVMkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VqBijfht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VqBijfht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AFBC116B1;
	Thu,  9 May 2024 18:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715279489;
	bh=+EUPR2pB1/6G+Fjpqe7GD0y/Fg8n3qNbyn8ckX6LsoI=;
	h=Date:To:From:Subject:From;
	b=VqBijfhtBbWH/OquDwG9L3da7IvLz5e01aBTI9WSyxf5lGrEbzCu3p8VtpqAPXeP8
	 yTSCL3cci/GB+U/E5JWn9g6Z4DWNUPIxBmneX3WhnprYHKLLqK4/rZQmG5HPjjzlP7
	 EDpEUNjrJdBqLwMVsCfX7uk2biwtyOj+48aVzhzU=
Date: Thu, 09 May 2024 11:31:28 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,liushixin2@huawei.com,axelrasmussen@google.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp.patch added to mm-unstable branch
Message-Id: <20240509183129.27AFBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_wp
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_wp
Date: Thu, 9 May 2024 12:01:48 +0200

commit 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage
copy-on-write faults") added support to use the mc variants when coping
hugetlb pages on CoW faults.

Add the missing VM_FAULT_SET_HINDEX, so the right si_addr_lsb will be
passed to userspace to report the extension of the faulty area.

Link: https://lkml.kernel.org/r/20240509100148.22384-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp
+++ a/mm/hugetlb.c
@@ -6067,7 +6067,7 @@ retry_avoidcopy:
 		goto out_release_all;
 
 	if (copy_user_large_folio(new_folio, old_folio, vmf->real_address, vma)) {
-		ret = VM_FAULT_HWPOISON_LARGE;
+		ret = VM_FAULT_HWPOISON_LARGE | VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_release_all;
 	}
 	__folio_mark_uptodate(new_folio);
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault.patch
mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp.patch


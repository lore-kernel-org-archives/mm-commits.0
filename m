Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2841C1F5F6
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467345; cv=none; b=H7qN0+12btZuXWlWt6BCTx3mKyd/rrd1sWEDATugEJa1akfF3OvL08T1JjFfpoDO9JVFwXF9oStNBqBH/9dFx8G86JRPyJbAsuXpI758fpGyUw3SEkJK0qNrTyhUjn4VM3rTnYxMapIEBjxlCN5XL/4ypqyrnhbEgmG3HWArR5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467345; c=relaxed/simple;
	bh=P5VkUV5OiA2rLPDmuIYBko+giomb8Z5bpk3hVQmLj8c=;
	h=Date:To:From:Subject:Message-Id; b=q+JSc7t9oXnkDE+AGt49NPeOnIhK5v3cG41a33fhQG3zDxRMSQ9EhwMpRvE+F8Z0G3IqFbKkf07Dv9uTYDUoXpdmRuvWYDA4XQ3jqoI/LmhPBAsXNtIGnPtQQ+Xd3Q8CVtM7lvOYcU4j9MHj/d12TtDJhYCqvXBzgHrZHTXSm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZoniIJ1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZoniIJ1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD968C32781;
	Sat, 11 May 2024 22:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467344;
	bh=P5VkUV5OiA2rLPDmuIYBko+giomb8Z5bpk3hVQmLj8c=;
	h=Date:To:From:Subject:From;
	b=ZoniIJ1pinsjusenxFD3iPCYVpSL4w2P0V2M6ZI/bhDv52j+Z/GVN9coBtAizyZe5
	 vXHJ+g29BZQhRcSuR1dO28AGLacwjNJXQoqsAmDUoMAdG8Xi7g+8FvVNYsMzdmyEyg
	 fIX/TbA26TiwKH4kEENKxt4WXCkmzbr3otw3cXN4=
Date: Sat, 11 May 2024 15:42:24 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,liushixin2@huawei.com,axelrasmussen@google.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp.patch removed from -mm tree
Message-Id: <20240511224224.AD968C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_wp
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



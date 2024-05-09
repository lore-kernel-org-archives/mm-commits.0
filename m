Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0035A79F2
	for <mm-commits@vger.kernel.org>; Thu,  9 May 2024 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715279488; cv=none; b=mxUsN23ZaPubtSDSohpH+nkzSs46MCq7kzQ9sIE0v4dlu5cKE8TNcG32mmP+ly8vkwFbjGzmRjEZsfxqcMj+ef5+AGkJI7uN0Z+tDAqI7sb81pNUyHmT7Czi1wrp1Set3PQ7jIa11aPvbGBpgtM/rdsjhYjRoHEtUT/3/9x8oNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715279488; c=relaxed/simple;
	bh=1WvF6q8M5VcxqtCFtT7EAiM5vQlo8n8fbWWYcp4jIDo=;
	h=Date:To:From:Subject:Message-Id; b=WvMd08BXeFM9XOnQKJJtLcob1ElKExGxEVWouY6mnJH6lKPpgZFBPib/7vjR4Sxg0D10cir8OVcOcswA7mnt+8gOVjR3rWzNJMOqt3ec3nl8efP7l/cVI5/ShferAqfASfflL0Ej+imKb2AQs0tG4P8ADA/2lAmpZ6GtmNMiVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n4Yb5Gjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n4Yb5Gjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3AFC116B1;
	Thu,  9 May 2024 18:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715279487;
	bh=1WvF6q8M5VcxqtCFtT7EAiM5vQlo8n8fbWWYcp4jIDo=;
	h=Date:To:From:Subject:From;
	b=n4Yb5GjyyV1LtjvZXVKdHmiAQ0LDlOglslah0iDhVq7s1pPIuU9iqOj6SgkVJ4zCn
	 5lTBqGjJzKKwRXTXme2tBUkAWNwxnFHZutlbmp1LjW0r4tjI6Mm15m2wgZes7orfLQ
	 MVYBQes+iCgcjEkV+iKMDc9kVKpqc4lTIRJK3iao=
Date: Thu, 09 May 2024 11:31:26 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,liushixin2@huawei.com,axelrasmussen@google.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault.patch added to mm-unstable branch
Message-Id: <20240509183127.7E3AFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_fault
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault.patch

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
Subject: mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_fault
Date: Thu, 9 May 2024 12:01:47 +0200

Patch series "Minor fixups for hugetlb fault path".

This series contains a couple of fixups for hugetlb_fault and hugetlb_wp
respectively, where a VM_FAULT_SET_HINDEX call was missing.

I did not bother with a Fixes tag because the missing piece here is that
we will not report to userspace the right extension of the faulty area by
adjusting struct kernel_siginfo.si_addr_lsb, but I do not consider that to
be a big issue because I assume that userspace already knows the size of
the mapping anyway.


This patch (of 2):

commit af19487f00f3 ("mm: make PTE_MARKER_SWAPIN_ERROR more general")
added the code to handle pte_markers in hugetlb faulting path.  In case of
an UFFD_POISON event, a PTE_MARKER_POISONED will be created and we will
return VM_FAULT_HWPOISON_LARGE upon detecting that in the fault path.  Add
the missing VM_FAULT_SET_HINDEX, so the right si_addr_lsb will be passed
to userspace to report the extension of the faulty area.

Link: https://lkml.kernel.org/r/20240509100148.22384-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20240509100148.22384-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -6485,7 +6485,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 				pte_marker_get(pte_to_swp_entry(vmf.orig_pte));
 
 			if (marker & PTE_MARKER_POISONED) {
-				ret = VM_FAULT_HWPOISON_LARGE;
+				ret = VM_FAULT_HWPOISON_LARGE |
+				      VM_FAULT_SET_HINDEX(hstate_index(h));
 				goto out_mutex;
 			}
 		}
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_fault.patch
mm-hugetlb-add-missing-vm_fault_set_hindex-in-hugetlb_wp.patch


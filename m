Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5607D2741A3
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751059517; cv=none; b=o2yLi3nbTfshbzqGQRdAy5qFRqNlxz0WZ9smij1AiEWdtXXt3LE6oQRbgHmyfQArzf5LA1TuKOO7sUnVfIbTyURA1t8o3O2X0mgWbVTHIb5ht3nx/grAAG0ZjHT0PRb2Z0p3cocfeVXi9cxB+7Fkne2JKvIm0Ba4DN772JPqgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751059517; c=relaxed/simple;
	bh=aKVXChWhhqq8+l7t15TszRZyy7nXDr+DcoUfMjFrx54=;
	h=Date:To:From:Subject:Message-Id; b=l3anGj9gcx2TV6Kej2CACt53RvbUYhXnBvZlzD7N+RB2AWliou4LSxS0gaCW2zMvXYjGBc2sw1RirRBF2NxM2zyz6Isi/mF9bidApUeuiyEbjzmIYSjNUTjwmYbIVx45tdaHsMZOoXrzOKJOGswnymE3oGU2F9DocRFXB1BWB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OAwS6SGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OAwS6SGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E45C4CEE3;
	Fri, 27 Jun 2025 21:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751059515;
	bh=aKVXChWhhqq8+l7t15TszRZyy7nXDr+DcoUfMjFrx54=;
	h=Date:To:From:Subject:From;
	b=OAwS6SGGtBIw0FQ/HPSxS1qRl1Q8t5ZO0uNl4W5GD02aF9LC2hsG5rhV8PgMNc545
	 tb1gxnZDgvhbUw9zamWVAZYcrmblAs2bYrxjrwb29V9q23hAVTY9gfUjyPK76m6npc
	 5v6zYHb6n/chEv2Kpcj+NTJou8HONCtq7KLc/YVE=
Date: Fri, 27 Jun 2025 14:25:15 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20250627212515.D3E45C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes
Date: Fri Jun 27 02:24:07 PM PDT 2025

WARNING: please, no space before tabs
#41: FILE: mm/hugetlb.c:5462:
+^I.uffd_features^I= ^I__VM_UFFD_FLAGS,$

WARNING: please, no space before tabs
#43: FILE: mm/hugetlb.c:5464:
+^I.uffd_ioctls^I= ^IBIT(_UFFDIO_COPY) |$

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -5459,9 +5459,9 @@ static vm_fault_t hugetlb_vm_op_fault(st
 
 #ifdef CONFIG_USERFAULTFD
 static const vm_uffd_ops hugetlb_uffd_ops = {
-	.uffd_features	= 	__VM_UFFD_FLAGS,
+	.uffd_features	=	__VM_UFFD_FLAGS,
 	/* _UFFDIO_ZEROPAGE not supported */
-	.uffd_ioctls	= 	BIT(_UFFDIO_COPY) |
+	.uffd_ioctls	=	BIT(_UFFDIO_COPY) |
 				BIT(_UFFDIO_WRITEPROTECT) |
 				BIT(_UFFDIO_CONTINUE) |
 				BIT(_UFFDIO_POISON),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fix-do_pages_stat-to-use-compat_uptr_t-fix.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes.patch
maintainers-add-lib-raid6-to-software-raid.patch


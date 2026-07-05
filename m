Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBB3322533
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 22:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783289744; cv=none; b=h9eDYwuYokhunXT+VwddMccvoVhYJ/hoPqyIgQFwX7VMRX88nl8pmN7qVzqQ2wPNShzgCNDOJ2iTgwuWDSbmdylXucN/EpidHOv3aH4pJFlW79pN5AlhoaVO4VejLv0FafO4P4UZLx0kdyjU18if72Od2ni+u6jGqvjocjq2tUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783289744; c=relaxed/simple;
	bh=uHAW4lL8BDwDXbujo2ahTjY4XwLTUx/55txnt1M3FXk=;
	h=Date:To:From:Subject:Message-Id; b=rPZ5SDMg5vWjUStLMwnUCMDmsEO8X3BaM/H0ky/TGOBDLOcoD1V0tlX6JjrSvio4BsKQOp2QcT6Mxq39RFwU9Kdalbix3sK8uVdloAlSS6d3IZch7GH1f/DDdRrG1pNGh6g3cV+Hu6nx97mQhEGhA6MuZdsueaZnzkGoFF4JUik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cNcQTx+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cNcQTx+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175A51F000E9;
	Sun,  5 Jul 2026 22:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783289743;
	bh=2KLs0f5rzLxSyjP9V6dH+rNcH0Uu+zUuoP2tRtfqArY=;
	h=Date:To:From:Subject;
	b=cNcQTx+8MJaZibN4XUI9o0V1TWrUaRKswpsXnbplUbzfTS6WeZgYnRoNej0UX0VI0
	 1kyN7H1FVGA4NaRzTIgJPjV0nqtPHllZzTdadayHarAa/DTs/unOnkTpR6ZHvOqrYy
	 gqvMyfv+zGFyqXAaFeo9gq/KnVgKNlgIGw/AjQJ0=
Date: Sun, 05 Jul 2026 15:15:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch added to mm-new branch
Message-Id: <20260705221543.175A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: nommu: add sysctl_max_map_count() check for do_mmap()
has been added to the -mm mm-new branch.  Its filename is
     mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch

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
From: Hajime Tazaki <thehajime@gmail.com>
Subject: mm: nommu: add sysctl_max_map_count() check for do_mmap()
Date: Thu, 2 Jul 2026 10:28:30 +0900

The sysctl variable vm.max_map_count (sysctl_max_map_count) is not exposed
under !MMU configurations, but its default value (DEFAULT_MAX_MAP_COUNT)
is still used as a allocation limit.  Currently, this limit is enforced
when a VMA entry is split into two chunks (split_vma()), but it is not
checked during initial allocation (do_mmap()).  As a result, if a user
requests a large number of memory allocations, the system will continue
allocating until it hits an Out-Of-Memory (OOM) condition.

This commit introduces a check at the beginning of do_mmap() in nommu.c to
prevent this situation.

This issue was detected using the Linux Test Project (LTP) test linked
below.

Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/munmap/munmap04.c
Link: https://lore.kernel.org/20260702012830.667205-1-thehajime@gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/nommu.c~mm-nommu-add-sysctl_max_map_count-check-for-do_mmap
+++ a/mm/nommu.c
@@ -1035,6 +1035,9 @@ unsigned long do_mmap(struct file *file,
 	if (ret < 0)
 		return ret;
 
+	if (current->mm->map_count >= get_sysctl_max_map_count())
+		return -ENOMEM;
+
 	/* we ignore the address hint */
 	addr = 0;
 	len = PAGE_ALIGN(len);
_

Patches currently in -mm which might be from thehajime@gmail.com are

mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch


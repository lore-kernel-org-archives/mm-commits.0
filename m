Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126E8144304
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 17:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400051; cv=none; b=nmhndTo1p129mFw1Vs0OvkEDQGaOXDY4JTohrN6ugvHQyClt6zh6U2h0gpb/TKJTkn+dZQcRlgfscOOfCQxkHJlKy1YbXsw2oAG4GKrMhotCWh7v6ZUgb/tqNynzr/4dJrsd1dfUnHUstj05Qq1sFfDOxH9ghEFLK95K+nqda/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400051; c=relaxed/simple;
	bh=0Ulzca1etuDe96P1Z/jYjP+u0VVCU4o2sRPrRAJXjHw=;
	h=Date:To:From:Subject:Message-Id; b=NowmUjV6ykAFWkgxo3+KKTE8a17CPO5x8OdPagepojeJ/eHpWVqDhy8s+R4R5ekwgBYKIVxYDe7VOrrMlLDVRewe60Sj4INJCCgPzHuk2t+YRlqsSMhlwIw1DwahNwPMBLupikppMFxM7Cp5a19KTygNFBtHV2ACJ8ckS7D228g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O0zCR7Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O0zCR7Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BF8C2BBFC;
	Wed, 22 May 2024 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716400050;
	bh=0Ulzca1etuDe96P1Z/jYjP+u0VVCU4o2sRPrRAJXjHw=;
	h=Date:To:From:Subject:From;
	b=O0zCR7BdITW/Bi8xvh568lMThz2WOpWq9iRZRL/zFsWZDW9pyWLMr0XnZFVQOKILn
	 hDDtH7Ipy526bNnuYQAUaFvxsAYKl6UNujIj1dkx9SrlSdp8/sE/5GUj3zj5ekHOyL
	 lkMY0NBxKFGRVdBd477/ZynEVZyCgXB4X7gAVspE=
Date: Wed, 22 May 2024 10:47:29 -0700
To: mm-commits@vger.kernel.org,vdonnefort@google.com,dan.j.williams@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-move-page_count-check-into-validate_page_before_insert.patch added to mm-unstable branch
Message-Id: <20240522174730.87BF8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: move page_count() check into validate_page_before_insert()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-move-page_count-check-into-validate_page_before_insert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-move-page_count-check-into-validate_page_before_insert.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: move page_count() check into validate_page_before_insert()
Date: Wed, 22 May 2024 14:57:11 +0200

Patch series "mm/memory: cleanly support zeropage in vm_insert_page*(),
vm_map_pages*() and vmf_insert_mixed()", v2.

There is interest in mapping zeropages via vm_insert_pages() [1] into
MAP_SHARED mappings.

For now, we only get zeropages in MAP_SHARED mappings via
vmf_insert_mixed() from FSDAX code, and I think it's a bit shaky in some
cases because we refcount the zeropage when mapping it but not necessarily
always when unmapping it ...  and we should actually never refcount it.

It's all a bit tricky, especially how zeropages in MAP_SHARED mappings
interact with GUP (FOLL_LONGTERM), mprotect(), write-faults and s390x
forbidding the shared zeropage (rewrite [2] s now upstream).

This series tries to take the careful approach of only allowing the
zeropage where it is likely safe to use (which should cover the existing
FSDAX use case and [1]), preventing that it could accidentally get mapped
writable during a write fault, mprotect() etc, and preventing issues with
FOLL_LONGTERM in the future with other users.

Tested with a patch from Vincent that uses the zeropage in context of
[1].

[1] https://lkml.kernel.org/r/20240430111354.637356-1-vdonnefort@google.com
[2] https://lkml.kernel.org/r/20240411161441.910170-1-david@redhat.com


This patch (of 3):

We'll now also cover the case where insert_page() is called from
__vm_insert_mixed(), which sounds like the right thing to do.

Link: https://lkml.kernel.org/r/20240522125713.775114-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-move-page_count-check-into-validate_page_before_insert
+++ a/mm/memory.c
@@ -1987,6 +1987,8 @@ static int validate_page_before_insert(s
 {
 	struct folio *folio = page_folio(page);
 
+	if (!folio_ref_count(folio))
+		return -EINVAL;
 	if (folio_test_anon(folio) || folio_test_slab(folio) ||
 	    page_has_type(page))
 		return -EINVAL;
@@ -2041,8 +2043,6 @@ static int insert_page_in_batch_locked(s
 {
 	int err;
 
-	if (!page_count(page))
-		return -EINVAL;
 	err = validate_page_before_insert(page);
 	if (err)
 		return err;
@@ -2176,8 +2176,6 @@ int vm_insert_page(struct vm_area_struct
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!page_count(page))
-		return -EINVAL;
 	if (!(vma->vm_flags & VM_MIXEDMAP)) {
 		BUG_ON(mmap_read_trylock(vma->vm_mm));
 		BUG_ON(vma->vm_flags & VM_PFNMAP);
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch


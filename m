Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D09924676C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759872998; cv=none; b=l2H5sW7dcQXTIE/Za9X79n2Y3A4bWh8Szu2zPP48/H25Zf7uPXUNEg+dKxheozu0L3BXW5n5OQsAL4ZLxWfRwcD2roGJvQTW8DRVPv7Zo/zb6y89/J9TcaXlYnhubjKuKlzhOBS3fqfpgNQngjNi+PFe6vrMCzUw865nB5ZR6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759872998; c=relaxed/simple;
	bh=uGSYVZuCYkjgbVUvZyq577jE0xRDeYPK4285nUGBrwI=;
	h=Date:To:From:Subject:Message-Id; b=fcddeTPKWXIi3O1U7OSkN0kWTZBsHXCSCvNoFQOeI+Ud7GHSsmRXXwClCngj1DJn0wwaDtHJt1L27DI0xO1QABq+TiE1Ur0HUYW4n8g1Pesa7vA+sMCP1c+jiplK6Npt3eQUC5NcwGoa/o3zj4Flgo0WEt2XqEEgUcSe8QF1ti4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f42TlsNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f42TlsNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB633C4CEF1;
	Tue,  7 Oct 2025 21:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872997;
	bh=uGSYVZuCYkjgbVUvZyq577jE0xRDeYPK4285nUGBrwI=;
	h=Date:To:From:Subject:From;
	b=f42TlsNc5G04f2s/Go8rm1JIUQhV95/n6jxqn8hgOxNAXDPCWO8d2nKLiOsXkHkZt
	 9Xl2eUkP/j1yg/+PCHsZFDD/DSgPE74ssPUAquiIusXzTFIc4vJa7oYKmrctXjSkBy
	 /MMst4gVydQQ/8DGCHBt/yK+4/bCMjrB9RD4T2ZQ=
Date: Tue, 07 Oct 2025 14:36:37 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch added to mm-new branch
Message-Id: <20251007213637.AB633C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: support non-blocking GFP in kasan_populate_vmalloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/kasan: support non-blocking GFP in kasan_populate_vmalloc()
Date: Tue, 7 Oct 2025 14:20:31 +0200

A "gfp_mask" is already passed to kasan_populate_vmalloc() as an argument
to respect GFPs from callers and KASAN uses it for its internal
allocations.

But apply_to_page_range() function ignores GFP flags due to a hard-coded
mask.

Wrap the call with memalloc_apply_gfp_scope()/memalloc_restore_scope() so
that non-blocking GFP flags(GFP_ATOMIC, GFP_NOWAIT) are respected.

Link: https://lkml.kernel.org/r/20251007122035.56347-7-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/kasan/shadow.c~mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc
+++ a/mm/kasan/shadow.c
@@ -377,18 +377,10 @@ static int __kasan_populate_vmalloc(unsi
 		 * page tables allocations ignore external gfp mask, enforce it
 		 * by the scope API
 		 */
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			flags = memalloc_nofs_save();
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			flags = memalloc_noio_save();
-
+		flags = memalloc_apply_gfp_scope(gfp_mask);
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
-
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			memalloc_nofs_restore(flags);
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			memalloc_noio_restore(flags);
+		memalloc_restore_scope(flags);
 
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch


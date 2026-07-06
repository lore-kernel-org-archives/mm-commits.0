Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB73E3D8F
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379760; cv=none; b=j7ajISVFNG7baVnkvU0cIKoXr3h4KgbyMCDvxAi206NUAt8j0spNQpPvQx4KHMT339WvhzIvjxgCPNXw3lxi8iGN8zm40bzG7DAWAxACW1lK6ptw/ukZLG1yUzfkl1660dMiVjD3cbVdi/JcvhwnNflUzGAxv+ykWCGTPmuSlVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379760; c=relaxed/simple;
	bh=Db1jZBvGbNFdpCexEgITNfQXpANiAPf/VzkXXoppFeU=;
	h=Date:To:From:Subject:Message-Id; b=BMaU4Gx+Fr6aO7TRtO4A8T/FdvpEg0/EqJVcI8utkQabMaDatJzGDLxQUiwJNgSDSjcdPJ52zUTfil6F018X9ZBiceRhBVj9GSjZCwYT4Pe8+9mEBWgHH9c1zQBEH3RgulWIJ6RojimME9doCrDy4asxcnxCbPPAXold3XStFRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djfPj/kR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djfPj/kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52471F000E9;
	Mon,  6 Jul 2026 23:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379757;
	bh=RuQHjBb2gvAxDYOCKLJ/JEG3v+aJP5EOxQKy15vhvdg=;
	h=Date:To:From:Subject;
	b=djfPj/kRceRrRy/APKlBe44c+79xlQkF+zHn5pWsjmcqkBkDSaRnCsxRCZAFoxXwB
	 aPitdTdxG7hdv8aWnZm7f+CXRRkIEO6JlIl/XUxJPT+MQx+5CtRLfiO6RrSaDC0cKK
	 JQbjKKC3iPkpBlPQZd3rZRqYnq/CGn9Z2pwDCDD4=
Date: Mon, 06 Jul 2026 16:15:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-entirely-remove-lru_add_drain-in-do_swap_page.patch added to mm-new branch
Message-Id: <20260706231557.B52471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: entirely remove lru_add_drain in do_swap_page
has been added to the -mm mm-new branch.  Its filename is
     mm-entirely-remove-lru_add_drain-in-do_swap_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-entirely-remove-lru_add_drain-in-do_swap_page.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: entirely remove lru_add_drain in do_swap_page
Date: Thu, 2 Jul 2026 07:59:54 +0800

We are doing a lot of redundant lru_add_drain() calls in do_swap_page(),
especially for synchronous I/O devices.  For example, the test program
below currently ends up draining lru_cache 100% of the time:

int main(int argc, char *argv[])
{
        int i;
 #define SIZE 100*1024*1024
	while(1) {
		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		madvise((void *)p, SIZE, MADV_PAGEOUT);
		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		munmap(p, SIZE);
	}
	return 0;
}

Folio reuse now relies primarily on the exclusive hint, making lru_cache
draining to drop the refcount in lru_cache largely irrelevant.  For a
kernel build with a minimal configuration running in a 1 GB memcg, this
patch skips more than 43,000 redundant local LRU drains.

Link: https://lore.kernel.org/20260701235955.36126-4-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/mm/memory.c~mm-entirely-remove-lru_add_drain-in-do_swap_page
+++ a/mm/memory.c
@@ -4894,16 +4894,6 @@ vm_fault_t do_swap_page(struct vm_fault
 	} else if (folio != swapcache)
 		page = folio_page(folio, 0);
 
-	/*
-	 * If we want to map a page that's in the swapcache writable, we
-	 * have to detect via the refcount if we're really the exclusive
-	 * owner. Try removing the extra reference from the local LRU
-	 * caches if required.
-	 */
-	if ((vmf->flags & FAULT_FLAG_WRITE) &&
-	    !folio_test_ksm(folio) && !folio_test_lru(folio))
-		lru_add_drain();
-
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch


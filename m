Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793671004;
	b=yCZSIcpO8k7T05fI1a45pyCSwVCprtCyuoWDSRBM0zhuh6BOKPH3Z4YgH183ivKToxod
	 l/kadqOeQ6nOdo/oqejR6YtvBjc7875Vwj7IpKux/ywI3b4OmQHSit1RjMzSgU3TVGYjW
	 J9kQruY46mW07JcCWKPdh6JwPvNRFiP2bV2WmmwsPJGikbQha+pyAn7tPtL0DQwOo0+27
	 86/O1S1R6Itd4jGLSeMFbFDkMQsf0jTOfyxKSd3K4O6zW0LIrOweq9QLx5e7cFEdNy6Ev
	 V1CocYatwsJJDUpFqN7tteGU8PV6Dbz2ubPltLmivwaHh/oDUZWjZBcnnvqsgGYY9lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793671004;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mN2ARbKjJcTjUlWq9QSQ+QhBO+L2ipFKpD6yTfDAm+c=;
	b=ZzTpH+6rQ/37S3/Ug4GPuLS0dTNZHU4Sn7Fu7VsWXOvB/Qg4KKLOeRym3zhluuDiwcgP
	 wPegVHmCBSdE2+2YUTfC5jF53FUx2mFZDp610unUNUIL41MdyT9fTMy/leR5rXJKlZB1V
	 XsnQwx1uSswQTY7ej5fWQVP/5UVWFlo8/9bhIMBx0t73R0jlfWgaLccvto1MeXCWPbLVG
	 tK1HbsO3knBWNjXRM1YJXQo7j5w/bjI9OZDrV7kzQvBLVd6sNove386voAb8mGPc4/Hc+
	 sXR0FAamn0ZHo37JgaubBjL2sMJKLhChpPRmmSdws7fh8L8vAl/DkQW6x1ruDu+drJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AEqw0T+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B4B606A326
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AEqw0T+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CFB1F000C1;
	Tue,  3 Nov 2026 01:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793671003;
	bh=mN2ARbKjJcTjUlWq9QSQ+QhBO+L2ipFKpD6yTfDAm+c=;
	h=Date:To:From:Subject;
	b=AEqw0T+WsQCJfNvOJUHyvRJe4LqVHYjufknW4b5I1ymMAMCwFS1cJPp9m1zadgF9F
	 zR3NZwtxvqfbDAvo3z253PVYHveBhG3AQnhF4V9MfRdQ+cz+iaKKYDk+R66t8vLllT
	 o8SEI62bqJ//yzCrH/U6WqdyKIDuJWNYYzY97IeM=
Date: Mon, 02 Nov 2026 17:56:43 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-thp_size-and-thp_order.patch added to mm-new branch
Message-Id: <20261103015643.C6CFB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove thp_size() and thp_order()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-thp_size-and-thp_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-thp_size-and-thp_order.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove thp_size() and thp_order()
Date: Mon, 02 Nov 2026 17:54:13 -0500

The last callers of thp_size() have been converted to folio_size(), and
thp_order()'s only remaining user was thp_size() itself, so remove
both.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 include/linux/mm.h |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/include/linux/mm.h~mm-remove-thp_size-and-thp_order
+++ a/include/linux/mm.h
@@ -2146,27 +2146,6 @@ static inline unsigned int page_shift(st
 	return PAGE_SHIFT + compound_order(page);
 }
 
-/**
- * thp_order - Order of a transparent huge page.
- * @page: Head page of a transparent huge page.
- */
-static inline unsigned int thp_order(struct page *page)
-{
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_order(page);
-}
-
-/**
- * thp_size - Size of a transparent huge page.
- * @page: Head page of a transparent huge page.
- *
- * Return: Number of bytes in this page.
- */
-static inline unsigned long thp_size(struct page *page)
-{
-	return PAGE_SIZE << thp_order(page);
-}
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
mm-remove-wait_on_page_writeback.patch
mm-remove-end_page_writeback.patch
mm-remove-clear_page_dirty_for_io.patch
mm-remove-attach_page_private-and-detach_page_private.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch


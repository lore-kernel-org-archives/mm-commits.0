Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D07134BD
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756859115; cv=none; b=QVqNYxoeK1U6T+r8d6nW5etqcxGvc/ArVcAIDNT3yQXwcJMkyvQ2uEvQ+VDdsNnrs+6eiTf6pdwhE4+P5zqq0ydN83ebqEaIoi59/UJvHDzJPqePeA97YZvI68vOnYMUeiV5o68ucwGi7cIlX9AiX1JwSCV/qYenZPPAp8EucE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756859115; c=relaxed/simple;
	bh=UP8BaW9jSfZxtbIebX8RaKiqvUnHHlIDiycIJpudBDs=;
	h=Date:To:From:Subject:Message-Id; b=IeyH8BnShmdYkVqd3CMbUBYTVK6MgdwRQENLWxVnX/3mgJJAq+8v52KNmcIzFsgvnUiOzyZgHywD6RKR17u11hxfTVtoVT7a0Fi3YmYbIT1xYlu1p/uleMrWLxQhUClk6pjf8HioEyc4DD9DMxcQsMXDY8zF6arZ72UXhqOJFP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fjdihPQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fjdihPQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DA1C4CEED;
	Wed,  3 Sep 2025 00:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756859115;
	bh=UP8BaW9jSfZxtbIebX8RaKiqvUnHHlIDiycIJpudBDs=;
	h=Date:To:From:Subject:From;
	b=fjdihPQqdBYqPUHemwgJo9h183l75mC8U59Y+qs6AKeC3eyqmYiESBPvXJjbN/xJ2
	 6gjLoMbRfIpEpJdMV6P2eKEd5QRWLfZM/LBqZsU3+9viPRrkh6lKuNWzSj+o/lUPXz
	 7MXWWusLXiChs+09LwkUx9w9ePLA+uJrjhyx9baQ=
Date: Tue, 02 Sep 2025 17:25:14 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,thuth@redhat.com,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,osalvador@suse.de,nysal@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,jfalempe@redhat.com,jcmvbkbc@gmail.com,james.bottomley@HansenPartnership.com,jack@suse.cz,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,deller@gmx.de,david@redhat.com,davem@davemloft.net,chris@zankel.net,broonie@kernel.org,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,andreas@gaisler.com,agordeev@linux.ibm.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-constify-mapping-related-test-functions-for-improved-const-correctness.patch added to mm-new branch
Message-Id: <20250903002514.E6DA1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: constify mapping related test functions for improved const-correctness
has been added to the -mm mm-new branch.  Its filename is
     fs-constify-mapping-related-test-functions-for-improved-const-correctness.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-constify-mapping-related-test-functions-for-improved-const-correctness.patch

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
From: Max Kellermann <max.kellermann@ionos.com>
Subject: fs: constify mapping related test functions for improved const-correctness
Date: Mon, 1 Sep 2025 22:50:13 +0200

We select certain test functions which either invoke each other, functions
that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which provides a
basis for further const-ification further up the call stack.

Link: https://lkml.kernel.org/r/20250901205021.3573313-5-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Nysal Jan K.A" <nysal@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/fs.h~fs-constify-mapping-related-test-functions-for-improved-const-correctness
+++ a/include/linux/fs.h
@@ -537,7 +537,7 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +585,7 @@ static inline void i_mmap_assert_write_l
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +599,7 @@ static inline int mapping_mapped(struct
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
_

Patches currently in -mm which might be from max.kellermann@ionos.com are

pagevech-add-const-to-pointer-parameters-of-getter-functions.patch
huge_mmh-disallow-is_huge_zero_folionull.patch
mm-constify-shmem-related-test-functions-for-improved-const-correctness.patch
mm-constify-pagemap-related-test-getter-functions.patch
mm-constify-zone-related-test-getter-functions.patch
fs-constify-mapping-related-test-functions-for-improved-const-correctness.patch
mm-constify-process_shares_mm-for-improved-const-correctness.patch
mm-s390-constify-mapping-related-test-getter-functions.patch
parisc-constify-mmap_upper_limit-parameter.patch
mm-constify-arch_pick_mmap_layout-for-improved-const-correctness.patch
mm-constify-ptdesc_pmd_pts_count-and-folio_get_private.patch
mm-constify-various-inline-functions-for-improved-const-correctness.patch
mm-constify-assert-test-functions-in-mmh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness.patch


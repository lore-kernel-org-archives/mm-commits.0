Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6957134BD
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756859120; cv=none; b=fu+you+j1JGYNobbDTNKTLrSxOiDgc5tX7HhkD9B2ZAvPHthlgkb/W+VgdmT79BOc4bTuN5Tr2pReDj7JjYUL6pkKaadRJdVCJb7CblIjgAR7IIV1KF89uUKAbxVUs2v7sMMWYYNJAyeitFgkQq9f2Id/aKFof0YYY9sdh4jYX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756859120; c=relaxed/simple;
	bh=yKoZXhu7/7dx9BoQvEC/0z+EeHCEYRBRfwjJPOXUtR0=;
	h=Date:To:From:Subject:Message-Id; b=beS5Sh4rH6B+kcNK1NW+lXpqUZxLYBe4H6PKm0EnevTQdNGu5/f+AFOB0fR7X3TLDk9FcmWvjBufuogFPpH+lBP9BAlhh331ZLTJO1inLXzLzrdIvqv+vFrDEFTnSyfCncUBR4Nv0Cc58jtsQ/91y+SpKDGUYHy3b0lYU2l+PSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xnDrQ6Sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xnDrQ6Sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F4BC4CEED;
	Wed,  3 Sep 2025 00:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756859119;
	bh=yKoZXhu7/7dx9BoQvEC/0z+EeHCEYRBRfwjJPOXUtR0=;
	h=Date:To:From:Subject:From;
	b=xnDrQ6SlY6p3TPwN6xbXy8a4Db0HOqycawq+TpMDJLFc/lEgfeU1F8+atNAB0KwIc
	 ce0QOsLZix1wLquVxpHGBqKf6um4lbHZuofDFOWfhuGhpC2Fme9Fnf6AyQLis2TGuu
	 ErLlIGtTmBfLnPBDTGzsnJCzTd3ZwaBeTFTBU+a4=
Date: Tue, 02 Sep 2025 17:25:19 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,thuth@redhat.com,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,osalvador@suse.de,nysal@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,jfalempe@redhat.com,jcmvbkbc@gmail.com,james.bottomley@HansenPartnership.com,jack@suse.cz,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,deller@gmx.de,david@redhat.com,davem@davemloft.net,chris@zankel.net,broonie@kernel.org,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,andreas@gaisler.com,agordeev@linux.ibm.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-constify-mmap_upper_limit-parameter.patch added to mm-new branch
Message-Id: <20250903002519.B6F4BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: parisc: constify mmap_upper_limit() parameter
has been added to the -mm mm-new branch.  Its filename is
     parisc-constify-mmap_upper_limit-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-constify-mmap_upper_limit-parameter.patch

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
Subject: parisc: constify mmap_upper_limit() parameter
Date: Mon, 1 Sep 2025 22:50:16 +0200

For improved const-correctness.

This piece is necessary to make the `rlim_stack` parameter to mmap_base()
const.

Link: https://lkml.kernel.org/r/20250901205021.3573313-8-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
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
Cc: Christian Brauner <brauner@kernel.org>
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
Cc: Jan Kara <jack@suse.cz>
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

 arch/parisc/include/asm/processor.h |    2 +-
 arch/parisc/kernel/sys_parisc.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/processor.h~parisc-constify-mmap_upper_limit-parameter
+++ a/arch/parisc/include/asm/processor.h
@@ -48,7 +48,7 @@
 #ifndef __ASSEMBLER__
 
 struct rlimit;
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
--- a/arch/parisc/kernel/sys_parisc.c~parisc-constify-mmap_upper_limit-parameter
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsign
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack)
 {
 	unsigned long stack_base;
 
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


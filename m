Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCE2371873
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 22:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783290447; cv=none; b=NSHD0zS6xoYzKES9m/v4zM4tlSaKB946DLwrI15fxSh7hGf3LrHNMbIU2DblOd8JkmyHS7o59tq/zytg+Dx5Eiq0Y9JdpHY1uj63poTjYhdRiXZars2y8H5XWOOLJ+hJCGE2t3SSriIEKEYqmwSBzcBEUbXJwsuM3dbld4cPRM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783290447; c=relaxed/simple;
	bh=2CTMJimz6TR4PZGZ3nFvSfumco0FMCKk9IgUYrFkBUA=;
	h=Date:To:From:Subject:Message-Id; b=k7+8YJlbwzoB5WRKeDzu9rvnakeukV793HhDQTGqCVFCXs/vbEMbV1OBJq9AE6qi3Dcp+HNuH1C8Z15JKKelL7XCqKNMfiR9JiBOjAYH2e3nb/WU2foU3bvRJqkR+kqfSX/xT7VefA11v6vqKIad/AP04Aw9cKtWCUznYC2Zcsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbHt179c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbHt179c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32161F000E9;
	Sun,  5 Jul 2026 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783290445;
	bh=O7lOHbZgA5kxz86fElouUyEdtN1IJrjlcU4YCUyDrcg=;
	h=Date:To:From:Subject;
	b=vbHt179c008Yuy6BrXWjR1Ps7GCt6Mfgn48yxRZqeG9GTKC9ToZzoQ59tG3OeLDmK
	 Fu5AwBNKBh8rfz2BasCOUrVSKGiKaJtfFh0cXWcjKjLZYRSJoMeF78wRb+Rbi0pSgy
	 exjeRl1lzITMRFN14Vh+D5rvZ9Bm09ewpdlRQzBA=
Date: Sun, 05 Jul 2026 15:27:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-point-to-the-write-iterator-upon-split_vma.patch added to mm-new branch
Message-Id: <20260705222725.B32161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: nommu: point to the write iterator upon split_vma
has been added to the -mm mm-new branch.  Its filename is
     mm-nommu-point-to-the-write-iterator-upon-split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-point-to-the-write-iterator-upon-split_vma.patch

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
Subject: mm: nommu: point to the write iterator upon split_vma
Date: Thu, 2 Jul 2026 10:25:46 +0900

When a user invokes munmap(2) on a partial region allocated by mmap(), the
kernel may split the original region if necessary and shrink it to the
correct size.  At the beginning of vmi_shrink_vma(), the unused part is
cleared; however, an assertion is triggered if the shrink occurs after
split_vma().

This commit fixes the issue by correctly configuring the pointer to the
iterator at the end of split_vma().

This bug was detected using the Linux Test Project (LTP) test linked
below, running on a nommu UML (User-Mode Linux) environment (via an
out-of-tree extension to UML).

Here is a minimal reproducible chunk of code for this issue:

	void *addr;
	size_t pagesize = getpagesize();

	addr = mmap(NULL, pagesize * 4, PROT_READ | PROT_WRITE,
		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
	munmap(addr + pagesize * 1, pagesize);

This is the console output with CONFIG_DEBUG_MAPLE_TREE=y.

nommu: WARN at __mas_set_range:791 (1)
MAS: tree=0000000091c23b08 enode=0000000065057663
(ma_active)
Store Type:
node_store
[9/9] index=70af8000 last=ffffffffffffffff
     min=0 max=ffffffffffffffff sheaf=0000000000000000, request 0
depth=0, flags=0
maple_tree(0000000091c23b08) flags 307, height 1 root 0000000083394c06
0-ffffffffffffffff: node 0000000010c90bd6 depth 0 type 1 parent
0000000050e1ddf8 contents: 0000000000000000 707A
7FFF 00000000eb0ac2b5 707AFFFF 0000000000000000 7093FFFF
0000000045ead616 7095FFFF 0000000000000000 7096CFFF 000
00000681c7151 7096FFFF 0000000000000000 70AF3FFF 000000006c78b9e9
70AF4FFF 000000001914ab0b 70AF7FFF 00000000000
00000 FFFFFFFFFFFFFFFF 0000000000000000 0 0000000000000000 0
0000000000000000 0 0000000000000000 0 0000000000000
000 0 00000000bca8be4f
  0-707a7fff: 0000000000000000
  707a8000-707affff: 00000000eb0ac2b5
  707b0000-7093ffff: 0000000000000000
  70940000-7095ffff: 0000000045ead616
  70960000-7096cfff: 0000000000000000
  7096d000-7096ffff: 00000000681c7151
  70970000-70af3fff: 0000000000000000
  70af4000-70af4fff: 000000006c78b9e9
  70af5000-70af7fff: 000000001914ab0b
  70af8000-ffffffffffffffff: 0000000000000000
nommu: Pass: 796 Run:797

Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/mseal/mseal02.c
Link: https://lore.kernel.org/20260702012546.665383-1-thehajime@gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/nommu.c~mm-nommu-point-to-the-write-iterator-upon-split_vma
+++ a/mm/nommu.c
@@ -1370,6 +1370,10 @@ static int split_vma(struct vma_iterator
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
 	vma_iter_store_new(vmi, new);
+
+	/* vmi should point lower address */
+	if (new_below)
+		vma_next(vmi);
 	mm->map_count++;
 	return 0;
 
_

Patches currently in -mm which might be from thehajime@gmail.com are

mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch
mm-nommu-point-to-the-write-iterator-upon-split_vma.patch


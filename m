Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF9D32AACB
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622258; cv=none; b=CK150Wc++fNeySSBhAB8bTN9yeW57ZfRHFonKf5HnXstVdS7AGBD3xKNN5FVnSpfNjvz/ielZUfSHrmokLzwXtQPrSjGxJo/IN0CpPR4TB8DlhqlTXXLPwLdmixpGSap18Ds3iXF57sWsIAWa1CxcOTjVW5V6p2WFdp0DcEJnSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622258; c=relaxed/simple;
	bh=xKlLLhbaGygGG9olyGmvaOwq6s3XhMaHIV2ktsQCXC4=;
	h=Date:To:From:Subject:Message-Id; b=r5gI4xhkYWQY8+gpDRo+PN5YZwhJ64vPB+bfScC9CMUZGuTxiGgETkO0Zn9zgyxuXx083eDlQ59JQGkPDNarnla8/JFb8Ul495f7f43HaaWtKxn3WdsJSzL103zCAiLrFMNXvSBc7M1PWGvRODADDe/MvBlKdbcVGtKkcvbkQjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o2rTOAvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o2rTOAvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188381F00A3A;
	Tue, 25 Aug 2026 01:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622257;
	bh=2y1J2FZ9IAwcCN+pPGTBL3TuYggRxj2/l6Ji5tAukhg=;
	h=Date:To:From:Subject;
	b=o2rTOAvjKEJG4FrQD6jXtq0Qwr7Pc/v9HejDcPr2f+ZT4pJ6PHLJOt8qFJscNyt3A
	 bIOp8T+saruFceiEM74NDXRm42ROgsEM3lHGlmFTB0Fe4L9pN7Ltp5Sx8Q2XjjEz4i
	 2qk5wvL1DS3JTDNYtr7ADunCVxQ1YuOrQKtHyvFo=
Date: Mon, 24 Aug 2026 18:44:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-point-to-the-write-iterator-upon-split_vma.patch removed from -mm tree
Message-Id: <20260825014417.188381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: nommu: point to the write iterator upon split_vma
has been removed from the -mm tree.  Its filename was
     mm-nommu-point-to-the-write-iterator-upon-split_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1393,6 +1393,10 @@ static int split_vma(struct vma_iterator
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



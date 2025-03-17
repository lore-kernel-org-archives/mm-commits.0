Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779462153D5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188234; cv=none; b=qkJ32f9x+aDiCreoaCHzVMZEkGe38ybgN2JEXwIBgtlmVX/Td7b8t9oxnpmeJRkBFaT6DQj+qNZt55zcFNN93MeQ7042dzmekP492uTsm0D2yKgM6tbSoj1Av3gE/RZw++peE/kS+IHo3MSTmd6+1Cv2Q2CBHSgNu6VUMZ15rjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188234; c=relaxed/simple;
	bh=Sc9F80Df2FHmlL6y8YLzldIx1Sql1wP4js0D0IE704Y=;
	h=Date:To:From:Subject:Message-Id; b=SjbY84x0FJfBOeRpK6y2bfKeMZ5JHvwafXB1TJcIa8IteSqJtOWlNkcBEyB17zqlzHX+z2I/kXGJY5LTi60cPFM934b9CKG+mSzWXBKddRtRugk4sd7ah/WepdF9kyEEBHWMHli0m0fhJTKY5EzniG5O0290lRdVwp+Gg7O0BnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yK1uq1m1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yK1uq1m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B360C4CEEC;
	Mon, 17 Mar 2025 05:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188234;
	bh=Sc9F80Df2FHmlL6y8YLzldIx1Sql1wP4js0D0IE704Y=;
	h=Date:To:From:Subject:From;
	b=yK1uq1m13OjXMiK3NBNWVyNKGL0TxYcrKgDFAcHb34pWkELo5r59olIqm+0OlDZ6r
	 plP2vEKgv82aObRLGpbPR+8nNzjhIHPR2K1xT8I0unYfR84Y9PwTSNZAeGfn6Vrg5s
	 lrITQ6vkh6HTieWLxAGSnazMzI08MMVi//T4gMCg=
Date: Sun, 16 Mar 2025 22:10:33 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-fix-spelling-and-grammatical-issues.patch removed from -mm tree
Message-Id: <20250317051034.4B360C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: fix spelling and grammatical issues
has been removed from the -mm tree.  Its filename was
     mm-memfd-fix-spelling-and-grammatical-issues.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/memfd: fix spelling and grammatical issues
Date: Thu, 6 Feb 2025 14:09:58 +0800

The comment "If a private mapping then writability is irrelevant" contains
a typo.  It should be "If a private mapping then writability is
irrelevant".  The comment "SEAL_EXEC implys SEAL_WRITE, making W^X from
the start." contains a typo.  It should be "SEAL_EXEC implies SEAL_WRITE,
making W^X from the start."

Link: https://lkml.kernel.org/r/20250206060958.98010-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~mm-memfd-fix-spelling-and-grammatical-issues
+++ a/mm/memfd.c
@@ -259,7 +259,7 @@ static int memfd_add_seals(struct file *
 	}
 
 	/*
-	 * SEAL_EXEC implys SEAL_WRITE, making W^X from the start.
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
 	 */
 	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
 		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
@@ -337,7 +337,7 @@ static int check_write_seal(unsigned lon
 	unsigned long vm_flags = *vm_flags_ptr;
 	unsigned long mask = vm_flags & (VM_SHARED | VM_WRITE);
 
-	/* If a private matting then writability is irrelevant. */
+	/* If a private mapping then writability is irrelevant. */
 	if (!(mask & VM_SHARED))
 		return 0;
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch
mm-debug-add-line-breaks.patch


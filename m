Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66F0372677
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028804; cv=none; b=PeZQKErWWbvTcqNCygz2v5N+kqHWfq9moWQ7xWnDnlS05Rq3HGOno8gMU4WjQOAdNb0jeTQgBq5UGlIFUh2jdI+zDoksj675zxrwDv8lk3XBlzs2Y1XH1zVxvOFHiHBntpie90AQ6SoXxgoevwOA4T1RKiFULGjhIpvV44GXqr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028804; c=relaxed/simple;
	bh=4MdlqjSf8jQgCjjzxlsg3lqPhCTVf1oMAcGp+UI5e9w=;
	h=Date:To:From:Subject:Message-Id; b=SvkgZhVdbta+zYxvYROZ2/goO2VXtMA1BoXu3y/HDm4FcoOP7O1hTzuYGHieUodj+SQG7hpCwF2NwJr3HCnN3LD/8Wt6E5nROzlL+IVnUZSwz5Ak2QyOv7MNpl7e/+F8bl09Z1r0535hyp4Hs7PnxpP9b5lylz/2pvgiJKuxTq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c+MEPrY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c+MEPrY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B55C1F00898;
	Fri, 29 May 2026 04:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028803;
	bh=xkRGo8NnpeJteQJ6vtobdB159xtlKQOi6cGfJreOziU=;
	h=Date:To:From:Subject;
	b=c+MEPrY4zpq4UiyDD4pHJuz3PWOhjFu0wnSNJpnmKxqNLFzAmigSCvDDcyuRaoNFq
	 96e7e/sMuDmthyJ3OV8Grf7I2lXgKEDSBZPxrMBIYHVZp3ofDVLOOmzU/vfyq2Gk1F
	 det9aDyM2LaIiJTbzoqpbPzO4A64XjSdFx5MI4II=
Date: Thu, 28 May 2026 21:26:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,song@kernel.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,linan122@huawei.com,kernel@xen0n.name,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,dsterba@suse.com,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-remove-unused-defines-in-pqh.patch removed from -mm tree
Message-Id: <20260529042643.4B55C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: remove unused defines in pq.h
has been removed from the -mm tree.  Its filename was
     raid6-remove-unused-defines-in-pqh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6: remove unused defines in pq.h
Date: Mon, 18 May 2026 07:17:47 +0200

These are not used anywhere in the kernel.

Link: https://lore.kernel.org/20260518051804.462141-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/raid/pq.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/raid/pq.h~raid6-remove-unused-defines-in-pqh
+++ a/include/linux/raid/pq.h
@@ -90,12 +90,6 @@ extern const struct raid6_calls raid6_ne
 extern const struct raid6_calls * const raid6_algos[];
 extern const struct raid6_recov_calls *const raid6_recov_algos[];
 
-/* Return values from chk_syndrome */
-#define RAID6_OK	0
-#define RAID6_P_BAD	1
-#define RAID6_Q_BAD	2
-#define RAID6_PQ_BAD	3
-
 /* Galois field tables */
 extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
 extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
_

Patches currently in -mm which might be from hch@lst.de are



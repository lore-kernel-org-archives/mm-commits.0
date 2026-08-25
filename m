Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB7837268D
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622947; cv=none; b=s1R3QYCshhJ0n6Tp9mfHmNaIkkIboKQLxwQwuNb15AvfH4hpnTy6bCVB/2znqlGhdyAn9GM1PqP0dO3u22gyDoZnw3ul/j0riK2dg8GP4VAPHMybNoP2QqAKiN9gdtl+o+maUsHU/+fPI9mUVVTzPsnDykzaw9skVmcQalpFlm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622947; c=relaxed/simple;
	bh=Fe8zZBP2cQRJ7vxjkHn7rkQswARawT4ZF14T7P8ADgI=;
	h=Date:To:From:Subject:Message-Id; b=kfLxqz/DWVziiJFyNL2kho/t+wIhPIi2yi4pkY1Bu6VOhjgN83dUIeTe4wpg8GnSVWdqT0BsG3SsbzD/Y71lyZiHs9S9lDYZS+Cg6yDvzhzJXCv4nmHG5UsxyMONl7LYlv8bRIrr+QSJi6K/gi8zZKaM15AP7sX2MKuJXygRs/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bn2iaiL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bn2iaiL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804D91F000E9;
	Tue, 25 Aug 2026 01:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622945;
	bh=yFNAZ/eKy1zQyV0w5S5ixpRYeOgdEP0cKbV2DUP+IpI=;
	h=Date:To:From:Subject;
	b=Bn2iaiL+VZliq75eiczqQbd+vkh4diLfYMwU4bQL4elLY9o2hG3rjZQloAiAat9tq
	 cHJaSaezei2wRdSgiu7bF3tUcXeuI3pFNGxCTQpOX19PULHuKz99T8yXpB28NJiO1i
	 eo+xJ717uBiMb3QkQUvunBjr0TBRuu49YY4KpdaQ=
Date: Mon, 24 Aug 2026 18:55:45 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug.patch removed from -mm tree
Message-Id: <20260825015545.804D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: fix garbage pfn and wrong direction in devmem fault debug
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiang Liu <liuqiang@kylinos.cn>
Subject: lib/test_hmm: fix garbage pfn and wrong direction in devmem fault debug
Date: Wed, 12 Aug 2026 17:28:56 +0800

Move pr_debug() inside the `if (dpage)` block to avoid printing garbage
pfn for NULL dpage, and correct the direction label from "sys to dev" to
"dev to sys".

Link: https://lore.kernel.org/20260812092856.55296-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug
+++ a/lib/test_hmm.c
@@ -1151,10 +1151,9 @@ static vm_fault_t dmirror_devmem_fault_a
 		if (!dpage && !order)
 			return VM_FAULT_OOM;
 
-		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
-				page_to_pfn(spage), page_to_pfn(dpage));
-
 		if (dpage) {
+			pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
+					page_to_pfn(spage), page_to_pfn(dpage));
 			lock_page(dpage);
 			*dst |= migrate_pfn(page_to_pfn(dpage));
 		}
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are



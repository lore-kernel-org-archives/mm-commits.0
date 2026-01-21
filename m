Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE95930F958
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967362; cv=none; b=J21vrjNmVyzY8x/fBU2ySLdNT7hsNXqdKh3pAMAjC1QXGF8fjKS7r92aoRCYURwt477rEF1ij/mQ33Nmd32eis4Ic1CtQu75+dIjNqF/QR2ea7oOGUkZdpE/hKXe2oGid7HmmFHN6yPO6aXzrsG6uCxlZZbOp9NAfMWEau2ValU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967362; c=relaxed/simple;
	bh=Yn32Bd+YllPW8MvqV8WyC3xRcOJTbo8UOOt74AweI3I=;
	h=Date:To:From:Subject:Message-Id; b=M3UBTIKHTnR0Dm5UeXc4KkIcVFq22WIUClibvCVPTi1wvX/QoprS/GAbncOutkPSL1QMJTUs1s6XgM0wLLR5hBCNLC0Rmntaw8vVwtD2FYUHjvJYaKaL91cV8Gx8LeUcmvRSvk5Q/1tUQr5CKhWZQhDBi5gBTnrhozg3WUExZuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1qZOQ/FV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1qZOQ/FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5CAC16AAE;
	Wed, 21 Jan 2026 03:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967362;
	bh=Yn32Bd+YllPW8MvqV8WyC3xRcOJTbo8UOOt74AweI3I=;
	h=Date:To:From:Subject:From;
	b=1qZOQ/FViT8eybKUOH1m/YmHbawhYUpbMjRvwUXEUw7/NRmP3TsD43qAgpVIDvjTb
	 JqPxKfkC+9P8QILEi+70i5DjZ+KPTy0h8XKKnkjAE4dZegRgSJnq56P+T+1M7nFTn1
	 ElyHc2iCx7m+CB7D4Ka8mezmfbhFvVQ3yt3X03ks=
Date: Tue, 20 Jan 2026 19:49:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stefani@seibold.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kfifo-fix-kmalloc_array_node-argument-order.patch removed from -mm tree
Message-Id: <20260121034922.7A5CAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo: fix kmalloc_array_node() argument order
has been removed from the -mm tree.  Its filename was
     kfifo-fix-kmalloc_array_node-argument-order.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kfifo: fix kmalloc_array_node() argument order
Date: Fri, 19 Dec 2025 21:45:41 -0800

To be consistent, pass the kmalloc_array_node() parameters in the order
(number_of_elements, element_size).  Since only the product of the two
values is used, this is not a bug fix.

Link: https://lkml.kernel.org/r/20251220054541.2295599-1-rdunlap@infradead.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216015
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kfifo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kfifo.c~kfifo-fix-kmalloc_array_node-argument-order
+++ a/lib/kfifo.c
@@ -41,7 +41,7 @@ int __kfifo_alloc_node(struct __kfifo *f
 		return -EINVAL;
 	}
 
-	fifo->data = kmalloc_array_node(esize, size, gfp_mask, node);
+	fifo->data = kmalloc_array_node(size, esize, gfp_mask, node);
 
 	if (!fifo->data) {
 		fifo->mask = 0;
_

Patches currently in -mm which might be from rdunlap@infradead.org are



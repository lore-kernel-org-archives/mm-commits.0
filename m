Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D86828E5
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810103; cv=none; b=XAPqRMaq3dtMn6wPsp5LGy8QN/Iy8EXtIz5xJPAblV6IkWVEY9/M5zJjqrnae67fGCGcUzBDjZ9uIJEujQhbWvQKD4ZMGT27k7Z/gXe+anLgpe/vMRmc9AyME7weYXdw2SNV1cDE5RjRyz6b5+jnet3GNViLQjqep9F2ODuSiC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810103; c=relaxed/simple;
	bh=j1t4tfvot7FWNyaPyRkGud9kUR/pSj/KoFgm1UE0uTg=;
	h=Date:To:From:Subject:Message-Id; b=ER2dcEwAVM4O4M68mVgLLVSjvnpRogvofF42YAARMfPv9RlSg+qH0DW8x0Bt1q7nxG97sa6Bh/dE6gAmXLp1NdoJK3B0/+ne4zY1tpiVUN13dJZ9uP0ITEekhkX/4nPqQ7kZr+ls55H4jcr9bacGSqMNLtG+i/cg1io9MWdspP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cn8ICBfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cn8ICBfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73600C4CEF7;
	Sun, 14 Sep 2025 00:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810103;
	bh=j1t4tfvot7FWNyaPyRkGud9kUR/pSj/KoFgm1UE0uTg=;
	h=Date:To:From:Subject:From;
	b=Cn8ICBfiDU7AQSwsKHGXzQgPYUP3Agu8FW4EQUQK12UehwY9qwlGvWpeEW0d1WrVK
	 dlowew198RsW9aEmJX/oixtIv+Z/oefnAs1kh+Rf3M13L6oshFc2Bb8yguKGlgs8HM
	 SR3+CT/9323QgHukeLweBtdmnKxnt5uopQt/+MjA=
Date: Sat, 13 Sep 2025 17:35:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nvmem-update-a-comment-related-to-struct-nvmem_config.patch removed from -mm tree
Message-Id: <20250914003503.73600C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nvmem: update a comment related to struct nvmem_config
has been removed from the -mm tree.  Its filename was
     nvmem-update-a-comment-related-to-struct-nvmem_config.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: nvmem: update a comment related to struct nvmem_config
Date: Mon, 14 Jul 2025 10:17:10 +0200

Update a comment to match the function used in nvmem_register(). 
ida_simple_get() was replaced by ida_alloc() in commit 1eb51d6a4fce
("nvmem: switch to simpler IDA interface")

Link: https://lkml.kernel.org/r/27a9dec93a9f79140b11a77df38b1b45bd342e09.1752480043.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nvmem-provider.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/nvmem-provider.h~nvmem-update-a-comment-related-to-struct-nvmem_config
+++ a/include/linux/nvmem-provider.h
@@ -103,7 +103,7 @@ struct nvmem_cell_info {
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
  * no name is specified in its configuration. In such case "<id>" is
- * generated with ida_simple_get() and provided id field is ignored.
+ * generated with ida_alloc() and provided id field is ignored.
  *
  * Note: Specifying name and setting id to -1 implies a unique device
  * whose name is provided as-is (kept unaltered).
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are



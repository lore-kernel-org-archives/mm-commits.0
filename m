Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0FC469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122243; cv=none; b=OCErKC67E6bwrNQE6hnIEXVjUB4BryrnHvEvX2uLmgKfpCKSbsXPORJlm1k3KmbtA9qtLdU2BKd4B50XH6RwjnYO6RzvQZKyp27MrKL/9ED7RbtBlftLBuZuHwsRYkOkwRzr3P/EM1nJhJtU4kA3Ygf4OU1OJt9yoog5xShdcc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122243; c=relaxed/simple;
	bh=qH3ztzmR9ok5jXvs9+jcG+mjnMOO9BermI1DH6cgVHU=;
	h=Date:To:From:Subject:Message-Id; b=ITOydG6jnyEIfrrJLXE3pFACuWWu8iE54PSmybi12w6U9tWZsk48U+O16oyUJm0gAwz8zSYHM/DR29Boc+NB27u7ZXmQATKIxjcdAYhivOsoFjfMAzi3omz0WL/tbSIbfXbVTJS6rkw+F/XX9ZzOs41dGG8Z+hNNNacNOUZEkgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cSSwi8fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cSSwi8fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0E1C4CEE3;
	Thu, 10 Jul 2025 04:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122242;
	bh=qH3ztzmR9ok5jXvs9+jcG+mjnMOO9BermI1DH6cgVHU=;
	h=Date:To:From:Subject:From;
	b=cSSwi8fmXxTnWiiVoFeiXGdMBbGaioJcXWjImHT/W7CR9jyQCeGZSZjFhVfOL2oE7
	 leFQ4O9p0W0h6EeWHfNVdUPvJnkVu0IY+BSXMuhDr8pqh1dD1jFm87xPsRNBKyP8Rm
	 BPEPHF9HjPwOLbun/WNrgmi4y6ZF0YkDlrm/uLsg=
Date: Wed, 09 Jul 2025 21:37:22 -0700
To: mm-commits@vger.kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix.patch removed from -mm tree
Message-Id: <20250710043722.AB0E1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: restore removed extra line
has been removed from the -mm tree.  Its filename was
     drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix.patch

This patch was dropped because it was folded into drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: restore removed extra line
Date: Mon, 9 Jun 2025 09:03:54 -0500

Re-added the extra blank line at the end of the memory.h that was removed
by the commit 'commit d61861e3bb35 ("drivers/base/node: optimize memory
block registration to reduce boot time")'

Link: https://lkml.kernel.org/r/20250609140354.467908-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/memory.h~drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix
+++ a/include/linux/memory.h
@@ -216,4 +216,5 @@ unsigned long memory_block_advised_max_s
  * can sleep.
  */
 extern struct mutex text_mutex;
+
 #endif /* _LINUX_MEMORY_H_ */
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch
drivers-base-node-remove-register_mem_block_under_node_early.patch
drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch
drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch
drivers-base-node-rename-__register_one_node-to-register_one_node.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1614E18CBFE
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 03:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457336; cv=none; b=FDcIPnLxMXWbaweJkbjRx/N+Gi+gvwpm8e0YuXHDTNUa07L+nc776ArWNUwho18lex6mQNHW4hJG3u6H7Urb3kMsjVzb5s3/nUOmg0S9MVQHMcYn2k9E0C06FpgY4H869F4iTHd37fRQvmT5n2b4iOs+ZlFzwv0C3mwtDXCuOsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457336; c=relaxed/simple;
	bh=gogurB67BPrJYixTo17uzur0r3QrY8ew+Ga83lhWsUU=;
	h=Date:To:From:Subject:Message-Id; b=evUJjZmPINKDpP8FxMLIaR1Kb5yzT9Z1N3jWdvxByJPlNXMtiOLvEpuExi8R8j85+WY9Bw69j3rV6sN4pNpApA08bZW0E1O1t5ri7PCUXYi30aPczoJQOzKB15B2QjTd08xBB6y/54vYpeVQzemlQK1KixvoXoeLhP3GqpMp7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EEHzzSAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EEHzzSAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A36C4CED1;
	Fri,  6 Dec 2024 03:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457336;
	bh=gogurB67BPrJYixTo17uzur0r3QrY8ew+Ga83lhWsUU=;
	h=Date:To:From:Subject:From;
	b=EEHzzSAq+ERY4gS67dIMfHzeW13BfEPPASTcaU5OKYYeQh2QNFeonD1cyFY/IBWeV
	 9tU/LZ/iimCQFXAJazlgBN4epNjA98x7mnUZ/YBh4B+YE+LmCehq7f2pADrH/lhJhm
	 /+QD+/mEewJEv+yFxJvNVLEC5XHUZ3W/1CpK2Qek=
Date: Thu, 05 Dec 2024 19:55:35 -0800
To: mm-commits@vger.kernel.org,logang@deltatee.com,hch@lst.de,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scatterlist-fix-incorrect-func-name-in-kernel-doc.patch removed from -mm tree
Message-Id: <20241206035535.E0A36C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scatterlist: fix incorrect func name in kernel-doc
has been removed from the -mm tree.  Its filename was
     scatterlist-fix-incorrect-func-name-in-kernel-doc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: scatterlist: fix incorrect func name in kernel-doc
Date: Fri, 29 Nov 2024 18:24:06 -0800

Fix a kernel-doc warning by making the kernel-doc function description
match the function name:

include/linux/scatterlist.h:323: warning: expecting prototype for sg_unmark_bus_address(). Prototype was for sg_dma_unmark_bus_address() instead

Link: https://lkml.kernel.org/r/20241130022406.537973-1-rdunlap@infradead.org
Fixes: 42399301203e ("lib/scatterlist: add flag for indicating P2PDMA segments in an SGL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/scatterlist.h~scatterlist-fix-incorrect-func-name-in-kernel-doc
+++ a/include/linux/scatterlist.h
@@ -313,7 +313,7 @@ static inline void sg_dma_mark_bus_addre
 }
 
 /**
- * sg_unmark_bus_address - Unmark the scatterlist entry as a bus address
+ * sg_dma_unmark_bus_address - Unmark the scatterlist entry as a bus address
  * @sg:		 SG entry
  *
  * Description:
_

Patches currently in -mm which might be from rdunlap@infradead.org are

documentation-move-dev-tools-debugging-files-to-process-debugging.patch


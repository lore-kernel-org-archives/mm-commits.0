Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9622EBDE0
	for <mm-commits@vger.kernel.org>; Mon, 13 Oct 2025 23:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760397292; cv=none; b=EcYy965+bRclwVUq3N8MFf0IjY8kFS8NBH6EXaEXmOPD9bWEoBddXgK/yqNNKtFwlW9F+KQ45eQcG8AoaXuWZksr8YCXL0teTWspXpFS4EZ+PCwHD8DFa8DXyImZtV2vudyL/m+7VNhlDLZCJ1HVWxmA9YUR+uhIp9L+fukxngk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760397292; c=relaxed/simple;
	bh=8VYOzk5e+8AFa6jCaS/wqwmWYXXBHLpzqlQj0Uv3mls=;
	h=Date:To:From:Subject:Message-Id; b=jo0WE5r/kwsxEpeQxjjZ2+Kk5NfdSht9DOhLVv9TpJ9W41nbZMFTs5+716wTEGMD/Zg5Bucn//y+tR0WxN8QgciK/I8YYHdFane+zEAlMJ2npNSAPKjoHgLqqEy+SoQ33wCBnf7bqd0NbjF/1JdYzOXSE/QYRXWoZ9eZCj21iww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZC0DUPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZC0DUPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9411C4CEE7;
	Mon, 13 Oct 2025 23:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760397291;
	bh=8VYOzk5e+8AFa6jCaS/wqwmWYXXBHLpzqlQj0Uv3mls=;
	h=Date:To:From:Subject:From;
	b=qZC0DUPJVcPQHQV1jj33UpRdxqI8310BCX/Y6ZjLvpNYlEVBQhGOhNypm/nIZuZH9
	 Ci9F9Ydh/dqjlUuFYfswGzrRVrG/L1IfGTjOnqPVOoiWIzXJ6FbjRB5UxkXJ38lzKX
	 ljSi0bgvlxgFPQ2zNFEHQteOmmorYm+109Wc7Z3M=
Date: Mon, 13 Oct 2025 16:14:51 -0700
To: mm-commits@vger.kernel.org,john.g.garry@oracle.com,johannes.thumshirn@wdc.com,hch@lst.de,hare@suse.de,david@redhat.com,axboe@kernel.dk,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-bounce-config-option.patch added to mm-new branch
Message-Id: <20251013231451.A9411C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove the BOUNCE config option
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-the-bounce-config-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-bounce-config-option.patch

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
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: mm: remove the BOUNCE config option
Date: Mon, 13 Oct 2025 17:56:20 +0800

Commit eeadd68e2a5f ("block: remove bounce buffering support") remove
block/bounce.c but left the BOUNCE config option.  Now this option has no
users, so remove it.

Link: https://lkml.kernel.org/r/20251013095620.1111061-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    9 ---------
 1 file changed, 9 deletions(-)

--- a/mm/Kconfig~mm-remove-the-bounce-config-option
+++ a/mm/Kconfig
@@ -695,15 +695,6 @@ config PCP_BATCH_SCALE_MAX
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT
 
-config BOUNCE
-	bool "Enable bounce buffers"
-	default y
-	depends on BLOCK && MMU && HIGHMEM
-	help
-	  Enable bounce buffers for devices that cannot access the full range of
-	  memory available to the CPU. Enabled by default when HIGHMEM is
-	  selected, but you may say n to override this.
-
 config MMU_NOTIFIER
 	bool
 	select INTERVAL_TREE
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

mm-remove-the-bounce-config-option.patch


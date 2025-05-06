Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35DD470D17
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 00:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746491985; cv=none; b=ciZTIR5HCN3K+fUcwTIOUfnLenuFYb1rzQXyhCywHYjRZgI8n6WzdbwuDGQZtpZmSmtezAssC0wRGgPNA9Mn8pm2pdCB1/mXsID0t5qJAyeJYGGr6vtm7zltc8WhIy1u4ZNv+nzVkG9S+0Xg5VluOTiYSra8G2nuwrz/JjkyMmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746491985; c=relaxed/simple;
	bh=AfL2aMYPKDEZ2yCtl1bNDd4RoL0VnIPii3KboXMHC1U=;
	h=Date:To:From:Subject:Message-Id; b=o0ssMQLLvUyseNdapGtDwPiPKz/wuNs68ry+ISc43T0jgCkWtJ87jA+tvODsYcvY/zEvbLEy2iN/X9FyECLT0Qp5J0276wrRNzkX5tY27nPxJf1u/NaqQPhHGxtNo7liVz5XuEWfFzKDVvJobF5qRzbPvVQuRpAARV4/vinBVWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M5Lz9jTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M5Lz9jTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053EEC4CEF1;
	Tue,  6 May 2025 00:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746491984;
	bh=AfL2aMYPKDEZ2yCtl1bNDd4RoL0VnIPii3KboXMHC1U=;
	h=Date:To:From:Subject:From;
	b=M5Lz9jTDgbLYxTBO2Rbn+EkVmeq08aeWqeTXTCB66j6Ziqoac7bzANTgZfQU74j7T
	 flGztcnlYGvSdPbnwvKZbXV954VUZi2hUGzMVFRcOm8ASRGmmcobW5bS3OKMsd060r
	 4kx9EGteSLHvlOVcEHxMWvIia2x8k74L+PR6Sm9c=
Date: Mon, 05 May 2025 17:39:43 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,dave@stgolabs.net,da.gomez@samsung.com,brauner@kernel.org,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + swapfile-disable-swapon-for-bs-ps-devices.patch added to mm-unstable branch
Message-Id: <20250506003944.053EEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: swapfile: disable swapon for bs > ps devices
has been added to the -mm mm-unstable branch.  Its filename is
     swapfile-disable-swapon-for-bs-ps-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swapfile-disable-swapon-for-bs-ps-devices.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: swapfile: disable swapon for bs > ps devices
Date: Mon, 5 May 2025 12:35:19 -0700

Devices which have a requirement for bs > ps cannot be supported for swap
as swap still needs work.  Now that the block device cache sets the min
order for block devices we need this stopgap otherwise all swap operations
are rejected.

Without this you'll end up with errors on these devices as the swap code
still needs much love to support min order.

With this we at least now put a stop gap of its use, until the swap
subsystem completes its major overhaul:

mkswap: /dev/nvme3n1: warning: wiping old swap signature.
Setting up swapspace version 1, size = 100 GiB (107374178304 bytes)
no label, UUID=6af76b5c-7e7b-4902-b7f7-4c24dde6fa36
swapon: /dev/nvme3n1: swapon failed: Invalid argument

Link: https://lkml.kernel.org/r/aBkS926thy9zvdZb@bombadil.infradead.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/swapfile.c~swapfile-disable-swapon-for-bs-ps-devices
+++ a/mm/swapfile.c
@@ -3335,6 +3335,15 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	/*
+	 * The swap subsystem needs a major overhaul to support this.
+	 * It doesn't work yet so just disable it for now.
+	 */
+	if (mapping_min_folio_order(mapping) > 0) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
+
+	/*
 	 * Read the swap header.
 	 */
 	if (!mapping->a_ops->read_folio) {
_

Patches currently in -mm which might be from mcgrof@kernel.org are

swapfile-disable-swapon-for-bs-ps-devices.patch


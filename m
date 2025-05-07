Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F59149C55
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 01:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746582158; cv=none; b=FnrKloPJNsInCIup9jvAoJUWwahvIfzldqjvkV/uub989pH/PB/2CT2R5b2rZxOWqAurh2gQTYl6ddxJfayA456LtN6IBXHxNbG4+dmISpfGdGZzZt7Pi57Y6P5a2e/fwU0lzBjIOIGcOputEMY3fAdQvuQ4E0eJsH2COFZ8g2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746582158; c=relaxed/simple;
	bh=OkI8QFaBB8/PCJd34XZgNJOG8SExtSEGTKNwRg7ymfc=;
	h=Date:To:From:Subject:Message-Id; b=HYIFwThHVjp+qwVcOBYp3+FQlXnvCYnDKKbdmEJta44Qh3lJr+gTKnM/X/DRxovXimvD1jZrgpYfUjCBo0NkM5CBFkXu7WRxd7M8Q6zoTEhQArECrOgKhb4/i5vHY+SohvXkRwRfpwJCX/I83pewqzbpABuVQBvMJOGpJpeYMMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uTN1iq/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uTN1iq/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F98C4CEE4;
	Wed,  7 May 2025 01:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746582158;
	bh=OkI8QFaBB8/PCJd34XZgNJOG8SExtSEGTKNwRg7ymfc=;
	h=Date:To:From:Subject:From;
	b=uTN1iq/UNuOO7L4ZYSXc6v85OVDVth89hH9Ly8UmHgij/PO7R3x395NPOqZrVmp8B
	 466PO9nakFTrrI6bFzKdpBahPZIUMVc47mcV0q0rNMaWOZFTEq9IMhxdBjCrwO/zEd
	 +L4KeGY7dMOfMZHJn/5Bbwh9IM037XjdbMm7RnF8=
Date: Tue, 06 May 2025 18:42:37 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,dave@stgolabs.net,da.gomez@samsung.com,brauner@kernel.org,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] swapfile-disable-swapon-for-bs-ps-devices.patch removed from -mm tree
Message-Id: <20250507014238.30F98C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: swapfile: disable swapon for bs > ps devices
has been removed from the -mm tree.  Its filename was
     swapfile-disable-swapon-for-bs-ps-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



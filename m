Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333B533344A
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961504; cv=none; b=riaxbb+d3EHpl1Wipx2O3gUh8TkazkNoi71KEjX3MKZkY/4wHD45l26+WvPh7h3zkJV0zzg3ezZgkT5vWuz1WUhGKfcbMIMQppsVjy2P6/ptYT7rXXaLLgmE0YXLfVxaNe/8/kjwvjPZAnDl2WhNdgaOTK3f68VkryTjFUmFIdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961504; c=relaxed/simple;
	bh=shPLjxMHEEr6T0JfdKUooRgbcP/z7/JueRmZf9yv/g4=;
	h=Date:To:From:Subject:Message-Id; b=Rx+IzwZveCppUUOiPixlydilso/imA21Vy2RuM8QUf//e2Fzpuu5ZUtE2/pDZctsrOINQq8ybyBWaxLAKWsqwXi/L0yMF0CCIkaNztXKw0DkVZiKkLFZHwUO5jBmqyigMZ7a8PMCt8hdpN907aFQWaPlM69vWCLZgZCFIs9oY3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O7PzK3Ag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O7PzK3Ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098831F00893;
	Mon, 21 Sep 2026 03:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961503;
	bh=kiU24KkwxEr4a786rFJvckU0M8OnCoEJ3Ao7E8ECmpg=;
	h=Date:To:From:Subject;
	b=O7PzK3AgRpQWqNNK7X178vwoCfudtV+cVu8K6+oIv6EuCP54wZQ2sokuqxA5bBLYD
	 so/XdJOb6q2lnQFiVnzXRDoJKrrgDNljUt4EjtoYK/h9bC9miCU42O9D8P0lLr8cZr
	 06uXy0XmOp0FZXrKGCYs0AGhjsn2Q0InkQ3D03nw=
Date: Sun, 20 Sep 2026 20:31:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] md-md-bitmap-replace-pageprivate-with-page_private.patch removed from -mm tree
Message-Id: <20260921033143.098831F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: md/md-bitmap: replace PagePrivate() with page_private()
has been removed from the -mm tree.  Its filename was
     md-md-bitmap-replace-pageprivate-with-page_private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: md/md-bitmap: replace PagePrivate() with page_private()
Date: Sun, 13 Sep 2026 22:24:11 -0400

PagePrivate() is going to be removed along with PG_private and its
implementation has been changed to match page_private().

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-13-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
---

 drivers/md/md-bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md-bitmap.c~md-md-bitmap-replace-pageprivate-with-page_private
+++ a/drivers/md/md-bitmap.c
@@ -535,7 +535,7 @@ static void free_buffers(struct page *pa
 {
 	struct buffer_head *bh;
 
-	if (!PagePrivate(page))
+	if (!page_private(page))
 		return;
 
 	bh = page_buffers(page);
_

Patches currently in -mm which might be from ziy@nvidia.com are

buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch


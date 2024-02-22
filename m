Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AD5FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645189; cv=none; b=rDIcIlj2/Em+qrBjN/vi3N32pT6YclS+rIg960+UHtjLjBNBkhk8RPvWvNknLWbZcFR1bCpxaCXVHLDqmIbqiVox6e69eDbkfWIqJFfErXmNhFi9r11GRcQBpDPR8BgaBo3kBZA2ptshmY8V+5I/zim1RQMQCuzTdH1fjEECArs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645189; c=relaxed/simple;
	bh=4ClSvLQRG15hHV1rIb394AHf3JaY6tcGeo0yUe8aPFs=;
	h=Date:To:From:Subject:Message-Id; b=Ha2gYjXZakeEytho5qSlqGoxJXgD3b3lcR292yR6U9i+ThJRlOMCOUNS2/5p6XyhmD0A1379hy9q/oyAYdEmvZsCD7C0vb9Q+CiRbgVkLZOrY0mitgcDqKeu+BuJw3iUmpi9UifN5biFIzzbg6OQEvsd9RpBA8/u9uzQBZmhI04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y9BEYEvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y9BEYEvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0028C433C7;
	Thu, 22 Feb 2024 23:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645188;
	bh=4ClSvLQRG15hHV1rIb394AHf3JaY6tcGeo0yUe8aPFs=;
	h=Date:To:From:Subject:From;
	b=Y9BEYEvEgeDtYhhUyoab9H2dFLkCk0gzRw4ptQeHmxZo+ZfRSR2SP5VHkfp6mh1sM
	 yQ3vOGblQts1B0PCPqM28PVwnMsxraCKLOVaq8v1QgOdoCiFnTM6zy0bU+zn8Pd36Q
	 VL7kKgnc4X5MoQ6hZHnwtu9k7JZDgYhbh8ZtLHGA=
Date: Thu, 22 Feb 2024 15:39:48 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233948.D0028C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_copy_buffer() to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert nilfs_copy_buffer() to use kmap_local
Date: Mon, 22 Jan 2024 23:01:50 +0900

The routine nilfs_copy_buffer() that copies a block buffer still uses the
deprecated kmap_atomic(), so convert it to use kmap_local.

Link: https://lkml.kernel.org/r/20240122140202.6950-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local
+++ a/fs/nilfs2/page.c
@@ -103,11 +103,11 @@ void nilfs_copy_buffer(struct buffer_hea
 	struct page *spage = sbh->b_page, *dpage = dbh->b_page;
 	struct buffer_head *bh;
 
-	kaddr0 = kmap_atomic(spage);
-	kaddr1 = kmap_atomic(dpage);
+	kaddr0 = kmap_local_page(spage);
+	kaddr1 = kmap_local_page(dpage);
 	memcpy(kaddr1 + bh_offset(dbh), kaddr0 + bh_offset(sbh), sbh->b_size);
-	kunmap_atomic(kaddr1);
-	kunmap_atomic(kaddr0);
+	kunmap_local(kaddr1);
+	kunmap_local(kaddr0);
 
 	dbh->b_state = sbh->b_state & NILFS_BUFFER_INHERENT_BITS;
 	dbh->b_blocknr = sbh->b_blocknr;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893061AAA1D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011382; cv=none; b=qTkHE1U3aKpIc1iv1xxWSbwrZjjlMhba/15mAGCw7Qg2/Qq8qgjX6opu97yqkKfZXlVVV4wV7Ah0oPm5Jo+28fn47MOkVUeeuaTtwBecfKsG+SrYzVgpQpw4PrAmMYoakoXJzIMhIcdoBMAP5KJaZUtDSE9ihGRZ1je8UBm7rjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011382; c=relaxed/simple;
	bh=UuP4i/tXTOn4ICHZxstzKKr/SgQcDwxjUVuEbOMQ6xU=;
	h=Date:To:From:Subject:Message-Id; b=eDjxB2KOzGiNX3wnHaWpr0yzk7GtCdzt5qQ9SspQYMjvOY7oXMXwnjZ6HLt3EiH8gYWk7c6gGnn7FTWytpZ8ltKBBZnA9ZatOL2lihGoKpykVAJY8xmdygHkMeaUI85MA6Il64w7Bu2kra3BE1HXQK92B000pCfz6lU1K9HrrFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8w/XBt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8w/XBt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D87FC4CEE4;
	Mon, 12 May 2025 00:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011382;
	bh=UuP4i/tXTOn4ICHZxstzKKr/SgQcDwxjUVuEbOMQ6xU=;
	h=Date:To:From:Subject:From;
	b=A8w/XBt1q2Ta/CLKH/D04VA3OTku2eqTN3/80rmvgXlDU2xSjgT08NrBwSyiLdYdZ
	 CuyBc//ymqlCaXxEwpyd5GInDhwrUsgcl5Ngwn34kTGFAOZ5VWV1F97xednwTI8AVD
	 hiKf7fdhTlLLp9O3dme9stn7SsR/VcNXVUwDAi7w=
Date: Sun, 11 May 2025 17:56:21 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,vulab@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-pointer-check-for-nilfs_direct_propagate.patch removed from -mm tree
Message-Id: <20250512005622.5D87FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add pointer check for nilfs_direct_propagate()
has been removed from the -mm tree.  Its filename was
     nilfs2-add-pointer-check-for-nilfs_direct_propagate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wentao Liang <vulab@iscas.ac.cn>
Subject: nilfs2: add pointer check for nilfs_direct_propagate()
Date: Tue, 29 Apr 2025 02:37:07 +0900

Patch series "nilfs2: improve sanity checks in dirty state propagation".

This fixes one missed check for block mapping anomalies and one improper
return of an error code during a preparation step for log writing, thereby
improving checking for filesystem corruption on writeback.


This patch (of 2):

In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
need to be checked to ensure it is not an invalid pointer.

If the pointer value obtained by nilfs_direct_get_ptr() is
NILFS_BMAP_INVALID_PTR, means that the metadata (in this case, i_bmap in
the nilfs_inode_info struct) that should point to the data block at the
buffer head of the argument is corrupted and the data block is orphaned,
meaning that the file system has lost consistency.

Add a value check and return -EINVAL when it is an invalid pointer.

Link: https://lkml.kernel.org/r/20250428173808.6452-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20250428173808.6452-2-konishi.ryusuke@gmail.com
Fixes: 36a580eb489f ("nilfs2: direct block mapping")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/direct.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/direct.c~nilfs2-add-pointer-check-for-nilfs_direct_propagate
+++ a/fs/nilfs2/direct.c
@@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
 	ptr = nilfs_direct_get_ptr(bmap, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
+		return -EINVAL;
+
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.pr_entry_nr = ptr;
 		newreq.pr_entry_nr = ptr;
_

Patches currently in -mm which might be from vulab@iscas.ac.cn are



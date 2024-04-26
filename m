Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A16763F8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104487; cv=none; b=iTOahq0+FYpT/DoH1aTP98/smUnjDS8kUHLnSAZBWBR6Zn3ISLvJlCnzbFr5vWWecry43w5BUadElCQe1MedbLzmdS9yNB5Ez4FvsqDyTeKVDNSJJNDNagbdS6IYUcbyw0w3H1Wt99j2lSZPNEDNFGjqYX6zOLN+biT9cnx+o5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104487; c=relaxed/simple;
	bh=rkoSsoHP2F7UPuUjozUf7wyJCDtGo5PoHFl0ODFVlQI=;
	h=Date:To:From:Subject:Message-Id; b=nhZ2EMapJFX5xawe5VAoEjmN3g8Bl3Mzhvj/hIL+A6sk56K5j+ZDoCCCHixqeNNhj+cZZXWHTk/QTAbBn3SpWzo9clxcD0t7bUV2lzYzTFAc1iTOyzRNtYQVBhewhXHEWL4fJbtLBtnebvjJ/Ga2rTsfsOKG70w7g8OLgMXB9jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukjuSNxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukjuSNxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCE0C3277B;
	Fri, 26 Apr 2024 04:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104487;
	bh=rkoSsoHP2F7UPuUjozUf7wyJCDtGo5PoHFl0ODFVlQI=;
	h=Date:To:From:Subject:From;
	b=ukjuSNxdM4aUpXcgDf7pJcrRibbkFKVts/+Shqzi5iLREtUiIwBNWvrZEQtEMBD4s
	 iekOeaBin6E0NiXWJij8Zikh/CtFl2tO9PaHvxW3gdbnRFlAsZvIkfjfI5C1LujmWE
	 lnIBPVzJWZ6p6C6xt8XRpFQv07zKxb7dFrlmYL9M=
Date: Thu, 25 Apr 2024 21:08:06 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch removed from -mm tree
Message-Id: <20240426040807.6DCE0C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add kernel-doc comments to nilfs_do_roll_forward()
has been removed from the -mm tree.  Its filename was
     nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: nilfs2: add kernel-doc comments to nilfs_do_roll_forward()
Date: Wed, 10 Apr 2024 16:56:27 +0900

Patch series "nilfs2: fix missing kernel-doc comments".

This commit adds kernel-doc style comments with complete parameter
descriptions for the function nilfs_do_roll_forward.

Link: https://lkml.kernel.org/r/20240410075629.3441-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240410075629.3441-2-konishi.ryusuke@gmail.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/recovery.c~nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward
+++ a/fs/nilfs2/recovery.c
@@ -563,6 +563,7 @@ static int nilfs_recover_dsync_blocks(st
  * checkpoint
  * @nilfs: nilfs object
  * @sb: super block instance
+ * @root: NILFS root instance
  * @ri: pointer to a nilfs_recovery_info
  */
 static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are



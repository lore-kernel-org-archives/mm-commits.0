Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A058120A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104489; cv=none; b=eudB/O8KyJc9IyKDW+26zoIR21NLKLKw5y7Iyau3eOY9x+v3VmFN9wXHU518RaYVd72BK4Uh4bBlYAMwpjT8hC7RZTq0lF6tXC8xKeuiMjmAMXyDCTStEYCT/otocUT1eltj3Qn3Oc0Dn46MS9rwAiMiyPbd+SunouGtAsR+EUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104489; c=relaxed/simple;
	bh=PuD06UGsSnLMLkxUl4hiB4PbujCiokCHJb6eDeCDI7A=;
	h=Date:To:From:Subject:Message-Id; b=PoBmHmNL2t9ZG4bSBsaSmkAKJkGpGW1004ah+vBM25onTINLmhhHVcM0+jXkpNVSxyJ35cMqGFiV1+Ey4x5E/pRH+mEtAaG2vWVm3MqI2kdnO4nY3BfRclf0XFZmK9AwcNcaYPjGQMEDmMLNxyBn72iYWkALwUaH9Q8UqjXoQkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecBGICSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecBGICSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A04DC116B1;
	Fri, 26 Apr 2024 04:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104489;
	bh=PuD06UGsSnLMLkxUl4hiB4PbujCiokCHJb6eDeCDI7A=;
	h=Date:To:From:Subject:From;
	b=ecBGICSWeMh0xf9JyxA+cXUAg3i0ysw31w0GvTfDW3pbIuybpj/+ajW0JSB07sfIS
	 qOEZjReJch8G8MMm1X0zV3VI4j/PZcVWlO4ZiUHsP+c3aN4JIxA83rbNTKUu6iv2pN
	 w3hvwGswLZPWKOrSsazKnYzD/F9UwuvyDo7O53hQ=
Date: Thu, 25 Apr 2024 21:08:09 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch removed from -mm tree
Message-Id: <20240426040809.7A04DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add kernel-doc comments to nilfs_remove_all_gcinodes()
has been removed from the -mm tree.  Its filename was
     nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: nilfs2: add kernel-doc comments to nilfs_remove_all_gcinodes()
Date: Wed, 10 Apr 2024 16:56:29 +0900

This commit adds kernel-doc style comments with complete parameter
descriptions for the function nilfs_remove_all_gcinodes.

Link: https://lkml.kernel.org/r/20240410075629.3441-4-konishi.ryusuke@gmail.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/gcinode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/gcinode.c~nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes
+++ a/fs/nilfs2/gcinode.c
@@ -175,6 +175,7 @@ int nilfs_init_gcinode(struct inode *ino
 
 /**
  * nilfs_remove_all_gcinodes() - remove all unprocessed gc inodes
+ * @nilfs: NILFS filesystem instance
  */
 void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 {
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are



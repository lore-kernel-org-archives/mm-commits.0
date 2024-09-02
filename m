Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B5F23BE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248816; cv=none; b=rCj3hNbfKMUtWnZtAZPBEKl5kuO/wHv5+Zd51phvVbqK3Tqj5lbUcxbrxlni180EYVvvYC3VcLvQl/ewcRp9vk8Qp4R1zaYl8wyTUZM3dAG0QKi8aKYv7mdM/OZPc6GvYu1ElJOxv1rkGWA6XyOjEqvwqHthe3ojeC6X4PetqkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248816; c=relaxed/simple;
	bh=ikOk0kx73cESe5DSUUuE3+Sv/ARYgH2MwVd33PJOsb4=;
	h=Date:To:From:Subject:Message-Id; b=KI7SCr5z2Z57ZemgKimDTpbtCEjxw8ORz3SsffGrTsmiwRjgGPIQiSk1QCHXbAB1ULLpthMtWGwgM6TPJpTsh5naez7euoiOVL1XNeRKjn/v8Ut7DknerZ3rrHdUB0c+jIdBJ7SVmaCR5OTrEWtMOlqHkqkYJRQUPEQNTJFTrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCgywbda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCgywbda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A4CC4CEC2;
	Mon,  2 Sep 2024 03:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248816;
	bh=ikOk0kx73cESe5DSUUuE3+Sv/ARYgH2MwVd33PJOsb4=;
	h=Date:To:From:Subject:From;
	b=OCgywbdaMMseJQa1LhIyaPzV8t0UihYjQ14ZV2hxuEfsZz2dCiSyvtG4MUxgcddpV
	 bLlKFZiM1kbQffyKQrrsIcUsryoYeive7cigKNZIL1Q2B70Vii9oFu4ymOU1N6bbZT
	 flxJ8kU2JqPZt1FmegDADnsklYa2hkwrSjziHNdI=
Date: Sun, 01 Sep 2024 20:46:55 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-support-for-fs_ioc_getfssysfspath.patch removed from -mm tree
Message-Id: <20240902034656.03A4CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add support for FS_IOC_GETFSSYSFSPATH
has been removed from the -mm tree.  Its filename was
     nilfs2-add-support-for-fs_ioc_getfssysfspath.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: add support for FS_IOC_GETFSSYSFSPATH
Date: Thu, 15 Aug 2024 16:44:06 +0900

Use the standard helper super_set_sysfs_name_bdev() to give the sysfs
subpath of the filesystem for the FS_IOC_GETFSSYSFSPATH ioctl.

For nilfs2, it will output "nilfs2/<dev>".

Link: https://lkml.kernel.org/r/20240815074408.5550-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/super.c~nilfs2-add-support-for-fs_ioc_getfssysfspath
+++ a/fs/nilfs2/super.c
@@ -1065,6 +1065,7 @@ nilfs_fill_super(struct super_block *sb,
 
 	super_set_uuid(sb, nilfs->ns_sbp[0]->s_uuid,
 		       sizeof(nilfs->ns_sbp[0]->s_uuid));
+	super_set_sysfs_name_bdev(sb);
 
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are



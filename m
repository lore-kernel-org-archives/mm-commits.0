Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9F1DF42
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739451; cv=none; b=q7dv8h55kszn5+3jOoan+Y9EkbSEKIFbcJRobgYP4OSwH5T/Ts6DaXkIp+78be8I57JfJ2dH8tsFZ1EWNy2OzscYO9+ZTcKFxUUiJ1TpUcUy8wSdwbe5+AOzBEm7aJI9pIOJX2QH/5Zvob3XKEW6yj2yeGpwayp32C0peLQq2no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739451; c=relaxed/simple;
	bh=aeYwGa8iFmK6l9JzeGebFJoBzrtNFao3BKPoWO41ZoM=;
	h=Date:To:From:Subject:Message-Id; b=qdETk3sASncloXilg6ClP/5uEu5Rj1c2XWwdk567ycWARjivAxUJoBHiNHBVl1G4uMZPQ7Q1yoPfgehZmtR9d9tiAPiXvWoaTlMxfgHDvAWvktYBE82CoopCK4G1X2gIXPnU/JiXYKSe636lEG0hB4ORqV7FNhjubMsdz56244Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G/rFHyRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G/rFHyRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A2DC433F1;
	Sat, 24 Feb 2024 01:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739451;
	bh=aeYwGa8iFmK6l9JzeGebFJoBzrtNFao3BKPoWO41ZoM=;
	h=Date:To:From:Subject:From;
	b=G/rFHyRd9Arun1gNKIRAyxa1xdvNEE38d4yx+XT/+n9uLeKmiWG32WB3Ian533TFu
	 H7hASFIQ4r005ttdaNG7ZspdN4tC7uJwv0QyCQu9C85X7MT3kDcORNOthDG+N5fLVf
	 J/oGHpNMDCmTY+XZ6P0/gqYsC7/Ih/4T6hMf7qoo=
Date: Fri, 23 Feb 2024 17:50:50 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,cmaiolino@redhat.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-properly-report-quota-mount-options.patch removed from -mm tree
Message-Id: <20240224015051.74A2DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: shmem: properly report quota mount options
has been removed from the -mm tree.  Its filename was
     shmem-properly-report-quota-mount-options.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: shmem: properly report quota mount options
Date: Mon, 29 Jan 2024 13:01:31 +0100

Report quota options among the set of mount options. This allows proper
user visibility into whether quotas are enabled or not.

Link: https://lkml.kernel.org/r/20240129120131.21145-1-jack@suse.cz
Fixes: e09764cff44b ("shmem: quota support")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/mm/shmem.c~shmem-properly-report-quota-mount-options
+++ a/mm/shmem.c
@@ -4265,6 +4265,24 @@ static int shmem_show_options(struct seq
 	mpol_put(mpol);
 	if (sbinfo->noswap)
 		seq_printf(seq, ",noswap");
+#ifdef CONFIG_TMPFS_QUOTA
+	if (sb_has_quota_active(root->d_sb, USRQUOTA))
+		seq_printf(seq, ",usrquota");
+	if (sb_has_quota_active(root->d_sb, GRPQUOTA))
+		seq_printf(seq, ",grpquota");
+	if (sbinfo->qlimits.usrquota_bhardlimit)
+		seq_printf(seq, ",usrquota_block_hardlimit=%lld",
+			   sbinfo->qlimits.usrquota_bhardlimit);
+	if (sbinfo->qlimits.grpquota_bhardlimit)
+		seq_printf(seq, ",grpquota_block_hardlimit=%lld",
+			   sbinfo->qlimits.grpquota_bhardlimit);
+	if (sbinfo->qlimits.usrquota_ihardlimit)
+		seq_printf(seq, ",usrquota_inode_hardlimit=%lld",
+			   sbinfo->qlimits.usrquota_ihardlimit);
+	if (sbinfo->qlimits.grpquota_ihardlimit)
+		seq_printf(seq, ",grpquota_inode_hardlimit=%lld",
+			   sbinfo->qlimits.grpquota_ihardlimit);
+#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are



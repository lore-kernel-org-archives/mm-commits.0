Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D589A14A0BF
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 20:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708459246; cv=none; b=lSIiI2/BBPysFggSHjUp6E3LiyWWGV8Bq60WMnpP16cmH7wllRIRWw+Zdevx59qN/DsA22Ou+WE9Lbkzk7R25xJYNYYmPxegPGl0OJqxS1IdoEoX9cF6CzNHoZ3eCjQMqwtU0TAGSmv/By1s91gv8w2rm08DA64CpE8cqQK30BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708459246; c=relaxed/simple;
	bh=J5VRpcHmmYmSqvPXDpaqAk8cFuXpIUlfHsVfeF85/ZY=;
	h=Date:To:From:Subject:Message-Id; b=cpr5OwSB0JCoKQiRNk7Xd0JGDOX9ogGtBXkXyWOxp6S4wntYDXS9SYP4KfwF4LjTPycOUk/PUUvZpyAevOIoKa4R99XQd+UfPxiV9iK3CwEw1XvZDt7y7EpcKHrpPQ7mOLmPK7/VnAN+nVuSNzVHCjDQa6VylanhN5fWNxyxdl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XrYWFkQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XrYWFkQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4175CC433C7;
	Tue, 20 Feb 2024 20:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708459245;
	bh=J5VRpcHmmYmSqvPXDpaqAk8cFuXpIUlfHsVfeF85/ZY=;
	h=Date:To:From:Subject:From;
	b=XrYWFkQcFVXoH2IVYEvXmBuBg4Yp9wIgfTWJKJpWR7Uf47G6bNd1P0mv7+RffrB8R
	 fWtvUem/O+sQxkl9PY1Pg5a3NeoM9Sxs+3JhbjGhJP1roFbp4RIzAkp7CfcgzhktQv
	 k7FcMsaB2R44WkA93QAWHLSLNiYfohhgIL/7rxro=
Date: Tue, 20 Feb 2024 12:00:44 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,cmaiolino@redhat.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-properly-report-quota-mount-options.patch added to mm-unstable branch
Message-Id: <20240220200045.4175CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: shmem: properly report quota mount options
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-properly-report-quota-mount-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-properly-report-quota-mount-options.patch

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

shmem-properly-report-quota-mount-options.patch
fat-fix-uninitialized-field-in-nostale-filehandles.patch


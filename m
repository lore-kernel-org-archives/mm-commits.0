Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6AFEDC;
	Wed, 14 Aug 2024 00:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723597098; cv=none; b=qd8U0EXXPuD/uTSR2EK0lTr8mOAxRTh9ae7O24omyVKiTQALbBnb+MuKx+PkqMkBEtKkminA6j7oPgD5DRLeIA1+2rcqqj54nMyANfP1SdSKpzmqrgpWlyFo/7HuGyI3jX35lDD/NX6M53LK2KufeFarbToI7BYbXmXPIgU2SRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723597098; c=relaxed/simple;
	bh=1GAGsivwfdix6+CNKazVUKevywXvFZXQnxC13vS6ims=;
	h=Date:To:From:Subject:Message-Id; b=JebkwA2x9E6yd2SNOUEOclXngzHSy6SyfIppLChZjOR4zmfSy6yy4KE0AfP3MY/xNuGbHd9ctGdlZQI03cOBdHUsixW7zerEvKUkGOycABxAHUW1bbRO9awNtFxtxH/xXT9fMH7QpnEKMUGjNI2hityRdkJWmS6dg5b52HImnH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J8hLj633; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J8hLj633"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E29CC32782;
	Wed, 14 Aug 2024 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723597097;
	bh=1GAGsivwfdix6+CNKazVUKevywXvFZXQnxC13vS6ims=;
	h=Date:To:From:Subject:From;
	b=J8hLj633DGjdPG8U6+zso43wso36mtwGZSsG1brYLgAvufLRmA9rDYkDC/iz56Wf5
	 Z4y8+8odP7PAbd1xt70zt9BQM7CGrUBd8aYloELjbktXJlQfCEZIwmswFTJRNgmWpO
	 fh3pD140d2snx6MsSILjP/qjG0ZiM2yv7rs5xeJw=
Date: Tue, 13 Aug 2024 17:58:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch added to mm-hotfixes-unstable branch
Message-Id: <20240814005817.4E29CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: protect references to superblock parameters exposed in sysfs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: protect references to superblock parameters exposed in sysfs
Date: Sun, 11 Aug 2024 19:03:20 +0900

The superblock buffers of nilfs2 can not only be overwritten at runtime
for modifications/repairs, but they are also regularly swapped, replaced
during resizing, and even abandoned when degrading to one side due to
backing device issues.  So, accessing them requires mutual exclusion using
the reader/writer semaphore "nilfs->ns_sem".

Some sysfs attribute show methods read this superblock buffer without the
necessary mutual exclusion, which can cause problems with pointer
dereferencing and memory access, so fix it.

Link: https://lkml.kernel.org/r/20240811100320.9913-1-konishi.ryusuke@gmail.com
Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs
+++ a/fs/nilfs2/sysfs.c
@@ -836,9 +836,15 @@ ssize_t nilfs_dev_revision_show(struct n
 				struct the_nilfs *nilfs,
 				char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	u32 major = le32_to_cpu(sbp[0]->s_rev_level);
-	u16 minor = le16_to_cpu(sbp[0]->s_minor_rev_level);
+	struct nilfs_super_block *raw_sb;
+	u32 major;
+	u16 minor;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	major = le32_to_cpu(raw_sb->s_rev_level);
+	minor = le16_to_cpu(raw_sb->s_minor_rev_level);
+	up_read(&nilfs->ns_sem);
 
 	return sysfs_emit(buf, "%d.%d\n", major, minor);
 }
@@ -856,8 +862,13 @@ ssize_t nilfs_dev_device_size_show(struc
 				    struct the_nilfs *nilfs,
 				    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	u64 dev_size = le64_to_cpu(sbp[0]->s_dev_size);
+	struct nilfs_super_block *raw_sb;
+	u64 dev_size;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	dev_size = le64_to_cpu(raw_sb->s_dev_size);
+	up_read(&nilfs->ns_sem);
 
 	return sysfs_emit(buf, "%llu\n", dev_size);
 }
@@ -879,9 +890,15 @@ ssize_t nilfs_dev_uuid_show(struct nilfs
 			    struct the_nilfs *nilfs,
 			    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct nilfs_super_block *raw_sb;
+	ssize_t len;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	len = sysfs_emit(buf, "%pUb\n", raw_sb->s_uuid);
+	up_read(&nilfs->ns_sem);
 
-	return sysfs_emit(buf, "%pUb\n", sbp[0]->s_uuid);
+	return len;
 }
 
 static
@@ -889,10 +906,16 @@ ssize_t nilfs_dev_volume_name_show(struc
 				    struct the_nilfs *nilfs,
 				    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct nilfs_super_block *raw_sb;
+	ssize_t len;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	len = scnprintf(buf, sizeof(raw_sb->s_volume_name), "%s\n",
+			raw_sb->s_volume_name);
+	up_read(&nilfs->ns_sem);
 
-	return scnprintf(buf, sizeof(sbp[0]->s_volume_name), "%s\n",
-			 sbp[0]->s_volume_name);
+	return len;
 }
 
 static const char dev_readme_str[] =
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch


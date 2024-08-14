Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D755C2FB6;
	Wed, 14 Aug 2024 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723597207; cv=none; b=W8QAUOI2p2ys9O8129c510NCz71FnU4JRyEr1Vl+qtPlCaXgD4BnCzt6UAF3K3TwFbmCnDx5MZjFx/OEmlmK8O2jRItOGpl797tpph7LS9B3vqBhG8QFHRgs5w+w+VNs0n1zxwRHUaUQfaQvYtWKPHRHhTNZBuhFZ76RSRWTJ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723597207; c=relaxed/simple;
	bh=O7qGOvj8p5QpN31ChhAw+7snwztHmeYt13uya/6L8qg=;
	h=Date:To:From:Subject:Message-Id; b=gkUajsdqirJfXpYI0664jvXupIURGd0ZzhogMrWFyOQqL6eoGtyvpD1+sN1rGDygDqkXGv1UcYAcvgUlaLKERpsbvMneHgGoYXM4LxPfSI+7Ify1uTB1/mm+tsPmyz9ELNRPoDuxpDJT4VDgXteP3N5mU2/ohfTNp7Yvj+dnPSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mqOpoxHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mqOpoxHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CE6C32782;
	Wed, 14 Aug 2024 01:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723597206;
	bh=O7qGOvj8p5QpN31ChhAw+7snwztHmeYt13uya/6L8qg=;
	h=Date:To:From:Subject:From;
	b=mqOpoxHRXXcP4PplioIuq6ZxSoLjaCg3r/2SdmZNzTRfyWZGeeECeKT2Z7jWIS1FY
	 5Izrw8MVrASMMuweDQeVmYpr11/075OmbMbD6Eywya7Qtz+R4/y48BLdaRJDqfKNAS
	 B2C3q8dCXOYT3fkNNQmozvDLL+5nJHsFYykKX02w=
Date: Tue, 13 Aug 2024 18:00:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20240814010006.36CE6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix missing cleanup on rollforward recovery error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch

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
Subject: nilfs2: fix missing cleanup on rollforward recovery error
Date: Sat, 10 Aug 2024 15:52:42 +0900

In an error injection test of a routine for mount-time recovery, KASAN
found a use-after-free bug.

It turned out that if data recovery was performed using partial logs
created by dsync writes, but an error occurred before starting the log
writer to create a recovered checkpoint, the inodes whose data had been
recovered were left in the ns_dirty_files list of the nilfs object and
were not freed.

Fix this issue by cleaning up inodes that have read the recovery data if
the recovery routine fails midway before the log writer starts.

Link: https://lkml.kernel.org/r/20240810065242.3701-1-konishi.ryusuke@gmail.com
Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/recovery.c~nilfs2-fix-missing-cleanup-on-rollforward-recovery-error
+++ a/fs/nilfs2/recovery.c
@@ -716,6 +716,33 @@ static void nilfs_finish_roll_forward(st
 }
 
 /**
+ * nilfs_abort_roll_forward - cleaning up after a failed rollforward recovery
+ * @nilfs: nilfs object
+ */
+static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
+{
+	struct nilfs_inode_info *ii, *n;
+	LIST_HEAD(head);
+
+	/* Abandon inodes that have read recovery data */
+	spin_lock(&nilfs->ns_inode_lock);
+	list_splice_init(&nilfs->ns_dirty_files, &head);
+	spin_unlock(&nilfs->ns_inode_lock);
+	if (list_empty(&head))
+		return;
+
+	set_nilfs_purging(nilfs);
+	list_for_each_entry_safe(ii, n, &head, i_dirty) {
+		spin_lock(&nilfs->ns_inode_lock);
+		list_del_init(&ii->i_dirty);
+		spin_unlock(&nilfs->ns_inode_lock);
+
+		iput(&ii->vfs_inode);
+	}
+	clear_nilfs_purging(nilfs);
+}
+
+/**
  * nilfs_salvage_orphan_logs - salvage logs written after the latest checkpoint
  * @nilfs: nilfs object
  * @sb: super block instance
@@ -773,15 +800,19 @@ int nilfs_salvage_orphan_logs(struct the
 		if (unlikely(err)) {
 			nilfs_err(sb, "error %d writing segment for recovery",
 				  err);
-			goto failed;
+			goto put_root;
 		}
 
 		nilfs_finish_roll_forward(nilfs, ri);
 	}
 
- failed:
+put_root:
 	nilfs_put_root(root);
 	return err;
+
+failed:
+	nilfs_abort_roll_forward(nilfs);
+	goto put_root;
 }
 
 /**
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch


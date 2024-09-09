Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA8B18C924;
	Mon,  9 Sep 2024 22:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920194; cv=none; b=Nfskfz9QM1yqKx+1WG06gX5PJERyZn99vqEDqevrPIE4mhL3mzrL/4w/SDah3yN9F1EuDMeiX72zUk1lqqe+K9CCiyXQk1xX1AboBJQwRq9YOvV2CyhfQYW7ZveZ67lAsQWsh3k9CX/LpatLfwHJ97hppu8qng/AEodhQyEaCy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920194; c=relaxed/simple;
	bh=yRRjc493j/hb/LPeAt6VaA//Ry3EyC+ktbpmOEP2Nfk=;
	h=Date:To:From:Subject:Message-Id; b=MruRVl6WVpvughrxtLrHpiaIEHJ2eT+hCmCs96pBzvwg3Td4n0G4GKo0lfBMNS3JWDY5LfzXjvtW3McSAe7FacQHMnTRjUUa/TR9wTqJqjeoQ5R3ITxEG9HLYyLT6LJ97EqLinLBkQQ767nor0oRdBf5z7GViIsv6j1xJWJaUeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fsicmo9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fsicmo9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767DBC4CEC5;
	Mon,  9 Sep 2024 22:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920194;
	bh=yRRjc493j/hb/LPeAt6VaA//Ry3EyC+ktbpmOEP2Nfk=;
	h=Date:To:From:Subject:From;
	b=Fsicmo9b+tlM5izfW5ylZ3dmbR5o5x6H1HcWrMYpk8/oIadASGlnRkBd4Fc8ra8Nq
	 arqKkSyh53e97L4r6l4aQ0paxYj8yH42rLDA7OC97A0f8/Zndw+xcLKZIXONBq70kR
	 6Zp+XqwyRdx0/ykit47jAtxOx0s4G3jJ/OiYdjds=
Date: Mon, 09 Sep 2024 15:16:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-cancel-dqi_sync_work-before-freeing-oinfo.patch removed from -mm tree
Message-Id: <20240909221634.767DBC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: cancel dqi_sync_work before freeing oinfo
has been removed from the -mm tree.  Its filename was
     ocfs2-cancel-dqi_sync_work-before-freeing-oinfo.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cancel dqi_sync_work before freeing oinfo
Date: Wed, 4 Sep 2024 15:10:03 +0800

ocfs2_global_read_info() will initialize and schedule dqi_sync_work at the
end, if error occurs after successfully reading global quota, it will
trigger the following warning with CONFIG_DEBUG_OBJECTS_* enabled:

ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c

This reports that there is an active delayed work when freeing oinfo in
error handling, so cancel dqi_sync_work first.  BTW, return status instead
of -1 when .read_file_info fails.

Link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
Link: https://lkml.kernel.org/r/20240904071004.2067695-1-joseph.qi@linux.alibaba.com
Fixes: 171bf93ce11f ("ocfs2: Periodic quota syncing")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_local.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/quota_local.c~ocfs2-cancel-dqi_sync_work-before-freeing-oinfo
+++ a/fs/ocfs2/quota_local.c
@@ -692,7 +692,7 @@ static int ocfs2_local_read_info(struct
 	int status;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_quota_recovery *rec;
-	int locked = 0;
+	int locked = 0, global_read = 0;
 
 	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
 	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
@@ -700,6 +700,7 @@ static int ocfs2_local_read_info(struct
 	if (!oinfo) {
 		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
 			       " info.");
+		status = -ENOMEM;
 		goto out_err;
 	}
 	info->dqi_priv = oinfo;
@@ -712,6 +713,7 @@ static int ocfs2_local_read_info(struct
 	status = ocfs2_global_read_info(sb, type);
 	if (status < 0)
 		goto out_err;
+	global_read = 1;
 
 	status = ocfs2_inode_lock(lqinode, &oinfo->dqi_lqi_bh, 1);
 	if (status < 0) {
@@ -782,10 +784,12 @@ out_err:
 		if (locked)
 			ocfs2_inode_unlock(lqinode, 1);
 		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
+		if (global_read)
+			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 		kfree(oinfo);
 	}
 	brelse(bh);
-	return -1;
+	return status;
 }
 
 /* Write local info to quota file */
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info.patch


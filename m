Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E39717E015;
	Fri, 15 Nov 2024 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653084; cv=none; b=PVCMnHnI2ZMqElgBijhI9hsTy/293emE16ySvG4yPX0dYAmnlHCGbP3MHR1DL4aBtImWEMr9lCDNNAO1Ow9Rxyrpvyi3XYpqGfBp+AWWCK4+agGoo3xhIIEFTPtpNRGQJtgYSQCaZtfUHk3oxaBJbKxTXMwjXa7jH8axNznQQE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653084; c=relaxed/simple;
	bh=nrt6R0WbzWR6hA84NdwkXjWpFMXXtfg3hyKzhTuM+TM=;
	h=Date:To:From:Subject:Message-Id; b=RbNv5lBZrMPHevSX9UpFSOUTMQAB+cWRBwou7uN1Rt8uUB85hDlBhw2irNhdPq1ToCDuVnTaO7X65d6FDtg54UqWGFJXD5QdmRfY29AVHjQBvLTNeKJTqH9oDCmSOqY0LwhJzMynEBmKxUYYGerc1HFfqUDwK0fgGqfDC9ZRdWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bGihncqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bGihncqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D35C4CED0;
	Fri, 15 Nov 2024 06:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653084;
	bh=nrt6R0WbzWR6hA84NdwkXjWpFMXXtfg3hyKzhTuM+TM=;
	h=Date:To:From:Subject:From;
	b=bGihncqIeuOoGF/sLVBF2CrDuMZzk++690x1OKUAEFN+caNHo+sTx+0n2DpOtNQt7
	 mjzb10cf2Iu6EExEi+u4cPoSne1YnTYKXCgfoLP2nBIPyY5hqe1N4TdTCo6sXWtcjW
	 lbmMALAAChhGDuDPB4ZbdfsAtF9cZwXt9Wo5NsSQ=
Date: Thu, 14 Nov 2024 22:44:40 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-uncache-inode-which-has-failed-entering-the-group.patch removed from -mm tree
Message-Id: <20241115064443.B2D35C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: uncache inode which has failed entering the group
has been removed from the -mm tree.  Its filename was
     ocfs2-uncache-inode-which-has-failed-entering-the-group.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: uncache inode which has failed entering the group
Date: Thu, 14 Nov 2024 07:38:44 +0300

Syzbot has reported the following BUG:

kernel BUG at fs/ocfs2/uptodate.c:509!
...
Call Trace:
 <TASK>
 ? __die_body+0x5f/0xb0
 ? die+0x9e/0xc0
 ? do_trap+0x15a/0x3a0
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? do_error_trap+0x1dc/0x2c0
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? __pfx_do_error_trap+0x10/0x10
 ? handle_invalid_op+0x34/0x40
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? exc_invalid_op+0x38/0x50
 ? asm_exc_invalid_op+0x1a/0x20
 ? ocfs2_set_new_buffer_uptodate+0x2e/0x160
 ? ocfs2_set_new_buffer_uptodate+0x144/0x160
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ocfs2_group_add+0x39f/0x15a0
 ? __pfx_ocfs2_group_add+0x10/0x10
 ? __pfx_lock_acquire+0x10/0x10
 ? mnt_get_write_access+0x68/0x2b0
 ? __pfx_lock_release+0x10/0x10
 ? rcu_read_lock_any_held+0xb7/0x160
 ? __pfx_rcu_read_lock_any_held+0x10/0x10
 ? smack_log+0x123/0x540
 ? mnt_get_write_access+0x68/0x2b0
 ? mnt_get_write_access+0x68/0x2b0
 ? mnt_get_write_access+0x226/0x2b0
 ocfs2_ioctl+0x65e/0x7d0
 ? __pfx_ocfs2_ioctl+0x10/0x10
 ? smack_file_ioctl+0x29e/0x3a0
 ? __pfx_smack_file_ioctl+0x10/0x10
 ? lockdep_hardirqs_on_prepare+0x43d/0x780
 ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
 ? __pfx_ocfs2_ioctl+0x10/0x10
 __se_sys_ioctl+0xfb/0x170
 do_syscall_64+0xf3/0x230
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...
 </TASK>

When 'ioctl(OCFS2_IOC_GROUP_ADD, ...)' has failed for the particular
inode in 'ocfs2_verify_group_and_input()', corresponding buffer head
remains cached and subsequent call to the same 'ioctl()' for the same
inode issues the BUG() in 'ocfs2_set_new_buffer_uptodate()' (trying
to cache the same buffer head of that inode). Fix this by uncaching
the buffer head with 'ocfs2_remove_from_cache()' on error path in
'ocfs2_group_add()'.

Link: https://lkml.kernel.org/r/20241114043844.111847-1-dmantipov@yandex.ru
Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+453873f1588c2d75b447@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=453873f1588c2d75b447
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/resize.c~ocfs2-uncache-inode-which-has-failed-entering-the-group
+++ a/fs/ocfs2/resize.c
@@ -574,6 +574,8 @@ out_commit:
 	ocfs2_commit_trans(osb, handle);
 
 out_free_group_bh:
+	if (ret < 0)
+		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
 	brelse(group_bh);
 
 out_unlock:
_

Patches currently in -mm which might be from dmantipov@yandex.ru are



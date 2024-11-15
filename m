Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62C10E4;
	Fri, 15 Nov 2024 02:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731639266; cv=none; b=XoLVek3NkUm+F3mbgOZlS8sw6SF1ZssDmTFCNTZxtXUQexw1mGLGXkoZBEuW+HMozSjNr6Q8Hsxq2FH2kXi04LPkFE6wHydDBbg+YgzAgan8awPq5vbu79npigViKN2ivsmT8GTauIhghy3pIJgi0MWxZucBSfYSc5BeYHRLjS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731639266; c=relaxed/simple;
	bh=ntPXljdx4MIFT97ZOY3j7O5J2Cvq/0RFWZcaJMYhJXg=;
	h=Date:To:From:Subject:Message-Id; b=KvbwcFOHENe8M66c6RJMmNPSD8zXjGEKpzYsCqbY5MyxpVDKAN9dUAnvkwQ+3BKNtqVCWv4Vr3/t/23t0nCko54oaQdOmMsnGtUmzZ6h5RLf+b2cT6Zrm7lOYaQvNJyMkNxCHAAr1lMJhyxmwjmwbszGBUntNjQVdwJGSU+Txzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNnBE02n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNnBE02n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F60CC4CECD;
	Fri, 15 Nov 2024 02:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731639265;
	bh=ntPXljdx4MIFT97ZOY3j7O5J2Cvq/0RFWZcaJMYhJXg=;
	h=Date:To:From:Subject:From;
	b=uNnBE02npqLNp/2Z+fYtuMIUjmtjD461r/VpLc62ScJaXB0LhQ0ET6FYMURvOI7Lf
	 Zi9UYXMEgGnTXXjlPsrwlz4l+MfcbG4s19OAVBznIzYPJVkVMklwFmZG+RkZR7QOTt
	 qACQULzRy/UPtdhE9s3jzZYagKlgxlSMO62bgI1w=
Date: Thu, 14 Nov 2024 18:54:22 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-uncache-inode-which-has-failed-entering-the-group.patch added to mm-hotfixes-unstable branch
Message-Id: <20241115025425.2F60CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: uncache inode which has failed entering the group
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-uncache-inode-which-has-failed-entering-the-group.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-uncache-inode-which-has-failed-entering-the-group.patch

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

ocfs2-uncache-inode-which-has-failed-entering-the-group.patch


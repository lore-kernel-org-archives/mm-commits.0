Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49FB156653;
	Tue,  5 Nov 2024 03:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730776192; cv=none; b=l7p04RnGPNnRl1kHyJ/cOIhFJ1lxAUIFw7GiaT5mzTKd0zkgp/6Im5by/OOMOICeeJ5+ArVzp+eF8CNMfarznzOuqi/x/1/RreB5+5iRNf4ocXFzh0rLnTpmNKHx/h/LADLaAqzbiM+QAD2+I+E6/EyKTDAzB3xYaITFbGA3jyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730776192; c=relaxed/simple;
	bh=OudbygbXI3Uc0+dr2OAiyMdf4/JuoLvEowybthCyl0Y=;
	h=Date:To:From:Subject:Message-Id; b=LLL9Oc3tCdBXKQSm9SFfmrQopAT8JYZwKCg1c0Ear+3aZtt+JTFViKjuu3n1IcXU81wW86Xu1VEM4irVRyEhTWLwpfg9AJwQKKxLqP9Z6d7X5cXonnmRUBLZRnT7ZYk/qy74fGRe59bC6EbYmByNe8e8PfiUQjdpLjuzX3Whkoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EvyAatJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EvyAatJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B95C4CECE;
	Tue,  5 Nov 2024 03:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730776192;
	bh=OudbygbXI3Uc0+dr2OAiyMdf4/JuoLvEowybthCyl0Y=;
	h=Date:To:From:Subject:From;
	b=EvyAatJytOtQ4JJazgO7kzk3+aJ7J4Y6DtmtA4R46OAZVCNNclHPelK7zHcvMDdI+
	 7myFFt+QYJ/Mm+l7Fz0oUzmXl1QMT7rr/i093ApcormRMNI491uT0aT2aYyV+amZS/
	 OlOd/1EfsP56XI1Fp8sX+Di1emNB4uIumnJU+p5E=
Date: Mon, 04 Nov 2024 19:09:51 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,andrew.kanner@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-entry-once-instead-of-null-ptr-dereference-in-ocfs2_xa_remove.patch added to mm-hotfixes-unstable branch
Message-Id: <20241105030952.42B95C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove entry once instead of null-ptr-dereference in ocfs2_xa_remove()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-remove-entry-once-instead-of-null-ptr-dereference-in-ocfs2_xa_remove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-entry-once-instead-of-null-ptr-dereference-in-ocfs2_xa_remove.patch

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
From: Andrew Kanner <andrew.kanner@gmail.com>
Subject: ocfs2: remove entry once instead of null-ptr-dereference in ocfs2_xa_remove()
Date: Sun, 3 Nov 2024 20:38:45 +0100

Syzkaller is able to provoke null-ptr-dereference in ocfs2_xa_remove():

[   57.319872] (a.out,1161,7):ocfs2_xa_remove:2028 ERROR: status = -12
[   57.320420] (a.out,1161,7):ocfs2_xa_cleanup_value_truncate:1999 ERROR: Partial truncate while removing xattr overlay.upper.  Leaking 1 clusters and removing the entry
[   57.321727] BUG: kernel NULL pointer dereference, address: 0000000000000004
[...]
[   57.325727] RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x2a/0xc0
[...]
[   57.331328] Call Trace:
[   57.331477]  <TASK>
[...]
[   57.333511]  ? do_user_addr_fault+0x3e5/0x740
[   57.333778]  ? exc_page_fault+0x70/0x170
[   57.334016]  ? asm_exc_page_fault+0x2b/0x30
[   57.334263]  ? __pfx_ocfs2_xa_block_wipe_namevalue+0x10/0x10
[   57.334596]  ? ocfs2_xa_block_wipe_namevalue+0x2a/0xc0
[   57.334913]  ocfs2_xa_remove_entry+0x23/0xc0
[   57.335164]  ocfs2_xa_set+0x704/0xcf0
[   57.335381]  ? _raw_spin_unlock+0x1a/0x40
[   57.335620]  ? ocfs2_inode_cache_unlock+0x16/0x20
[   57.335915]  ? trace_preempt_on+0x1e/0x70
[   57.336153]  ? start_this_handle+0x16c/0x500
[   57.336410]  ? preempt_count_sub+0x50/0x80
[   57.336656]  ? _raw_read_unlock+0x20/0x40
[   57.336906]  ? start_this_handle+0x16c/0x500
[   57.337162]  ocfs2_xattr_block_set+0xa6/0x1e0
[   57.337424]  __ocfs2_xattr_set_handle+0x1fd/0x5d0
[   57.337706]  ? ocfs2_start_trans+0x13d/0x290
[   57.337971]  ocfs2_xattr_set+0xb13/0xfb0
[   57.338207]  ? dput+0x46/0x1c0
[   57.338393]  ocfs2_xattr_trusted_set+0x28/0x30
[   57.338665]  ? ocfs2_xattr_trusted_set+0x28/0x30
[   57.338948]  __vfs_removexattr+0x92/0xc0
[   57.339182]  __vfs_removexattr_locked+0xd5/0x190
[   57.339456]  ? preempt_count_sub+0x50/0x80
[   57.339705]  vfs_removexattr+0x5f/0x100
[...]

Reproducer uses faultinject facility to fail ocfs2_xa_remove() ->
ocfs2_xa_value_truncate() with -ENOMEM.

In this case the comment mentions that we can return 0 if
ocfs2_xa_cleanup_value_truncate() is going to wipe the entry
anyway. But the following 'rc' check is wrong and execution flow do
'ocfs2_xa_remove_entry(loc);' twice:
* 1st: in ocfs2_xa_cleanup_value_truncate();
* 2nd: returning back to ocfs2_xa_remove() instead of going to 'out'.

Fix this by skipping the 2nd removal of the same entry and making
syzkaller repro happy.

Link: https://lkml.kernel.org/r/20241103193845.2940988-1-andrew.kanner@gmail.com
Fixes: 399ff3a748cf ("ocfs2: Handle errors while setting external xattr values.")
Signed-off-by: Andrew Kanner <andrew.kanner@gmail.com>
Reported-by: syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/671e13ab.050a0220.2b8c0f.01d0.GAE@google.com/T/
Tested-by: syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-remove-entry-once-instead-of-null-ptr-dereference-in-ocfs2_xa_remove
+++ a/fs/ocfs2/xattr.c
@@ -2036,8 +2036,7 @@ static int ocfs2_xa_remove(struct ocfs2_
 				rc = 0;
 			ocfs2_xa_cleanup_value_truncate(loc, "removing",
 							orig_clusters);
-			if (rc)
-				goto out;
+			goto out;
 		}
 	}
 
_

Patches currently in -mm which might be from andrew.kanner@gmail.com are

ocfs2-remove-entry-once-instead-of-null-ptr-dereference-in-ocfs2_xa_remove.patch


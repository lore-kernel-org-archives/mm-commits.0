Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149951EB3D;
	Sat, 15 Jun 2024 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473425; cv=none; b=DgXEV524+x9zKkZyuPYN15oQ0wJ7evKHE0BDC6WOsVBeXF1tVND8Lq8Vd+O1MH2ZTutduimgD8eaVMY9gD3mXr2bBD3veOUgpfHQkurlYACika/lxt6gJu4jIQ7JkNRE7pRE5DU+zBD3jrj8cjkvMDt1NB7/ZzGF0TNQTAQ15tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473425; c=relaxed/simple;
	bh=ItnpoNRbnE8TmvFHC/OBSynv/EhiWR0znAU5tUJzOPc=;
	h=Date:To:From:Subject:Message-Id; b=BMPWNGmLeJ2ymBGwz57FG9mKCLjLN5Y1WuykideqPxKpszJ2k31C2sZg6RGDNqz5ZxsnWNOAwH68JssI5BrTU5s6IWEsHFMWUksdZdpFAovVgwvhCU59xFsnA8UZzQVVwcedbKp0q789zfeBt/WGzb7Q1KgJ1jFsPvQfxo0Lbzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d5VRvQHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d5VRvQHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F37C116B1;
	Sat, 15 Jun 2024 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473424;
	bh=ItnpoNRbnE8TmvFHC/OBSynv/EhiWR0znAU5tUJzOPc=;
	h=Date:To:From:Subject:From;
	b=d5VRvQHGRQZy8B8TdWZqYRFBgswIkzYLo8YGCX8RDWFTxWGyPli6IXZGa7Y7PUKyQ
	 geh1y3Syabf5BrU9ZZ0NkzPLBHYYIcXGmbv2UkOQDk2FyoJrjsVMeydon1TcQVB4zC
	 NmxV56Z1MwiClPP09yOUaOYDZ+A5JQVdVvCqTobQ=
Date: Sat, 15 Jun 2024 10:43:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-null-pointer-dereference-in-ocfs2_journal_dirty.patch removed from -mm tree
Message-Id: <20240615174344.91F37C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix NULL pointer dereference in ocfs2_journal_dirty()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-ocfs2_journal_dirty.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix NULL pointer dereference in ocfs2_journal_dirty()
Date: Thu, 30 May 2024 19:06:29 +0800

bdev->bd_super has been removed and commit 8887b94d9322 change the usage
from bdev->bd_super to b_assoc_map->host->i_sb.  This introduces the
following NULL pointer dereference in ocfs2_journal_dirty() since
b_assoc_map is still not initialized.  This can be easily reproduced by
running xfstests generic/186, which simulate no more credits.

[  134.351592] BUG: kernel NULL pointer dereference, address: 0000000000000000
...
[  134.355341] RIP: 0010:ocfs2_journal_dirty+0x14f/0x160 [ocfs2]
...
[  134.365071] Call Trace:
[  134.365312]  <TASK>
[  134.365524]  ? __die_body+0x1e/0x60
[  134.365868]  ? page_fault_oops+0x13d/0x4f0
[  134.366265]  ? __pfx_bit_wait_io+0x10/0x10
[  134.366659]  ? schedule+0x27/0xb0
[  134.366981]  ? exc_page_fault+0x6a/0x140
[  134.367356]  ? asm_exc_page_fault+0x26/0x30
[  134.367762]  ? ocfs2_journal_dirty+0x14f/0x160 [ocfs2]
[  134.368305]  ? ocfs2_journal_dirty+0x13d/0x160 [ocfs2]
[  134.368837]  ocfs2_create_new_meta_bhs.isra.51+0x139/0x2e0 [ocfs2]
[  134.369454]  ocfs2_grow_tree+0x688/0x8a0 [ocfs2]
[  134.369927]  ocfs2_split_and_insert.isra.67+0x35c/0x4a0 [ocfs2]
[  134.370521]  ocfs2_split_extent+0x314/0x4d0 [ocfs2]
[  134.371019]  ocfs2_change_extent_flag+0x174/0x410 [ocfs2]
[  134.371566]  ocfs2_add_refcount_flag+0x3fa/0x630 [ocfs2]
[  134.372117]  ocfs2_reflink_remap_extent+0x21b/0x4c0 [ocfs2]
[  134.372994]  ? inode_update_timestamps+0x4a/0x120
[  134.373692]  ? __pfx_ocfs2_journal_access_di+0x10/0x10 [ocfs2]
[  134.374545]  ? __pfx_ocfs2_journal_access_di+0x10/0x10 [ocfs2]
[  134.375393]  ocfs2_reflink_remap_blocks+0xe4/0x4e0 [ocfs2]
[  134.376197]  ocfs2_remap_file_range+0x1de/0x390 [ocfs2]
[  134.376971]  ? security_file_permission+0x29/0x50
[  134.377644]  vfs_clone_file_range+0xfe/0x320
[  134.378268]  ioctl_file_clone+0x45/0xa0
[  134.378853]  do_vfs_ioctl+0x457/0x990
[  134.379422]  __x64_sys_ioctl+0x6e/0xd0
[  134.379987]  do_syscall_64+0x5d/0x170
[  134.380550]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  134.381231] RIP: 0033:0x7fa4926397cb
[  134.381786] Code: 73 01 c3 48 8b 0d bd 56 38 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d 56 38 00 f7 d8 64 89 01 48
[  134.383930] RSP: 002b:00007ffc2b39f7b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  134.384854] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fa4926397cb
[  134.385734] RDX: 00007ffc2b39f7f0 RSI: 000000004020940d RDI: 0000000000000003
[  134.386606] RBP: 0000000000000000 R08: 00111a82a4f015bb R09: 00007fa494221000
[  134.387476] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  134.388342] R13: 0000000000f10000 R14: 0000558e844e2ac8 R15: 0000000000f10000
[  134.389207]  </TASK>

Fix it by only aborting transaction and journal in ocfs2_journal_dirty()
now, and leave ocfs2_abort() later when detecting an aborted handle,
e.g. start next transaction. Also log the handle details in this case.

Link: https://lkml.kernel.org/r/20240530110630.3933832-1-joseph.qi@linux.alibaba.com
Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_journal_dirty
+++ a/fs/ocfs2/journal.c
@@ -778,13 +778,15 @@ void ocfs2_journal_dirty(handle_t *handl
 		if (!is_handle_aborted(handle)) {
 			journal_t *journal = handle->h_transaction->t_journal;
 
-			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
-					"Aborting transaction and journal.\n");
+			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed: "
+			     "handle type %u started at line %u, credits %u/%u "
+			     "errcode %d. Aborting transaction and journal.\n",
+			     handle->h_type, handle->h_line_no,
+			     handle->h_requested_credits,
+			     jbd2_handle_buffer_credits(handle), status);
 			handle->h_err = status;
 			jbd2_journal_abort_handle(handle);
 			jbd2_journal_abort(journal, status);
-			ocfs2_abort(bh->b_assoc_map->host->i_sb,
-				    "Journal already aborted.\n");
 		}
 	}
 }
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6641FDD;
	Tue,  3 Jun 2025 02:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748917178; cv=none; b=aoowbdQyFI6gbHJeyejg8xbKjmS3PlhQPXp4gzIZEqh+26gsp30P7C0KNJVWf8bcp48qoi42Sx4mifyEuV1uvRzYPCaLjdfoQQ0tYKtEfmeRPVXfYc71gBPixobSoD56HN6B7r+6F/ZY6wsCbO3P4L5BfqOTtRJajXzOLjR3tBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748917178; c=relaxed/simple;
	bh=ktuKedGNJWCXD6IDuyaWLzeLTHihNWiDvOKQdGvVXnw=;
	h=Date:To:From:Subject:Message-Id; b=WO3PQI0PqWa1SdlgHa3c0jhds/bOyHGrBJexLv/dCyJuSCmLZcSrSbBBsjmmkdjSw+sK8rRpMiFtGPiCkTp7m2suUIsKQxXRxPSljHM65+Mgwipm/ox5h2MB90/yfRKqZaLQtwpKYLnR0/1D3m3tvfsqCM7Bw0ivK2VKW1djfpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIJ3Cihh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIJ3Cihh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C220C4CEEB;
	Tue,  3 Jun 2025 02:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748917178;
	bh=ktuKedGNJWCXD6IDuyaWLzeLTHihNWiDvOKQdGvVXnw=;
	h=Date:To:From:Subject:From;
	b=zIJ3Cihh5W9RUkWXO2fu6NQXOOAUQyMxKn+BMYry8Z0y36ZCmPW9/DSQrhKJYnyya
	 15JoP0ArLv25U9qoF3hkBTSzUnOOtIIpys8Vzf0ACIfVIDEnvRgGtrPP1JyIZID436
	 scaRAT5FpkoxSWQT6x1+APQeL0zn0f0SwrpM5SKo=
Date: Mon, 02 Jun 2025 19:19:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tytso@mit.edu,stable@vger.kernel.org,jhubbard@nvidia.com,jack@suse.cz,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dan.j.williams@intel.com,brauner@kernel.org,balbirs@nvidia.com,alison.schofield@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-dax-fix-dont-skip-locked-entries-when-scanning-entries.patch removed from -mm tree
Message-Id: <20250603021938.1C220C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: fix "don't skip locked entries when scanning entries"
has been removed from the -mm tree.  Its filename was
     fs-dax-fix-dont-skip-locked-entries-when-scanning-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: fix "don't skip locked entries when scanning entries"
Date: Fri, 23 May 2025 14:37:49 +1000

Commit 6be3e21d25ca ("fs/dax: don't skip locked entries when scanning
entries") introduced a new function, wait_entry_unlocked_exclusive(),
which waits for the current entry to become unlocked without advancing the
XArray iterator state.

Waiting for the entry to become unlocked requires dropping the XArray
lock.  This requires calling xas_pause() prior to dropping the lock which
leaves the xas in a suitable state for the next iteration.  However this
has the side-effect of advancing the xas state to the next index. 
Normally this isn't an issue because xas_for_each() contains code to
detect this state and thus avoid advancing the index a second time on the
next loop iteration.

However both callers of and wait_entry_unlocked_exclusive() itself
subsequently use the xas state to reload the entry.  As xas_pause()
updated the state to the next index this will cause the current entry
which is being waited on to be skipped.  This caused the following warning
to fire intermittently when running xftest generic/068 on an XFS
filesystem with FS DAX enabled:

[   35.067397] ------------[ cut here ]------------
[   35.068229] WARNING: CPU: 21 PID: 1640 at mm/truncate.c:89 truncate_folio_batch_exceptionals+0xd8/0x1e0
[   35.069717] Modules linked in: nd_pmem dax_pmem nd_btt nd_e820 libnvdimm
[   35.071006] CPU: 21 UID: 0 PID: 1640 Comm: fstest Not tainted 6.15.0-rc7+ #77 PREEMPT(voluntary)
[   35.072613] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/204
[   35.074845] RIP: 0010:truncate_folio_batch_exceptionals+0xd8/0x1e0
[   35.075962] Code: a1 00 00 00 f6 47 0d 20 0f 84 97 00 00 00 4c 63 e8 41 39 c4 7f 0b eb 61 49 83 c5 01 45 39 ec 7e 58 42 f68
[   35.079522] RSP: 0018:ffffb04e426c7850 EFLAGS: 00010202
[   35.080359] RAX: 0000000000000000 RBX: ffff9d21e3481908 RCX: ffffb04e426c77f4
[   35.081477] RDX: ffffb04e426c79e8 RSI: ffffb04e426c79e0 RDI: ffff9d21e34816e8
[   35.082590] RBP: ffffb04e426c79e0 R08: 0000000000000001 R09: 0000000000000003
[   35.083733] R10: 0000000000000000 R11: 822b53c0f7a49868 R12: 000000000000001f
[   35.084850] R13: 0000000000000000 R14: ffffb04e426c78e8 R15: fffffffffffffffe
[   35.085953] FS:  00007f9134c87740(0000) GS:ffff9d22abba0000(0000) knlGS:0000000000000000
[   35.087346] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.088244] CR2: 00007f9134c86000 CR3: 000000040afff000 CR4: 00000000000006f0
[   35.089354] Call Trace:
[   35.089749]  <TASK>
[   35.090168]  truncate_inode_pages_range+0xfc/0x4d0
[   35.091078]  truncate_pagecache+0x47/0x60
[   35.091735]  xfs_setattr_size+0xc7/0x3e0
[   35.092648]  xfs_vn_setattr+0x1ea/0x270
[   35.093437]  notify_change+0x1f4/0x510
[   35.094219]  ? do_truncate+0x97/0xe0
[   35.094879]  do_truncate+0x97/0xe0
[   35.095640]  path_openat+0xabd/0xca0
[   35.096278]  do_filp_open+0xd7/0x190
[   35.096860]  do_sys_openat2+0x8a/0xe0
[   35.097459]  __x64_sys_openat+0x6d/0xa0
[   35.098076]  do_syscall_64+0xbb/0x1d0
[   35.098647]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   35.099444] RIP: 0033:0x7f9134d81fc1
[   35.100033] Code: 75 57 89 f0 25 00 00 41 00 3d 00 00 41 00 74 49 80 3d 2a 26 0e 00 00 74 6d 89 da 48 89 ee bf 9c ff ff ff5
[   35.102993] RSP: 002b:00007ffcd41e0d10 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
[   35.104263] RAX: ffffffffffffffda RBX: 0000000000000242 RCX: 00007f9134d81fc1
[   35.105452] RDX: 0000000000000242 RSI: 00007ffcd41e1200 RDI: 00000000ffffff9c
[   35.106663] RBP: 00007ffcd41e1200 R08: 0000000000000000 R09: 0000000000000064
[   35.107923] R10: 00000000000001a4 R11: 0000000000000202 R12: 0000000000000066
[   35.109112] R13: 0000000000100000 R14: 0000000000100000 R15: 0000000000000400
[   35.110357]  </TASK>
[   35.110769] irq event stamp: 8415587
[   35.111486] hardirqs last  enabled at (8415599): [<ffffffff8d74b562>] __up_console_sem+0x52/0x60
[   35.113067] hardirqs last disabled at (8415610): [<ffffffff8d74b547>] __up_console_sem+0x37/0x60
[   35.114575] softirqs last  enabled at (8415300): [<ffffffff8d6ac625>] handle_softirqs+0x315/0x3f0
[   35.115933] softirqs last disabled at (8415291): [<ffffffff8d6ac811>] __irq_exit_rcu+0xa1/0xc0
[   35.117316] ---[ end trace 0000000000000000 ]---

Fix this by using xas_reset() instead, which is equivalent in
implementation to xas_pause() but does not advance the XArray state.

Link: https://lkml.kernel.org/r/20250523043749.1460780-1-apopple@nvidia.com
Fixes: 6be3e21d25ca ("fs/dax: don't skip locked entries when scanning entries")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dax.c~fs-dax-fix-dont-skip-locked-entries-when-scanning-entries
+++ a/fs/dax.c
@@ -257,7 +257,7 @@ static void *wait_entry_unlocked_exclusi
 		wq = dax_entry_waitqueue(xas, entry, &ewait.key);
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					TASK_UNINTERRUPTIBLE);
-		xas_pause(xas);
+		xas_reset(xas);
 		xas_unlock_irq(xas);
 		schedule();
 		finish_wait(wq, &ewait.wait);
_

Patches currently in -mm which might be from apopple@nvidia.com are

maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch


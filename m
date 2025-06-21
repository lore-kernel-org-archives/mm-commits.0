Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B63D2561BB;
	Sat, 21 Jun 2025 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750531633; cv=none; b=SKcD9IPJco4bV+UD/dCSsQWoGye+LvZca6tIULIXroTdj7KVdIpCxkRBEZuTT4zr1g4kqJRKfAEjOMCAtNw91Q5l4YxJBXQpVRtkm2Z2Cfox2YtRgFgbhGe1xlIppdiCdksHWwIt6aG7ZZpv9uy6I6II3FwuklsIC2GJO20ACjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750531633; c=relaxed/simple;
	bh=JyJYizQTl99ZpLk/kGVVWjAW/kYnGMdVBd443Liovy4=;
	h=Date:To:From:Subject:Message-Id; b=sECXnqAZZ2VpD/l+YRwaJ3F2vgjw/SraSRgE3Gj/V2L6rLQcTyoqN2qjtW91r6LvBtii9G+gwNQuUeaUQCIXyyH9qzKflSTqdVS5UDYjxYWZlvueM73Gr6h/+QxT0sPi1maKihzCPMZYeGXjeOg3BPPVMU0TACesoWsG3pQ0lig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LPOzszFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LPOzszFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A75C4CEE7;
	Sat, 21 Jun 2025 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750531632;
	bh=JyJYizQTl99ZpLk/kGVVWjAW/kYnGMdVBd443Liovy4=;
	h=Date:To:From:Subject:From;
	b=LPOzszFUhlnUEbbXT2fnO9EbDkN1nJHPRBkWGCeDcVsZpvnPQJmi2J/3QLWX2B/lZ
	 pFBcrWxj8JNyUn3jpfDcPvdonjnnKm8OhNoMWkmSZxnXLIhsq75dG6D2ZUQAMRP59j
	 On8XmowDpYcAM8Wms7OVfk/tnKhhU8RmAU3bxoVM=
Date: Sat, 21 Jun 2025 11:47:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,miklos@szeredi.hu,dan.j.williams@intel.com,apopple@nvidia.com,haiyuewa@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-fix-runtime-warning-on-truncate_folio_batch_exceptionals.patch added to mm-hotfixes-unstable branch
Message-Id: <20250621184712.85A75C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fuse: Fix runtime warning on truncate_folio_batch_exceptionals()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fuse-fix-runtime-warning-on-truncate_folio_batch_exceptionals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fuse-fix-runtime-warning-on-truncate_folio_batch_exceptionals.patch

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
From: Haiyue Wang <haiyuewa@163.com>
Subject: fuse: Fix runtime warning on truncate_folio_batch_exceptionals()
Date: Sun, 22 Jun 2025 01:13:51 +0800

The WARN_ON_ONCE is introduced on truncate_folio_batch_exceptionals() to
capture whether the filesystem has removed all DAX entries or not.

And the fix has been applied on the filesystem xfs and ext4 by the commit
0e2f80afcfa6 ("fs/dax: ensure all pages are idle prior to filesystem
unmount").

Apply the missed fix on filesystem fuse to fix the runtime warning:

[    2.011450] ------------[ cut here ]------------
[    2.011873] WARNING: CPU: 0 PID: 145 at mm/truncate.c:89 truncate_folio_batch_exceptionals+0x272/0x2b0
[    2.012468] Modules linked in:
[    2.012718] CPU: 0 UID: 1000 PID: 145 Comm: weston Not tainted 6.16.0-rc2-WSL2-STABLE #2 PREEMPT(undef)
[    2.013292] RIP: 0010:truncate_folio_batch_exceptionals+0x272/0x2b0
[    2.013704] Code: 48 63 d0 41 29 c5 48 8d 1c d5 00 00 00 00 4e 8d 6c 2a 01 49 c1 e5 03 eb 09 48 83 c3 08 49 39 dd 74 83 41 f6 44 1c 08 01 74 ef <0f> 0b 49 8b 34 1e 48 89 ef e8 10 a2 17 00 eb df 48 8b 7d 00 e8 35
[    2.014845] RSP: 0018:ffffa47ec33f3b10 EFLAGS: 00010202
[    2.015279] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    2.015884] RDX: 0000000000000000 RSI: ffffa47ec33f3ca0 RDI: ffff98aa44f3fa80
[    2.016377] RBP: ffff98aa44f3fbf0 R08: ffffa47ec33f3ba8 R09: 0000000000000000
[    2.016942] R10: 0000000000000001 R11: 0000000000000000 R12: ffffa47ec33f3ca0
[    2.017437] R13: 0000000000000008 R14: ffffa47ec33f3ba8 R15: 0000000000000000
[    2.017972] FS:  000079ce006afa40(0000) GS:ffff98aade441000(0000) knlGS:0000000000000000
[    2.018510] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.018987] CR2: 000079ce03e74000 CR3: 000000010784f006 CR4: 0000000000372eb0
[    2.019518] Call Trace:
[    2.019729]  <TASK>
[    2.019901]  truncate_inode_pages_range+0xd8/0x400
[    2.020280]  ? timerqueue_add+0x66/0xb0
[    2.020574]  ? get_nohz_timer_target+0x2a/0x140
[    2.020904]  ? timerqueue_add+0x66/0xb0
[    2.021231]  ? timerqueue_del+0x2e/0x50
[    2.021646]  ? __remove_hrtimer+0x39/0x90
[    2.022017]  ? srso_alias_untrain_ret+0x1/0x10
[    2.022497]  ? psi_group_change+0x136/0x350
[    2.023046]  ? _raw_spin_unlock+0xe/0x30
[    2.023514]  ? finish_task_switch.isra.0+0x8d/0x280
[    2.024068]  ? __schedule+0x532/0xbd0
[    2.024551]  fuse_evict_inode+0x29/0x190
[    2.025131]  evict+0x100/0x270
[    2.025641]  ? _atomic_dec_and_lock+0x39/0x50
[    2.026316]  ? __pfx_generic_delete_inode+0x10/0x10
[    2.026843]  __dentry_kill+0x71/0x180
[    2.027335]  dput+0xeb/0x1b0
[    2.027725]  __fput+0x136/0x2b0
[    2.028054]  __x64_sys_close+0x3d/0x80
[    2.028469]  do_syscall_64+0x6d/0x1b0
[    2.028832]  ? clear_bhb_loop+0x30/0x80
[    2.029182]  ? clear_bhb_loop+0x30/0x80
[    2.029533]  ? clear_bhb_loop+0x30/0x80
[    2.029902]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    2.030423] RIP: 0033:0x79ce03d0d067
[    2.030820] Code: b8 ff ff ff ff e9 3e ff ff ff 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 c3 a7 f8 ff
[    2.032354] RSP: 002b:00007ffef0498948 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
[    2.032939] RAX: ffffffffffffffda RBX: 00007ffef0498960 RCX: 000079ce03d0d067
[    2.033612] RDX: 0000000000000003 RSI: 0000000000001000 RDI: 000000000000000d
[    2.034289] RBP: 00007ffef0498a30 R08: 000000000000000d R09: 0000000000000000
[    2.034944] R10: 00007ffef0498978 R11: 0000000000000246 R12: 0000000000000001
[    2.035610] R13: 00007ffef0498960 R14: 000079ce03e09ce0 R15: 0000000000000003
[    2.036301]  </TASK>
[    2.036532] ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20250621171507.3770-1-haiyuewa@163.com
Fixes: bde708f1a65d ("fs/dax: always remove DAX page-cache entries when breaking layouts")
Signed-off-by: Haiyue Wang <haiyuewa@163.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/inode.c~fuse-fix-runtime-warning-on-truncate_folio_batch_exceptionals
+++ a/fs/fuse/inode.c
@@ -9,6 +9,7 @@
 #include "fuse_i.h"
 #include "dev_uring_i.h"
 
+#include <linux/dax.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -162,6 +163,9 @@ static void fuse_evict_inode(struct inod
 	/* Will write inode on close/munmap and in all other dirtiers */
 	WARN_ON(inode->i_state & I_DIRTY_INODE);
 
+	if (FUSE_IS_DAX(inode))
+		dax_break_layout_final(inode);
+
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (inode->i_sb->s_flags & SB_ACTIVE) {
_

Patches currently in -mm which might be from haiyuewa@163.com are

fuse-fix-runtime-warning-on-truncate_folio_batch_exceptionals.patch


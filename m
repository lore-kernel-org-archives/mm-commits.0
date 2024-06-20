Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3456E13AF2
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718846872; cv=none; b=hV864okhwjd2+VdDChMlBBNpcgrXvEwUf39hsYIMNJtcV17k1FzxcRBfXOd/X+hilitUaBRVgGSOWWUnqpw0qCbr8Er/2yx093Ppin78c2kfLPhNI4WWUo6XKUrr4Tw0IwqtQYBBK4BWhB29R1xy+cHbxwmIDPSnIqSo5Stin/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718846872; c=relaxed/simple;
	bh=sBOcGv8MpzyEGy7nqH2E49ZoZC/Ng4QqyHEZ03k+vok=;
	h=Date:To:From:Subject:Message-Id; b=ZrF5O5Pph1RhkIF88z4dwsYid635F14M/zoFM0sKv7TfarNt5IuEz+HsduzJ4wgDVOUXtaDQeCWnA7d5ry2L7aD4wT6J0zFUGcLHBDhqodW6OWR/mjIepRIO7FQ2mpYvaJxeFp2L2ejH2Bjc9NOFeJEVmVgXbqYsb9CTNRYGMTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SA/a3btT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SA/a3btT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9606DC2BBFC;
	Thu, 20 Jun 2024 01:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718846871;
	bh=sBOcGv8MpzyEGy7nqH2E49ZoZC/Ng4QqyHEZ03k+vok=;
	h=Date:To:From:Subject:From;
	b=SA/a3btTMGzXOCCZKWp33LGbO9atU0TlLPrIeSHHx6bMxdsNFcNpzI1o+1HYbbPLl
	 8ky3CJTZAr6PoKsHTDHvgFZl52rgutfhHijJ47IZ/AAsdnCVO0L2OI1b9BHdVKpR3F
	 EzGZVxcjN7baj/b6HPQSTeYAHyBYLZge5y2JS1n0=
Date: Wed, 19 Jun 2024 18:27:51 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,oliver.sang@intel.com,muchun.song@linux.dev,m.szyprowski@samsung.com,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix-fix.patch added to mm-unstable branch
Message-Id: <20240620012751.9606DC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix-fix.patch

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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix-fix
Date: Wed, 19 Jun 2024 01:55:27 +0000

When CONFIG_DEBUG_LOCK_ALLOC is enabled, the following commands can
trigger a bug,

mount -t cgroup2 none /sys/fs/cgroup
cd /sys/fs/cgroup
echo "+hugetlb" > cgroup.subtree_control

The log is as below:

BUG: key ffff8880046d88d8 has not been registered!
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 3 PID: 226 at kernel/locking/lockdep.c:4945 lockdep_init_map_type+0x185/0x220
Modules linked in:
CPU: 3 PID: 226 Comm: bash Not tainted 6.10.0-rc4-next-20240617-g76db4c64526c #544
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:lockdep_init_map_type+0x185/0x220
Code: 00 85 c0 0f 84 6c ff ff ff 8b 3d 6a d1 85 01 85 ff 0f 85 5e ff ff ff 48 c7 c6 21 99 4a 82 48 c7 c7 60 29 49 82 e8 3b 2e f5
RSP: 0018:ffffc9000083fc30 EFLAGS: 00000282
RAX: 0000000000000000 RBX: ffffffff828dd820 RCX: 0000000000000027
RDX: ffff88803cd9cac8 RSI: 0000000000000001 RDI: ffff88803cd9cac0
RBP: ffff88800674fbb0 R08: ffffffff828ce248 R09: 00000000ffffefff
R10: ffffffff8285e260 R11: ffffffff828b8eb8 R12: ffff8880046d88d8
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880067281c0
FS:  00007f68601ea740(0000) GS:ffff88803cd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005614f3ebc740 CR3: 000000000773a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ? __warn+0x77/0xd0
 ? lockdep_init_map_type+0x185/0x220
 ? report_bug+0x189/0x1a0
 ? handle_bug+0x3c/0x70
 ? exc_invalid_op+0x18/0x70
 ? asm_exc_invalid_op+0x1a/0x20
 ? lockdep_init_map_type+0x185/0x220
 __kernfs_create_file+0x79/0x100
 cgroup_addrm_files+0x163/0x380
 ? find_held_lock+0x2b/0x80
 ? find_held_lock+0x2b/0x80
 ? find_held_lock+0x2b/0x80
 css_populate_dir+0x73/0x180
 cgroup_apply_control_enable+0x12f/0x3a0
 cgroup_subtree_control_write+0x30b/0x440
 kernfs_fop_write_iter+0x13a/0x1f0
 vfs_write+0x341/0x450
 ksys_write+0x64/0xe0
 do_syscall_64+0x4b/0x110
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f68602d9833
Code: 8b 15 61 26 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 08
RSP: 002b:00007fff9bbdf8e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007f68602d9833
RDX: 0000000000000009 RSI: 00005614f3ebc740 RDI: 0000000000000001
RBP: 00005614f3ebc740 R08: 000000000000000a R09: 0000000000000008
R10: 00005614f3db6ba0 R11: 0000000000000246 R12: 0000000000000009
R13: 00007f68603bd6a0 R14: 0000000000000009 R15: 00007f68603b8880

For lockdep, there is a sanity check in lockdep_init_map_type(), the
lock-class key must either have been allocated statically or must
have been registered as a dynamic key. However the commit e18df2889ff9
("mm/hugetlb_cgroup: prepare cftypes based on template") has changed
the cftypes from static allocated objects to dynamic allocated objects,
so the cft->lockdep_key must be registered proactively.

Link: https://lkml.kernel.org/r/20240619015527.2212698-1-xiujianfeng@huawei.com
Fixes: e18df2889ff9 ("mm/hugetlb_cgroup: prepare cftypes based on template")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202406181046.8d8b2492-oliver.sang@intel.com
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: SeongJae Park <sj@kernel.org>
Closes: https://lore.kernel.org/20240618233608.400367-1-sj@kernel.org
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup-defs.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/cgroup-defs.h~mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix-fix
+++ a/include/linux/cgroup-defs.h
@@ -676,9 +676,7 @@ struct cftype {
 	__poll_t (*poll)(struct kernfs_open_file *of,
 			 struct poll_table_struct *pt);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	lockdep_key;
-#endif
 };
 
 /*
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch
mm-hugetlb_cgroup-prepare-cftypes-based-on-template.patch
mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix.patch
mm-hugetlb_cgroup-prepare-cftypes-based-on-template-fix-fix.patch
mm-hugetlb_cgroup-switch-to-the-new-cftypes.patch


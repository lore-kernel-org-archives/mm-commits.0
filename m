Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792729072;
	b=h2bK2YqzK3okId/LB4MtY02ZJVIPOr3jrDq4rclH1N8Kz8stKA9Imlz6iM6D+Y9DLUNh
	 MAracZWHnY5tJ5sTJDWMXC3OuU5xjsAw563UUbNmIeVdvAEfwrtf3rETAunukkgMyW1fa
	 Nrnh+sD7FO81DrBWP78aYclXRuC0mpABV+HUmYvbisBfBsB91zEm3S5ipxlIo/bYH2Zt7
	 2kQcpGcbK4PJuZ+wYtz4Jj5H6APb+0x+2yhTWXAQsSuL+HI1Ivs3+OfEmy0WvSgb4QZwy
	 SU2TsbgeUX7dk2PiQ2XV7Afse7+GKWYNjGqexyzORgEJ4/5tE/cUx3Gneea4BcCLY2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792729072;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=E6o+77lkFv+7PjXdrWcZ2hRJGPEw0O3j6Ku2keoady0=;
	b=ft5uoSWMnAGhtjQY/wM0mu7QeyMG7ZJubO0tZNCAZ26ht3jcHJJsgO6Sl+sf+ObOk08v
	 oWXtHBJ5wjFhD/J8bjdmg1LFXND4+oqaTiRFnIe5X3vUGd01HNC02ulyhduWDnLzy04Zh
	 VBGX6bEE37BqfB+rkeHjqar1Yw6kGl4lk9wEWwrn4AJ6u4FkKxI4Hpn4p+Ja40x8stjsa
	 z2nxZYqsh1p/81LoNIsdk8tSiC5XmYJP11cU+YGroDWxu6cnHtfp9jTwMOpRLah63DfXC
	 twfOFxr8QkFutUciY5ULYVCW8XvGj50Daw8WfDErq4rdZy8imOm2M4/t3IBZIof/kvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ciwaWiK1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD5606A319;
	Fri, 23 Oct 2026 04:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ciwaWiK1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC6F1F01825;
	Fri, 23 Oct 2026 04:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792729071;
	bh=E6o+77lkFv+7PjXdrWcZ2hRJGPEw0O3j6Ku2keoady0=;
	h=Date:To:From:Subject;
	b=ciwaWiK1edvFjd3VJILNk44X9MYvxHoz98BG+i+Qy5wBmvyY7R7eXuz9dPlDPC1F7
	 9eHnrQJqo7bEdDh7YIb0ZTICqTpdT/WFClSZkS4A9IKEMIEnPSSicx01A5I03y9mJ6
	 7X5yYSJcR07wb+UHpyvLvK5bMhNotfFJlPUOdGxc=
Date: Thu, 22 Oct 2026 21:17:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch added to mm-nonmm-unstable branch
Message-Id: <20261023041751.2DC6F1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: snapshot dentry names in file and setattr traces
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: snapshot dentry names in file and setattr traces
Date: Thu, 22 Oct 2026 17:08:41 +0800

Patch series "ocfs2: stabilize dentry names in file and setattr traces",
v4.

Snapshot names at all six users of ocfs2__file_ops and at the separate
setattr event. Patch 1 handles the five ordinary file-operation callers
and setattr. Patch 2 handles release separately to preserve its locked
open-count sample and take the snapshot outside that critical section.

The release explanation distinguishes its existing RCU lifetime coverage
from name/length consistency. It does not claim that the ordinary
callers' external-name UAF interleaving crosses the held inode spinlock.
The release source change is unchanged from v3.

Patch 1 also removes the read callback's redundant NULL-inode check.
The two patches apply independently and leave trace formats unchanged.


This patch (of 2):

The open, fsync, read, write and splice-read trace calls pass the live
dentry name and length to the shared ocfs2__file_ops event class.
ocfs2_setattr() passes the same unprotected arguments to its own event.
Both events size and copy a __string field separately. A reference to
the dentry does not pin the external storage backing an individual name.

With an event enabled, a caller can be preempted after loading the name
pointer. A long-to-short rename can then replace the name and reclaim its
old external allocation before the trace callback sizes or copies it,
provided no other snapshot retains that allocation.

The setattr inode lock does not exclude every rename: a same-directory
rename of a source directory need not take that directory's inode lock.
It can therefore change the dentry name while setattr records its event.
Inline names and separately loaded lengths can also change during trace
record sizing and copying.

Take a dentry name snapshot around each of these six trace calls and
pass both the string and length from the snapshot. Check event enablement
before taking a snapshot. Keep the event classes and formats unchanged.

Also remove the redundant NULL-inode check in the read callback.
file_inode() returns the open file's inode, which is already used by the
trace call above the check.

The historical report below is from the read path.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in strlen+0x85/0xa0
    Read of size 1 at addr ffff88810a5b2b18 by task python3/496

    [CPU and host details omitted.]
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? strlen+0x85/0xa0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? strlen+0x85/0xa0
     kasan_report+0xe0/0x110
     ? strlen+0x85/0xa0
     strlen+0x85/0xa0
     trace_event_raw_event_ocfs2__file_ops+0xf0/0x480
     ? __pfx_trace_event_raw_event_ocfs2__file_ops+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xe7/0x1c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ocfs2_file_read_iter+0x6cd/0xb30
     ? __pfx_ocfs2_file_read_iter+0x10/0x10
     ? selinux_file_permission+0x11d/0x540
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? security_file_permission+0x26/0x80
     vfs_read+0x7d2/0xc20
     ? __pfx_vfs_read+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_do_sys_openat2+0x10/0x10
     ksys_read+0x111/0x200
     ? __pfx_ksys_read+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     ? srso_alias_return_thunk+0x5/0xfbef5
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    [User register dump omitted.]
     </TASK>

    Allocated by task 489:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_noprof+0x2de/0x780
     __d_alloc+0x5fc/0x8c0
     d_alloc_parallel+0x106/0x11d0
     lookup_open+0x3ff/0x13e0
     path_openat+0x95e/0x2020
     do_file_open+0x21e/0x470
     do_sys_openat2+0xf4/0x1b0
     __x64_sys_openat+0x136/0x1e0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 0:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     __rcu_free_sheaf_prepare+0x65/0x2a0
     rcu_free_sheaf_nobarn+0x1d/0x50
     rcu_core+0x6be/0x1ed0
     handle_softirqs+0x1fa/0x8d0
     __irq_exit_rcu+0x113/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20

    The buggy address belongs to the object at ffff88810a5b2b00
     which belongs to the cache kmalloc-rcl-192 of size 192
    The buggy address is located 24 bytes inside of
     freed 192-byte region [ffff88810a5b2b00, ffff88810a5b2bc0)

    [Page and shadow-memory dumps omitted.]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com
Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-1@gmail.com
Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/file.c |  102 +++++++++++++++++++++++++++++-----------------
 1 file changed, 65 insertions(+), 37 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-snapshot-dentry-names-in-file-and-setattr-traces
+++ a/fs/ocfs2/file.c
@@ -85,10 +85,17 @@ static int ocfs2_file_open(struct inode
 	int mode = file->f_flags;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	trace_ocfs2_file_open(inode, file, file->f_path.dentry,
-			      (unsigned long long)oi->ip_blkno,
-			      file->f_path.dentry->d_name.len,
-			      file->f_path.dentry->d_name.name, mode);
+	if (trace_ocfs2_file_open_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_open(inode, file, dentry,
+				      oi->ip_blkno,
+				      name.name.len, name.name.name,
+				      mode);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (file->f_mode & FMODE_WRITE) {
 		status = dquot_initialize(inode);
@@ -174,11 +181,17 @@ static int ocfs2_sync_file(struct file *
 	tid_t commit_tid;
 	bool needs_barrier = false;
 
-	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
-			      oi->ip_blkno,
-			      file->f_path.dentry->d_name.len,
-			      file->f_path.dentry->d_name.name,
-			      (unsigned long long)datasync);
+	if (trace_ocfs2_sync_file_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_sync_file(inode, file, dentry,
+				      oi->ip_blkno,
+				      name.name.len, name.name.name,
+				      (unsigned long long)datasync);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
@@ -1132,15 +1145,19 @@ int ocfs2_setattr(struct mnt_idmap *idma
 	int had_lock;
 	struct ocfs2_lock_holder oh;
 
-	trace_ocfs2_setattr(inode, dentry,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    dentry->d_name.len, dentry->d_name.name,
-			    attr->ia_valid,
-				attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
-				attr->ia_valid & ATTR_UID ?
+	if (trace_ocfs2_setattr_enabled()) {
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_setattr(inode, dentry, OCFS2_I(inode)->ip_blkno,
+				    name.name.len, name.name.name, attr->ia_valid,
+				    attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
+				    attr->ia_valid & ATTR_UID ?
 					from_kuid(&init_user_ns, attr->ia_uid) : 0,
-				attr->ia_valid & ATTR_GID ?
+				    attr->ia_valid & ATTR_GID ?
 					from_kgid(&init_user_ns, attr->ia_gid) : 0);
+		release_dentry_name_snapshot(&name);
+	}
 
 	status = ocfs2_emergency_state(osb);
 	if (unlikely(status)) {
@@ -2392,11 +2409,17 @@ static ssize_t ocfs2_file_write_iter(str
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
-		(unsigned long long)OCFS2_I(inode)->ip_blkno,
-		file->f_path.dentry->d_name.len,
-		file->f_path.dentry->d_name.name,
-		(unsigned int)from->nr_segs);	/* GRRRRR */
+	if (trace_ocfs2_file_write_iter_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_write_iter(inode, file, dentry,
+					    OCFS2_I(inode)->ip_blkno,
+					    name.name.len, name.name.name,
+					    (unsigned int)from->nr_segs);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
@@ -2542,17 +2565,16 @@ static ssize_t ocfs2_file_read_iter(stru
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			filp->f_path.dentry->d_name.len,
-			filp->f_path.dentry->d_name.name,
-			to->nr_segs);	/* GRRRRR */
-
-
-	if (!inode) {
-		ret = -EINVAL;
-		mlog_errno(ret);
-		goto bail;
+	if (trace_ocfs2_file_read_iter_enabled()) {
+		struct dentry *dentry = filp->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_read_iter(inode, filp, dentry,
+					   OCFS2_I(inode)->ip_blkno,
+					   name.name.len, name.name.name,
+					   to->nr_segs);
+		release_dentry_name_snapshot(&name);
 	}
 
 	if (!direct_io && nowait)
@@ -2624,11 +2646,17 @@ static ssize_t ocfs2_file_splice_read(st
 	ssize_t ret = 0;
 	int lock_level = 0;
 
-	trace_ocfs2_file_splice_read(inode, in, in->f_path.dentry,
-				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-				     in->f_path.dentry->d_name.len,
-				     in->f_path.dentry->d_name.name,
-				     flags);
+	if (trace_ocfs2_file_splice_read_enabled()) {
+		struct dentry *dentry = in->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_splice_read(inode, in, dentry,
+					     OCFS2_I(inode)->ip_blkno,
+					     name.name.len, name.name.name,
+					     flags);
+		release_dentry_name_snapshot(&name);
+	}
 
 	/*
 	 * We're fine letting folks race truncates and extending writes with
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-drain-quorum-work-before-removing-the-cluster.patch
ocfs2-dlm-drain-join-handlers-before-releasing-module-text.patch
ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch
ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch


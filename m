From: akpm@linux-foundation.org
Subject: [merged] fs-superc-add-lockdep-annotation-to-s_umount.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:58 -0800
Message-ID: <200902191916.n1JJGw8A016309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbZBSTRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, arjan@infradead.org, lizf@cn.fujitsu.com, menage@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/super.c: add lockdep annotation to s_umount
has been removed from the -mm tree.  Its filename was
     fs-superc-add-lockdep-annotation-to-s_umount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/super.c: add lockdep annotation to s_umount
From: Peter Zijlstra <peterz@infradead.org>

Li Zefan said:

Thread 1:
  for ((; ;))
  {
      mount -t cpuset xxx /mnt > /dev/null 2>&1
      cat /mnt/cpus > /dev/null 2>&1
      umount /mnt > /dev/null 2>&1
  }

Thread 2:
  for ((; ;))
  {
      mount -t cpuset xxx /mnt > /dev/null 2>&1
      umount /mnt > /dev/null 2>&1
  }

(Note: It is irrelevant which cgroup subsys is used.)

After a while a lockdep warning showed up:

=============================================
[ INFO: possible recursive locking detected ]
2.6.28 #479
---------------------------------------------
mount/13554 is trying to acquire lock:
 (&type->s_umount_key#19){--..}, at: [<c049d888>] sget+0x5e/0x321

but task is already holding lock:
 (&type->s_umount_key#19){--..}, at: [<c049da0c>] sget+0x1e2/0x321

other info that might help us debug this:
1 lock held by mount/13554:
 #0:  (&type->s_umount_key#19){--..}, at: [<c049da0c>] sget+0x1e2/0x321

stack backtrace:
Pid: 13554, comm: mount Not tainted 2.6.28-mc #479
Call Trace:
 [<c044ad2e>] validate_chain+0x4c6/0xbbd
 [<c044ba9b>] __lock_acquire+0x676/0x700
 [<c044bb82>] lock_acquire+0x5d/0x7a
 [<c049d888>] ? sget+0x5e/0x321
 [<c061b9b8>] down_write+0x34/0x50
 [<c049d888>] ? sget+0x5e/0x321
 [<c049d888>] sget+0x5e/0x321
 [<c045a2e7>] ? cgroup_set_super+0x0/0x3e
 [<c045959f>] ? cgroup_test_super+0x0/0x2f
 [<c045bcea>] cgroup_get_sb+0x98/0x2e7
 [<c045cfb6>] cpuset_get_sb+0x4a/0x5f
 [<c049dfa4>] vfs_kern_mount+0x40/0x7b
 [<c049e02d>] do_kern_mount+0x37/0xbf
 [<c04af4a0>] do_mount+0x5c3/0x61a
 [<c04addd2>] ? copy_mount_options+0x2c/0x111
 [<c04af560>] sys_mount+0x69/0xa0
 [<c0403251>] sysenter_do_call+0x12/0x31

The cause is after alloc_super() and then retry, an old entry in list
fs_supers is found, so grab_super(old) is called, but both functions hold
s_umount lock:

struct super_block *sget(...)
{
	...
retry:
	spin_lock(&sb_lock);
	if (test) {
		list_for_each_entry(old, &type->fs_supers, s_instances) {
			if (!test(old, data))
				continue;
			if (!grab_super(old))  <--- 2nd: down_write(&old->s_umount);
				goto retry;
			if (s)
				destroy_super(s);
			return old;
		}
	}
	if (!s) {
		spin_unlock(&sb_lock);
		s = alloc_super(type);   <--- 1th: down_write(&s->s_umount)
		if (!s)
			return ERR_PTR(-ENOMEM);
		goto retry;
	}
	...
}

It seems like a false positive, and seems like VFS but not cgroup needs to
be fixed.


Peter said:

We can simply put the new s_umount instance in a but lockdep doesn't
particularly cares about subclass order.

If there's any issue with the callers of sget() assuming the s_umount lock
being of sublcass 0, then there is another annotation we can use to fix
that, but lets not bother with that if this is sufficient.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12673

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Menage <menage@google.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN fs/super.c~fs-superc-add-lockdep-annotation-to-s_umount fs/super.c
--- a/fs/super.c~fs-superc-add-lockdep-annotation-to-s_umount
+++ a/fs/super.c
@@ -82,7 +82,22 @@ static struct super_block *alloc_super(s
 		 * lock ordering than usbfs:
 		 */
 		lockdep_set_class(&s->s_lock, &type->s_lock_key);
-		down_write(&s->s_umount);
+		/*
+		 * sget() can have s_umount recursion.
+		 *
+		 * When it cannot find a suitable sb, it allocates a new
+		 * one (this one), and tries again to find a suitable old
+		 * one.
+		 *
+		 * In case that succeeds, it will acquire the s_umount
+		 * lock of the old one. Since these are clearly distrinct
+		 * locks, and this object isn't exposed yet, there's no
+		 * risk of deadlocks.
+		 *
+		 * Annotate this by putting this lock in a different
+		 * subclass.
+		 */
+		down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);
 		s->s_count = S_BIAS;
 		atomic_set(&s->s_active, 1);
 		mutex_init(&s->s_vfs_rename_mutex);
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
linux-next.patch
workqueue-avoid-recursion-in-run_workqueue.patch


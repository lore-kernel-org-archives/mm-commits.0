From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-track-numbers-of-writers-to-mounts-fix-for-boot-time-mnt_want_write-bug.patch added to -mm tree
Date: Thu, 13 Mar 2008 13:53:19 -0700
Message-ID: <200803132053.m2DKrJfx032359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYCMUxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 16:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp, viro@parcelfarce.linux.theplanet.co.uk


The patch titled
     fix for boot-time mnt_want_write() bug
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-track-numbers-of-writers-to-mounts-fix-for-boot-time-mnt_want_write-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix for boot-time mnt_want_write() bug
From: Dave Hansen <haveblue@us.ibm.com>

First of all, this is a hard bug to trigger.  I think it requires page
alloc (or slab) debugging.  It also requires that a vfsmnt has been
freed and its memory not been mapped as something else.  It must also
have had a recent mnt_writer at the time of its __mntput().  The area
where the vfsmnt was must fault when accessed.

The problem occurs when we unmount and __mntput() a vfsmount.  We go
find any cpu_writers for that mount and clear the cpu_writer->count to
zero.  That is supposed to mean that no one will ever go try and
coalesce the cpu_writer->count int to the mnt->__mnt_writers.  Buuuuuut,
that isn't quite what happens.  We only check in __clear_mnt_count() for
a NULL mount:

void __clear_mnt_count(mnt, cpu_writer)
{
 	if (!cpu_writer->mnt)
 		return;
 	atomic_add(cpu_writer->count, &cpu_writer->mnt->__mnt_writers);
 	cpu_writer->count = 0;
}

and we go ahead and dereference the mnt (which may be invalid here).  If
it *WAS* invalid, the cpu_writer->count is always 0, and we don't
actually do anything in practice to the invalid memory location except
access it.  Adding a 0 doesn't _hurt_ anything, even if there is
something else in the memory.  That's why we didn't notice this before.
Miklos, you were very right to get nervous about this area in your
review.

Either one of the hunks in the patch would have fixed Tetsuo's oops.
But, let's include both for completeness.  They're both operating on hot
cachelines at the time so it shouldn't really impact anything.

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-track-numbers-of-writers-to-mounts-fix-for-boot-time-mnt_want_write-bug fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-track-numbers-of-writers-to-mounts-fix-for-boot-time-mnt_want_write-bug
+++ a/fs/namespace.c
@@ -149,6 +149,12 @@ static inline void __clear_mnt_count(str
 {
 	if (!cpu_writer->mnt)
 		return;
+	/*
+	 * This is in case anyone ever leaves an invalid,
+	 * old ->mnt and a count of 0.
+	 */
+	if (!cpu_writer->count)
+		return;
 	atomic_add(cpu_writer->count, &cpu_writer->mnt->__mnt_writers);
 	cpu_writer->count = 0;
 }
@@ -529,6 +535,12 @@ static inline void __mntput(struct vfsmo
 		spin_lock(&cpu_writer->lock);
 		atomic_add(cpu_writer->count, &mnt->__mnt_writers);
 		cpu_writer->count = 0;
+		/*
+		 * Might as well do this so that no one
+		 * ever sees the pointer and expects
+		 * it to be valid.
+		 */
+		cpu_writer->mnt = NULL;
 		spin_unlock(&cpu_writer->lock);
 	}
 	/*
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

origin.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts-fix-for-boot-time-mnt_want_write-bug.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch


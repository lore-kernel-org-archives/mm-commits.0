From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-track-numbers-of-writers-to-mounts-fix-for-boot-time-mnt_want_write-bug.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:41:13 -0700
Message-ID: <200803261841.m2QIfDxj028833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758333AbYCZSla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp, viro@parcelfarce.linux.theplanet.co.uk, mm-commits@vger.kernel.org


The patch titled
     fix for boot-time mnt_want_write() bug
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-track-numbers-of-writers-to-mounts-fix-for-boot-time-mnt_want_write-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch


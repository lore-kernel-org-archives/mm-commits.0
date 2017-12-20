From: akpm@linux-foundation.org
Subject: + proc-rearrange-struct-proc_dir_entry.patch added to -mm tree
Date: Wed, 20 Dec 2017 14:43:25 -0800
Message-ID: <5a3ae78d.w2MH/ohmWWFsfsDA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38138 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756529AbdLTWn1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 17:43:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/internal.h: rearrange struct proc_dir_entry
has been added to the -mm tree.  Its filename is
     proc-rearrange-struct-proc_dir_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-rearrange-struct-proc_dir_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-rearrange-struct-proc_dir_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc/internal.h: rearrange struct proc_dir_entry

struct proc_dir_entry became bit messy over years:

* move 16-bit ->mode_t before namelen to get rid of padding
* make ->in_use first field: it seems to be most used resulting in
  smaller code on x86_64 (defconfig):

	add/remove: 0/0 grow/shrink: 7/13 up/down: 24/-67 (-43)
	Function                                     old     new   delta
	proc_readdir_de                              451     455      +4
	proc_get_inode                               282     286      +4
	pde_put                                       65      69      +4
	remove_proc_subtree                          294     297      +3
	remove_proc_entry                            297     300      +3
	proc_register                                295     298      +3
	proc_notify_change                            94      97      +3
	unuse_pde                                     27      26      -1
	proc_reg_write                                89      85      -4
	proc_reg_unlocked_ioctl                       85      81      -4
	proc_reg_read                                 89      85      -4
	proc_reg_llseek                               87      83      -4
	proc_reg_get_unmapped_area                   123     119      -4
	proc_entry_rundown                           139     135      -4
	proc_reg_poll                                 91      85      -6
	proc_reg_mmap                                 79      73      -6
	proc_get_link                                 55      49      -6
	proc_reg_release                             108     101      -7
	proc_reg_open                                298     291      -7
	close_pdeo                                   228     218     -10

* move writeable fields together to a first cacheline (on x86_64),
  those include
	* ->in_use: reference count, taken every open/read/write/close etc
	* ->count: reference count, taken at readdir on every entry
	* ->pde_openers: tracks (nearly) every open, dirtied
	* ->pde_unload_lock: spinlock protecting ->pde_openers
	* ->proc_iops, ->proc_fops, ->data: writeonce fields,
	  used right together with previous group.

* other rarely written fields go into 1st/2nd and 2nd/3rd cacheline on
  32-bit and 64-bit respectively.

Additionally on 32-bit, ->subdir, ->subdir_node, ->namelen, ->name go
fully into 2nd cacheline, separated from writeable fields.  They are all
used during lookup.

Link: http://lkml.kernel.org/r/20171220215914.GA7877@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN fs/proc/internal.h~proc-rearrange-struct-proc_dir_entry fs/proc/internal.h
--- a/fs/proc/internal.h~proc-rearrange-struct-proc_dir_entry
+++ a/fs/proc/internal.h
@@ -31,24 +31,27 @@ struct mempolicy;
  * subdir_node is used to build the rb tree "subdir" of the parent.
  */
 struct proc_dir_entry {
+	/*
+	 * number of callers into module in progress;
+	 * negative -> it's going away RSN
+	 */
+	atomic_t in_use;
+	atomic_t count;		/* use count */
+	struct list_head pde_openers;	/* who did ->open, but not ->release */
+	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	struct completion *pde_unload_completion;
+	const struct inode_operations *proc_iops;
+	const struct file_operations *proc_fops;
+	void *data;
 	unsigned int low_ino;
-	umode_t mode;
 	nlink_t nlink;
 	kuid_t uid;
 	kgid_t gid;
 	loff_t size;
-	const struct inode_operations *proc_iops;
-	const struct file_operations *proc_fops;
 	struct proc_dir_entry *parent;
 	struct rb_root_cached subdir;
 	struct rb_node subdir_node;
-	void *data;
-	atomic_t count;		/* use count */
-	atomic_t in_use;	/* number of callers into module in progress; */
-			/* negative -> it's going away RSN */
-	struct completion *pde_unload_completion;
-	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	umode_t mode;
 	u8 namelen;
 	char name[];
 } __randomize_layout;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
proc-simpler-proc-vmcore-cleanup.patch
proc-less-memory-for-proc-map_files-readdir.patch
proc-delete-children_seq_release.patch
proc-rearrange-struct-proc_dir_entry.patch
seq_file-delete-small-value-optimization.patch
cpumask-make-cpumask_size-return-unsigned-int.patch


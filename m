From: akpm@linux-foundation.org
Subject: [patch 022/114] fs/proc/internal.h: rearrange struct
 proc_dir_entry
Date: Tue, 06 Feb 2018 15:37:18 -0800
Message-ID: <20180206233718.GGlEyGqun%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXhT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

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

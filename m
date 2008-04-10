From: akpm@linux-foundation.org
Subject: + proc-remove-get_info-infrastructure.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:35:04 -0700
Message-ID: <200804102135.m3ALZ499018562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757062AbYDJVmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     proc: remove ->get_info infrastructure
has been added to the -mm tree.  Its filename is
     proc-remove-get_info-infrastructure.patch

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
Subject: proc: remove ->get_info infrastructure
From: Alexey Dobriyan <adobriyan@sw.ru>

Now that last dozen or so users of ->get_info were removed, ditch it too.
Everyone sane shouldd have switched to seq_file interface long ago.

P.S.: Co-existing 3 interfaces (->get_info/->read_proc/->proc_fops) for proc
      is long-standing crap, BTW, thus
      a) put ->read_proc/->write_proc/read_proc_entry() users on death row,
      b) new such users should be rejected,
      c) everyone is encouraged to convert his favourite ->read_proc user or
         I'll do it, lazy bastards.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    7 +------
 include/linux/proc_fs.h |   15 +--------------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff -puN fs/proc/generic.c~proc-remove-get_info-infrastructure fs/proc/generic.c
--- a/fs/proc/generic.c~proc-remove-get_info-infrastructure
+++ a/fs/proc/generic.c
@@ -69,12 +69,7 @@ proc_file_read(struct file *file, char _
 		count = min_t(size_t, PROC_BLOCK_SIZE, nbytes);
 
 		start = NULL;
-		if (dp->get_info) {
-			/* Handle old net routines */
-			n = dp->get_info(page, &start, *ppos, count);
-			if (n < count)
-				eof = 1;
-		} else if (dp->read_proc) {
+		if (dp->read_proc) {
 			/*
 			 * How to be a proc read function
 			 * ------------------------------
diff -puN include/linux/proc_fs.h~proc-remove-get_info-infrastructure include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-remove-get_info-infrastructure
+++ a/include/linux/proc_fs.h
@@ -40,7 +40,7 @@ enum {
  * /proc file has a parent, but "subdir" is NULL for all
  * non-directory entries).
  *
- * "get_info" is called at "read", while "owner" is used to protect module
+ * "owner" is used to protect module
  * from unloading while proc_dir_entry is in use
  */
 
@@ -48,7 +48,6 @@ typedef	int (read_proc_t)(char *page, ch
 			  int count, int *eof, void *data);
 typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
 			   unsigned long count, void *data);
-typedef int (get_info_t)(char *, char **, off_t, int);
 
 struct proc_dir_entry {
 	unsigned int low_ino;
@@ -69,7 +68,6 @@ struct proc_dir_entry {
 	 * somewhere.
 	 */
 	const struct file_operations *proc_fops;
-	get_info_t *get_info;
 	struct module *owner;
 	struct proc_dir_entry *next, *parent, *subdir;
 	void *data;
@@ -187,14 +185,6 @@ static inline struct proc_dir_entry *cre
 	return res;
 }
  
-static inline struct proc_dir_entry *create_proc_info_entry(const char *name,
-	mode_t mode, struct proc_dir_entry *base, get_info_t *get_info)
-{
-	struct proc_dir_entry *res=create_proc_entry(name,mode,base);
-	if (res) res->get_info=get_info;
-	return res;
-}
-
 extern struct proc_dir_entry *proc_net_fops_create(struct net *net,
 	const char *name, mode_t mode, const struct file_operations *fops);
 extern void proc_net_remove(struct net *net, const char *name);
@@ -234,9 +224,6 @@ static inline struct proc_dir_entry *pro
 static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *base, 
 	read_proc_t *read_proc, void * data) { return NULL; }
-static inline struct proc_dir_entry *create_proc_info_entry(const char *name,
-	mode_t mode, struct proc_dir_entry *base, get_info_t *get_info)
-	{ return NULL; }
 
 struct tty_driver;
 static inline void proc_tty_register_driver(struct tty_driver *driver) {};
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-x86.patch
git-net.patch
git-cryptodev.patch
keys-switch-to-proc_create.patch
proc-print-more-information-when-removing-non-empty-directories.patch
proc-switch-to-proc_create.patch
proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch
proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch
proc-switch-proc-apm-to-seq_file-interface.patch
proc-remove-proc-mac_iop.patch
proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch
proc-switch-proc-excite-unit_id-to-seq_file-interface.patch
proc-switch-proc-irda-irnet-to-seq_file-interface.patch
proc-convert-proc-bus-nubus-to-seq_file-interface.patch
proc-switch-proc-ip2mem-to-seq_file-interface.patch
proc-switch-proc-scsi-device_info-to-seq_file-interface.patch
proc-remove-get_info-infrastructure.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
single_open-seq_release-leak-diagnostics.patch


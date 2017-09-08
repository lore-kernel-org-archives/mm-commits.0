From: akpm@linux-foundation.org
Subject: [patch 050/126] proc: uninline proc_create()
Date: Fri, 08 Sep 2017 16:13:38 -0700
Message-ID: <20170908231338.7NiisPmPr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757307AbdIHXNk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: uninline proc_create()

Save some code from ~320 invocations all clearing last argument.

	add/remove: 3/0 grow/shrink: 0/158 up/down: 45/-702 (-657)
	function                                     old     new   delta
	proc_create                                    -      17     +17
	__ksymtab_proc_create                          -      16     +16
	__kstrtab_proc_create                          -      12     +12
	yam_init_driver                              301     298      -3

		...

	cifs_proc_init                               249     228     -21
	via_fb_pci_probe                            2304    2280     -24

Link: http://lkml.kernel.org/r/20170819094702.GA27864@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    8 ++++++++
 include/linux/proc_fs.h |    8 +-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/proc/generic.c~proc-uninline-proc_create fs/proc/generic.c
--- a/fs/proc/generic.c~proc-uninline-proc_create
+++ a/fs/proc/generic.c
@@ -499,6 +499,14 @@ out:
 }
 EXPORT_SYMBOL(proc_create_data);
  
+struct proc_dir_entry *proc_create(const char *name, umode_t mode,
+				   struct proc_dir_entry *parent,
+				   const struct file_operations *proc_fops)
+{
+	return proc_create_data(name, mode, parent, proc_fops, NULL);
+}
+EXPORT_SYMBOL(proc_create);
+
 void proc_set_size(struct proc_dir_entry *de, loff_t size)
 {
 	de->size = size;
diff -puN include/linux/proc_fs.h~proc-uninline-proc_create include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-uninline-proc_create
+++ a/include/linux/proc_fs.h
@@ -28,13 +28,7 @@ extern struct proc_dir_entry *proc_creat
 					       const struct file_operations *,
 					       void *);
 
-static inline struct proc_dir_entry *proc_create(
-	const char *name, umode_t mode, struct proc_dir_entry *parent,
-	const struct file_operations *proc_fops)
-{
-	return proc_create_data(name, mode, parent, proc_fops, NULL);
-}

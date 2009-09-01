From: akpm@linux-foundation.org
Subject: + dac960-switch-to-seq_file.patch added to -mm tree
Date: Tue, 01 Sep 2009 16:27:39 -0700
Message-ID: <200909012327.n81NRd6v029001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbZIAX2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 19:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, jens.axboe@oracle.com, tj@kernel.org, yanghy@cn.fujitsu.com


The patch titled
     dac960: switch to seq_file
has been added to the -mm tree.  Its filename is
     dac960-switch-to-seq_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dac960: switch to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |  156 +++++++++++++++++----------------------
 1 file changed, 71 insertions(+), 85 deletions(-)

diff -puN drivers/block/DAC960.c~dac960-switch-to-seq_file drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~dac960-switch-to-seq_file
+++ a/drivers/block/DAC960.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
@@ -6422,16 +6423,10 @@ static bool DAC960_V2_ExecuteUserCommand
   return true;
 }
 
-
-/*
-  DAC960_ProcReadStatus implements reading /proc/rd/status.
-*/
-
-static int DAC960_ProcReadStatus(char *Page, char **Start, off_t Offset,
-				 int Count, int *EOF, void *Data)
+static int dac960_proc_show(struct seq_file *m, void *v)
 {
   unsigned char *StatusMessage = "OK\n";
-  int ControllerNumber, BytesAvailable;
+  int ControllerNumber;
   for (ControllerNumber = 0;
        ControllerNumber < DAC960_ControllerCount;
        ControllerNumber++)
@@ -6444,52 +6439,49 @@ static int DAC960_ProcReadStatus(char *P
 	  break;
 	}
     }
-  BytesAvailable = strlen(StatusMessage) - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &StatusMessage[Offset], Count);
-  return Count;
+  seq_puts(m, StatusMessage);
+  return 0;
 }
 
+static int dac960_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_proc_show, NULL);
+}
 
-/*
-  DAC960_ProcReadInitialStatus implements reading /proc/rd/cN/initial_status.
-*/
+static const struct file_operations dac960_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-static int DAC960_ProcReadInitialStatus(char *Page, char **Start, off_t Offset,
-					int Count, int *EOF, void *Data)
+static int dac960_initial_status_proc_show(struct seq_file *m, void *v)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
-  int BytesAvailable = Controller->InitialStatusLength - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &Controller->CombinedStatusBuffer[Offset], Count);
-  return Count;
+	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
+	seq_printf(m, "%.*s", Controller->InitialStatusLength, Controller->CombinedStatusBuffer);
+	return 0;
 }
 
+static int dac960_initial_status_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_initial_status_proc_show, PDE(inode)->data);
+}
 
-/*
-  DAC960_ProcReadCurrentStatus implements reading /proc/rd/cN/current_status.
-*/
+static const struct file_operations dac960_initial_status_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_initial_status_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-static int DAC960_ProcReadCurrentStatus(char *Page, char **Start, off_t Offset,
-					int Count, int *EOF, void *Data)
+static int dac960_current_status_proc_show(struct seq_file *m, void *v)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
+  DAC960_Controller_T *Controller = (DAC960_Controller_T *) m->private;
   unsigned char *StatusMessage =
     "No Rebuild or Consistency Check in Progress\n";
   int ProgressMessageLength = strlen(StatusMessage);
-  int BytesAvailable;
   if (jiffies != Controller->LastCurrentStatusTime)
     {
       Controller->CurrentStatusLength = 0;
@@ -6513,49 +6505,41 @@ static int DAC960_ProcReadCurrentStatus(
 	}
       Controller->LastCurrentStatusTime = jiffies;
     }
-  BytesAvailable = Controller->CurrentStatusLength - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &Controller->CurrentStatusBuffer[Offset], Count);
-  return Count;
+	seq_printf(m, "%.*s", Controller->CurrentStatusLength, Controller->CurrentStatusBuffer);
+	return 0;
 }
 
+static int dac960_current_status_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_current_status_proc_show, PDE(inode)->data);
+}
 
-/*
-  DAC960_ProcReadUserCommand implements reading /proc/rd/cN/user_command.
-*/
+static const struct file_operations dac960_current_status_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_current_status_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-static int DAC960_ProcReadUserCommand(char *Page, char **Start, off_t Offset,
-				      int Count, int *EOF, void *Data)
+static int dac960_user_command_proc_show(struct seq_file *m, void *v)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
-  int BytesAvailable = Controller->UserStatusLength - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &Controller->UserStatusBuffer[Offset], Count);
-  return Count;
-}
+	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
 
+	seq_printf(m, "%.*s", Controller->UserStatusLength, Controller->UserStatusBuffer);
+	return 0;
+}
 
-/*
-  DAC960_ProcWriteUserCommand implements writing /proc/rd/cN/user_command.
-*/
+static int dac960_user_command_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_user_command_proc_show, PDE(inode)->data);
+}
 
-static int DAC960_ProcWriteUserCommand(struct file *file,
+static ssize_t dac960_user_command_proc_write(struct file *file,
 				       const char __user *Buffer,
-				       unsigned long Count, void *Data)
+				       size_t Count, loff_t *pos)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
+  DAC960_Controller_T *Controller = (DAC960_Controller_T *) PDE(file->f_path.dentry->d_inode)->data;
   unsigned char CommandBuffer[80];
   int Length;
   if (Count > sizeof(CommandBuffer)-1) return -EINVAL;
@@ -6572,6 +6556,14 @@ static int DAC960_ProcWriteUserCommand(s
 	    ? Count : -EBUSY);
 }
 
+static const struct file_operations dac960_user_command_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_user_command_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= dac960_user_command_proc_write,
+};
 
 /*
   DAC960_CreateProcEntries creates the /proc/rd/... entries for the
@@ -6586,23 +6578,17 @@ static void DAC960_CreateProcEntries(DAC
 
 	if (DAC960_ProcDirectoryEntry == NULL) {
   		DAC960_ProcDirectoryEntry = proc_mkdir("rd", NULL);
-  		StatusProcEntry = create_proc_read_entry("status", 0,
+  		StatusProcEntry = proc_create("status", 0,
 					   DAC960_ProcDirectoryEntry,
-					   DAC960_ProcReadStatus, NULL);
+					   &dac960_proc_fops);
 	}
 
       sprintf(Controller->ControllerName, "c%d", Controller->ControllerNumber);
       ControllerProcEntry = proc_mkdir(Controller->ControllerName,
 				       DAC960_ProcDirectoryEntry);
-      create_proc_read_entry("initial_status", 0, ControllerProcEntry,
-			     DAC960_ProcReadInitialStatus, Controller);
-      create_proc_read_entry("current_status", 0, ControllerProcEntry,
-			     DAC960_ProcReadCurrentStatus, Controller);
-      UserCommandProcEntry =
-	create_proc_read_entry("user_command", S_IWUSR | S_IRUSR,
-			       ControllerProcEntry, DAC960_ProcReadUserCommand,
-			       Controller);
-      UserCommandProcEntry->write_proc = DAC960_ProcWriteUserCommand;
+      proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
+      proc_create_data("current_status", 0, ControllerProcEntry, &dac960_current_status_proc_fops, Controller);
+      UserCommandProcEntry = proc_create_data("user_command", S_IWUSR | S_IRUSR, ControllerProcEntry, &dac960_user_command_proc_fops, Controller);
       Controller->ControllerProcEntry = ControllerProcEntry;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch


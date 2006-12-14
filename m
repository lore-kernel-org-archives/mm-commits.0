From: akpm@osdl.org
Subject: - n_r3964-use-struct-pid-to-track-user-space-clients.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:13:09 -0800
Message-ID: <200612140613.kBE6D8Gf002095@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbWLNGNn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     n_r3964: Use struct pid to track user space clients
has been removed from the -mm tree.  Its filename was
     n_r3964-use-struct-pid-to-track-user-space-clients.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: n_r3964: Use struct pid to track user space clients
From: Eric W. Biederman <ebiederm@xmission.com>

Currently this driver tracks user space clients it should send signals to.  In
the presenct of file descriptor passing this is appears susceptible to
confusion from pid wrap around issues.

Replacing this with a struct pid prevents us from getting confused, and
prepares for a pid namespace implementation.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/n_r3964.c  |   37 +++++++++++++++++--------------------
 include/linux/n_r3964.h |    2 +-
 2 files changed, 18 insertions(+), 21 deletions(-)

diff -puN drivers/char/n_r3964.c~n_r3964-use-struct-pid-to-track-user-space-clients drivers/char/n_r3964.c
--- a/drivers/char/n_r3964.c~n_r3964-use-struct-pid-to-track-user-space-clients
+++ a/drivers/char/n_r3964.c
@@ -125,8 +125,8 @@ static void transmit_block(struct r3964_
 static void receive_char(struct r3964_info *pInfo, const unsigned char c);
 static void receive_error(struct r3964_info *pInfo, const char flag);
 static void on_timeout(unsigned long priv);
-static int enable_signals(struct r3964_info *pInfo, pid_t pid, int arg);
-static int read_telegram(struct r3964_info *pInfo, pid_t pid, unsigned char __user *buf);
+static int enable_signals(struct r3964_info *pInfo, struct pid *pid, int arg);
+static int read_telegram(struct r3964_info *pInfo, struct pid *pid, unsigned char __user *buf);
 static void add_msg(struct r3964_client_info *pClient, int msg_id, int arg,
              int error_code, struct r3964_block_header *pBlock);
 static struct r3964_message* remove_msg(struct r3964_info *pInfo, 
@@ -829,7 +829,7 @@ static void on_timeout(unsigned long pri
 }
 
 static struct r3964_client_info *findClient(
-  struct r3964_info *pInfo, pid_t pid)
+  struct r3964_info *pInfo, struct pid *pid)
 {
    struct r3964_client_info *pClient;
    
@@ -843,7 +843,7 @@ static struct r3964_client_info *findCli
    return NULL;
 }
 
-static int enable_signals(struct r3964_info *pInfo, pid_t pid, int arg)
+static int enable_signals(struct r3964_info *pInfo, struct pid *pid, int arg)
 {
    struct r3964_client_info *pClient;
    struct r3964_client_info **ppClient;
@@ -858,7 +858,7 @@ static int enable_signals(struct r3964_i
          
          if(pClient->pid == pid)
          {
-            TRACE_PS("removing client %d from client list", pid);
+            TRACE_PS("removing client %d from client list", pid_nr(pid));
             *ppClient = pClient->next;
             while(pClient->msg_count)
             {
@@ -869,6 +869,7 @@ static int enable_signals(struct r3964_i
                   TRACE_M("enable_signals - msg kfree %p",pMsg);
                }
             }
+	    put_pid(pClient->pid);
             kfree(pClient);
             TRACE_M("enable_signals - kfree %p",pClient);
             return 0;
@@ -892,10 +893,10 @@ static int enable_signals(struct r3964_i
          if(pClient==NULL)
             return -ENOMEM;
 
-         TRACE_PS("add client %d to client list", pid);
+         TRACE_PS("add client %d to client list", pid_nr(pid));
 	 spin_lock_init(&pClient->lock);
          pClient->sig_flags=arg;
-         pClient->pid = pid;
+         pClient->pid = get_pid(pid);
          pClient->next=pInfo->firstClient;
          pClient->first_msg = NULL;
          pClient->last_msg = NULL;
@@ -908,7 +909,7 @@ static int enable_signals(struct r3964_i
    return 0;
 }
 
-static int read_telegram(struct r3964_info *pInfo, pid_t pid, unsigned char __user *buf)
+static int read_telegram(struct r3964_info *pInfo, struct pid *pid, unsigned char __user *buf)
 {
     struct r3964_client_info *pClient;
     struct r3964_block_header *block;
@@ -1005,7 +1006,7 @@ queue_the_message:
    /* Send SIGIO signal to client process: */
    if(pClient->sig_flags & R3964_USE_SIGIO)
    {
-      kill_proc(pClient->pid, SIGIO, 1);
+      kill_pid(pClient->pid, SIGIO, 1);
    }
 }
 
@@ -1042,7 +1043,7 @@ static void remove_client_block(struct r
 {
     struct r3964_block_header *block;
 
-    TRACE_PS("remove_client_block PID %d", pClient->pid);
+    TRACE_PS("remove_client_block PID %d", pid_nr(pClient->pid));
 
     block=pClient->next_block_to_read;
     if(block)
@@ -1157,6 +1158,7 @@ static void r3964_close(struct tty_struc
              TRACE_M("r3964_close - msg kfree %p",pMsg);
           }
        }
+       put_pid(pClient->pid);
        kfree(pClient);
        TRACE_M("r3964_close - client kfree %p",pClient);
        pClient=pNext;
@@ -1193,12 +1195,11 @@ static ssize_t r3964_read(struct tty_str
    struct r3964_client_message theMsg;
    DECLARE_WAITQUEUE (wait, current);
    
-   int pid = current->pid;
    int count;
    
    TRACE_L("read()");
  
-   pClient=findClient(pInfo, pid);
+   pClient=findClient(pInfo, task_pid(current));
    if(pClient)
    {
       pMsg = remove_msg(pInfo, pClient);
@@ -1252,7 +1253,6 @@ static ssize_t r3964_write(struct tty_st
    struct r3964_block_header *pHeader;
    struct r3964_client_info *pClient;
    unsigned char *new_data;
-   int pid;
    
    TRACE_L("write request, %d characters", count);
 /* 
@@ -1295,9 +1295,7 @@ static ssize_t r3964_write(struct tty_st
    pHeader->locks = 0;
    pHeader->owner = NULL;
    
-   pid=current->pid;
-   
-   pClient=findClient(pInfo, pid);
+   pClient=findClient(pInfo, task_pid(current));
    if(pClient)
    {
       pHeader->owner = pClient;
@@ -1328,7 +1326,7 @@ static int r3964_ioctl(struct tty_struct
    switch(cmd)
    {
       case R3964_ENABLE_SIGNALS:
-         return enable_signals(pInfo, current->pid, arg);
+         return enable_signals(pInfo, task_pid(current), arg);
       case R3964_SETPRIORITY:
          if(arg<R3964_MASTER || arg>R3964_SLAVE)
             return -EINVAL;
@@ -1341,7 +1339,7 @@ static int r3964_ioctl(struct tty_struct
             pInfo->flags &= ~R3964_BCC;
          return 0;
       case R3964_READ_TELEGRAM:
-         return read_telegram(pInfo, current->pid, (unsigned char __user *)arg);
+         return read_telegram(pInfo, task_pid(current), (unsigned char __user *)arg);
       default:
          return -ENOIOCTLCMD;
    }
@@ -1357,7 +1355,6 @@ static unsigned int r3964_poll(struct tt
 		      struct poll_table_struct *wait)
 {
    struct r3964_info *pInfo=(struct r3964_info*)tty->disc_data;
-   int pid=current->pid;
    struct r3964_client_info *pClient;
    struct r3964_message *pMsg=NULL;
    unsigned long flags;
@@ -1365,7 +1362,7 @@ static unsigned int r3964_poll(struct tt
 
    TRACE_L("POLL");
 
-   pClient=findClient(pInfo,pid);
+   pClient=findClient(pInfo, task_pid(current));
    if(pClient)
      {
        poll_wait(file, &pInfo->read_wait, wait);
diff -puN include/linux/n_r3964.h~n_r3964-use-struct-pid-to-track-user-space-clients include/linux/n_r3964.h
--- a/include/linux/n_r3964.h~n_r3964-use-struct-pid-to-track-user-space-clients
+++ a/include/linux/n_r3964.h
@@ -116,7 +116,7 @@ struct r3964_message;
 
 struct r3964_client_info {
 	spinlock_t     lock;
-	pid_t          pid;
+	struct pid    *pid;
 	unsigned int   sig_flags;
 
 	struct r3964_client_info *next;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch


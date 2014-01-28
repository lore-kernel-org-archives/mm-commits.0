From: akpm@linux-foundation.org
Subject: [merged] ipc-remove-braces-for-single-statements.patch removed
 from -mm tree
Date: Tue, 28 Jan 2014 11:09:33 -0800
Message-ID: <52e8006d.Zhlwpoe7/1Jc5yB4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbaA1TJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: [merged] ipc-remove-braces-for-single-statements.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:33 -0800


The patch titled
     Subject: ipc: remove braces for single statements
has been removed from the -mm tree.  Its filename was
     ipc-remove-braces-for-single-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc: remove braces for single statements

Deal with checkpatch messages:
     WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c |   18 +++++++++---------
 ipc/mqueue.c |    6 +++---
 ipc/sem.c    |    8 +++-----
 ipc/util.c   |    3 +--
 4 files changed, 16 insertions(+), 19 deletions(-)

diff -puN ipc/compat.c~ipc-remove-braces-for-single-statements ipc/compat.c
--- a/ipc/compat.c~ipc-remove-braces-for-single-statements
+++ a/ipc/compat.c
@@ -288,11 +288,11 @@ static long do_compat_semctl(int first,
 		break;
 
 	case IPC_SET:
-		if (version == IPC_64) {
+		if (version == IPC_64)
 			err = get_compat_semid64_ds(&s64, compat_ptr(pad));
-		} else {
+		else
 			err = get_compat_semid_ds(&s64, compat_ptr(pad));
-		}
+
 		up64 = compat_alloc_user_space(sizeof(s64));
 		if (copy_to_user(up64, &s64, sizeof(s64)))
 			err = -EFAULT;
@@ -515,11 +515,11 @@ long compat_sys_msgctl(int first, int se
 		break;
 
 	case IPC_SET:
-		if (version == IPC_64) {
+		if (version == IPC_64)
 			err = get_compat_msqid64(&m64, uptr);
-		} else {
+		else
 			err = get_compat_msqid(&m64, uptr);
-		}
+
 		if (err)
 			break;
 		p = compat_alloc_user_space(sizeof(m64));
@@ -702,11 +702,11 @@ long compat_sys_shmctl(int first, int se
 
 
 	case IPC_SET:
-		if (version == IPC_64) {
+		if (version == IPC_64)
 			err = get_compat_shmid64_ds(&s64, uptr);
-		} else {
+		else
 			err = get_compat_shmid_ds(&s64, uptr);
-		}
+
 		if (err)
 			break;
 		p = compat_alloc_user_space(sizeof(s64));
diff -puN ipc/mqueue.c~ipc-remove-braces-for-single-statements ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-remove-braces-for-single-statements
+++ a/ipc/mqueue.c
@@ -1303,11 +1303,11 @@ retry:
 out_fput:
 	fdput(f);
 out:
-	if (sock) {
+	if (sock)
 		netlink_detachskb(sock, nc);
-	} else if (nc) {
+	else if (nc)
 		dev_kfree_skb(nc);
-	}
+
 	return ret;
 }
 
diff -puN ipc/sem.c~ipc-remove-braces-for-single-statements ipc/sem.c
--- a/ipc/sem.c~ipc-remove-braces-for-single-statements
+++ a/ipc/sem.c
@@ -492,9 +492,9 @@ static int newary(struct ipc_namespace *
 
 	size = sizeof(*sma) + nsems * sizeof(struct sem);
 	sma = ipc_rcu_alloc(size);
-	if (!sma) {
+	if (!sma)
 		return -ENOMEM;
-	}
+
 	memset(sma, 0, size);
 
 	sma->sem_perm.mode = (semflg & S_IRWXUGO);
@@ -1967,10 +1967,8 @@ sleep_again:
 	 * If queue.status != -EINTR we are woken up by another process.
 	 * Leave without unlink_queue(), but with sem_unlock().
 	 */
-
-	if (error != -EINTR) {
+	if (error != -EINTR)
 		goto out_unlock_free;
-	}
 
 	/*
 	 * If an interrupt occurred we have to clean up the queue
diff -puN ipc/util.c~ipc-remove-braces-for-single-statements ipc/util.c
--- a/ipc/util.c~ipc-remove-braces-for-single-statements
+++ a/ipc/util.c
@@ -183,9 +183,8 @@ void __init ipc_init_proc_interface(cons
 			       NULL,           /* parent dir */
 			       &sysvipc_proc_fops,
 			       iface);
-	if (!pde) {
+	if (!pde)
 		kfree(iface);
-	}
 }
 #endif
 
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + mcheck-mce_64-mce_read_sem-to-mutex.patch added to -mm tree
Date: Tue, 11 Dec 2007 22:02:08 -0800
Message-ID: <200712120602.lBC628Ag028726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbXLLGDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 01:03:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     mcheck mce_64: mce_read_sem to mutex
has been added to the -mm tree.  Its filename is
     mcheck-mce_64-mce_read_sem-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mcheck mce_64: mce_read_sem to mutex
From: Daniel Walker <dwalker@mvista.com>

Converted to a mutex, and changed the name to mce_read_mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce_64.c~mcheck-mce_64-mce_read_sem-to-mutex arch/x86/kernel/cpu/mcheck/mce_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c~mcheck-mce_64-mce_read_sem-to-mutex
+++ a/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -564,7 +564,7 @@ static ssize_t mce_read(struct file *fil
 			loff_t *off)
 {
 	unsigned long *cpu_tsc;
-	static DECLARE_MUTEX(mce_read_sem);
+	static DEFINE_MUTEX(mce_read_mutex);
 	unsigned next;
 	char __user *buf = ubuf;
 	int i, err;
@@ -573,12 +573,12 @@ static ssize_t mce_read(struct file *fil
 	if (!cpu_tsc)
 		return -ENOMEM;
 
-	down(&mce_read_sem);
+	mutex_lock(&mce_read_mutex);
 	next = rcu_dereference(mcelog.next);
 
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
-		up(&mce_read_sem);
+		mutex_unlock(&mce_read_mutex);
 		kfree(cpu_tsc);
 		return -EINVAL;
 	}
@@ -621,7 +621,7 @@ static ssize_t mce_read(struct file *fil
 			memset(&mcelog.entry[i], 0, sizeof(struct mce));
 		}
 	}
-	up(&mce_read_sem);
+	mutex_unlock(&mce_read_mutex);
 	kfree(cpu_tsc);
 	return err ? -EFAULT : buf - ubuf;
 }
_

Patches currently in -mm which might be from dwalker@mvista.com are

media-video-usbvision-add-mutex_unlock-to-error-paths.patch
media-video-usbvision-add-mutex_unlock-to-error-paths-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
mcheck-mce_64-mce_read_sem-to-mutex.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

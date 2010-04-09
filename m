From: akpm@linux-foundation.org
Subject: + frv-remove-struct-file-argument-from-sysctl-proc_handler.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:23 -0700
Message-ID: <201004092315.o39NFN1E017189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab0DIXPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, adobriyan@gmail.com, dhowells@redhat.com, fweisbec@gmail.com


The patch titled
     frv: remove "struct file *" argument from sysctl ->proc_handler
has been added to the -mm tree.  Its filename is
     frv-remove-struct-file-argument-from-sysctl-proc_handler.patch

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
Subject: frv: remove "struct file *" argument from sysctl ->proc_handler
From: Jan Blunck <jblunck@suse.de>

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/sysctl.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN arch/frv/kernel/sysctl.c~frv-remove-struct-file-argument-from-sysctl-proc_handler arch/frv/kernel/sysctl.c
--- a/arch/frv/kernel/sysctl.c~frv-remove-struct-file-argument-from-sysctl-proc_handler
+++ a/arch/frv/kernel/sysctl.c
@@ -46,8 +46,9 @@ static void frv_change_dcache_mode(unsig
 /*
  * handle requests to dynamically switch the write caching mode delivered by /proc
  */
-static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
-				 void __user *buffer, size_t *lenp, loff_t *ppos)
+static int procctl_frv_cachemode(ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos)
 {
 	unsigned long hsr0;
 	char buff[8];
@@ -84,7 +85,7 @@ static int procctl_frv_cachemode(ctl_tab
 	}
 
 	/* read the state */
-	if (filp->f_pos > 0) {
+	if (*ppos > 0) {
 		*lenp = 0;
 		return 0;
 	}
@@ -110,7 +111,7 @@ static int procctl_frv_cachemode(ctl_tab
 		return -EFAULT;
 
 	*lenp = len;
-	filp->f_pos = len;
+	*ppos = len;
 	return 0;
 
 } /* end procctl_frv_cachemode() */
@@ -120,8 +121,9 @@ static int procctl_frv_cachemode(ctl_tab
  * permit the mm_struct the nominated process is using have its MMU context ID pinned
  */
 #ifdef CONFIG_MMU
-static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
+static int procctl_frv_pin_cxnr(ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
 {
 	pid_t pid;
 	char buff[16], *p;
@@ -150,7 +152,7 @@ static int procctl_frv_pin_cxnr(ctl_tabl
 	}
 
 	/* read the currently pinned CXN */
-	if (filp->f_pos > 0) {
+	if (*ppos > 0) {
 		*lenp = 0;
 		return 0;
 	}
@@ -163,7 +165,7 @@ static int procctl_frv_pin_cxnr(ctl_tabl
 		return -EFAULT;
 
 	*lenp = len;
-	filp->f_pos = len;
+	*ppos = len;
 	return 0;
 
 } /* end procctl_frv_pin_cxnr() */
_

Patches currently in -mm which might be from jblunck@suse.de are

osst-update-ppos-instead-of-using-file-f_pos.patch
drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
zcrypt-use-nonseekable_open.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch


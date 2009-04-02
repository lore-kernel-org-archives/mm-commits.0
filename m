From: akpm@linux-foundation.org
Subject: [folded] kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:24:51 -0700
Message-ID: <200904022324.n32NOppr012321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758513AbZDBX3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, ebiederm@xmission.com, horms@verge.net.au, oomichi@mxs.nes.nec.co.jp, randy.dunlap@oracle.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch

This patch was dropped because it was folded into kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix
From: Neil Horman <nhorman@tuxdriver.com>

Add some comments and extra symbols on top of whats there for
kernel/printk.c to satisfy Erics requests, and support Ken'ichi's
enhanced version of the makedumpfile patch

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix kernel/printk.c
--- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix
+++ a/kernel/printk.c
@@ -137,10 +137,21 @@ static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
 #ifdef CONFIG_KEXEC
+/*
+ * This appends the listed symbols to /proc/vmcoreinfo
+ * /proc/vmcoreinfo is used by various utiilties, like
+ * crash and makedumpfile to obtain access to symbols that
+ * are otherwise very difficult to locate.  These symbols
+ * are specifically used so that utilities
+ * can access and extract the dmesg log from a vmcore file
+ * after a crash
+ */
 void log_buf_kexec_setup(void)
 {
 	VMCOREINFO_SYMBOL(log_buf);
 	VMCOREINFO_SYMBOL(log_end);
+	VMCOREINFO_SYMBOL(log_buf_len);
+	VMCOREINFO_SYMBOL(logged_chars)
 }
 #endif
 
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
linux-next.patch


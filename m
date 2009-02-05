From: akpm@linux-foundation.org
Subject: + kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:04:39 -0800
Message-ID: <200902052104.n15L4d15030775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbZBEVFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, ebiederm@xmission.com, horms@verge.net.au, oomichi@mxs.nes.nec.co.jp, randy.dunlap@oracle.com, vgoyal@redhat.com


The patch titled
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix
has been added to the -mm tree.  Its filename is
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch

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

linux-next.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch


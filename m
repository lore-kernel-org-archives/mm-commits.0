From: akpm@linux-foundation.org
Subject: [merged] printk-add-dummy-routine-for-when-config_printk=n.patch
 removed from -mm tree
Date: Tue, 27 Jan 2015 12:22:35 -0800
Message-ID: <54c7f38b.k+ogPSkivKdQtmiW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbbA0UWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 15:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, mpe@ellerman.id.au, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add dummy routine for when CONFIG_PRINTK=n
has been removed from the -mm tree.  Its filename was
     printk-add-dummy-routine-for-when-config_printk=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: printk: add dummy routine for when CONFIG_PRINTK=n

There are missing dummy routines for log_buf_addr_get() and log_buf_len_get()
for when CONFIG_PRINTK is not set causing build failures.

This patch adds these dummy routines at the appropriate location.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/printk.h~printk-add-dummy-routine-for-when-config_printk=n include/linux/printk.h
--- a/include/linux/printk.h~printk-add-dummy-routine-for-when-config_printk=n
+++ a/include/linux/printk.h
@@ -10,9 +10,6 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-extern char *log_buf_addr_get(void);
-extern u32 log_buf_len_get(void);
-
 static inline int printk_get_level(const char *buffer)
 {
 	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
@@ -163,6 +160,8 @@ extern int kptr_restrict;
 
 extern void wake_up_klogd(void);
 
+char *log_buf_addr_get(void);
+u32 log_buf_len_get(void);
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 void dump_stack_set_arch_desc(const char *fmt, ...);
@@ -198,6 +197,16 @@ static inline void wake_up_klogd(void)
 {
 }
 
+static inline char *log_buf_addr_get(void)
+{
+	return NULL;
+}
+
+static inline u32 log_buf_len_get(void)
+{
+	return 0;
+}
+
 static inline void log_buf_kexec_setup(void)
 {
 }
_

Patches currently in -mm which might be from bobby.prani@gmail.com are

origin.patch
linux-next.patch


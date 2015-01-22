From: akpm@linux-foundation.org
Subject: + printk-add-dummy-routine-for-when-config_printk=n.patch added
 to -mm tree
Date: Thu, 22 Jan 2015 11:51:25 -0800
Message-ID: <54c154bd.zfzO0shiMe7ftzLU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbbAVTvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 14:51:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, mpe@ellerman.id.au, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add dummy routine for when CONFIG_PRINTK=n
has been added to the -mm tree.  Its filename is
     printk-add-dummy-routine-for-when-config_printk=n.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-add-dummy-routine-for-when-config_printk%3Dn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-add-dummy-routine-for-when-config_printk%3Dn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

printk-add-dummy-routine-for-when-config_printk=n.patch
linux-next.patch


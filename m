From: akpm@linux-foundation.org
Subject: [merged] kernelh-add-printk_ratelimited-and-pr_level_rl.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:46 -0800
Message-ID: <200912152156.nBFLukov015667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761357AbZLOWQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, a.p.zijlstra@chello.nl, h-shimamoto@ct.jp.nec.com, mingo@elte.hu, nooiwa@miraclelinux.com, mm-commits@vger.kernel.org


The patch titled
     kernel.h: add printk_ratelimited and pr_<level>_rl
has been removed from the -mm tree.  Its filename was
     kernelh-add-printk_ratelimited-and-pr_level_rl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel.h: add printk_ratelimited and pr_<level>_rl
From: Joe Perches <joe@perches.com>

Add a printk_ratelimited statement expression macro that uses a per-call
ratelimit_state so that multiple subsystems output messages are not
suppressed by a global __ratelimit state.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: s/_rl/_ratelimited/g]
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   44 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN include/linux/kernel.h~kernelh-add-printk_ratelimited-and-pr_level_rl include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-printk_ratelimited-and-pr_level_rl
+++ a/include/linux/kernel.h
@@ -405,6 +405,50 @@ static inline char *pack_hex_byte(char *
 #endif
 
 /*
+ * ratelimited messages with local ratelimit_state,
+ * no local ratelimit_state used in the !PRINTK case
+ */
+#ifdef CONFIG_PRINTK
+#define printk_ratelimited(fmt, ...)  ({		\
+	static struct ratelimit_state _rs = {		\
+		.interval = DEFAULT_RATELIMIT_INTERVAL, \
+		.burst = DEFAULT_RATELIMIT_BURST,       \
+	};                                              \
+							\
+	if (!__ratelimit(&_rs))                         \
+		printk(fmt, ##__VA_ARGS__);		\
+})
+#else
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_ratelimited printk
+#endif
+
+#define pr_emerg_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* no pr_cont_ratelimited, don't do that... */
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_ratelimited(fmt, ...) \
+	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
+				     ##__VA_ARGS__); 0; })
+#endif
+
+/*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
  *
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch


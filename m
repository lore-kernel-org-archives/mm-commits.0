From: akpm@linux-foundation.org
Subject: - uml-sysrq-and-mconsole-fixes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:23 -0700
Message-ID: <200710162038.l9GKcN4C015443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936145AbXJPVHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: sysrq and mconsole fixes
has been removed from the -mm tree.  Its filename was
     uml-sysrq-and-mconsole-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: sysrq and mconsole fixes
From: Jeff Dike <jdike@addtoit.com>

Fix the passing of printk output back to the mconsole client.  The existing
code was somewhat confused, accumulating output in a buffer, but writing it
out entirely whenever a new chunk was added.  This is fixed.

The earlier include cleanups caused linux/sysrq.h to not be included - this is
fixed by adding the include back, under CONFIG_MAGIC_SYSRQ.

CONFIG_MAGIC_SYSRQ is also defaulted to on in defconfig.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/defconfig               |    2 +-
 arch/um/drivers/mconsole_kern.c |   23 +++++++++--------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff -puN arch/um/defconfig~uml-sysrq-and-mconsole-fixes arch/um/defconfig
--- a/arch/um/defconfig~uml-sysrq-and-mconsole-fixes
+++ a/arch/um/defconfig
@@ -80,7 +80,7 @@ CONFIG_BINFMT_MISC=m
 # CONFIG_HOSTFS is not set
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
-# CONFIG_MAGIC_SYSRQ is not set
+CONFIG_MAGIC_SYSRQ=y
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
 CONFIG_KERNEL_STACK_ORDER=0
diff -puN arch/um/drivers/mconsole_kern.c~uml-sysrq-and-mconsole-fixes arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-sysrq-and-mconsole-fixes
+++ a/arch/um/drivers/mconsole_kern.c
@@ -632,10 +632,9 @@ struct mconsole_output {
 static DEFINE_SPINLOCK(client_lock);
 static LIST_HEAD(clients);
 static char console_buf[MCONSOLE_MAX_DATA];
-static int console_index = 0;
 
 static void console_write(struct console *console, const char *string,
-			  unsigned len)
+			  unsigned int len)
 {
 	struct list_head *ele;
 	int n;
@@ -643,24 +642,18 @@ static void console_write(struct console
 	if (list_empty(&clients))
 		return;
 
-	while (1) {
-		n = min((size_t) len, ARRAY_SIZE(console_buf) - console_index);
-		strncpy(&console_buf[console_index], string, n);
-		console_index += n;
+	while (len > 0) {
+		n = min((size_t) len, ARRAY_SIZE(console_buf));
+		strncpy(console_buf, string, n);
 		string += n;
 		len -= n;
-		if (len == 0)
-			return;
 
 		list_for_each(ele, &clients) {
 			struct mconsole_output *entry;
 
 			entry = list_entry(ele, struct mconsole_output, list);
-			mconsole_reply_len(entry->req, console_buf,
-					   console_index, 0, 1);
+			mconsole_reply_len(entry->req, console_buf, n, 0, 1);
 		}
-
-		console_index = 0;
 	}
 }
 
@@ -690,8 +683,7 @@ static void with_console(struct mc_reque
 
 	(*proc)(arg);
 
-	mconsole_reply_len(req, console_buf, console_index, 0, 0);
-	console_index = 0;
+	mconsole_reply_len(req, "", 0, 0, 0);
 
 	spin_lock_irqsave(&client_lock, flags);
 	list_del(&entry.list);
@@ -699,6 +691,9 @@ static void with_console(struct mc_reque
 }
 
 #ifdef CONFIG_MAGIC_SYSRQ
+
+#include <linux/sysrq.h>
+
 static void sysrq_proc(void *arg)
 {
 	char *op = arg;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch

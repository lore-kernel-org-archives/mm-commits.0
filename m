From: akpm@linux-foundation.org
Subject: [merged] x86-olpc-add-debugfs-interface-for-ec-commands.patch removed from -mm tree
Date: Wed, 28 Mar 2012 12:43:05 -0700
Message-ID: <20120328194305.8EB3BA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48573 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab2C1TnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 15:43:07 -0400
Received: by vbnl22 with SMTP id l22so170144vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 12:43:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, pgf@laptop.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, olpc: add debugfs interface for EC commands
has been removed from the -mm tree.  Its filename was
     x86-olpc-add-debugfs-interface-for-ec-commands.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Daniel Drake <dsd@laptop.org>
Subject: x86, olpc: add debugfs interface for EC commands

Add a debugfs interface for sending commands to the OLPC Embedded
Controller (EC) and reading the responses.  The EC provides functionality
for machine identification, battery and AC control, wakeup control, etc.

Having a debugfs interface available is useful for EC development and
debugging.

Based on code by Paul Fox.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Paul Fox <pgf@laptop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/debugfs-olpc |   16 ++++
 arch/x86/platform/olpc/olpc.c          |   86 +++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/debugfs-olpc
--- /dev/null
+++ a/Documentation/ABI/testing/debugfs-olpc
@@ -0,0 +1,16 @@
+What:		/sys/kernel/debug/olpc-ec/generic
+Date:		Dec 2011
+KernelVersion:	3.3
+Contact:	devel@lists.laptop.org
+Description:
+
+A generic interface for executing OLPC Embedded Controller commands and
+reading their responses.
+
+To execute a command, write data with the format: CC:N A A A A
+CC is the (hex) command, N is the count of expected reply bytes, and A A A A
+are optional (hex) arguments.
+
+To read the response (if any), read from the generic node after executing
+a command. Hex reply bytes will be returned, *whether or not* they came from
+the immediately previous command.
diff -puN arch/x86/platform/olpc/olpc.c~x86-olpc-add-debugfs-interface-for-ec-commands arch/x86/platform/olpc/olpc.c
--- a/arch/x86/platform/olpc/olpc.c~x86-olpc-add-debugfs-interface-for-ec-commands
+++ a/arch/x86/platform/olpc/olpc.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/syscore_ops.h>
+#include <linux/debugfs.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -31,6 +32,13 @@ EXPORT_SYMBOL_GPL(olpc_platform_info);
 
 static DEFINE_SPINLOCK(ec_lock);
 
+/* debugfs interface to EC commands */
+#define EC_MAX_CMD_ARGS (5 + 1)	/* cmd byte + 5 args */
+#define EC_MAX_CMD_REPLY (8)
+static struct dentry *ec_debugfs_dir;
+static unsigned char ec_debugfs_resp[EC_MAX_CMD_REPLY];
+static unsigned int ec_debugfs_resp_bytes;
+
 /* EC event mask to be applied during suspend (defining wakeup sources). */
 static u16 ec_wakeup_mask;
 
@@ -269,6 +277,83 @@ int olpc_ec_sci_query(u16 *sci_value)
 }
 EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
 
+static ssize_t ec_gen_write(struct file *file, const char __user *buf,
+			    size_t size, loff_t *ppos)
+{
+	int i, m;
+	unsigned char ec_cmd[EC_MAX_CMD_ARGS];
+	unsigned int ec_cmd_int[EC_MAX_CMD_ARGS];
+	char cmdbuf[64];
+	int ec_cmd_bytes;
+
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+
+	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
+		   &ec_debugfs_resp_bytes,
+		   &ec_cmd_int[1], &ec_cmd_int[2], &ec_cmd_int[3],
+		   &ec_cmd_int[4], &ec_cmd_int[5]);
+	if (m < 2 || ec_debugfs_resp_bytes > EC_MAX_CMD_REPLY) {
+		printk(KERN_DEBUG "olpc-ec: bad ec cmd:  "
+		       "cmd:response-count [arg1 [arg2 ...]]\n");
+		return -EINVAL;
+	}
+
+	/* convert scanf'd ints to char */
+	ec_cmd_bytes = m - 2;
+	for (i = 0; i <= ec_cmd_bytes; i++)
+		ec_cmd[i] = ec_cmd_int[i];
+
+	printk(KERN_DEBUG "olpc-ec: debugfs cmd 0x%02x with %d args "
+	       "%02x %02x %02x %02x %02x, want %d returns\n",
+	       ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2], ec_cmd[3],
+	       ec_cmd[4], ec_cmd[5], ec_debugfs_resp_bytes);
+
+	olpc_ec_cmd((unsigned char) ec_cmd[0],
+		(ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
+		ec_cmd_bytes, ec_debugfs_resp, ec_debugfs_resp_bytes);
+
+	printk(KERN_DEBUG "olpc-ec: response "
+	       "%02x %02x %02x %02x %02x %02x %02x %02x (%d bytes expected)\n",
+	       ec_debugfs_resp[0], ec_debugfs_resp[1], ec_debugfs_resp[2],
+	       ec_debugfs_resp[3], ec_debugfs_resp[4], ec_debugfs_resp[5],
+	       ec_debugfs_resp[6], ec_debugfs_resp[7], ec_debugfs_resp_bytes);
+
+	return size;
+}
+
+static ssize_t ec_gen_read(struct file *file, char __user *buf,
+			   size_t size, loff_t *ppos)
+{
+	unsigned int i, r;
+	char *rp;
+	char respbuf[64];
+
+	rp = respbuf;
+	rp += sprintf(rp, "%02x", ec_debugfs_resp[0]);
+	for (i = 1; i < ec_debugfs_resp_bytes; i++)
+		rp += sprintf(rp, ", %02x", ec_debugfs_resp[i]);
+	rp += sprintf(rp, "\n");
+
+	r = rp - respbuf;
+
+	return simple_read_from_buffer(buf, size, ppos, respbuf, r);
+}
+
+static const struct file_operations ec_debugfs_genops = {
+	.write	 = ec_gen_write,
+	.read	 = ec_gen_read,
+};
+
+static void setup_debugfs(void)
+{
+	ec_debugfs_dir = debugfs_create_dir("olpc-ec", 0);
+	if (ec_debugfs_dir == ERR_PTR(-ENODEV))
+		return;
+
+	debugfs_create_file("generic", 0600, ec_debugfs_dir, NULL,
+			    &ec_debugfs_genops);
+}
+
 static int olpc_ec_suspend(void)
 {
 	return olpc_ec_mask_write(ec_wakeup_mask);
@@ -372,6 +457,7 @@ static int __init olpc_init(void)
 	}
 
 	register_syscore_ops(&olpc_syscore_ops);
+	setup_debugfs();
 
 	return 0;
 }
_

Patches currently in -mm which might be from dsd@laptop.org are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [merged] x86-olpc-add-debugfs-interface-for-ec-commands-v3.patch removed from -mm tree
Date: Wed, 28 Mar 2012 12:43:07 -0700
Message-ID: <20120328194307.72D79A00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33610 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab2C1TnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 15:43:09 -0400
Received: by wejx9 with SMTP id x9so70330wej.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 12:43:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, pgf@laptop.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-olpc-add-debugfs-interface-for-ec-commands v3
has been removed from the -mm tree.  Its filename was
     x86-olpc-add-debugfs-interface-for-ec-commands-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Daniel Drake <dsd@laptop.org>
Subject: x86-olpc-add-debugfs-interface-for-ec-commands v3

v3: incorporate feedback from Ingo Molnar (thanks!): whitespace/cast
fixes, fix potential overflow when nonsense resp_bytes is passed from
userspace, add mutex to protect data and to protect against concurrent
read/write, give node name 'cmd' which is better than 'generic'

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Paul Fox <pgf@laptop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/debugfs-olpc |    4 +-
 arch/x86/platform/olpc/olpc.c          |   35 +++++++++++++++--------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff -puN Documentation/ABI/testing/debugfs-olpc~x86-olpc-add-debugfs-interface-for-ec-commands-v3 Documentation/ABI/testing/debugfs-olpc
--- a/Documentation/ABI/testing/debugfs-olpc~x86-olpc-add-debugfs-interface-for-ec-commands-v3
+++ a/Documentation/ABI/testing/debugfs-olpc
@@ -1,6 +1,6 @@
-What:		/sys/kernel/debug/olpc-ec/generic
+What:		/sys/kernel/debug/olpc-ec/cmd
 Date:		Dec 2011
-KernelVersion:	3.3
+KernelVersion:	3.4
 Contact:	devel@lists.laptop.org
 Description:
 
diff -puN arch/x86/platform/olpc/olpc.c~x86-olpc-add-debugfs-interface-for-ec-commands-v3 arch/x86/platform/olpc/olpc.c
--- a/arch/x86/platform/olpc/olpc.c~x86-olpc-add-debugfs-interface-for-ec-commands-v3
+++ a/arch/x86/platform/olpc/olpc.c
@@ -21,6 +21,7 @@
 #include <linux/of.h>
 #include <linux/syscore_ops.h>
 #include <linux/debugfs.h>
+#include <linux/mutex.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -35,7 +36,9 @@ static DEFINE_SPINLOCK(ec_lock);
 /* debugfs interface to EC commands */
 #define EC_MAX_CMD_ARGS (5 + 1)	/* cmd byte + 5 args */
 #define EC_MAX_CMD_REPLY (8)
+
 static struct dentry *ec_debugfs_dir;
+static DEFINE_MUTEX(ec_debugfs_cmd_lock);
 static unsigned char ec_debugfs_resp[EC_MAX_CMD_REPLY];
 static unsigned int ec_debugfs_resp_bytes;
 
@@ -277,8 +280,8 @@ int olpc_ec_sci_query(u16 *sci_value)
 }
 EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
 
-static ssize_t ec_gen_write(struct file *file, const char __user *buf,
-			    size_t size, loff_t *ppos)
+static ssize_t ec_debugfs_cmd_write(struct file *file, const char __user *buf,
+				    size_t size, loff_t *ppos)
 {
 	int i, m;
 	unsigned char ec_cmd[EC_MAX_CMD_ARGS];
@@ -286,6 +289,8 @@ static ssize_t ec_gen_write(struct file 
 	char cmdbuf[64];
 	int ec_cmd_bytes;
 
+	mutex_lock(&ec_debugfs_cmd_lock);
+
 	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
 
 	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
@@ -293,9 +298,13 @@ static ssize_t ec_gen_write(struct file 
 		   &ec_cmd_int[1], &ec_cmd_int[2], &ec_cmd_int[3],
 		   &ec_cmd_int[4], &ec_cmd_int[5]);
 	if (m < 2 || ec_debugfs_resp_bytes > EC_MAX_CMD_REPLY) {
+		/* reset to prevent overflow on read */
+		ec_debugfs_resp_bytes = 0;
+
 		printk(KERN_DEBUG "olpc-ec: bad ec cmd:  "
 		       "cmd:response-count [arg1 [arg2 ...]]\n");
-		return -EINVAL;
+		size = -EINVAL;
+		goto out;
 	}
 
 	/* convert scanf'd ints to char */
@@ -308,9 +317,8 @@ static ssize_t ec_gen_write(struct file 
 	       ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2], ec_cmd[3],
 	       ec_cmd[4], ec_cmd[5], ec_debugfs_resp_bytes);
 
-	olpc_ec_cmd((unsigned char) ec_cmd[0],
-		(ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
-		ec_cmd_bytes, ec_debugfs_resp, ec_debugfs_resp_bytes);
+	olpc_ec_cmd(ec_cmd[0], (ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
+		    ec_cmd_bytes, ec_debugfs_resp, ec_debugfs_resp_bytes);
 
 	printk(KERN_DEBUG "olpc-ec: response "
 	       "%02x %02x %02x %02x %02x %02x %02x %02x (%d bytes expected)\n",
@@ -318,30 +326,33 @@ static ssize_t ec_gen_write(struct file 
 	       ec_debugfs_resp[3], ec_debugfs_resp[4], ec_debugfs_resp[5],
 	       ec_debugfs_resp[6], ec_debugfs_resp[7], ec_debugfs_resp_bytes);
 
+out:
+	mutex_unlock(&ec_debugfs_cmd_lock);
 	return size;
 }
 
-static ssize_t ec_gen_read(struct file *file, char __user *buf,
-			   size_t size, loff_t *ppos)
+static ssize_t ec_debugfs_cmd_read(struct file *file, char __user *buf,
+				   size_t size, loff_t *ppos)
 {
 	unsigned int i, r;
 	char *rp;
 	char respbuf[64];
 
+	mutex_lock(&ec_debugfs_cmd_lock);
 	rp = respbuf;
 	rp += sprintf(rp, "%02x", ec_debugfs_resp[0]);
 	for (i = 1; i < ec_debugfs_resp_bytes; i++)
 		rp += sprintf(rp, ", %02x", ec_debugfs_resp[i]);
+	mutex_unlock(&ec_debugfs_cmd_lock);
 	rp += sprintf(rp, "\n");
 
 	r = rp - respbuf;
-
 	return simple_read_from_buffer(buf, size, ppos, respbuf, r);
 }
 
 static const struct file_operations ec_debugfs_genops = {
-	.write	 = ec_gen_write,
-	.read	 = ec_gen_read,
+	.write	 = ec_debugfs_cmd_write,
+	.read	 = ec_debugfs_cmd_read,
 };
 
 static void setup_debugfs(void)
@@ -350,7 +361,7 @@ static void setup_debugfs(void)
 	if (ec_debugfs_dir == ERR_PTR(-ENODEV))
 		return;
 
-	debugfs_create_file("generic", 0600, ec_debugfs_dir, NULL,
+	debugfs_create_file("cmd", 0600, ec_debugfs_dir, NULL,
 			    &ec_debugfs_genops);
 }
 
_

Patches currently in -mm which might be from dsd@laptop.org are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [to-be-updated] ipmi-add-console-oops-catcher.patch removed from -mm tree
Date: Wed, 15 Apr 2009 12:53:24 -0700
Message-ID: <200904151953.n3FJrOhI029323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbZDOT4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 15:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: add console oops catcher
has been removed from the -mm tree.  Its filename was
     ipmi-add-console-oops-catcher.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: add console oops catcher
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Console messages on oops or panic are very important to investigate
problem.  Logging oops or panic messages to SEL is useful because SEL is a
non volatile memory.

Implement a console driver to log messages to SEL when oops_in_progress is
not zero.  The first message just after oops, panic or every 10 seconds
from last timestamp are logged as OEM event with timestamp, others are
logged as OEM event without timestamp.

Enable config IPMI_OOPS_CONSOLE and add console=ttyIPMI to kernel command
line to log panic or oops messages to IPMI SEL.

The number of entries for this output is limited by msg_limit paramter,
and the default value is 100.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/Kconfig             |    7 
 drivers/char/ipmi/Makefile            |    1 
 drivers/char/ipmi/ipmi_oops_console.c |  256 ++++++++++++++++++++++++
 3 files changed, 264 insertions(+)

diff -puN drivers/char/ipmi/Kconfig~ipmi-add-console-oops-catcher drivers/char/ipmi/Kconfig
--- a/drivers/char/ipmi/Kconfig~ipmi-add-console-oops-catcher
+++ a/drivers/char/ipmi/Kconfig
@@ -61,4 +61,11 @@ config IPMI_POWEROFF
          This enables a function to power off the system with IPMI if
 	 the IPMI management controller is capable of this.
 
+config IPMI_OOPS_CONSOLE
+	tristate 'IPMI oops console'
+	help
+	  This enables the IPMI oops console. IPMI oops console logs oops or
+	  panic console messsages to SEL. The number of entries for this usage
+	  is limited by msg_limit, default is 100 entries.
+
 endif # IPMI_HANDLER
diff -puN drivers/char/ipmi/Makefile~ipmi-add-console-oops-catcher drivers/char/ipmi/Makefile
--- a/drivers/char/ipmi/Makefile~ipmi-add-console-oops-catcher
+++ a/drivers/char/ipmi/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += i
 obj-$(CONFIG_IPMI_SI) += ipmi_si.o
 obj-$(CONFIG_IPMI_WATCHDOG) += ipmi_watchdog.o
 obj-$(CONFIG_IPMI_POWEROFF) += ipmi_poweroff.o
+obj-$(CONFIG_IPMI_OOPS_CONSOLE) += ipmi_oops_console.o
diff -puN /dev/null drivers/char/ipmi/ipmi_oops_console.c
--- /dev/null
+++ a/drivers/char/ipmi/ipmi_oops_console.c
@@ -0,0 +1,256 @@
+/*
+ * ipmi_oops_console.c
+ *
+ * IPMI Oops Console
+ * Logging console message to SEL on oops
+ *
+ * Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
+ *
+ * Copyright (C) 2008 NEC Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the
+ *  Free Software Foundation; either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *
+ *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
+ *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
+ *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
+ *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/ipmi.h>
+#include <linux/ipmi_smi.h>
+#include <linux/console.h>
+#include <linux/jiffies.h>
+#include <asm/atomic.h>
+
+#define PFX "IPMI oops_console: "
+
+static ipmi_user_t oops_user;
+static int oops_intf = -1;
+
+static atomic_t oops_counter;
+
+#define SEL_MSGSIZE_TIMESTAMP	(6U)
+#define SEL_MSGSIZE		(13U)
+#define DEF_LIMIT		(100)
+#define TIMESTAMP_INTERVAL	(10 * HZ)
+
+static char oops_msg[SEL_MSGSIZE_TIMESTAMP + SEL_MSGSIZE];
+static char *msg_ptr = oops_msg;
+static unsigned int msg_len;
+static unsigned long msg_jiffies;
+static int msg_count, msg_limit = DEF_LIMIT;
+
+module_param(msg_limit, int, 0644);
+MODULE_PARM_DESC(msg_limit, "Message limit. Default: 100 entries.");
+
+static void oops_smi_msg_done(struct ipmi_smi_msg *msg)
+{
+	atomic_dec(&oops_counter);
+}
+static struct ipmi_smi_msg oops_smi_msg = {
+	.done = oops_smi_msg_done
+};
+
+static void oops_recv_msg_done(struct ipmi_recv_msg *msg)
+{
+	atomic_dec(&oops_counter);
+}
+static struct ipmi_recv_msg oops_recv_msg = {
+	.done = oops_recv_msg_done
+};
+
+static void ipmi_oops_console_log_to_sel(int timestamp)
+{
+	struct ipmi_system_interface_addr si;
+	struct kernel_ipmi_msg msg;
+	unsigned int len;
+	unsigned char data[16];
+	unsigned char my_addr;
+
+	if (!oops_user || !msg_len || msg_count >= msg_limit)
+		return;
+
+	len = min((timestamp ? SEL_MSGSIZE_TIMESTAMP : SEL_MSGSIZE), msg_len);
+
+	si.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	si.channel = IPMI_BMC_CHANNEL;
+	si.lun = 0;
+
+	msg.netfn = IPMI_NETFN_STORAGE_REQUEST;
+	msg.cmd = IPMI_ADD_SEL_ENTRY_CMD;
+	msg.data = data;
+	msg.data_len = 16;
+
+	memset(data, 0, sizeof(data));
+	if (timestamp) {
+		len = min(SEL_MSGSIZE_TIMESTAMP, msg_len);
+		data[2] = 0xd1; /* OEM event with timestamp */
+		memcpy(data + 10, msg_ptr, len);
+		msg_jiffies = jiffies; /* save jiffies at timestamp */
+	} else {
+		len = min(SEL_MSGSIZE, msg_len);
+		data[2] = 0xf1; /* OEM event without timestamp */
+		memcpy(data + 3, msg_ptr, len);
+	}
+
+	preempt_disable();
+
+	if (ipmi_get_my_address(oops_user, 0, &my_addr))
+		goto out;
+
+	atomic_set(&oops_counter, 2);
+	if (ipmi_request_supply_msgs(oops_user, (struct ipmi_addr *)&si,
+				     0, &msg, NULL, &oops_smi_msg,
+				     &oops_recv_msg, 1) < 0)
+		goto out;
+	while (atomic_read(&oops_counter) > 0) {
+		ipmi_poll_interface(oops_user);
+		cpu_relax();
+	}
+
+	++msg_count;
+	msg_len -= len;
+	msg_ptr = msg_len ? &oops_msg[len] : oops_msg;
+out:
+	preempt_enable();
+}
+
+static void ipmi_oops_console_sync(void)
+{
+	if (!oops_user || !msg_len || msg_count >= msg_limit)
+		return;
+
+	if (jiffies > (msg_jiffies + TIMESTAMP_INTERVAL)) {
+		if (msg_ptr != oops_msg)
+			ipmi_oops_console_log_to_sel(0);
+		if (msg_len >= SEL_MSGSIZE_TIMESTAMP)
+			ipmi_oops_console_log_to_sel(1);
+		return;
+	}
+	if (msg_len >= SEL_MSGSIZE)
+		ipmi_oops_console_log_to_sel(0);
+}
+
+static void
+ipmi_oops_console_write(struct console *con, const char *s, unsigned int count)
+{
+	unsigned int size;
+
+	if (likely(!oops_in_progress)) {
+		ipmi_oops_console_log_to_sel(0);
+		return;
+	}
+
+	if (unlikely(!oops_user))
+		return;
+
+	while (msg_count < msg_limit && count > 0) {
+		size = min(SEL_MSGSIZE - msg_len, count);
+		memcpy(msg_ptr + msg_len, s, size);
+		msg_len += size;
+		s += size;
+		count -= size;
+		ipmi_oops_console_sync();
+	}
+}
+
+static struct console oops_console = {
+	.name	= "ttyIPMI",
+	.write	= ipmi_oops_console_write,
+	.unblank = ipmi_oops_console_sync,
+	.index	= -1,
+};
+
+static void ipmi_oops_recv(struct ipmi_recv_msg *msg, void *data)
+{
+	ipmi_free_recv_msg(msg);
+}
+
+static struct ipmi_user_hndl ipmi_handler = {
+	.ipmi_recv_hndl = ipmi_oops_recv,
+};
+
+static void ipmi_register_oops_console(int intf)
+{
+	int ret;
+
+	ret = ipmi_create_user(intf, &ipmi_handler, NULL, &oops_user);
+	if (ret < 0) {
+		printk(KERN_ERR PFX "unable to create user\n");
+		return;
+	}
+
+	oops_intf = intf;
+
+	register_console(&oops_console);
+
+	printk(KERN_INFO PFX "ready\n");
+}
+
+static void ipmi_unregister_oops_console(int intf)
+{
+	unregister_console(&oops_console);
+
+	ipmi_destroy_user(oops_user);
+	oops_user = NULL;
+	oops_intf = -1;
+}
+
+static void ipmi_new_smi(int if_num, struct device *dev)
+{
+	ipmi_register_oops_console(if_num);
+}
+
+static void ipmi_smi_gone(int if_num)
+{
+	ipmi_unregister_oops_console(if_num);
+}
+
+static struct ipmi_smi_watcher smi_watcher = {
+	.owner		= THIS_MODULE,
+	.new_smi	= ipmi_new_smi,
+	.smi_gone	= ipmi_smi_gone,
+};
+
+static int __init ipmi_oops_console_init(void)
+{
+	int ret;
+
+	ret = ipmi_smi_watcher_register(&smi_watcher);
+	if (ret) {
+		printk(KERN_ERR PFX "unable to register smi watcher\n");
+		return ret;
+	}
+
+	printk(KERN_INFO PFX "driver initialized\n");
+
+	return ret;
+}
+module_init(ipmi_oops_console_init);
+
+static void __exit ipmi_oops_console_exit(void)
+{
+	if (oops_intf >= 0)
+		ipmi_unregister_oops_console(oops_intf);
+}
+module_exit(ipmi_oops_console_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>");
+MODULE_DESCRIPTION("oops console handler based upon the IPMI interface.");
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

ipmi-add-console-oops-catcher.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch


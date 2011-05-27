From: akpm@linux-foundation.org
Subject: [merged] ipmi-convert-to-seq_file-interface.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:53 -0700
Message-ID: <201105271956.p4RJux8t017619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab1E0UMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: convert to seq_file interface
has been removed from the -mm tree.  Its filename was
     ipmi-convert-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: convert to seq_file interface
From: Alexey Dobriyan <adobriyan@gmail.com>

The ->read_proc interface is going away, convert to seq_file.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc:Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |  138 +++++++++++++++-----------
 drivers/char/ipmi/ipmi_si_intf.c    |   88 +++++++++++-----
 include/linux/ipmi_smi.h            |    2 
 3 files changed, 142 insertions(+), 86 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-to-seq_file-interface drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-to-seq_file-interface
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -36,6 +36,7 @@
 #include <asm/system.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -1896,102 +1897,128 @@ int ipmi_request_supply_msgs(ipmi_user_t
 EXPORT_SYMBOL(ipmi_request_supply_msgs);
 
 #ifdef CONFIG_PROC_FS
-static int ipmb_file_read_proc(char *page, char **start, off_t off,
-			       int count, int *eof, void *data)
+static int smi_ipmb_proc_show(struct seq_file *m, void *v)
 {
-	char       *out = (char *) page;
-	ipmi_smi_t intf = data;
+	ipmi_smi_t intf = m->private;
 	int        i;
-	int        rv = 0;
 
-	for (i = 0; i < IPMI_MAX_CHANNELS; i++)
-		rv += sprintf(out+rv, "%x ", intf->channels[i].address);
-	out[rv-1] = '\n'; /* Replace the final space with a newline */
-	out[rv] = '\0';
-	rv++;
-	return rv;
+	seq_printf(m, "%x", intf->channels[0].address);
+	for (i = 1; i < IPMI_MAX_CHANNELS; i++)
+		seq_printf(m, " %x", intf->channels[i].address);
+	return seq_putc(m, '\n');
 }
 
-static int version_file_read_proc(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int smi_ipmb_proc_open(struct inode *inode, struct file *file)
 {
-	char       *out = (char *) page;
-	ipmi_smi_t intf = data;
+	return single_open(file, smi_ipmb_proc_show, PDE(inode)->data);
+}
 
-	return sprintf(out, "%u.%u\n",
+static const struct file_operations smi_ipmb_proc_ops = {
+	.open		= smi_ipmb_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int smi_version_proc_show(struct seq_file *m, void *v)
+{
+	ipmi_smi_t intf = m->private;
+
+	return seq_printf(m, "%u.%u\n",
 		       ipmi_version_major(&intf->bmc->id),
 		       ipmi_version_minor(&intf->bmc->id));
 }
 
-static int stat_file_read_proc(char *page, char **start, off_t off,
-			       int count, int *eof, void *data)
+static int smi_version_proc_open(struct inode *inode, struct file *file)
 {
-	char       *out = (char *) page;
-	ipmi_smi_t intf = data;
+	return single_open(file, smi_version_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations smi_version_proc_ops = {
+	.open		= smi_version_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-	out += sprintf(out, "sent_invalid_commands:       %u\n",
+static int smi_stats_proc_show(struct seq_file *m, void *v)
+{
+	ipmi_smi_t intf = m->private;
+
+	seq_printf(m, "sent_invalid_commands:       %u\n",
 		       ipmi_get_stat(intf, sent_invalid_commands));
-	out += sprintf(out, "sent_local_commands:         %u\n",
+	seq_printf(m, "sent_local_commands:         %u\n",
 		       ipmi_get_stat(intf, sent_local_commands));
-	out += sprintf(out, "handled_local_responses:     %u\n",
+	seq_printf(m, "handled_local_responses:     %u\n",
 		       ipmi_get_stat(intf, handled_local_responses));
-	out += sprintf(out, "unhandled_local_responses:   %u\n",
+	seq_printf(m, "unhandled_local_responses:   %u\n",
 		       ipmi_get_stat(intf, unhandled_local_responses));
-	out += sprintf(out, "sent_ipmb_commands:          %u\n",
+	seq_printf(m, "sent_ipmb_commands:          %u\n",
 		       ipmi_get_stat(intf, sent_ipmb_commands));
-	out += sprintf(out, "sent_ipmb_command_errs:      %u\n",
+	seq_printf(m, "sent_ipmb_command_errs:      %u\n",
 		       ipmi_get_stat(intf, sent_ipmb_command_errs));
-	out += sprintf(out, "retransmitted_ipmb_commands: %u\n",
+	seq_printf(m, "retransmitted_ipmb_commands: %u\n",
 		       ipmi_get_stat(intf, retransmitted_ipmb_commands));
-	out += sprintf(out, "timed_out_ipmb_commands:     %u\n",
+	seq_printf(m, "timed_out_ipmb_commands:     %u\n",
 		       ipmi_get_stat(intf, timed_out_ipmb_commands));
-	out += sprintf(out, "timed_out_ipmb_broadcasts:   %u\n",
+	seq_printf(m, "timed_out_ipmb_broadcasts:   %u\n",
 		       ipmi_get_stat(intf, timed_out_ipmb_broadcasts));
-	out += sprintf(out, "sent_ipmb_responses:         %u\n",
+	seq_printf(m, "sent_ipmb_responses:         %u\n",
 		       ipmi_get_stat(intf, sent_ipmb_responses));
-	out += sprintf(out, "handled_ipmb_responses:      %u\n",
+	seq_printf(m, "handled_ipmb_responses:      %u\n",
 		       ipmi_get_stat(intf, handled_ipmb_responses));
-	out += sprintf(out, "invalid_ipmb_responses:      %u\n",
+	seq_printf(m, "invalid_ipmb_responses:      %u\n",
 		       ipmi_get_stat(intf, invalid_ipmb_responses));
-	out += sprintf(out, "unhandled_ipmb_responses:    %u\n",
+	seq_printf(m, "unhandled_ipmb_responses:    %u\n",
 		       ipmi_get_stat(intf, unhandled_ipmb_responses));
-	out += sprintf(out, "sent_lan_commands:           %u\n",
+	seq_printf(m, "sent_lan_commands:           %u\n",
 		       ipmi_get_stat(intf, sent_lan_commands));
-	out += sprintf(out, "sent_lan_command_errs:       %u\n",
+	seq_printf(m, "sent_lan_command_errs:       %u\n",
 		       ipmi_get_stat(intf, sent_lan_command_errs));
-	out += sprintf(out, "retransmitted_lan_commands:  %u\n",
+	seq_printf(m, "retransmitted_lan_commands:  %u\n",
 		       ipmi_get_stat(intf, retransmitted_lan_commands));
-	out += sprintf(out, "timed_out_lan_commands:      %u\n",
+	seq_printf(m, "timed_out_lan_commands:      %u\n",
 		       ipmi_get_stat(intf, timed_out_lan_commands));
-	out += sprintf(out, "sent_lan_responses:          %u\n",
+	seq_printf(m, "sent_lan_responses:          %u\n",
 		       ipmi_get_stat(intf, sent_lan_responses));
-	out += sprintf(out, "handled_lan_responses:       %u\n",
+	seq_printf(m, "handled_lan_responses:       %u\n",
 		       ipmi_get_stat(intf, handled_lan_responses));
-	out += sprintf(out, "invalid_lan_responses:       %u\n",
+	seq_printf(m, "invalid_lan_responses:       %u\n",
 		       ipmi_get_stat(intf, invalid_lan_responses));
-	out += sprintf(out, "unhandled_lan_responses:     %u\n",
+	seq_printf(m, "unhandled_lan_responses:     %u\n",
 		       ipmi_get_stat(intf, unhandled_lan_responses));
-	out += sprintf(out, "handled_commands:            %u\n",
+	seq_printf(m, "handled_commands:            %u\n",
 		       ipmi_get_stat(intf, handled_commands));
-	out += sprintf(out, "invalid_commands:            %u\n",
+	seq_printf(m, "invalid_commands:            %u\n",
 		       ipmi_get_stat(intf, invalid_commands));
-	out += sprintf(out, "unhandled_commands:          %u\n",
+	seq_printf(m, "unhandled_commands:          %u\n",
 		       ipmi_get_stat(intf, unhandled_commands));
-	out += sprintf(out, "invalid_events:              %u\n",
+	seq_printf(m, "invalid_events:              %u\n",
 		       ipmi_get_stat(intf, invalid_events));
-	out += sprintf(out, "events:                      %u\n",
+	seq_printf(m, "events:                      %u\n",
 		       ipmi_get_stat(intf, events));
-	out += sprintf(out, "failed rexmit LAN msgs:      %u\n",
+	seq_printf(m, "failed rexmit LAN msgs:      %u\n",
 		       ipmi_get_stat(intf, dropped_rexmit_lan_commands));
-	out += sprintf(out, "failed rexmit IPMB msgs:     %u\n",
+	seq_printf(m, "failed rexmit IPMB msgs:     %u\n",
 		       ipmi_get_stat(intf, dropped_rexmit_ipmb_commands));
+	return 0;
+}
 
-	return (out - ((char *) page));
+static int smi_stats_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, smi_stats_proc_show, PDE(inode)->data);
 }
+
+static const struct file_operations smi_stats_proc_ops = {
+	.open		= smi_stats_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    read_proc_t *read_proc,
+			    const struct file_operations *proc_ops,
 			    void *data)
 {
 	int                    rv = 0;
@@ -2010,15 +2037,12 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 	}
 	strcpy(entry->name, name);
 
-	file = create_proc_entry(name, 0, smi->proc_dir);
+	file = proc_create_data(name, 0, smi->proc_dir, proc_ops, data);
 	if (!file) {
 		kfree(entry->name);
 		kfree(entry);
 		rv = -ENOMEM;
 	} else {
-		file->data = data;
-		file->read_proc = read_proc;
-
 		mutex_lock(&smi->proc_entry_lock);
 		/* Stick it on the list. */
 		entry->next = smi->proc_entries;
@@ -2043,17 +2067,17 @@ static int add_proc_entries(ipmi_smi_t s
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "stats",
-					     stat_file_read_proc,
+					     &smi_stats_proc_ops,
 					     smi);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "ipmb",
-					     ipmb_file_read_proc,
+					     &smi_ipmb_proc_ops,
 					     smi);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "version",
-					     version_file_read_proc,
+					     &smi_version_proc_ops,
 					     smi);
 #endif /* CONFIG_PROC_FS */
 
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-convert-to-seq_file-interface drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-convert-to-seq_file-interface
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -43,6 +43,7 @@
 #include <linux/moduleparam.h>
 #include <asm/system.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/timer.h>
 #include <linux/errno.h>
 #include <linux/spinlock.h>
@@ -2805,54 +2806,73 @@ static int try_enable_event_buffer(struc
 	return rv;
 }
 
-static int type_file_read_proc(char *page, char **start, off_t off,
-			       int count, int *eof, void *data)
+static int smi_type_proc_show(struct seq_file *m, void *v)
 {
-	struct smi_info *smi = data;
+	struct smi_info *smi = m->private;
 
-	return sprintf(page, "%s\n", si_to_str[smi->si_type]);
+	return seq_printf(m, "%s\n", si_to_str[smi->si_type]);
 }
 
-static int stat_file_read_proc(char *page, char **start, off_t off,
-			       int count, int *eof, void *data)
+static int smi_type_proc_open(struct inode *inode, struct file *file)
 {
-	char            *out = (char *) page;
-	struct smi_info *smi = data;
+	return single_open(file, smi_type_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations smi_type_proc_ops = {
+	.open		= smi_type_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int smi_si_stats_proc_show(struct seq_file *m, void *v)
+{
+	struct smi_info *smi = m->private;
 
-	out += sprintf(out, "interrupts_enabled:    %d\n",
+	seq_printf(m, "interrupts_enabled:    %d\n",
 		       smi->irq && !smi->interrupt_disabled);
-	out += sprintf(out, "short_timeouts:        %u\n",
+	seq_printf(m, "short_timeouts:        %u\n",
 		       smi_get_stat(smi, short_timeouts));
-	out += sprintf(out, "long_timeouts:         %u\n",
+	seq_printf(m, "long_timeouts:         %u\n",
 		       smi_get_stat(smi, long_timeouts));
-	out += sprintf(out, "idles:                 %u\n",
+	seq_printf(m, "idles:                 %u\n",
 		       smi_get_stat(smi, idles));
-	out += sprintf(out, "interrupts:            %u\n",
+	seq_printf(m, "interrupts:            %u\n",
 		       smi_get_stat(smi, interrupts));
-	out += sprintf(out, "attentions:            %u\n",
+	seq_printf(m, "attentions:            %u\n",
 		       smi_get_stat(smi, attentions));
-	out += sprintf(out, "flag_fetches:          %u\n",
+	seq_printf(m, "flag_fetches:          %u\n",
 		       smi_get_stat(smi, flag_fetches));
-	out += sprintf(out, "hosed_count:           %u\n",
+	seq_printf(m, "hosed_count:           %u\n",
 		       smi_get_stat(smi, hosed_count));
-	out += sprintf(out, "complete_transactions: %u\n",
+	seq_printf(m, "complete_transactions: %u\n",
 		       smi_get_stat(smi, complete_transactions));
-	out += sprintf(out, "events:                %u\n",
+	seq_printf(m, "events:                %u\n",
 		       smi_get_stat(smi, events));
-	out += sprintf(out, "watchdog_pretimeouts:  %u\n",
+	seq_printf(m, "watchdog_pretimeouts:  %u\n",
 		       smi_get_stat(smi, watchdog_pretimeouts));
-	out += sprintf(out, "incoming_messages:     %u\n",
+	seq_printf(m, "incoming_messages:     %u\n",
 		       smi_get_stat(smi, incoming_messages));
+	return 0;
+}
 
-	return out - page;
+static int smi_si_stats_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, smi_si_stats_proc_show, PDE(inode)->data);
 }
 
-static int param_read_proc(char *page, char **start, off_t off,
-			   int count, int *eof, void *data)
+static const struct file_operations smi_si_stats_proc_ops = {
+	.open		= smi_si_stats_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int smi_params_proc_show(struct seq_file *m, void *v)
 {
-	struct smi_info *smi = data;
+	struct smi_info *smi = m->private;
 
-	return sprintf(page,
+	return seq_printf(m,
 		       "%s,%s,0x%lx,rsp=%d,rsi=%d,rsh=%d,irq=%d,ipmb=%d\n",
 		       si_to_str[smi->si_type],
 		       addr_space_to_str[smi->io.addr_type],
@@ -2864,6 +2884,18 @@ static int param_read_proc(char *page, c
 		       smi->slave_addr);
 }
 
+static int smi_params_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, smi_params_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations smi_params_proc_ops = {
+	.open		= smi_params_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * oem_data_avail_to_receive_msg_avail
  * @info - smi_info structure with msg_flags set
@@ -3257,7 +3289,7 @@ static int try_smi_init(struct smi_info 
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "type",
-				     type_file_read_proc,
+				     &smi_type_proc_ops,
 				     new_smi);
 	if (rv) {
 		dev_err(new_smi->dev, "Unable to create proc entry: %d\n", rv);
@@ -3265,7 +3297,7 @@ static int try_smi_init(struct smi_info 
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "si_stats",
-				     stat_file_read_proc,
+				     &smi_si_stats_proc_ops,
 				     new_smi);
 	if (rv) {
 		dev_err(new_smi->dev, "Unable to create proc entry: %d\n", rv);
@@ -3273,7 +3305,7 @@ static int try_smi_init(struct smi_info 
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "params",
-				     param_read_proc,
+				     &smi_params_proc_ops,
 				     new_smi);
 	if (rv) {
 		dev_err(new_smi->dev, "Unable to create proc entry: %d\n", rv);
diff -puN include/linux/ipmi_smi.h~ipmi-convert-to-seq_file-interface include/linux/ipmi_smi.h
--- a/include/linux/ipmi_smi.h~ipmi-convert-to-seq_file-interface
+++ a/include/linux/ipmi_smi.h
@@ -236,7 +236,7 @@ static inline void ipmi_free_smi_msg(str
    directory for this interface.  Note that the entry will
    automatically be dstroyed when the interface is destroyed. */
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    read_proc_t *read_proc,
+			    const struct file_operations *proc_ops,
 			    void *data);
 
 #endif /* __LINUX_IPMI_SMI_H */
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-add-proc_dointvec_bool-handler.patch


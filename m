From: akpm@linux-foundation.org
Subject: + uml-style-fixes-pass-2.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:20 -0700
Message-ID: <200708162114.l7GLEKZu007086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbXHPVOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: style fixes pass 2
has been added to the -mm tree.  Its filename is
     uml-style-fixes-pass-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: style fixes pass 2
From: Jeff Dike <jdike@addtoit.com>

Formatting changes in the files which have been changed in the course
of removing CHOOSE_MODE.  These include:
	copyright updates
	header file trimming
	style fixes
	adding severity to printks

These changes should be entirely non-functional.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |  250 +++++++++++++++---------------
 arch/um/include/um_mmu.h        |    2 
 arch/um/include/um_uaccess.h    |   15 -
 arch/um/kernel/ksyms.c          |   17 --
 include/asm-um/a.out.h          |    5 
 include/asm-um/tlbflush.h       |    8 
 6 files changed, 145 insertions(+), 152 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-style-fixes-pass-2 arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-style-fixes-pass-2
+++ a/arch/um/drivers/mconsole_kern.c
@@ -1,43 +1,35 @@
 /*
  * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
- * Copyright (C) 2001 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/slab.h"
-#include "linux/init.h"
-#include "linux/notifier.h"
-#include "linux/reboot.h"
-#include "linux/utsname.h"
+#include "linux/console.h"
 #include "linux/ctype.h"
 #include "linux/interrupt.h"
-#include "linux/sysrq.h"
-#include "linux/workqueue.h"
+#include "linux/list.h"
+#include "linux/mm.h"
 #include "linux/module.h"
-#include "linux/file.h"
-#include "linux/fs.h"
-#include "linux/namei.h"
+#include "linux/notifier.h"
+#include "linux/reboot.h"
 #include "linux/proc_fs.h"
+#include "linux/slab.h"
 #include "linux/syscalls.h"
-#include "linux/list.h"
-#include "linux/mm.h"
-#include "linux/console.h"
-#include "asm/irq.h"
+#include "linux/utsname.h"
+#include "linux/workqueue.h"
 #include "asm/uaccess.h"
+#include "init.h"
+#include "irq_kern.h"
+#include "irq_user.h"
 #include "kern_util.h"
-#include "kern.h"
 #include "mconsole.h"
 #include "mconsole_kern.h"
-#include "irq_user.h"
-#include "init.h"
 #include "os.h"
-#include "irq_kern.h"
 
 static int do_unlink_socket(struct notifier_block *notifier,
 			    unsigned long what, void *data)
 {
-	return(mconsole_unlink_socket());
+	return mconsole_unlink_socket();
 }
 
 
@@ -58,10 +50,9 @@ static void mc_work_proc(struct work_str
 	struct mconsole_entry *req;
 	unsigned long flags;
 
-	while(!list_empty(&mc_requests)){
+	while (!list_empty(&mc_requests)) {
 		local_irq_save(flags);
-		req = list_entry(mc_requests.next, struct mconsole_entry,
-				 list);
+		req = list_entry(mc_requests.next, struct mconsole_entry, list);
 		list_del(&req->list);
 		local_irq_restore(flags);
 		req->request.cmd->handler(&req->request);
@@ -79,12 +70,12 @@ static irqreturn_t mconsole_interrupt(in
 	static struct mc_request req;	/* that's OK */
 
 	fd = (long) dev_id;
-	while (mconsole_get_request(fd, &req)){
-		if(req.cmd->context == MCONSOLE_INTR)
+	while (mconsole_get_request(fd, &req)) {
+		if (req.cmd->context == MCONSOLE_INTR)
 			(*req.cmd->handler)(&req);
 		else {
 			new = kmalloc(sizeof(*new), GFP_NOWAIT);
-			if(new == NULL)
+			if (new == NULL)
 				mconsole_reply(&req, "Out of memory", 1, 0);
 			else {
 				new->request = req;
@@ -93,10 +84,10 @@ static irqreturn_t mconsole_interrupt(in
 			}
 		}
 	}
-	if(!list_empty(&mc_requests))
+	if (!list_empty(&mc_requests))
 		schedule_work(&mconsole_work);
 	reactivate_fd(fd, MCONSOLE_IRQ);
-	return(IRQ_HANDLED);
+	return IRQ_HANDLED;
 }
 
 void mconsole_version(struct mc_request *req)
@@ -104,8 +95,8 @@ void mconsole_version(struct mc_request 
 	char version[256];
 
 	sprintf(version, "%s %s %s %s %s", utsname()->sysname,
-		utsname()->nodename, utsname()->release,
-		utsname()->version, utsname()->machine);
+		utsname()->nodename, utsname()->release, utsname()->version,
+		utsname()->machine);
 	mconsole_reply(req, version, 0, 0);
 }
 
@@ -117,7 +108,7 @@ void mconsole_log(struct mc_request *req
 	ptr += strlen("log ");
 
 	len = req->len - (ptr - req->request.data);
-	printk("%.*s", len, ptr);
+	printk(KERN_WARNING "%.*s", len, ptr);
 	mconsole_reply(req, "", 0, 0);
 }
 
@@ -136,17 +127,17 @@ void mconsole_proc(struct mc_request *re
 	char *ptr = req->request.data, *buf;
 
 	ptr += strlen("proc");
-	while(isspace(*ptr)) ptr++;
+	while (isspace(*ptr)) ptr++;
 
 	proc = get_fs_type("proc");
-	if(proc == NULL){
+	if (proc == NULL) {
 		mconsole_reply(req, "procfs not registered", 1, 0);
 		goto out;
 	}
 
 	super = (*proc->get_sb)(proc, 0, NULL, NULL);
 	put_filesystem(proc);
-	if(super == NULL){
+	if (super == NULL) {
 		mconsole_reply(req, "Failed to get procfs superblock", 1, 0);
 		goto out;
 	}
@@ -161,29 +152,29 @@ void mconsole_proc(struct mc_request *re
 	 * if commenting out these two calls + the below read cycle. To
 	 * make UML crash again, it was enough to readd either one.*/
 	err = link_path_walk(ptr, &nd);
-	if(err){
+	if (err) {
 		mconsole_reply(req, "Failed to look up file", 1, 0);
 		goto out_kill;
 	}
 
 	file = dentry_open(nd.dentry, nd.mnt, O_RDONLY);
-	if(IS_ERR(file)){
+	if (IS_ERR(file)) {
 		mconsole_reply(req, "Failed to open file", 1, 0);
 		goto out_kill;
 	}
 	/*END*/
 
 	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if(buf == NULL){
+	if (buf == NULL) {
 		mconsole_reply(req, "Failed to allocate buffer", 1, 0);
 		goto out_fput;
 	}
 
-	if((file->f_op != NULL) && (file->f_op->read != NULL)){
+	if ((file->f_op != NULL) && (file->f_op->read != NULL)) {
 		do {
 			n = (*file->f_op->read)(file, buf, PAGE_SIZE - 1,
 						&file->f_pos);
-			if(n >= 0){
+			if (n >= 0) {
 				buf[n] = '\0';
 				mconsole_reply(req, buf, 0, (n > 0));
 			}
@@ -192,7 +183,7 @@ void mconsole_proc(struct mc_request *re
 					       1, 0);
 				goto out_free;
 			}
-		} while(n > 0);
+		} while (n > 0);
 	}
 	else mconsole_reply(req, "", 0, 0);
 
@@ -216,18 +207,19 @@ void mconsole_proc(struct mc_request *re
 	char *ptr = req->request.data;
 
 	ptr += strlen("proc");
-	while(isspace(*ptr)) ptr++;
+	while (isspace(*ptr))
+		ptr++;
 	snprintf(path, sizeof(path), "/proc/%s", ptr);
 
 	fd = sys_open(path, 0, 0);
 	if (fd < 0) {
 		mconsole_reply(req, "Failed to open file", 1, 0);
-		printk("open %s: %d\n",path,fd);
+		printk(KERN_ERR "open %s: %d\n",path,fd);
 		goto out;
 	}
 
 	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if(buf == NULL){
+	if (buf == NULL) {
 		mconsole_reply(req, "Failed to allocate buffer", 1, 0);
 		goto out_close;
 	}
@@ -238,7 +230,7 @@ void mconsole_proc(struct mc_request *re
 			mconsole_reply(req, "Read of file failed", 1, 0);
 			goto out_free;
 		}
-		/*Begin the file content on his own line.*/
+		/* Begin the file content on his own line. */
 		if (first_chunk) {
 			mconsole_reply(req, "\n", 0, 1);
 			first_chunk = 0;
@@ -350,12 +342,12 @@ static struct mc_device *mconsole_find_d
 	struct list_head *ele;
 	struct mc_device *dev;
 
-	list_for_each(ele, &mconsole_devices){
+	list_for_each(ele, &mconsole_devices) {
 		dev = list_entry(ele, struct mc_device, list);
-		if(!strncmp(name, dev->name, strlen(dev->name)))
-			return(dev);
+		if (!strncmp(name, dev->name, strlen(dev->name)))
+			return dev;
 	}
-	return(NULL);
+	return NULL;
 }
 
 #define UNPLUGGED_PER_PAGE \
@@ -377,15 +369,15 @@ static int mem_config(char *str, char **
 	int err = -EINVAL, i, add;
 	char *ret;
 
-	if(str[0] != '='){
+	if (str[0] != '=') {
 		*error_out = "Expected '=' after 'mem'";
 		goto out;
 	}
 
 	str++;
-	if(str[0] == '-')
+	if (str[0] == '-')
 		add = 0;
-	else if(str[0] == '+'){
+	else if (str[0] == '+') {
 		add = 1;
 	}
 	else {
@@ -395,7 +387,7 @@ static int mem_config(char *str, char **
 
 	str++;
 	diff = memparse(str, &ret);
-	if(*ret != '\0'){
+	if (*ret != '\0') {
 		*error_out = "Failed to parse memory increment";
 		goto out;
 	}
@@ -403,17 +395,17 @@ static int mem_config(char *str, char **
 	diff /= PAGE_SIZE;
 
 	down(&plug_mem_mutex);
-	for(i = 0; i < diff; i++){
+	for (i = 0; i < diff; i++) {
 		struct unplugged_pages *unplugged;
 		void *addr;
 
-		if(add){
-			if(list_empty(&unplugged_pages))
+		if (add) {
+			if (list_empty(&unplugged_pages))
 				break;
 
 			unplugged = list_entry(unplugged_pages.next,
 					       struct unplugged_pages, list);
-			if(unplug_index > 0)
+			if (unplug_index > 0)
 				addr = unplugged->pages[--unplug_index];
 			else {
 				list_del(&unplugged->list);
@@ -428,11 +420,11 @@ static int mem_config(char *str, char **
 			struct page *page;
 
 			page = alloc_page(GFP_ATOMIC);
-			if(page == NULL)
+			if (page == NULL)
 				break;
 
 			unplugged = page_address(page);
-			if(unplug_index == UNPLUGGED_PER_PAGE){
+			if (unplug_index == UNPLUGGED_PER_PAGE) {
 				list_add(&unplugged->list, &unplugged_pages);
 				unplug_index = 0;
 			}
@@ -444,9 +436,9 @@ static int mem_config(char *str, char **
 						       struct unplugged_pages,
 						       list);
 				err = os_drop_memory(addr, PAGE_SIZE);
-				if(err){
-					printk("Failed to release memory - "
-					       "errno = %d\n", err);
+				if (err) {
+					printk(KERN_ERR "Failed to release "
+					       "memory - errno = %d\n", err);
 					*error_out = "Failed to release memory";
 					goto out_unlock;
 				}
@@ -500,10 +492,10 @@ static struct mc_device mem_mc = {
 
 static int __init mem_mc_init(void)
 {
-	if(can_drop_memory())
+	if (can_drop_memory())
 		mconsole_register_dev(&mem_mc);
-	else printk("Can't release memory to the host - memory hotplug won't "
-		    "be supported\n");
+	else printk(KERN_ERR "Can't release memory to the host - memory "
+		    "hotplug won't be supported\n");
 	return 0;
 }
 
@@ -518,7 +510,7 @@ static void mconsole_get_config(int (*ge
 	char default_buf[CONFIG_BUF_SIZE], *error, *buf;
 	int n, size;
 
-	if(get_config == NULL){
+	if (get_config == NULL) {
 		mconsole_reply(req, "No get_config routine defined", 1, 0);
 		return;
 	}
@@ -527,30 +519,30 @@ static void mconsole_get_config(int (*ge
 	size = ARRAY_SIZE(default_buf);
 	buf = default_buf;
 
-	while(1){
+	while (1) {
 		n = (*get_config)(name, buf, size, &error);
-		if(error != NULL){
+		if (error != NULL) {
 			mconsole_reply(req, error, 1, 0);
 			goto out;
 		}
 
-		if(n <= size){
+		if (n <= size) {
 			mconsole_reply(req, buf, 0, 0);
 			goto out;
 		}
 
-		if(buf != default_buf)
+		if (buf != default_buf)
 			kfree(buf);
 
 		size = n;
 		buf = kmalloc(size, GFP_KERNEL);
-		if(buf == NULL){
+		if (buf == NULL) {
 			mconsole_reply(req, "Failed to allocate buffer", 1, 0);
 			return;
 		}
 	}
  out:
-	if(buf != default_buf)
+	if (buf != default_buf)
 		kfree(buf);
 }
 
@@ -561,19 +553,20 @@ void mconsole_config(struct mc_request *
 	int err;
 
 	ptr += strlen("config");
-	while(isspace(*ptr)) ptr++;
+	while (isspace(*ptr))
+		ptr++;
 	dev = mconsole_find_dev(ptr);
-	if(dev == NULL){
+	if (dev == NULL) {
 		mconsole_reply(req, "Bad configuration option", 1, 0);
 		return;
 	}
 
 	name = &ptr[strlen(dev->name)];
 	ptr = name;
-	while((*ptr != '=') && (*ptr != '\0'))
+	while ((*ptr != '=') && (*ptr != '\0'))
 		ptr++;
 
-	if(*ptr == '='){
+	if (*ptr == '=') {
 		err = (*dev->config)(name, &error_string);
 		mconsole_reply(req, error_string, err, 0);
 	}
@@ -588,9 +581,9 @@ void mconsole_remove(struct mc_request *
 	int err, start, end, n;
 
 	ptr += strlen("remove");
-	while(isspace(*ptr)) ptr++;
+	while (isspace(*ptr)) ptr++;
 	dev = mconsole_find_dev(ptr);
-	if(dev == NULL){
+	if (dev == NULL) {
 		mconsole_reply(req, "Bad remove option", 1, 0);
 		return;
 	}
@@ -599,11 +592,11 @@ void mconsole_remove(struct mc_request *
 
 	err = 1;
 	n = (*dev->id)(&ptr, &start, &end);
-	if(n < 0){
+	if (n < 0) {
 		err_msg = "Couldn't parse device number";
 		goto out;
 	}
-	else if((n < start) || (n > end)){
+	else if ((n < start) || (n > end)) {
 		sprintf(error, "Invalid device number - must be between "
 			"%d and %d", start, end);
 		err_msg = error;
@@ -612,16 +605,16 @@ void mconsole_remove(struct mc_request *
 
 	err_msg = NULL;
 	err = (*dev->remove)(n, &err_msg);
-	switch(err){
+	switch(err) {
 	case 0:
 		err_msg = "";
 		break;
 	case -ENODEV:
-		if(err_msg == NULL)
+		if (err_msg == NULL)
 			err_msg = "Device doesn't exist";
 		break;
 	case -EBUSY:
-		if(err_msg == NULL)
+		if (err_msg == NULL)
 			err_msg = "Device is currently open";
 		break;
 	default:
@@ -647,19 +640,19 @@ static void console_write(struct console
 	struct list_head *ele;
 	int n;
 
-	if(list_empty(&clients))
+	if (list_empty(&clients))
 		return;
 
-	while(1){
+	while (1) {
 		n = min((size_t) len, ARRAY_SIZE(console_buf) - console_index);
 		strncpy(&console_buf[console_index], string, n);
 		console_index += n;
 		string += n;
 		len -= n;
-		if(len == 0)
+		if (len == 0)
 			return;
 
-		list_for_each(ele, &clients){
+		list_for_each(ele, &clients) {
 			struct mconsole_output *entry;
 
 			entry = list_entry(ele, struct mconsole_output, list);
@@ -717,12 +710,13 @@ void mconsole_sysrq(struct mc_request *r
 	char *ptr = req->request.data;
 
 	ptr += strlen("sysrq");
-	while(isspace(*ptr)) ptr++;
+	while (isspace(*ptr)) ptr++;
 
-	/* With 'b', the system will shut down without a chance to reply,
+	/*
+	 * With 'b', the system will shut down without a chance to reply,
 	 * so in this case, we reply first.
 	 */
-	if(*ptr == 'b')
+	if (*ptr == 'b')
 		mconsole_reply(req, "", 0, 0);
 
 	with_console(req, sysrq_proc, ptr);
@@ -742,7 +736,8 @@ static void stack_proc(void *arg)
 	switch_to(from, to, from);
 }
 
-/* Mconsole stack trace
+/*
+ * Mconsole stack trace
  *  Added by Allan Graves, Jeff Dike
  *  Dumps a stacks registers to the linux console.
  *  Usage stack <pid>.
@@ -754,17 +749,21 @@ void mconsole_stack(struct mc_request *r
 	struct task_struct *from = NULL;
 	struct task_struct *to = NULL;
 
-	/* Would be nice:
+	/*
+	 * Would be nice:
 	 * 1) Send showregs output to mconsole.
 	 * 2) Add a way to stack dump all pids.
 	 */
 
 	ptr += strlen("stack");
-	while(isspace(*ptr)) ptr++;
+	while (isspace(*ptr))
+		ptr++;
 
-	/* Should really check for multiple pids or reject bad args here */
+	/*
+	 * Should really check for multiple pids or reject bad args here
+	 */
 	/* What do the arguments in mconsole_reply mean? */
-	if(sscanf(ptr, "%d", &pid_requested) == 0){
+	if (sscanf(ptr, "%d", &pid_requested) == 0) {
 		mconsole_reply(req, "Please specify a pid", 1, 0);
 		return;
 	}
@@ -772,14 +771,15 @@ void mconsole_stack(struct mc_request *r
 	from = current;
 
 	to = find_task_by_pid(pid_requested);
-	if((to == NULL) || (pid_requested == 0)) {
+	if ((to == NULL) || (pid_requested == 0)) {
 		mconsole_reply(req, "Couldn't find that pid", 1, 0);
 		return;
 	}
 	with_console(req, stack_proc, to);
 }
 
-/* Changed by mconsole_setup, which is __setup, and called before SMP is
+/*
+ * Changed by mconsole_setup, which is __setup, and called before SMP is
  * active.
  */
 static char *notify_socket = NULL;
@@ -791,13 +791,14 @@ static int __init mconsole_init(void)
 	int err;
 	char file[256];
 
-	if(umid_file_name("mconsole", file, sizeof(file))) return(-1);
+	if (umid_file_name("mconsole", file, sizeof(file)))
+		return -1;
 	snprintf(mconsole_socket_name, sizeof(file), "%s", file);
 
 	sock = os_create_unix_socket(file, sizeof(file), 1);
-	if (sock < 0){
-		printk("Failed to initialize management console\n");
-		return(1);
+	if (sock < 0) {
+		printk(KERN_ERR "Failed to initialize management console\n");
+		return 1;
 	}
 
 	register_reboot_notifier(&reboot_notifier);
@@ -805,14 +806,14 @@ static int __init mconsole_init(void)
 	err = um_request_irq(MCONSOLE_IRQ, sock, IRQ_READ, mconsole_interrupt,
 			     IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			     "mconsole", (void *)sock);
-	if (err){
-		printk("Failed to get IRQ for management console\n");
-		return(1);
+	if (err) {
+		printk(KERN_ERR "Failed to get IRQ for management console\n");
+		return 1;
 	}
 
-	if(notify_socket != NULL){
+	if (notify_socket != NULL) {
 		notify_socket = kstrdup(notify_socket, GFP_KERNEL);
-		if(notify_socket != NULL)
+		if (notify_socket != NULL)
 			mconsole_notify(notify_socket, MCONSOLE_SOCKET,
 					mconsole_socket_name,
 					strlen(mconsole_socket_name) + 1);
@@ -820,9 +821,9 @@ static int __init mconsole_init(void)
 			    "string\n");
 	}
 
-	printk("mconsole (version %d) initialized on %s\n",
+	printk(KERN_INFO "mconsole (version %d) initialized on %s\n",
 	       MCONSOLE_VERSION, mconsole_socket_name);
-	return(0);
+	return 0;
 }
 
 __initcall(mconsole_init);
@@ -833,10 +834,10 @@ static int write_proc_mconsole(struct fi
 	char *buf;
 
 	buf = kmalloc(count + 1, GFP_KERNEL);
-	if(buf == NULL)
-		return(-ENOMEM);
+	if (buf == NULL)
+		return -ENOMEM;
 
-	if(copy_from_user(buf, buffer, count)){
+	if (copy_from_user(buf, buffer, count)) {
 		count = -EFAULT;
 		goto out;
 	}
@@ -846,24 +847,26 @@ static int write_proc_mconsole(struct fi
 	mconsole_notify(notify_socket, MCONSOLE_USER_NOTIFY, buf, count);
  out:
 	kfree(buf);
-	return(count);
+	return count;
 }
 
 static int create_proc_mconsole(void)
 {
 	struct proc_dir_entry *ent;
 
-	if(notify_socket == NULL) return(0);
+	if (notify_socket == NULL)
+		return 0;
 
 	ent = create_proc_entry("mconsole", S_IFREG | 0200, NULL);
-	if(ent == NULL){
-		printk(KERN_INFO "create_proc_mconsole : create_proc_entry failed\n");
-		return(0);
+	if (ent == NULL) {
+		printk(KERN_INFO "create_proc_mconsole : create_proc_entry "
+		       "failed\n");
+		return 0;
 	}
 
 	ent->read_proc = NULL;
 	ent->write_proc = write_proc_mconsole;
-	return(0);
+	return 0;
 }
 
 static DEFINE_SPINLOCK(notify_spinlock);
@@ -884,12 +887,12 @@ __initcall(create_proc_mconsole);
 
 static int mconsole_setup(char *str)
 {
-	if(!strncmp(str, NOTIFY, strlen(NOTIFY))){
+	if (!strncmp(str, NOTIFY, strlen(NOTIFY))) {
 		str += strlen(NOTIFY);
 		notify_socket = str;
 	}
 	else printk(KERN_ERR "mconsole_setup : Unknown option - '%s'\n", str);
-	return(1);
+	return 1;
 }
 
 __setup("mconsole", mconsole_setup);
@@ -907,11 +910,12 @@ static int notify_panic(struct notifier_
 {
 	char *message = ptr;
 
-	if(notify_socket == NULL) return(0);
+	if (notify_socket == NULL)
+		return 0;
 
 	mconsole_notify(notify_socket, MCONSOLE_PANIC, message,
 			strlen(message) + 1);
-	return(0);
+	return 0;
 }
 
 static struct notifier_block panic_exit_notifier = {
@@ -924,14 +928,14 @@ static int add_notifier(void)
 {
 	atomic_notifier_chain_register(&panic_notifier_list,
 			&panic_exit_notifier);
-	return(0);
+	return 0;
 }
 
 __initcall(add_notifier);
 
 char *mconsole_notify_socket(void)
 {
-	return(notify_socket);
+	return notify_socket;
 }
 
 EXPORT_SYMBOL(mconsole_notify_socket);
diff -puN arch/um/include/um_mmu.h~uml-style-fixes-pass-2 arch/um/include/um_mmu.h
--- a/arch/um/include/um_mmu.h~uml-style-fixes-pass-2
+++ a/arch/um/include/um_mmu.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
diff -puN arch/um/include/um_uaccess.h~uml-style-fixes-pass-2 arch/um/include/um_uaccess.h
--- a/arch/um/include/um_uaccess.h~uml-style-fixes-pass-2
+++ a/arch/um/include/um_uaccess.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -10,7 +10,7 @@
 
 #define __under_task_size(addr, size) \
 	(((unsigned long) (addr) < TASK_SIZE) && \
-         (((unsigned long) (addr) + (size)) < TASK_SIZE))
+	 (((unsigned long) (addr) + (size)) < TASK_SIZE))
 
 #define __access_ok_vsyscall(type, addr, size) \
 	 ((type == VERIFY_READ) && \
@@ -90,14 +90,3 @@ extern int clear_user(void __user *mem, 
 extern int strnlen_user(const void __user *str, int len);
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/ksyms.c~uml-style-fixes-pass-2 arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-style-fixes-pass-2
+++ a/arch/um/kernel/ksyms.c
@@ -1,22 +1,15 @@
 /* 
- * Copyright (C) 2001 - 2004 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include "linux/module.h"
-#include "linux/string.h"
-#include "linux/smp_lock.h"
-#include "linux/spinlock.h"
-#include "linux/highmem.h"
-#include "asm/current.h"
-#include "asm/processor.h"
-#include "asm/unistd.h"
-#include "asm/pgalloc.h"
-#include "asm/pgtable.h"
-#include "asm/page.h"
+#include "linux/syscalls.h"
+#include "asm/a.out.h"
 #include "asm/tlbflush.h"
-#include "kern_util.h"
+#include "asm/uaccess.h"
 #include "as-layout.h"
+#include "kern_util.h"
 #include "mem_user.h"
 #include "os.h"
 
diff -puN include/asm-um/a.out.h~uml-style-fixes-pass-2 include/asm-um/a.out.h
--- a/include/asm-um/a.out.h~uml-style-fixes-pass-2
+++ a/include/asm-um/a.out.h
@@ -1,3 +1,8 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
 #ifndef __UM_A_OUT_H
 #define __UM_A_OUT_H
 
diff -puN include/asm-um/tlbflush.h~uml-style-fixes-pass-2 include/asm-um/tlbflush.h
--- a/include/asm-um/tlbflush.h~uml-style-fixes-pass-2
+++ a/include/asm-um/tlbflush.h
@@ -1,5 +1,5 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -30,7 +30,9 @@ extern void flush_tlb_page_skas(struct v
 static inline void flush_tlb_page(struct vm_area_struct *vma,
 				  unsigned long address)
 {
-	flush_tlb_page_skas(vma, address & PAGE_MASK);
+	address &= PAGE_MASK;
+
+	flush_tlb_page_skas(vma, address);
 }
 
 extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch

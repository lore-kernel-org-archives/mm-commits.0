From: akpm@linux-foundation.org
Subject: + uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:32:01 -0700
Message-ID: <200704131932.l3DJW1OQ007659@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbXDMTcJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: rename os_{read_write}_file_k back to os_{read_write}_file
has been added to the -mm tree.  Its filename is
     uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: rename os_{read_write}_file_k back to os_{read_write}_file
From: Jeff Dike <jdike@addtoit.com>

Rename os_{read_write}_file_k back to os_{read_write}_file, delete
the originals and their bogus infrastructure, and fix all the callers.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c       |    4 +-
 arch/um/drivers/chan_user.c       |   10 ++---
 arch/um/drivers/cow_sys.h         |    2 -
 arch/um/drivers/daemon_user.c     |    4 +-
 arch/um/drivers/harddog_user.c    |    4 +-
 arch/um/drivers/hostaudio_kern.c  |    4 +-
 arch/um/drivers/net_user.c        |    8 ++--
 arch/um/drivers/port_kern.c       |    2 -
 arch/um/drivers/random.c          |    2 -
 arch/um/drivers/ubd_kern.c        |   20 +++++------
 arch/um/include/os.h              |    2 -
 arch/um/kernel/initrd.c           |    2 -
 arch/um/kernel/ksyms.c            |    2 -
 arch/um/kernel/physmem.c          |    4 +-
 arch/um/kernel/sigio.c            |    2 -
 arch/um/kernel/smp.c              |   12 +++---
 arch/um/kernel/tt/process_kern.c  |    6 +--
 arch/um/kernel/tt/ptproxy/proxy.c |    8 ++--
 arch/um/kernel/tt/tracer.c        |    2 -
 arch/um/os-Linux/file.c           |   50 ----------------------------
 arch/um/sys-i386/bugs.c           |    4 +-
 arch/um/sys-i386/ldt.c            |    2 -
 22 files changed, 51 insertions(+), 105 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/chan_kern.c
@@ -98,7 +98,7 @@ int generic_read(int fd, char *c_out, vo
 {
 	int n;
 
-	n = os_read_file_k(fd, c_out, sizeof(*c_out));
+	n = os_read_file(fd, c_out, sizeof(*c_out));
 
 	if(n == -EAGAIN)
 		return 0;
@@ -111,7 +111,7 @@ int generic_read(int fd, char *c_out, vo
 
 int generic_write(int fd, const char *buf, int n, void *unused)
 {
-	return os_write_file_k(fd, buf, n);
+	return os_write_file(fd, buf, n);
 }
 
 int generic_window_size(int fd, void *unused, unsigned short *rows_out,
diff -puN arch/um/drivers/chan_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/chan_user.c
@@ -85,7 +85,7 @@ static int winch_thread(void *arg)
 
 	pty_fd = data->pty_fd;
 	pipe_fd = data->pipe_fd;
-	count = os_write_file_k(pipe_fd, &c, sizeof(c));
+	count = os_write_file(pipe_fd, &c, sizeof(c));
 	if(count != sizeof(c))
 		printk("winch_thread : failed to write synchronization "
 		       "byte, err = %d\n", -count);
@@ -120,7 +120,7 @@ static int winch_thread(void *arg)
 	 * host - since they are not different kernel threads, we cannot use
 	 * kernel semaphores. We don't use SysV semaphores because they are
 	 * persistent. */
-	count = os_read_file_k(pipe_fd, &c, sizeof(c));
+	count = os_read_file(pipe_fd, &c, sizeof(c));
 	if(count != sizeof(c))
 		printk("winch_thread : failed to read synchronization byte, "
 		       "err = %d\n", -count);
@@ -130,7 +130,7 @@ static int winch_thread(void *arg)
 		 * are blocked.*/
 		sigsuspend(&sigs);
 
-		count = os_write_file_k(pipe_fd, &c, sizeof(c));
+		count = os_write_file(pipe_fd, &c, sizeof(c));
 		if(count != sizeof(c))
 			printk("winch_thread : write failed, err = %d\n",
 			       -count);
@@ -162,7 +162,7 @@ static int winch_tramp(int fd, struct tt
 	}
 
 	*fd_out = fds[0];
-	n = os_read_file_k(fds[0], &c, sizeof(c));
+	n = os_read_file(fds[0], &c, sizeof(c));
 	if(n != sizeof(c)){
 		printk("winch_tramp : failed to read synchronization byte\n");
 		printk("read failed, err = %d\n", -n);
@@ -195,7 +195,7 @@ void register_winch(int fd, struct tty_s
 		if(thread > 0){
 			register_winch_irq(thread_fd, fd, thread, tty);
 
-			count = os_write_file_k(thread_fd, &c, sizeof(c));
+			count = os_write_file(thread_fd, &c, sizeof(c));
 			if(count != sizeof(c))
 				printk("register_winch : failed to write "
 				       "synchronization byte, err = %d\n",
diff -puN arch/um/drivers/cow_sys.h~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/cow_sys.h
--- a/arch/um/drivers/cow_sys.h~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/cow_sys.h
@@ -35,7 +35,7 @@ static inline int cow_file_size(char *fi
 
 static inline int cow_write_file(int fd, void *buf, int size)
 {
-	return os_write_file_k(fd, buf, size);
+	return os_write_file(fd, buf, size);
 }
 
 #endif
diff -puN arch/um/drivers/daemon_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/daemon_user.c
@@ -94,7 +94,7 @@ static int connect_to_switch(struct daem
 	req.version = SWITCH_VERSION;
 	req.type = REQ_NEW_CONTROL;
 	req.sock = *local_addr;
-	n = os_write_file_k(pri->control, &req, sizeof(req));
+	n = os_write_file(pri->control, &req, sizeof(req));
 	if(n != sizeof(req)){
 		printk("daemon_open : control setup request failed, err = %d\n",
 		       -n);
@@ -102,7 +102,7 @@ static int connect_to_switch(struct daem
 		goto out_free;
 	}
 
-	n = os_read_file_k(pri->control, sun, sizeof(*sun));
+	n = os_read_file(pri->control, sun, sizeof(*sun));
 	if(n != sizeof(*sun)){
 		printk("daemon_open : read of data socket failed, err = %d\n",
 		       -n);
diff -puN arch/um/drivers/harddog_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/harddog_user.c
@@ -79,7 +79,7 @@ int start_watchdog(int *in_fd_ret, int *
 		goto out_close_out;
 	}
 
-	n = os_read_file_k(in_fds[0], &c, sizeof(c));
+	n = os_read_file(in_fds[0], &c, sizeof(c));
 	if(n == 0){
 		printk("harddog_open - EOF on watchdog pipe\n");
 		helper_wait(pid);
@@ -118,7 +118,7 @@ int ping_watchdog(int fd)
 	int n;
 	char c = '\n';
 
-	n = os_write_file_k(fd, &c, sizeof(c));
+	n = os_write_file(fd, &c, sizeof(c));
 	if(n != sizeof(c)){
 		printk("ping_watchdog - write failed, err = %d\n", -n);
 		if(n < 0)
diff -puN arch/um/drivers/hostaudio_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/hostaudio_kern.c
--- a/arch/um/drivers/hostaudio_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/hostaudio_kern.c
@@ -84,7 +84,7 @@ static ssize_t hostaudio_read(struct fil
 	if(kbuf == NULL)
 		return(-ENOMEM);
 
-	err = os_read_file_k(state->fd, kbuf, count);
+	err = os_read_file(state->fd, kbuf, count);
 	if(err < 0)
 		goto out;
 
@@ -115,7 +115,7 @@ static ssize_t hostaudio_write(struct fi
 	if(copy_from_user(kbuf, buffer, count))
 		goto out;
 
-	err = os_write_file_k(state->fd, kbuf, count);
+	err = os_write_file(state->fd, kbuf, count);
 	if(err < 0)
 		goto out;
 	*ppos += err;
diff -puN arch/um/drivers/net_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/net_user.c
@@ -63,7 +63,7 @@ void read_output(int fd, char *output, i
 	}
 		
 	*output = '\0';
-	ret = os_read_file_k(fd, &remain, sizeof(remain));
+	ret = os_read_file(fd, &remain, sizeof(remain));
 
 	if (ret != sizeof(remain)) {
 		expected = sizeof(remain);
@@ -73,7 +73,7 @@ void read_output(int fd, char *output, i
 
 	while(remain != 0){
 		expected = (remain < len) ? remain : len;
-		ret = os_read_file_k(fd, output, expected);
+		ret = os_read_file(fd, output, expected);
 		if (ret != expected) {
 			str = "data";
 			goto err;
@@ -94,7 +94,7 @@ int net_read(int fd, void *buf, int len)
 {
 	int n;
 
-	n = os_read_file_k(fd,  buf,  len);
+	n = os_read_file(fd,  buf,  len);
 
 	if(n == -EAGAIN)
 		return 0;
@@ -122,7 +122,7 @@ int net_write(int fd, void *buf, int len
 {
 	int n;
 
-	n = os_write_file_k(fd, buf, len);
+	n = os_write_file(fd, buf, len);
 
 	if(n == -EAGAIN)
 		return 0;
diff -puN arch/um/drivers/port_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/port_kern.c
--- a/arch/um/drivers/port_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/port_kern.c
@@ -113,7 +113,7 @@ static int port_accept(struct port_list 
 	}
 
 	if(atomic_read(&port->wait_count) == 0){
-		os_write_file_k(fd, NO_WAITER_MSG, sizeof(NO_WAITER_MSG));
+		os_write_file(fd, NO_WAITER_MSG, sizeof(NO_WAITER_MSG));
 		printk("No one waiting for port\n");
 	}
 	list_add(&conn->list, &port->pending);
diff -puN arch/um/drivers/random.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/random.c
--- a/arch/um/drivers/random.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/random.c
@@ -44,7 +44,7 @@ static ssize_t rng_dev_read (struct file
         int n, ret = 0, have_data;
 
         while(size){
-                n = os_read_file_k(random_fd, &data, sizeof(data));
+                n = os_read_file(random_fd, &data, sizeof(data));
                 if(n > 0){
                         have_data = n;
                         while (have_data && size) {
diff -puN arch/um/drivers/ubd_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/drivers/ubd_kern.c
@@ -511,8 +511,8 @@ static void ubd_handler(void)
 	int n;
 
 	while(1){
-		n = os_read_file_k(thread_fd, &req,
-				   sizeof(struct io_thread_req *));
+		n = os_read_file(thread_fd, &req,
+				 sizeof(struct io_thread_req *));
 		if(n != sizeof(req)){
 			if(n == -EAGAIN)
 				break;
@@ -1112,8 +1112,8 @@ static void do_ubd_request(request_queue
 					(unsigned long long) req->sector << 9,
 					sg->offset, sg->length, sg->page);
 
-			n = os_write_file_k(thread_fd, &io_req,
-					    sizeof(struct io_thread_req *));
+			n = os_write_file(thread_fd, &io_req,
+					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
 				if(n != -EAGAIN)
 					printk("write to io thread failed, "
@@ -1366,8 +1366,8 @@ static int update_bitmap(struct io_threa
 		return 1;
 	}
 
-	n = os_write_file_k(req->fds[1], &req->bitmap_words,
-			    sizeof(req->bitmap_words));
+	n = os_write_file(req->fds[1], &req->bitmap_words,
+			  sizeof(req->bitmap_words));
 	if(n != sizeof(req->bitmap_words)){
 		printk("do_io - bitmap update failed, err = %d fd = %d\n", -n,
 		       req->fds[1]);
@@ -1411,7 +1411,7 @@ void do_io(struct io_thread_req *req)
 			do {
 				buf = &buf[n];
 				len -= n;
-				n = os_read_file_k(req->fds[bit], buf, len);
+				n = os_read_file(req->fds[bit], buf, len);
 				if (n < 0) {
 					printk("do_io - read failed, err = %d "
 					       "fd = %d\n", -n, req->fds[bit]);
@@ -1421,7 +1421,7 @@ void do_io(struct io_thread_req *req)
 			} while((n < len) && (n != 0));
 			if (n < len) memset(&buf[n], 0, len - n);
 		} else {
-			n = os_write_file_k(req->fds[bit], buf, len);
+			n = os_write_file(req->fds[bit], buf, len);
 			if(n != len){
 				printk("do_io - write failed err = %d "
 				       "fd = %d\n", -n, req->fds[bit]);
@@ -1451,7 +1451,7 @@ int io_thread(void *arg)
 
 	ignore_sigwinch_sig();
 	while(1){
-		n = os_read_file_k(kernel_fd, &req,
+		n = os_read_file(kernel_fd, &req,
 				 sizeof(struct io_thread_req *));
 		if(n != sizeof(struct io_thread_req *)){
 			if(n < 0)
@@ -1465,7 +1465,7 @@ int io_thread(void *arg)
 		}
 		io_count++;
 		do_io(req);
-		n = os_write_file_k(kernel_fd, &req,
+		n = os_write_file(kernel_fd, &req,
 				  sizeof(struct io_thread_req *));
 		if(n != sizeof(struct io_thread_req *))
 			printk("io_thread - write failed, fd = %d, err = %d\n",
diff -puN arch/um/include/os.h~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/include/os.h
--- a/arch/um/include/os.h~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/include/os.h
@@ -144,9 +144,7 @@ extern int os_mode_fd(int fd, int mode);
 extern int os_seek_file(int fd, __u64 offset);
 extern int os_open_file(char *file, struct openflags flags, int mode);
 extern int os_read_file(int fd, void *buf, int len);
-extern int os_read_file_k(int fd, void *buf, int len);
 extern int os_write_file(int fd, const void *buf, int count);
-extern int os_write_file_k(int fd, const void *buf, int len);
 extern int os_file_size(char *file, unsigned long long *size_out);
 extern int os_file_modtime(char *file, unsigned long *modtime);
 extern int os_pipe(int *fd, int stream, int close_on_exec);
diff -puN arch/um/kernel/initrd.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/initrd.c
@@ -63,7 +63,7 @@ int load_initrd(char *filename, void *bu
 		printk("Opening '%s' failed - err = %d\n", filename, -fd);
 		return -1;
 	}
-	n = os_read_file_k(fd, buf, size);
+	n = os_read_file(fd, buf, size);
 	if(n != size){
 		printk("Read of %d bytes from '%s' failed, err = %d\n", size,
 		       filename, -n);
diff -puN arch/um/kernel/ksyms.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/ksyms.c
@@ -62,9 +62,7 @@ EXPORT_SYMBOL(os_get_exec_close);
 EXPORT_SYMBOL(os_set_exec_close);
 EXPORT_SYMBOL(os_getpid);
 EXPORT_SYMBOL(os_open_file);
-EXPORT_SYMBOL(os_read_file_k);
 EXPORT_SYMBOL(os_read_file);
-EXPORT_SYMBOL(os_write_file_k);
 EXPORT_SYMBOL(os_write_file);
 EXPORT_SYMBOL(os_seek_file);
 EXPORT_SYMBOL(os_lock_file);
diff -puN arch/um/kernel/physmem.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/physmem.c
@@ -211,7 +211,7 @@ void physmem_forget_descriptor(int fd)
 			panic("physmem_forget_descriptor - failed to seek "
 			      "to %lld in fd %d, error = %d\n",
 			      offset, fd, -err);
-		err = os_read_file_k(fd, addr, PAGE_SIZE);
+		err = os_read_file(fd, addr, PAGE_SIZE);
 		if(err < 0)
 			panic("physmem_forget_descriptor - failed to read "
 			      "from fd %d to 0x%p, error = %d\n",
@@ -341,7 +341,7 @@ void setup_physmem(unsigned long start, 
 	 * from physmem_fd, so it needs to be written out there.
 	 */
 	os_seek_file(physmem_fd, __pa(&__syscall_stub_start));
-	os_write_file_k(physmem_fd, &__syscall_stub_start, PAGE_SIZE);
+	os_write_file(physmem_fd, &__syscall_stub_start, PAGE_SIZE);
 
 	bootmap_size = init_bootmem(pfn, pfn + delta);
 	free_bootmem(__pa(reserve_end) + bootmap_size,
diff -puN arch/um/kernel/sigio.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/sigio.c
--- a/arch/um/kernel/sigio.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/sigio.c
@@ -21,7 +21,7 @@ static irqreturn_t sigio_interrupt(int i
 {
 	char c;
 
-	os_read_file_k(sigio_irq_fd, &c, sizeof(c));
+	os_read_file(sigio_irq_fd, &c, sizeof(c));
 	reactivate_fd(sigio_irq_fd, SIGIO_WRITE_IRQ);
 	return IRQ_HANDLED;
 }
diff -puN arch/um/kernel/smp.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/smp.c
@@ -47,7 +47,7 @@ struct task_struct *idle_threads[NR_CPUS
 
 void smp_send_reschedule(int cpu)
 {
-	os_write_file_k(cpu_data[cpu].ipi_pipe[1], "R", 1);
+	os_write_file(cpu_data[cpu].ipi_pipe[1], "R", 1);
 	num_reschedules_sent++;
 }
 
@@ -59,7 +59,7 @@ void smp_send_stop(void)
 	for(i = 0; i < num_online_cpus(); i++){
 		if(i == current_thread->cpu)
 			continue;
-		os_write_file_k(cpu_data[i].ipi_pipe[1], "S", 1);
+		os_write_file(cpu_data[i].ipi_pipe[1], "S", 1);
 	}
 	printk("done\n");
 }
@@ -108,8 +108,8 @@ static struct task_struct *idle_thread(i
 		          { .pid = 	new_task->thread.mode.tt.extern_pid,
 			    .task = 	new_task } );
 	idle_threads[cpu] = new_task;
-	CHOOSE_MODE(os_write_file_k(new_task->thread.mode.tt.switch_pipe[1], &c,
-				    sizeof(c)),
+	CHOOSE_MODE(os_write_file(new_task->thread.mode.tt.switch_pipe[1], &c,
+				  sizeof(c)),
 		    ({ panic("skas mode doesn't support SMP"); }));
 	return new_task;
 }
@@ -179,7 +179,7 @@ void IPI_handler(int cpu)
 	int fd;
 
 	fd = cpu_data[cpu].ipi_pipe[0];
-	while (os_read_file_k(fd, &c, 1) == 1) {
+	while (os_read_file(fd, &c, 1) == 1) {
 		switch (c) {
 		case 'C':
 			smp_call_function_slave(cpu);
@@ -239,7 +239,7 @@ int smp_call_function(void (*_func)(void
 	info = _info;
 
 	for_each_online_cpu(i)
-		os_write_file_k(cpu_data[i].ipi_pipe[1], "C", 1);
+		os_write_file(cpu_data[i].ipi_pipe[1], "C", 1);
 
 	while (atomic_read(&scf_started) != cpus)
 		barrier();
diff -puN arch/um/kernel/tt/process_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/tt/process_kern.c
--- a/arch/um/kernel/tt/process_kern.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/tt/process_kern.c
@@ -57,14 +57,14 @@ void switch_to_tt(void *prev, void *next
 	 * nor the value in "to" (since it was the task which stole us the CPU,
 	 * which we don't care about). */
 
-	err = os_write_file_k(to->thread.mode.tt.switch_pipe[1], &c, sizeof(c));
+	err = os_write_file(to->thread.mode.tt.switch_pipe[1], &c, sizeof(c));
 	if(err != sizeof(c))
 		panic("write of switch_pipe failed, err = %d", -err);
 
 	if(from->thread.mode.tt.switch_pipe[0] == -1)
 		os_kill_process(os_getpid(), 0);
 
-	err = os_read_file_k(from->thread.mode.tt.switch_pipe[0], &c,
+	err = os_read_file(from->thread.mode.tt.switch_pipe[0], &c,
 			     sizeof(c));
 	if(err != sizeof(c))
 		panic("read of switch_pipe failed, errno = %d", -err);
@@ -114,7 +114,7 @@ void suspend_new_thread(int fd)
 	char c;
 
 	os_stop_process(os_getpid());
-	err = os_read_file_k(fd, &c, sizeof(c));
+	err = os_read_file(fd, &c, sizeof(c));
 	if(err != sizeof(c))
 		panic("read failed in suspend_new_thread, err = %d", -err);
 }
diff -puN arch/um/kernel/tt/ptproxy/proxy.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/tt/ptproxy/proxy.c
--- a/arch/um/kernel/tt/ptproxy/proxy.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/tt/ptproxy/proxy.c
@@ -338,14 +338,14 @@ int start_debugger(char *prog, int start
 			       "err = %d\n", -fd);
 			exit(1);
 		}
-		os_write_file_k(fd, gdb_init_string,
-				sizeof(gdb_init_string) - 1);
+		os_write_file(fd, gdb_init_string,
+			      sizeof(gdb_init_string) - 1);
 		if(startup){
 			if(stop){
-				os_write_file_k(fd, "b start_kernel\n",
+				os_write_file(fd, "b start_kernel\n",
 						strlen("b start_kernel\n"));
 			}
-			os_write_file_k(fd, "c\n", strlen("c\n"));
+			os_write_file(fd, "c\n", strlen("c\n"));
 		}
 		if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0){
 			printk("start_debugger :  PTRACE_TRACEME failed, "
diff -puN arch/um/kernel/tt/tracer.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/kernel/tt/tracer.c
--- a/arch/um/kernel/tt/tracer.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/kernel/tt/tracer.c
@@ -44,7 +44,7 @@ static void tracer_winch_handler(int sig
 	int n;
 	char c = 1;
 
-	n = os_write_file_k(tracer_winch[1], &c, sizeof(c));
+	n = os_write_file(tracer_winch[1], &c, sizeof(c));
 	if(n != sizeof(c))
 		printk("tracer_winch_handler - write failed, err = %d\n", -n);
 }
diff -puN arch/um/os-Linux/file.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/os-Linux/file.c
@@ -290,52 +290,8 @@ int os_seek_file(int fd, __u64 offset)
 	return 0;
 }
 
-static int fault_buffer(void *start, int len,
-			int (*copy_proc)(void *addr, void *buf, int len))
-{
-	int page = getpagesize(), i;
-	char c;
-
-	for(i = 0; i < len; i += page){
-		if((*copy_proc)(start + i, &c, sizeof(c)))
-			return -EFAULT;
-	}
-	if((len % page) != 0){
-		if((*copy_proc)(start + len - 1, &c, sizeof(c)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static int file_io(int fd, void *buf, int len,
-		   int (*io_proc)(int fd, void *buf, int len),
-		   int (*copy_user_proc)(void *addr, void *buf, int len))
-{
-	int n, err;
-
-	do {
-		n = (*io_proc)(fd, buf, len);
-		if((n < 0) && (errno == EFAULT)){
-			err = fault_buffer(buf, len, copy_user_proc);
-			if(err)
-				return err;
-			n = (*io_proc)(fd, buf, len);
-		}
-	} while((n < 0) && (errno == EINTR));
-
-	if(n < 0)
-		return -errno;
-	return n;
-}
-
 int os_read_file(int fd, void *buf, int len)
 {
-	return file_io(fd, buf, len, (int (*)(int, void *, int)) read,
-		       copy_from_user_proc);
-}
-
-int os_read_file_k(int fd, void *buf, int len)
-{
 	int n = read(fd, buf, len);
 
 	if(n < 0)
@@ -345,12 +301,6 @@ int os_read_file_k(int fd, void *buf, in
 
 int os_write_file(int fd, const void *buf, int len)
 {
-	return file_io(fd, (void *) buf, len,
-		       (int (*)(int, void *, int)) write, copy_to_user_proc);
-}
-
-int os_write_file_k(int fd, const void *buf, int len)
-{
 	int n = write(fd, (void *) buf, len);
 
 	if(n < 0)
diff -puN arch/um/sys-i386/bugs.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/sys-i386/bugs.c
@@ -28,7 +28,7 @@ static char token(int fd, char *buf, int
 	ptr = buf;
 	end = &buf[len];
 	do {
-		n = os_read_file_k(fd, ptr, sizeof(*ptr));
+		n = os_read_file(fd, ptr, sizeof(*ptr));
 		c = *ptr++;
 		if(n != sizeof(*ptr)){
 			if(n == 0)
@@ -67,7 +67,7 @@ static int find_cpuinfo_line(int fd, cha
 			return 1;
 
 		do {
-			n = os_read_file_k(fd, &c, sizeof(c));
+			n = os_read_file(fd, &c, sizeof(c));
 			if(n != sizeof(c)){
 				printk("Failed to find newline in "
 				       "/proc/cpuinfo, err = %d\n", -n);
diff -puN arch/um/sys-i386/ldt.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-rename-os_read_write_file_k-back-to-os_read_write_file
+++ a/arch/um/sys-i386/ldt.c
@@ -517,7 +517,7 @@ long init_new_ldt(struct mmu_context_ska
 					      .u 	=
 					      { .copy_segments =
 							from_mm->id.u.mm_fd } } );
-		i = os_write_file_k(new_mm->id.u.mm_fd, &copy, sizeof(copy));
+		i = os_write_file(new_mm->id.u.mm_fd, &copy, sizeof(copy));
 		if(i != sizeof(copy))
 			printk("new_mm : /proc/mm copy_segments failed, "
 			       "err = %d\n", -i);
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch

From: akpm@linux-foundation.org
Subject: - uml-tidy-libc-code.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:08 -0700
Message-ID: <200705080007.l48078Rm009254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967269AbXEHALv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: tidy libc code
has been removed from the -mm tree.  Its filename was
     uml-tidy-libc-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: tidy libc code
From: Jeff Dike <jdike@addtoit.com>

This patch lays some groundwork for the next one, which converts calls to
os_{read,write}_file into {read,write}, by doing some tidying in the affected
areas.

do_not_aio gets restructured to make the final result a bit cleaner.

There are also whitespace and other formatting fixes, fixes in error messages,
and a typo fix.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/aio.c                   |   20 ++++----------
 arch/um/os-Linux/drivers/ethertap_user.c |   10 +++++--
 arch/um/os-Linux/helper.c                |    9 ++++--
 arch/um/os-Linux/process.c               |   29 ++++++++++-----------
 arch/um/os-Linux/sigio.c                 |    7 ++---
 arch/um/os-Linux/skas/process.c          |    2 -
 arch/um/os-Linux/tty_log.c               |   16 +++++------
 7 files changed, 47 insertions(+), 46 deletions(-)

diff -puN arch/um/os-Linux/aio.c~uml-tidy-libc-code arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-tidy-libc-code
+++ a/arch/um/os-Linux/aio.c
@@ -146,28 +146,21 @@ static int aio_thread(void *arg)
 static int do_not_aio(struct aio_thread_req *req)
 {
 	char c;
+	unsigned long long actual;
 	int err;
 
+	actual = lseek64(req->io_fd, req->offset, SEEK_SET);
+	if(actual != req->offset)
+		return -errno;
+
 	switch(req->type){
 	case AIO_READ:
-		err = os_seek_file(req->io_fd, req->offset);
-		if(err)
-			goto out;
-
 		err = os_read_file(req->io_fd, req->buf, req->len);
 		break;
 	case AIO_WRITE:
-		err = os_seek_file(req->io_fd, req->offset);
-		if(err)
-			goto out;
-
 		err = os_write_file(req->io_fd, req->buf, req->len);
 		break;
 	case AIO_MMAP:
-		err = os_seek_file(req->io_fd, req->offset);
-		if(err)
-			goto out;
-
 		err = os_read_file(req->io_fd, &c, sizeof(c));
 		break;
 	default:
@@ -176,7 +169,6 @@ static int do_not_aio(struct aio_thread_
 		break;
 	}
 
-out:
 	return err;
 }
 
@@ -207,7 +199,7 @@ static int not_aio_thread(void *arg)
 		}
 		err = do_not_aio(&req);
 		reply = ((struct aio_thread_reply) { .data 	= req.aio,
-					 .err	= err });
+						     .err	= err });
 		err = os_write_file(req.aio->reply_fd, &reply, sizeof(reply));
 		if(err != sizeof(reply))
 			printk("not_aio_thread - write failed, fd = %d, "
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-tidy-libc-code arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-tidy-libc-code
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and 
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
@@ -49,8 +49,11 @@ static void etap_change(int op, unsigned
 	memcpy(change.addr, addr, sizeof(change.addr));
 	memcpy(change.netmask, netmask, sizeof(change.netmask));
 	n = os_write_file(fd, &change, sizeof(change));
-	if(n != sizeof(change))
+	if(n != sizeof(change)){
 		printk("etap_change - request failed, err = %d\n", -n);
+		return;
+	}
+
 	output = um_kmalloc(UM_KERN_PAGE_SIZE);
 	if(output == NULL)
 		printk("etap_change : Failed to allocate output buffer\n");
@@ -116,7 +119,8 @@ static int etap_tramp(char *dev, char *g
 	pe_data.data_me = data_me;
 	pid = run_helper(etap_pre_exec, &pe_data, args, NULL);
 
-	if(pid < 0) err = pid;
+	if(pid < 0)
+		err = pid;
 	os_close_file(data_remote);
 	os_close_file(control_remote);
 	n = os_read_file(control_me, &c, sizeof(c));
diff -puN arch/um/os-Linux/helper.c~uml-tidy-libc-code arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-tidy-libc-code
+++ a/arch/um/os-Linux/helper.c
@@ -34,7 +34,8 @@ static int helper_child(void *arg)
 	if (data->pre_exec != NULL)
 		(*data->pre_exec)(data->pre_data);
 	errval = execvp_noalloc(data->buf, argv[0], argv);
-	printk("helper_child - execvp of '%s' failed - errno = %d\n", argv[0], -errval);
+	printk("helper_child - execvp of '%s' failed - errno = %d\n", argv[0],
+	       -errval);
 	os_write_file(data->fd, &errval, sizeof(errval));
 	kill(os_getpid(), SIGKILL);
 	return 0;
@@ -87,8 +88,10 @@ int run_helper(void (*pre_exec)(void *),
 	close(fds[1]);
 	fds[1] = -1;
 
-	/* Read the errno value from the child, if the exec failed, or get 0 if
-	 * the exec succeeded because the pipe fd was set as close-on-exec. */
+	/*
+	 * Read the errno value from the child, if the exec failed, or get 0 if
+	 * the exec succeeded because the pipe fd was set as close-on-exec.
+	 */
 	n = os_read_file(fds[0], &ret, sizeof(ret));
 	if (n == 0) {
 		ret = pid;
diff -puN arch/um/os-Linux/process.c~uml-tidy-libc-code arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-tidy-libc-code
+++ a/arch/um/os-Linux/process.c
@@ -40,14 +40,14 @@ unsigned long os_process_pc(int pid)
 	if(fd < 0){
 		printk("os_process_pc - couldn't open '%s', err = %d\n",
 		       proc_stat, -fd);
-		return(ARBITRARY_ADDR);
+		return ARBITRARY_ADDR;
 	}
 	err = os_read_file(fd, buf, sizeof(buf));
 	if(err < 0){
 		printk("os_process_pc - couldn't read '%s', err = %d\n",
 		       proc_stat, -err);
 		os_close_file(fd);
-		return(ARBITRARY_ADDR);
+		return ARBITRARY_ADDR;
 	}
 	os_close_file(fd);
 	pc = ARBITRARY_ADDR;
@@ -56,7 +56,7 @@ unsigned long os_process_pc(int pid)
 		  "%*d %*d %*d %*d %*d %lu", &pc) != 1){
 		printk("os_process_pc - couldn't find pc in '%s'\n", buf);
 	}
-	return(pc);
+	return pc;
 }
 
 int os_process_parent(int pid)
@@ -65,13 +65,14 @@ int os_process_parent(int pid)
 	char data[256];
 	int parent, n, fd;
 
-	if(pid == -1) return(-1);
+	if(pid == -1)
+		return -1;
 
 	snprintf(stat, sizeof(stat), "/proc/%d/stat", pid);
 	fd = os_open_file(stat, of_read(OPENFLAGS()), 0);
 	if(fd < 0){
 		printk("Couldn't open '%s', err = %d\n", stat, -fd);
-		return(FAILURE_PID);
+		return FAILURE_PID;
 	}
 
 	n = os_read_file(fd, data, sizeof(data));
@@ -79,7 +80,7 @@ int os_process_parent(int pid)
 
 	if(n < 0){
 		printk("Couldn't read '%s', err = %d\n", stat, -n);
-		return(FAILURE_PID);
+		return FAILURE_PID;
 	}
 
 	parent = FAILURE_PID;
@@ -87,7 +88,7 @@ int os_process_parent(int pid)
 	if(n != 1)
 		printk("Failed to scan '%s'\n", data);
 
-	return(parent);
+	return parent;
 }
 
 void os_stop_process(int pid)
@@ -145,7 +146,7 @@ void os_usr1_process(int pid)
 
 int os_getpid(void)
 {
-	return(syscall(__NR_getpid));
+	return syscall(__NR_getpid);
 }
 
 int os_getpgrp(void)
@@ -165,8 +166,8 @@ int os_map_memory(void *virt, int fd, un
 	loc = mmap64((void *) virt, len, prot, MAP_SHARED | MAP_FIXED,
 		     fd, off);
 	if(loc == MAP_FAILED)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 int os_protect_memory(void *addr, unsigned long len, int r, int w, int x)
@@ -175,8 +176,8 @@ int os_protect_memory(void *addr, unsign
 		    (x ? PROT_EXEC : 0));
 
         if(mprotect(addr, len, prot) < 0)
-		return(-errno);
-        return(0);
+		return -errno;
+        return 0;
 }
 
 int os_unmap_memory(void *addr, int len)
@@ -185,8 +186,8 @@ int os_unmap_memory(void *addr, int len)
 
         err = munmap(addr, len);
 	if(err < 0)
-		return(-errno);
-        return(0);
+		return -errno;
+        return 0;
 }
 
 #ifndef MADV_REMOVE
diff -puN arch/um/os-Linux/sigio.c~uml-tidy-libc-code arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-tidy-libc-code
+++ a/arch/um/os-Linux/sigio.c
@@ -461,15 +461,16 @@ static void tty_output(int master, int s
 
 	while(os_write_file(master, buf, sizeof(buf)) > 0) ;
 	if(errno != EAGAIN)
-		panic("check_sigio : write failed, errno = %d\n", errno);
+		panic("tty_output : write failed, errno = %d\n", errno);
 	while(((n = os_read_file(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
 
 	if(got_sigio){
 		printk("Yes\n");
 		pty_output_sigio = 1;
 	}
-	else if(n == -EAGAIN) printk("No, enabling workaround\n");
-	else panic("check_sigio : read failed, err = %d\n", n);
+	else if(n == -EAGAIN)
+		printk("No, enabling workaround\n");
+	else panic("tty_output : read failed, err = %d\n", n);
 }
 
 static void tty_close(int master, int slave)
diff -puN arch/um/os-Linux/skas/process.c~uml-tidy-libc-code arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-tidy-libc-code
+++ a/arch/um/os-Linux/skas/process.c
@@ -409,7 +409,7 @@ int copy_context_skas0(unsigned long new
 
 /*
  * This is used only, if stub pages are needed, while proc_mm is
- * availabl. Opening /proc/mm creates a new mm_context, which lacks
+ * available. Opening /proc/mm creates a new mm_context, which lacks
  * the stub-pages. Thus, we map them using /proc/mm-fd
  */
 void map_stub_pages(int fd, unsigned long code,
diff -puN arch/um/os-Linux/tty_log.c~uml-tidy-libc-code arch/um/os-Linux/tty_log.c
--- a/arch/um/os-Linux/tty_log.c~uml-tidy-libc-code
+++ a/arch/um/os-Linux/tty_log.c
@@ -55,7 +55,7 @@ int open_tty_log(void *tty, void *curren
 					       .usec = tv.tv_usec } );
 		os_write_file(tty_log_fd, &data, sizeof(data));
 		os_write_file(tty_log_fd, &current_tty, data.len);
-		return(tty_log_fd);
+		return tty_log_fd;
 	}
 
 	sprintf(buf, "%s/%0u-%0u", tty_log_dir, (unsigned int) tv.tv_sec,
@@ -67,7 +67,7 @@ int open_tty_log(void *tty, void *curren
 		printk("open_tty_log : couldn't open '%s', errno = %d\n",
 		       buf, -fd);
 	}
-	return(fd);
+	return fd;
 }
 
 void close_tty_log(int fd, void *tty)
@@ -101,18 +101,18 @@ static int log_chunk(int fd, const char 
 		n = os_write_file(fd, chunk, try);
 		if(n != try) {
 			if(n < 0)
-				return(n);
-			return(-EIO);
+				return n;
+			return -EIO;
 		}
 		if(missed != 0)
-			return(-EFAULT);
+			return -EFAULT;
 
 		len -= try;
 		total += try;
 		buf += try;
 	}
 
-	return(total);
+	return total;
 }
 
 int write_tty_log(int fd, const char *buf, int len, void *tty, int is_read)
@@ -133,7 +133,7 @@ int write_tty_log(int fd, const char *bu
 		os_write_file(tty_log_fd, &data, sizeof(data));
 	}
 
-	return(log_chunk(fd, buf, len));
+	return log_chunk(fd, buf, len);
 }
 
 void log_exec(char **argv, void *tty)
@@ -179,7 +179,7 @@ extern void register_tty_logger(int (*op
 static int register_logger(void)
 {
 	register_tty_logger(open_tty_log, write_tty_log, close_tty_log);
-	return(0);
+	return 0;
 }
 
 __uml_initcall(register_logger);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch

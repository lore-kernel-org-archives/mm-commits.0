From: akpm@linux-foundation.org
Subject: - uml-convert-libc-layer-to-call-read-and-write.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:10 -0700
Message-ID: <200705080007.l4807AEc009257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967386AbXEHAHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: convert libc layer to call read and write
has been removed from the -mm tree.  Its filename was
     uml-convert-libc-layer-to-call-read-and-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: convert libc layer to call read and write
From: Jeff Dike <jdike@addtoit.com>

This patch converts calls in the os layer to os_{read,write}_file to calls
directly to libc read() and write() where it is clear that the I/O buffer is
in the kernel.

We can do that here instead of calling os_{read,write}_file_k since we are in
libc code and can call libc directly.

With the change in the calls, error handling needs to be changed to refer to
errno directly rather than the return value of the call.

CATCH_EINTR wrappers were also added where needed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/aio.c                   |   36 +++++++++++----------
 arch/um/os-Linux/drivers/ethertap_user.c |   11 +++---
 arch/um/os-Linux/helper.c                |    5 +-
 arch/um/os-Linux/mem.c                   |    5 +-
 arch/um/os-Linux/process.c               |    8 ++--
 arch/um/os-Linux/sigio.c                 |   21 ++++++------
 arch/um/os-Linux/skas/mem.c              |   19 +++++++----
 arch/um/os-Linux/skas/process.c          |    9 ++---
 arch/um/os-Linux/tty_log.c               |   14 ++++----
 9 files changed, 71 insertions(+), 57 deletions(-)

diff -puN arch/um/os-Linux/aio.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/aio.c
@@ -132,10 +132,10 @@ static int aio_thread(void *arg)
 				{ .data = (void *) (long) event.data,
 						.err	= event.res });
 			reply_fd = ((struct aio_context *) reply.data)->reply_fd;
-			err = os_write_file(reply_fd, &reply, sizeof(reply));
+			err = write(reply_fd, &reply, sizeof(reply));
 			if(err != sizeof(reply))
 				printk("aio_thread - write failed, fd = %d, "
-				       "err = %d\n", reply_fd, -err);
+				       "err = %d\n", reply_fd, errno);
 		}
 	}
 	return 0;
@@ -147,7 +147,7 @@ static int do_not_aio(struct aio_thread_
 {
 	char c;
 	unsigned long long actual;
-	int err;
+	int n;
 
 	actual = lseek64(req->io_fd, req->offset, SEEK_SET);
 	if(actual != req->offset)
@@ -155,21 +155,22 @@ static int do_not_aio(struct aio_thread_
 
 	switch(req->type){
 	case AIO_READ:
-		err = os_read_file(req->io_fd, req->buf, req->len);
+		n = read(req->io_fd, req->buf, req->len);
 		break;
 	case AIO_WRITE:
-		err = os_write_file(req->io_fd, req->buf, req->len);
+		n = write(req->io_fd, req->buf, req->len);
 		break;
 	case AIO_MMAP:
-		err = os_read_file(req->io_fd, &c, sizeof(c));
+		n = read(req->io_fd, &c, sizeof(c));
 		break;
 	default:
 		printk("do_not_aio - bad request type : %d\n", req->type);
-		err = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
-	return err;
+	if(n < 0)
+		return -errno;
+	return 0;
 }
 
 /* These are initialized in initcalls and not changed */
@@ -185,12 +186,12 @@ static int not_aio_thread(void *arg)
 
 	signal(SIGWINCH, SIG_IGN);
 	while(1){
-		err = os_read_file(aio_req_fd_r, &req, sizeof(req));
+		err = read(aio_req_fd_r, &req, sizeof(req));
 		if(err != sizeof(req)){
 			if(err < 0)
 				printk("not_aio_thread - read failed, "
 				       "fd = %d, err = %d\n", aio_req_fd_r,
-				       -err);
+				       errno);
 			else {
 				printk("not_aio_thread - short read, fd = %d, "
 				       "length = %d\n", aio_req_fd_r, err);
@@ -200,10 +201,10 @@ static int not_aio_thread(void *arg)
 		err = do_not_aio(&req);
 		reply = ((struct aio_thread_reply) { .data 	= req.aio,
 						     .err	= err });
-		err = os_write_file(req.aio->reply_fd, &reply, sizeof(reply));
+		err = write(req.aio->reply_fd, &reply, sizeof(reply));
 		if(err != sizeof(reply))
 			printk("not_aio_thread - write failed, fd = %d, "
-			       "err = %d\n", req.aio->reply_fd, -err);
+			       "err = %d\n", req.aio->reply_fd, errno);
 	}
 
 	return 0;
@@ -277,10 +278,12 @@ static int submit_aio_26(enum aio_type t
 	if(err){
 		reply = ((struct aio_thread_reply) { .data = aio,
 					 .err  = err });
-		err = os_write_file(aio->reply_fd, &reply, sizeof(reply));
-		if(err != sizeof(reply))
+		err = write(aio->reply_fd, &reply, sizeof(reply));
+		if(err != sizeof(reply)){
+			err = -errno;
 			printk("submit_aio_26 - write failed, "
 			       "fd = %d, err = %d\n", aio->reply_fd, -err);
+		}
 		else err = 0;
 	}
 
@@ -375,9 +378,10 @@ static int submit_aio_24(enum aio_type t
 	};
 	int err;
 
-	err = os_write_file(aio_req_fd_w, &req, sizeof(req));
+	err = write(aio_req_fd_w, &req, sizeof(req));
 	if(err == sizeof(req))
 		err = 0;
+	else err = -errno;
 
 	return err;
 }
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -48,9 +48,9 @@ static void etap_change(int op, unsigned
 	change.what = op;
 	memcpy(change.addr, addr, sizeof(change.addr));
 	memcpy(change.netmask, netmask, sizeof(change.netmask));
-	n = os_write_file(fd, &change, sizeof(change));
+	CATCH_EINTR(n = write(fd, &change, sizeof(change)));
 	if(n != sizeof(change)){
-		printk("etap_change - request failed, err = %d\n", -n);
+		printk("etap_change - request failed, err = %d\n", errno);
 		return;
 	}
 
@@ -123,10 +123,11 @@ static int etap_tramp(char *dev, char *g
 		err = pid;
 	os_close_file(data_remote);
 	os_close_file(control_remote);
-	n = os_read_file(control_me, &c, sizeof(c));
+	CATCH_EINTR(n = read(control_me, &c, sizeof(c)));
 	if(n != sizeof(c)){
-		printk("etap_tramp : read of status failed, err = %d\n", -n);
-		return -EINVAL;
+		err = -errno;
+		printk("etap_tramp : read of status failed, err = %d\n", -err);
+		return err;
 	}
 	if(c != 1){
 		printk("etap_tramp : uml_net failed\n");
diff -puN arch/um/os-Linux/helper.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/helper.c
@@ -36,7 +36,7 @@ static int helper_child(void *arg)
 	errval = execvp_noalloc(data->buf, argv[0], argv);
 	printk("helper_child - execvp of '%s' failed - errno = %d\n", argv[0],
 	       -errval);
-	os_write_file(data->fd, &errval, sizeof(errval));
+	write(data->fd, &errval, sizeof(errval));
 	kill(os_getpid(), SIGKILL);
 	return 0;
 }
@@ -92,11 +92,12 @@ int run_helper(void (*pre_exec)(void *),
 	 * Read the errno value from the child, if the exec failed, or get 0 if
 	 * the exec succeeded because the pipe fd was set as close-on-exec.
 	 */
-	n = os_read_file(fds[0], &ret, sizeof(ret));
+	n = read(fds[0], &ret, sizeof(ret));
 	if (n == 0) {
 		ret = pid;
 	} else {
 		if (n < 0) {
+			n = -errno;
 			printk("run_helper : read on pipe failed, ret = %d\n",
 			       -n);
 			ret = n;
diff -puN arch/um/os-Linux/mem.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/mem.c
@@ -232,10 +232,9 @@ int __init create_tmp_file(unsigned long
 
 	zero = 0;
 
-	err = os_write_file(fd, &zero, 1);
+	err = write(fd, &zero, 1);
 	if(err != 1){
-		errno = -err;
-		perror("os_write_file");
+		perror("write");
 		exit(1);
 	}
 
diff -puN arch/um/os-Linux/process.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/process.c
@@ -42,10 +42,10 @@ unsigned long os_process_pc(int pid)
 		       proc_stat, -fd);
 		return ARBITRARY_ADDR;
 	}
-	err = os_read_file(fd, buf, sizeof(buf));
+	CATCH_EINTR(err = read(fd, buf, sizeof(buf)));
 	if(err < 0){
 		printk("os_process_pc - couldn't read '%s', err = %d\n",
-		       proc_stat, -err);
+		       proc_stat, errno);
 		os_close_file(fd);
 		return ARBITRARY_ADDR;
 	}
@@ -75,11 +75,11 @@ int os_process_parent(int pid)
 		return FAILURE_PID;
 	}
 
-	n = os_read_file(fd, data, sizeof(data));
+	CATCH_EINTR(n = read(fd, data, sizeof(data)));
 	os_close_file(fd);
 
 	if(n < 0){
-		printk("Couldn't read '%s', err = %d\n", stat, -n);
+		printk("Couldn't read '%s', err = %d\n", stat, errno);
 		return FAILURE_PID;
 	}
 
diff -puN arch/um/os-Linux/sigio.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/sigio.c
@@ -69,11 +69,12 @@ static int write_sigio_thread(void *unus
 			p = &fds->poll[i];
 			if(p->revents == 0) continue;
 			if(p->fd == sigio_private[1]){
-				n = os_read_file(sigio_private[1], &c, sizeof(c));
+				CATCH_EINTR(n = read(sigio_private[1], &c,
+						     sizeof(c)));
 				if(n != sizeof(c))
 					printk("write_sigio_thread : "
 					       "read on socket failed, "
-					       "err = %d\n", -n);
+					       "err = %d\n", errno);
 				tmp = current_poll;
 				current_poll = next_poll;
 				next_poll = tmp;
@@ -86,10 +87,10 @@ static int write_sigio_thread(void *unus
 					(fds->used - i) * sizeof(*fds->poll));
 			}
 
-			n = os_write_file(respond_fd, &c, sizeof(c));
+			CATCH_EINTR(n = write(respond_fd, &c, sizeof(c)));
 			if(n != sizeof(c))
 				printk("write_sigio_thread : write on socket "
-				       "failed, err = %d\n", -n);
+				       "failed, err = %d\n", errno);
 		}
 	}
 
@@ -127,15 +128,15 @@ static void update_thread(void)
 	char c;
 
 	flags = set_signals(0);
-	n = os_write_file(sigio_private[0], &c, sizeof(c));
+	n = write(sigio_private[0], &c, sizeof(c));
 	if(n != sizeof(c)){
-		printk("update_thread : write failed, err = %d\n", -n);
+		printk("update_thread : write failed, err = %d\n", errno);
 		goto fail;
 	}
 
-	n = os_read_file(sigio_private[0], &c, sizeof(c));
+	CATCH_EINTR(n = read(sigio_private[0], &c, sizeof(c)));
 	if(n != sizeof(c)){
-		printk("update_thread : read failed, err = %d\n", -n);
+		printk("update_thread : read failed, err = %d\n", errno);
 		goto fail;
 	}
 
@@ -459,10 +460,10 @@ static void tty_output(int master, int s
 
 	memset(buf, 0, sizeof(buf));
 
-	while(os_write_file(master, buf, sizeof(buf)) > 0) ;
+	while(write(master, buf, sizeof(buf)) > 0) ;
 	if(errno != EAGAIN)
 		panic("tty_output : write failed, errno = %d\n", errno);
-	while(((n = os_read_file(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
+	while(((n = read(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
 
 	if(got_sigio){
 		printk("Yes\n");
diff -puN arch/um/os-Linux/skas/mem.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/skas/mem.c
@@ -6,6 +6,7 @@
 #include <signal.h>
 #include <errno.h>
 #include <string.h>
+#include <unistd.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #include <asm/page.h>
@@ -199,9 +200,11 @@ int map(struct mm_id * mm_idp, unsigned 
 					   .fd	= phys_fd,
 					   .offset= offset
 					 } } } );
-		ret = os_write_file(fd, &map, sizeof(map));
-		if(ret != sizeof(map))
+		CATCH_EINTR(ret = write(fd, &map, sizeof(map)));
+		if(ret != sizeof(map)){
+			ret = -errno;
 			printk("map : /proc/mm map failed, err = %d\n", -ret);
+		}
 		else ret = 0;
 	}
 	else {
@@ -231,9 +234,11 @@ int unmap(struct mm_id * mm_idp, void *a
 					   { .addr	=
 					     (unsigned long) addr,
 					     .len		= len } } } );
-		ret = os_write_file(fd, &unmap, sizeof(unmap));
-		if(ret != sizeof(unmap))
+		CATCH_EINTR(ret = write(fd, &unmap, sizeof(unmap)));
+		if(ret != sizeof(unmap)){
+			ret = -errno;
 			printk("unmap - proc_mm write returned %d\n", ret);
+		}
 		else ret = 0;
 	}
 	else {
@@ -266,9 +271,11 @@ int protect(struct mm_id * mm_idp, unsig
 					       .len	= len,
 					       .prot	= prot } } } );
 
-		ret = os_write_file(fd, &protect, sizeof(protect));
-		if(ret != sizeof(protect))
+		CATCH_EINTR(ret = write(fd, &protect, sizeof(protect)));
+		if(ret != sizeof(protect)){
+			ret = -errno;
 			printk("protect failed, err = %d", -ret);
+		}
 		else ret = 0;
 	}
 	else {
diff -puN arch/um/os-Linux/skas/process.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/skas/process.c
@@ -431,12 +431,13 @@ void map_stub_pages(int fd, unsigned lon
 					  .fd      = code_fd,
 					  .offset  = code_offset
 	} } });
-	n = os_write_file(fd, &mmop, sizeof(mmop));
+	CATCH_EINTR(n = write(fd, &mmop, sizeof(mmop)));
 	if(n != sizeof(mmop)){
+		n = errno;
 		printk("mmap args - addr = 0x%lx, fd = %d, offset = %llx\n",
 		       code, code_fd, (unsigned long long) code_offset);
 		panic("map_stub_pages : /proc/mm map for code failed, "
-		      "err = %d\n", -n);
+		      "err = %d\n", n);
 	}
 
 	if ( stack ) {
@@ -453,10 +454,10 @@ void map_stub_pages(int fd, unsigned lon
 				      .fd      = map_fd,
 				      .offset  = map_offset
 		} } });
-		n = os_write_file(fd, &mmop, sizeof(mmop));
+		CATCH_EINTR(n = write(fd, &mmop, sizeof(mmop)));
 		if(n != sizeof(mmop))
 			panic("map_stub_pages : /proc/mm map for data failed, "
-			      "err = %d\n", -n);
+			      "err = %d\n", errno);
 	}
 }
 
diff -puN arch/um/os-Linux/tty_log.c~uml-convert-libc-layer-to-call-read-and-write arch/um/os-Linux/tty_log.c
--- a/arch/um/os-Linux/tty_log.c~uml-convert-libc-layer-to-call-read-and-write
+++ a/arch/um/os-Linux/tty_log.c
@@ -53,8 +53,8 @@ int open_tty_log(void *tty, void *curren
 					       .direction = 0,
 					       .sec = tv.tv_sec,
 					       .usec = tv.tv_usec } );
-		os_write_file(tty_log_fd, &data, sizeof(data));
-		os_write_file(tty_log_fd, &current_tty, data.len);
+		write(tty_log_fd, &data, sizeof(data));
+		write(tty_log_fd, &current_tty, data.len);
 		return tty_log_fd;
 	}
 
@@ -83,7 +83,7 @@ void close_tty_log(int fd, void *tty)
 					       .direction = 0,
 					       .sec = tv.tv_sec,
 					       .usec = tv.tv_usec } );
-		os_write_file(tty_log_fd, &data, sizeof(data));
+		write(tty_log_fd, &data, sizeof(data));
 		return;
 	}
 	os_close_file(fd);
@@ -98,10 +98,10 @@ static int log_chunk(int fd, const char 
 		try = (len > sizeof(chunk)) ? sizeof(chunk) : len;
 		missed = copy_from_user_proc(chunk, (char *) buf, try);
 		try -= missed;
-		n = os_write_file(fd, chunk, try);
+		n = write(fd, chunk, try);
 		if(n != try) {
 			if(n < 0)
-				return n;
+				return -errno;
 			return -EIO;
 		}
 		if(missed != 0)
@@ -130,7 +130,7 @@ int write_tty_log(int fd, const char *bu
 					       .direction = direction,
 					       .sec = tv.tv_sec,
 					       .usec = tv.tv_usec } );
-		os_write_file(tty_log_fd, &data, sizeof(data));
+		write(tty_log_fd, &data, sizeof(data));
 	}
 
 	return log_chunk(fd, buf, len);
@@ -161,7 +161,7 @@ void log_exec(char **argv, void *tty)
 				       .direction = 0,
 				       .sec = tv.tv_sec,
 				       .usec = tv.tv_usec } );
-	os_write_file(tty_log_fd, &data, sizeof(data));
+	write(tty_log_fd, &data, sizeof(data));
 
 	for(ptr = argv; ; ptr++){
 		if(copy_from_user_proc(&arg, ptr, sizeof(arg)))
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch

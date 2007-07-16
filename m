From: akpm@linux-foundation.org
Subject: - uml-debug_shirq-fixes.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:10 -0700
Message-ID: <200707162051.l6GKpAV5001379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757968AbXGPV05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxdamage@aladin.ro, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: DEBUG_SHIRQ fixes
has been removed from the -mm tree.  Its filename was
     uml-debug_shirq-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: DEBUG_SHIRQ fixes
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>

DEBUG_SHIRQ generates spurious interrupts, triggering handlers such as
mconsole_interrupt() or line_interrupt().  They expect data to be available to
be read from their sockets/pipes, but in the case of spurious interrupts, the
host didn't actually send anything, so UML hangs in read() and friends. 
Setting those fd's as O_NONBLOCK makes DEBUG_SHIRQ-enabled UML kernels boot
and run correctly.

Signed-off-by: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c     |    8 +++++++-
 arch/um/drivers/mconsole_user.c |    5 +++--
 arch/um/drivers/ubd_user.c      |    6 ++++++
 arch/um/drivers/xterm.c         |    7 +++++++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-debug_shirq-fixes arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/chan_user.c
@@ -170,7 +170,13 @@ static int winch_tramp(int fd, struct tt
                 err = -EINVAL;
 		goto out_close;
 	}
-	return err ;
+
+	if (os_set_fd_block(*fd_out, 0)) {
+		printk("winch_tramp: failed to set thread_fd non-blocking.\n");
+		goto out_close;
+	}
+
+	return err;
 
  out_close:
 	os_close_file(fds[1]);
diff -puN arch/um/drivers/mconsole_user.c~uml-debug_shirq-fixes arch/um/drivers/mconsole_user.c
--- a/arch/um/drivers/mconsole_user.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/mconsole_user.c
@@ -86,8 +86,9 @@ int mconsole_get_request(int fd, struct 
 	int len;
 
 	req->originlen = sizeof(req->origin);
-	req->len = recvfrom(fd, &req->request, sizeof(req->request), 0,
-			    (struct sockaddr *) req->origin, &req->originlen);
+	req->len = recvfrom(fd, &req->request, sizeof(req->request),
+			    MSG_DONTWAIT, (struct sockaddr *) req->origin,
+			    &req->originlen);
 	if (req->len < 0)
 		return 0;
 
diff -puN arch/um/drivers/ubd_user.c~uml-debug_shirq-fixes arch/um/drivers/ubd_user.c
--- a/arch/um/drivers/ubd_user.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/ubd_user.c
@@ -43,6 +43,12 @@ int start_io_thread(unsigned long sp, in
 	kernel_fd = fds[0];
 	*fd_out = fds[1];
 
+	err = os_set_fd_block(*fd_out, 0);
+	if (err) {
+		printk("start_io_thread - failed to set nonblocking I/O.\n");
+		goto out_close;
+	}
+
 	pid = clone(io_thread, (void *) sp, CLONE_FILES | CLONE_VM | SIGCHLD,
 		    NULL);
 	if(pid < 0){
diff -puN arch/um/drivers/xterm.c~uml-debug_shirq-fixes arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/xterm.c
@@ -151,6 +151,13 @@ int xterm_open(int input, int output, in
 		goto out;
 	}
 
+	err = os_set_fd_block(new, 0);
+	if (err) {
+		printk("xterm_open : failed to set xterm descriptor "
+		       "non-blocking, err = %d\n", -err);
+		goto out;
+	}
+
 	CATCH_EINTR(err = tcgetattr(new, &data->tt));
 	if(err){
 		new = err;
_

Patches currently in -mm which might be from maxdamage@aladin.ro are

origin.patch

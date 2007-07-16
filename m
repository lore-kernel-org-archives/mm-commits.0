From: akpm@linux-foundation.org
Subject: - uml-eliminate-kernel-allocator-wrappers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:28 -0700
Message-ID: <200707162051.l6GKpSVh001399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761793AbXGPVe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: Eliminate kernel allocator wrappers
has been removed from the -mm tree.  Its filename was
     uml-eliminate-kernel-allocator-wrappers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: Eliminate kernel allocator wrappers
From: Jeff Dike <jdike@addtoit.com>

UML had two wrapper procedures for kmalloc, um_kmalloc and um_kmalloc_atomic
because the flag constants weren't available in userspace code. 
kern_constants.h had made kernel constants available for a long time, so there
is no need for these wrappers any more.  Rather, userspace code calls kmalloc
directly with the userspace versions of the gfp flags.

kmalloc isn't a real procedure, so I had to essentially copy the inline
wrapper around __kmalloc.

vmalloc also had its own wrapper for no good reason.  This is now gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/cow_sys.h                |    2 +-
 arch/um/drivers/daemon_user.c            |    4 ++--
 arch/um/drivers/fd.c                     |    2 +-
 arch/um/drivers/mcast_user.c             |    2 +-
 arch/um/drivers/net_user.c               |    2 +-
 arch/um/drivers/port_user.c              |    2 +-
 arch/um/drivers/pty.c                    |    2 +-
 arch/um/drivers/slip_user.c              |    2 +-
 arch/um/drivers/tty.c                    |    2 +-
 arch/um/include/common-offsets.h         |    3 +++
 arch/um/include/um_malloc.h              |   12 +++++++++---
 arch/um/kernel/irq.c                     |    1 -
 arch/um/kernel/process.c                 |   16 ----------------
 arch/um/os-Linux/drivers/ethertap_user.c |    4 ++--
 arch/um/os-Linux/helper.c                |    4 ++--
 arch/um/os-Linux/main.c                  |    4 ++--
 arch/um/os-Linux/sigio.c                 |    4 ++--
 17 files changed, 30 insertions(+), 38 deletions(-)

diff -puN arch/um/drivers/cow_sys.h~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/cow_sys.h
--- a/arch/um/drivers/cow_sys.h~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/cow_sys.h
@@ -8,7 +8,7 @@
 
 static inline void *cow_malloc(int size)
 {
-	return um_kmalloc(size);
+	return kmalloc(size, UM_GFP_KERNEL);
 }
 
 static inline void cow_free(void *ptr)
diff -puN arch/um/drivers/daemon_user.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/daemon_user.c
@@ -35,7 +35,7 @@ static struct sockaddr_un *new_addr(void
 {
 	struct sockaddr_un *sun;
 
-	sun = um_kmalloc(sizeof(struct sockaddr_un));
+	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if(sun == NULL){
 		printk("new_addr: allocation of sockaddr_un failed\n");
 		return NULL;
@@ -83,7 +83,7 @@ static int connect_to_switch(struct daem
 		goto out_close;
 	}
 
-	sun = um_kmalloc(sizeof(struct sockaddr_un));
+	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if(sun == NULL){
 		printk("new_addr: allocation of sockaddr_un failed\n");
 		err = -ENOMEM;
diff -puN arch/um/drivers/fd.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/fd.c
--- a/arch/um/drivers/fd.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/fd.c
@@ -37,7 +37,7 @@ static void *fd_init(char *str, int devi
 		printk("fd_init : couldn't parse file descriptor '%s'\n", str);
 		return(NULL);
 	}
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if(data == NULL) return(NULL);
 	*data = ((struct fd_chan) { .fd  	= n,
 				    .raw  	= opts->raw });
diff -puN arch/um/drivers/mcast_user.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/mcast_user.c
@@ -30,7 +30,7 @@ static struct sockaddr_in *new_addr(char
 {
 	struct sockaddr_in *sin;
 
-	sin = um_kmalloc(sizeof(struct sockaddr_in));
+	sin = kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if(sin == NULL){
 		printk("new_addr: allocation of sockaddr_in failed\n");
 		return NULL;
diff -puN arch/um/drivers/net_user.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/net_user.c
@@ -217,7 +217,7 @@ static void change(char *dev, char *what
 		netmask[2], netmask[3]);
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = um_kmalloc(output_len);
+	output = kmalloc(output_len, UM_GFP_KERNEL);
 	if(output == NULL)
 		printk("change : failed to allocate output buffer\n");
 
diff -puN arch/um/drivers/port_user.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/port_user.c
--- a/arch/um/drivers/port_user.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/port_user.c
@@ -50,7 +50,7 @@ static void *port_init(char *str, int de
 	if(kern_data == NULL)
 		return NULL;
 
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if(data == NULL)
 		goto err;
 
diff -puN arch/um/drivers/pty.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/pty.c
--- a/arch/um/drivers/pty.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/pty.c
@@ -29,7 +29,7 @@ static void *pty_chan_init(char *str, in
 {
 	struct pty_chan *data;
 
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
diff -puN arch/um/drivers/slip_user.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/slip_user.c
@@ -91,7 +91,7 @@ static int slip_tramp(char **argv, int f
 	pid = err;
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = um_kmalloc(output_len);
+	output = kmalloc(output_len, UM_GFP_KERNEL);
 	if(output == NULL){
 		printk("slip_tramp : failed to allocate output buffer\n");
 		os_kill_process(pid, 1);
diff -puN arch/um/drivers/tty.c~uml-eliminate-kernel-allocator-wrappers arch/um/drivers/tty.c
--- a/arch/um/drivers/tty.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/drivers/tty.c
@@ -29,7 +29,7 @@ static void *tty_chan_init(char *str, in
 	}
 	str++;
 
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if(data == NULL)
 		return NULL;
 	*data = ((struct tty_chan) { .dev 	= str,
diff -puN arch/um/include/common-offsets.h~uml-eliminate-kernel-allocator-wrappers arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/include/common-offsets.h
@@ -27,6 +27,9 @@ DEFINE(UM_ELFCLASS64, ELFCLASS64);
 
 DEFINE(UM_NR_CPUS, NR_CPUS);
 
+DEFINE(UM_GFP_KERNEL, GFP_KERNEL);
+DEFINE(UM_GFP_ATOMIC, GFP_ATOMIC);
+
 /* For crypto assembler code. */
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
 
diff -puN arch/um/include/um_malloc.h~uml-eliminate-kernel-allocator-wrappers arch/um/include/um_malloc.h
--- a/arch/um/include/um_malloc.h~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/include/um_malloc.h
@@ -6,11 +6,17 @@
 #ifndef __UM_MALLOC_H__
 #define __UM_MALLOC_H__
 
-extern void *um_kmalloc(int size);
-extern void *um_kmalloc_atomic(int size);
+#include "kern_constants.h"
+
+extern void *__kmalloc(int size, int flags);
+static inline void *kmalloc(int size, int flags)
+{
+	return __kmalloc(size, flags);
+}
+
 extern void kfree(const void *ptr);
 
-extern void *um_vmalloc(int size);
+extern void *vmalloc(unsigned long size);
 extern void vfree(void *ptr);
 
 #endif /* __UM_MALLOC_H__ */
diff -puN arch/um/kernel/irq.c~uml-eliminate-kernel-allocator-wrappers arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/kernel/irq.c
@@ -30,7 +30,6 @@
 #include "irq_kern.h"
 #include "os.h"
 #include "sigio.h"
-#include "um_malloc.h"
 #include "misc_constants.h"
 #include "as-layout.h"
 
diff -puN arch/um/kernel/process.c~uml-eliminate-kernel-allocator-wrappers arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/kernel/process.c
@@ -46,7 +46,6 @@
 #include "mode.h"
 #include "mode_kern.h"
 #include "choose-mode.h"
-#include "um_malloc.h"
 
 /* This is a per-cpu array.  A processor only modifies its entry and it only
  * cares about its entry, so it's OK if another processor is modifying its
@@ -262,21 +261,6 @@ void dump_thread(struct pt_regs *regs, s
 {
 }
 
-void *um_kmalloc(int size)
-{
-	return kmalloc(size, GFP_KERNEL);
-}
-
-void *um_kmalloc_atomic(int size)
-{
-	return kmalloc(size, GFP_ATOMIC);
-}
-
-void *um_vmalloc(int size)
-{
-	return vmalloc(size);
-}
-
 int __cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-eliminate-kernel-allocator-wrappers arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -54,7 +54,7 @@ static void etap_change(int op, unsigned
 		return;
 	}
 
-	output = um_kmalloc(UM_KERN_PAGE_SIZE);
+	output = kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
 	if(output == NULL)
 		printk("etap_change : Failed to allocate output buffer\n");
 	read_output(fd, output, UM_KERN_PAGE_SIZE);
@@ -166,7 +166,7 @@ static int etap_open(void *data)
 	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0], 
 			 control_fds[1], data_fds[0], data_fds[1]);
 	output_len = UM_KERN_PAGE_SIZE;
-	output = um_kmalloc(output_len);
+	output = kmalloc(output_len, UM_GFP_KERNEL);
 	read_output(control_fds[0], output, output_len);
 
 	if(output == NULL)
diff -puN arch/um/os-Linux/helper.c~uml-eliminate-kernel-allocator-wrappers arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/os-Linux/helper.c
@@ -72,8 +72,8 @@ int run_helper(void (*pre_exec)(void *),
 	data.pre_data = pre_data;
 	data.argv = argv;
 	data.fd = fds[1];
-	data.buf = __cant_sleep() ? um_kmalloc_atomic(PATH_MAX) :
-					um_kmalloc(PATH_MAX);
+	data.buf = __cant_sleep() ? kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
+					kmalloc(PATH_MAX, UM_GFP_KERNEL);
 	pid = clone(helper_child, (void *) sp, CLONE_VM | SIGCHLD, &data);
 	if (pid < 0) {
 		ret = -errno;
diff -puN arch/um/os-Linux/main.c~uml-eliminate-kernel-allocator-wrappers arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/os-Linux/main.c
@@ -235,8 +235,8 @@ void *__wrap_malloc(int size)
 		return __real_malloc(size);
 	else if(size <= UM_KERN_PAGE_SIZE)
 		/* finding contiguous pages can be hard*/
-		ret = um_kmalloc(size);
-	else ret = um_vmalloc(size);
+		ret = kmalloc(size, UM_GFP_KERNEL);
+	else ret = vmalloc(size);
 
 	/* glibc people insist that if malloc fails, errno should be
 	 * set by malloc as well. So we do.
diff -puN arch/um/os-Linux/sigio.c~uml-eliminate-kernel-allocator-wrappers arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-eliminate-kernel-allocator-wrappers
+++ a/arch/um/os-Linux/sigio.c
@@ -105,7 +105,7 @@ static int need_poll(struct pollfds *pol
 	if(n <= polls->size)
 		return 0;
 
-	new = um_kmalloc_atomic(n * sizeof(struct pollfd));
+	new = kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if(new == NULL){
 		printk("need_poll : failed to allocate new pollfds\n");
 		return -ENOMEM;
@@ -233,7 +233,7 @@ static struct pollfd *setup_initial_poll
 {
 	struct pollfd *p;
 
-	p = um_kmalloc(sizeof(struct pollfd));
+	p = kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
 		printk("setup_initial_poll : failed to allocate poll\n");
 		return NULL;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch

From: akpm@linux-foundation.org
Subject: - uml-fix-build-when-slob-is-enabled.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:33 -0700
Message-ID: <200805132132.m4DLWX62000698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759724AbYEMVco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix build when SLOB is enabled
has been removed from the -mm tree.  Its filename was
     uml-fix-build-when-slob-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix build when SLOB is enabled
From: Jeff Dike <jdike@addtoit.com>

Reintroduce uml_kmalloc for the benefit of UML libc code.  The
previous tactic of declaring __kmalloc so it could be called directly
from the libc side of the house turned out to be getting too intimate
with slab, and it doesn't work with slob.

So, the uml_kmalloc wrapper is back.  It calls kmalloc or whatever
that translates into, and libc code calls it.

kfree is left alone since that still works, leaving a somewhat
inconsistent API.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c              |    1 +
 arch/um/drivers/cow_sys.h                |    2 +-
 arch/um/drivers/daemon_user.c            |    4 ++--
 arch/um/drivers/fd.c                     |    2 +-
 arch/um/drivers/mcast_user.c             |    3 ++-
 arch/um/drivers/net_user.c               |    2 +-
 arch/um/drivers/port_user.c              |    2 +-
 arch/um/drivers/pty.c                    |    2 +-
 arch/um/drivers/slip_user.c              |    2 +-
 arch/um/drivers/tty.c                    |    2 +-
 arch/um/drivers/xterm.c                  |    2 +-
 arch/um/include/um_malloc.h              |    9 +++------
 arch/um/kernel/mem.c                     |    5 +++++
 arch/um/os-Linux/drivers/ethertap_user.c |    4 ++--
 arch/um/os-Linux/helper.c                |    4 ++--
 arch/um/os-Linux/main.c                  |    2 +-
 arch/um/os-Linux/sigio.c                 |    4 ++--
 17 files changed, 28 insertions(+), 24 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/chan_user.c
@@ -11,6 +11,7 @@
 #include <termios.h>
 #include <sys/ioctl.h>
 #include "chan_user.h"
+#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
 #include "user.h"
diff -puN arch/um/drivers/cow_sys.h~uml-fix-build-when-slob-is-enabled arch/um/drivers/cow_sys.h
--- a/arch/um/drivers/cow_sys.h~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/cow_sys.h
@@ -8,7 +8,7 @@
 
 static inline void *cow_malloc(int size)
 {
-	return kmalloc(size, UM_GFP_KERNEL);
+	return uml_kmalloc(size, UM_GFP_KERNEL);
 }
 
 static inline void cow_free(void *ptr)
diff -puN arch/um/drivers/daemon_user.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/daemon_user.c
@@ -34,7 +34,7 @@ static struct sockaddr_un *new_addr(void
 {
 	struct sockaddr_un *sun;
 
-	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
+	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
@@ -83,7 +83,7 @@ static int connect_to_switch(struct daem
 		goto out_close;
 	}
 
-	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
+	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
diff -puN arch/um/drivers/fd.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/fd.c
--- a/arch/um/drivers/fd.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/fd.c
@@ -40,7 +40,7 @@ static void *fd_init(char *str, int devi
 		return NULL;
 	}
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
diff -puN arch/um/drivers/mcast_user.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/mcast_user.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <netinet/in.h>
+#include "kern_constants.h"
 #include "mcast.h"
 #include "net_user.h"
 #include "um_malloc.h"
@@ -24,7 +25,7 @@ static struct sockaddr_in *new_addr(char
 {
 	struct sockaddr_in *sin;
 
-	sin = kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
+	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if (sin == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
 		       "failed\n");
diff -puN arch/um/drivers/net_user.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/net_user.c
@@ -222,7 +222,7 @@ static void change(char *dev, char *what
 		netmask[2], netmask[3]);
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL)
 		printk(UM_KERN_ERR "change : failed to allocate output "
 		       "buffer\n");
diff -puN arch/um/drivers/port_user.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/port_user.c
--- a/arch/um/drivers/port_user.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/port_user.c
@@ -47,7 +47,7 @@ static void *port_init(char *str, int de
 	if (kern_data == NULL)
 		return NULL;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		goto err;
 
diff -puN arch/um/drivers/pty.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/pty.c
--- a/arch/um/drivers/pty.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/pty.c
@@ -29,7 +29,7 @@ static void *pty_chan_init(char *str, in
 {
 	struct pty_chan *data;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
diff -puN arch/um/drivers/slip_user.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/slip_user.c
@@ -96,7 +96,7 @@ static int slip_tramp(char **argv, int f
 	pid = err;
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL) {
 		printk(UM_KERN_ERR "slip_tramp : failed to allocate output "
 		       "buffer\n");
diff -puN arch/um/drivers/tty.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/tty.c
--- a/arch/um/drivers/tty.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/tty.c
@@ -29,7 +29,7 @@ static void *tty_chan_init(char *str, in
 	}
 	str++;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 	*data = ((struct tty_chan) { .dev 	= str,
diff -puN arch/um/drivers/xterm.c~uml-fix-build-when-slob-is-enabled arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/drivers/xterm.c
@@ -30,7 +30,7 @@ static void *xterm_init(char *str, int d
 {
 	struct xterm_chan *data;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 	*data = ((struct xterm_chan) { .pid 		= -1,
diff -puN arch/um/include/um_malloc.h~uml-fix-build-when-slob-is-enabled arch/um/include/um_malloc.h
--- a/arch/um/include/um_malloc.h~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/include/um_malloc.h
@@ -8,15 +8,12 @@
 
 #include "kern_constants.h"
 
-extern void *__kmalloc(int size, int flags);
-static inline void *kmalloc(int size, int flags)
-{
-	return __kmalloc(size, flags);
-}
-
+extern void *uml_kmalloc(int size, int flags);
 extern void kfree(const void *ptr);
 
 extern void *vmalloc(unsigned long size);
 extern void vfree(void *ptr);
 
 #endif /* __UM_MALLOC_H__ */
+
+
diff -puN arch/um/kernel/mem.c~uml-fix-build-when-slob-is-enabled arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/kernel/mem.c
@@ -375,3 +375,8 @@ pmd_t *pmd_alloc_one(struct mm_struct *m
 	return pmd;
 }
 #endif
+
+void *uml_kmalloc(int size, int flags)
+{
+	return kmalloc(size, flags);
+}
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-fix-build-when-slob-is-enabled arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -52,7 +52,7 @@ static void etap_change(int op, unsigned
 		return;
 	}
 
-	output = kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
+	output = uml_kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
 	if (output == NULL)
 		printk(UM_KERN_ERR "etap_change : Failed to allocate output "
 		       "buffer\n");
@@ -165,7 +165,7 @@ static int etap_open(void *data)
 	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0],
 			 control_fds[1], data_fds[0], data_fds[1]);
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	read_output(control_fds[0], output, output_len);
 
 	if (output == NULL)
diff -puN arch/um/os-Linux/helper.c~uml-fix-build-when-slob-is-enabled arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/os-Linux/helper.c
@@ -71,8 +71,8 @@ int run_helper(void (*pre_exec)(void *),
 	data.pre_data = pre_data;
 	data.argv = argv;
 	data.fd = fds[1];
-	data.buf = __cant_sleep() ? kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
-					kmalloc(PATH_MAX, UM_GFP_KERNEL);
+	data.buf = __cant_sleep() ? uml_kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
+					uml_kmalloc(PATH_MAX, UM_GFP_KERNEL);
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
 		ret = -errno;
diff -puN arch/um/os-Linux/main.c~uml-fix-build-when-slob-is-enabled arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/os-Linux/main.c
@@ -199,7 +199,7 @@ void *__wrap_malloc(int size)
 		return __real_malloc(size);
 	else if (size <= UM_KERN_PAGE_SIZE)
 		/* finding contiguous pages can be hard*/
-		ret = kmalloc(size, UM_GFP_KERNEL);
+		ret = uml_kmalloc(size, UM_GFP_KERNEL);
 	else ret = vmalloc(size);
 
 	/*
diff -puN arch/um/os-Linux/sigio.c~uml-fix-build-when-slob-is-enabled arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-fix-build-when-slob-is-enabled
+++ a/arch/um/os-Linux/sigio.c
@@ -109,7 +109,7 @@ static int need_poll(struct pollfds *pol
 	if (n <= polls->size)
 		return 0;
 
-	new = kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
+	new = uml_kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if (new == NULL) {
 		printk(UM_KERN_ERR "need_poll : failed to allocate new "
 		       "pollfds\n");
@@ -243,7 +243,7 @@ static struct pollfd *setup_initial_poll
 {
 	struct pollfd *p;
 
-	p = kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
+	p = uml_kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
 		printk(UM_KERN_ERR "setup_initial_poll : failed to allocate "
 		       "poll\n");
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch


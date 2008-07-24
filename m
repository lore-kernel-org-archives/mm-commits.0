From: akpm@linux-foundation.org
Subject: - flag-parameters-socket-and-socketpair.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:06 -0700
Message-ID: <200807242327.m6ONR6QG011139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756672AbYGXX3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davem@davemloft.net, davidel@xmailserver.org, mtk.manpages@googlemail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     flag parameters: socket and socketpair
has been removed from the -mm tree.  Its filename was
     flag-parameters-socket-and-socketpair.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: socket and socketpair
From: Ulrich Drepper <drepper@redhat.com>

This patch adds support for flag values which are ORed to the type passwd
to socket and socketpair.  The additional code is minimal.  The flag
values in this implementation can and must match the O_* flags.  This
avoids overhead in the conversion.

The internal functions sock_alloc_fd and sock_map_fd get a new parameters
and all callers are changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/socket.h>

#define PORT 57392

/* For Linux these must be the same.  */
#define SOCK_CLOEXEC O_CLOEXEC

int
main (void)
{
  int fd;
  fd = socket (PF_INET, SOCK_STREAM, 0);
  if (fd == -1)
    {
      puts ("socket(0) failed");
      return 1;
    }
  int coe = fcntl (fd, F_GETFD);
  if (coe == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if (coe & FD_CLOEXEC)
    {
      puts ("socket(0) set close-on-exec flag");
      return 1;
    }
  close (fd);

  fd = socket (PF_INET, SOCK_STREAM|SOCK_CLOEXEC, 0);
  if (fd == -1)
    {
      puts ("socket(SOCK_CLOEXEC) failed");
      return 1;
    }
  coe = fcntl (fd, F_GETFD);
  if (coe == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if ((coe & FD_CLOEXEC) == 0)
    {
      puts ("socket(SOCK_CLOEXEC) does not set close-on-exec flag");
      return 1;
    }
  close (fd);

  int fds[2];
  if (socketpair (PF_UNIX, SOCK_STREAM, 0, fds) == -1)
    {
      puts ("socketpair(0) failed");
      return 1;
    }
  for (int i = 0; i < 2; ++i)
    {
      coe = fcntl (fds[i], F_GETFD);
      if (coe == -1)
        {
          puts ("fcntl failed");
          return 1;
        }
      if (coe & FD_CLOEXEC)
        {
          printf ("socketpair(0) set close-on-exec flag for fds[%d]\n", i);
          return 1;
        }
      close (fds[i]);
    }

  if (socketpair (PF_UNIX, SOCK_STREAM|SOCK_CLOEXEC, 0, fds) == -1)
    {
      puts ("socketpair(SOCK_CLOEXEC) failed");
      return 1;
    }
  for (int i = 0; i < 2; ++i)
    {
      coe = fcntl (fds[i], F_GETFD);
      if (coe == -1)
        {
          puts ("fcntl failed");
          return 1;
        }
      if ((coe & FD_CLOEXEC) == 0)
        {
          printf ("socketpair(SOCK_CLOEXEC) does not set close-on-exec flag for fds[%d]\n", i);
          return 1;
        }
      close (fds[i]);
    }

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/socket.h |    7 +++++++
 include/linux/net.h       |    9 ++++++++-
 net/9p/trans_fd.c         |    2 +-
 net/sctp/socket.c         |    2 +-
 net/socket.c              |   28 ++++++++++++++++++++--------
 5 files changed, 37 insertions(+), 11 deletions(-)

diff -puN include/asm-mips/socket.h~flag-parameters-socket-and-socketpair include/asm-mips/socket.h
--- a/include/asm-mips/socket.h~flag-parameters-socket-and-socketpair
+++ a/include/asm-mips/socket.h
@@ -102,6 +102,13 @@ enum sock_type {
 };
 
 #define SOCK_MAX (SOCK_PACKET + 1)
+/* Mask which covers at least up to SOCK_MASK-1.  The
+ *  * remaining bits are used as flags. */
+#define SOCK_TYPE_MASK 0xf
+
+/* Flags for socket, socketpair, paccept */
+#define SOCK_CLOEXEC	O_CLOEXEC
+#define SOCK_NONBLOCK	O_NONBLOCK
 
 #define ARCH_HAS_SOCKET_TYPES 1
 
diff -puN include/linux/net.h~flag-parameters-socket-and-socketpair include/linux/net.h
--- a/include/linux/net.h~flag-parameters-socket-and-socketpair
+++ a/include/linux/net.h
@@ -20,6 +20,7 @@
 
 #include <linux/wait.h>
 #include <linux/socket.h>
+#include <linux/fcntl.h>	/* For O_CLOEXEC */
 #include <asm/socket.h>
 
 struct poll_table_struct;
@@ -94,6 +95,12 @@ enum sock_type {
 };
 
 #define SOCK_MAX (SOCK_PACKET + 1)
+/* Mask which covers at least up to SOCK_MASK-1.  The
+ * remaining bits are used as flags. */
+#define SOCK_TYPE_MASK 0xf
+
+/* Flags for socket, socketpair, paccept */
+#define SOCK_CLOEXEC	O_CLOEXEC
 
 #endif /* ARCH_HAS_SOCKET_TYPES */
 
@@ -208,7 +215,7 @@ extern int   	     sock_sendmsg(struct s
 				  size_t len);
 extern int	     sock_recvmsg(struct socket *sock, struct msghdr *msg,
 				  size_t size, int flags);
-extern int 	     sock_map_fd(struct socket *sock);
+extern int 	     sock_map_fd(struct socket *sock, int flags);
 extern struct socket *sockfd_lookup(int fd, int *err);
 #define		     sockfd_put(sock) fput(sock->file)
 extern int	     net_ratelimit(void);
diff -puN net/9p/trans_fd.c~flag-parameters-socket-and-socketpair net/9p/trans_fd.c
--- a/net/9p/trans_fd.c~flag-parameters-socket-and-socketpair
+++ a/net/9p/trans_fd.c
@@ -1285,7 +1285,7 @@ static int p9_socket_open(struct p9_tran
 	int fd, ret;
 
 	csocket->sk->sk_allocation = GFP_NOIO;
-	fd = sock_map_fd(csocket);
+	fd = sock_map_fd(csocket, 0);
 	if (fd < 0) {
 		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to map fd\n");
 		return fd;
diff -puN net/sctp/socket.c~flag-parameters-socket-and-socketpair net/sctp/socket.c
--- a/net/sctp/socket.c~flag-parameters-socket-and-socketpair
+++ a/net/sctp/socket.c
@@ -3910,7 +3910,7 @@ static int sctp_getsockopt_peeloff(struc
 		goto out;
 
 	/* Map the socket to an unused fd that can be returned to the user.  */
-	retval = sock_map_fd(newsock);
+	retval = sock_map_fd(newsock, 0);
 	if (retval < 0) {
 		sock_release(newsock);
 		goto out;
diff -puN net/socket.c~flag-parameters-socket-and-socketpair net/socket.c
--- a/net/socket.c~flag-parameters-socket-and-socketpair
+++ a/net/socket.c
@@ -349,11 +349,11 @@ static struct dentry_operations sockfs_d
  *	but we take care of internal coherence yet.
  */
 
-static int sock_alloc_fd(struct file **filep)
+static int sock_alloc_fd(struct file **filep, int flags)
 {
 	int fd;
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(flags);
 	if (likely(fd >= 0)) {
 		struct file *file = get_empty_filp();
 
@@ -396,10 +396,10 @@ static int sock_attach_fd(struct socket 
 	return 0;
 }
 
-int sock_map_fd(struct socket *sock)
+int sock_map_fd(struct socket *sock, int flags)
 {
 	struct file *newfile;
-	int fd = sock_alloc_fd(&newfile);
+	int fd = sock_alloc_fd(&newfile, flags);
 
 	if (likely(fd >= 0)) {
 		int err = sock_attach_fd(sock, newfile);
@@ -1218,12 +1218,18 @@ asmlinkage long sys_socket(int family, i
 {
 	int retval;
 	struct socket *sock;
+	int flags;
+
+	flags = type & ~SOCK_TYPE_MASK;
+	if (flags & ~SOCK_CLOEXEC)
+		return -EINVAL;
+	type &= SOCK_TYPE_MASK;
 
 	retval = sock_create(family, type, protocol, &sock);
 	if (retval < 0)
 		goto out;
 
-	retval = sock_map_fd(sock);
+	retval = sock_map_fd(sock, flags & O_CLOEXEC);
 	if (retval < 0)
 		goto out_release;
 
@@ -1246,6 +1252,12 @@ asmlinkage long sys_socketpair(int famil
 	struct socket *sock1, *sock2;
 	int fd1, fd2, err;
 	struct file *newfile1, *newfile2;
+	int flags;
+
+	flags = type & ~SOCK_TYPE_MASK;
+	if (flags & ~SOCK_CLOEXEC)
+		return -EINVAL;
+	type &= SOCK_TYPE_MASK;
 
 	/*
 	 * Obtain the first socket and check if the underlying protocol
@@ -1264,13 +1276,13 @@ asmlinkage long sys_socketpair(int famil
 	if (err < 0)
 		goto out_release_both;
 
-	fd1 = sock_alloc_fd(&newfile1);
+	fd1 = sock_alloc_fd(&newfile1, flags & O_CLOEXEC);
 	if (unlikely(fd1 < 0)) {
 		err = fd1;
 		goto out_release_both;
 	}
 
-	fd2 = sock_alloc_fd(&newfile2);
+	fd2 = sock_alloc_fd(&newfile2, flags & O_CLOEXEC);
 	if (unlikely(fd2 < 0)) {
 		err = fd2;
 		put_filp(newfile1);
@@ -1426,7 +1438,7 @@ asmlinkage long sys_accept(int fd, struc
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = sock_alloc_fd(&newfile);
+	newfd = sock_alloc_fd(&newfile, 0);
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch


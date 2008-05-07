From: akpm@linux-foundation.org
Subject: + flag-parameters-paccept.patch added to -mm tree
Date: Wed, 07 May 2008 15:05:34 -0700
Message-ID: <200805072205.m47M5Ysl018828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758710AbYEGWGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: paccept
has been added to the -mm tree.  Its filename is
     flag-parameters-paccept.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: paccept
From: Ulrich Drepper <drepper@redhat.com>

This patch is by far the most complex in the series.  It adds a new syscall
paccept.  This syscall differs from accept in that it adds (at the userlevel)
two additional parameters:

- a signal mask
- a flags value

The flags parameter can be used to set flag like SOCK_CLOEXEC.  This is
imlpemented here as well.  Some people argued that this is a property which
should be inherited from the file desriptor for the server but this is against
POSIX.  Additionally, we really want the signal mask parameter as well
(similar to pselect, ppoll, etc).  So an interface change in inevitable.

The flag value is the same as for socket and socketpair.  I think diverging
here will only create confusion.  Similar to the filesystem interfaces where
the use of the O_* constants differs, it is acceptable here.

The signal mask is handled as for pselect etc.  The mask is temporarily
installed for the thread and removed before the call returns.  I modeled the
code after pselect.  If there is a problem it's likely also in pselect.

For architectures which use socketcall I maintained this interface instead of
adding a system call.  The symmetry shouldn't be broken.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/syscall.h>

#ifndef __NR_paccept
# ifdef __x86_64__
#  define __NR_paccept 288
# elif defined __i386__
#  define SYS_PACCEPT 18
#  define USE_SOCKETCALL 1
# else
#  error "need __NR_paccept"
# endif
#endif

#ifdef USE_SOCKETCALL
# define paccept(fd, addr, addrlen, mask, flags) \
  ({ long args[6] = { \
       (long) fd, (long) addr, (long) addrlen, (long) mask, 8, (long) flags }; \
     syscall (__NR_socketcall, SYS_PACCEPT, args); })
#else
# define paccept(fd, addr, addrlen, mask, flags) \
  syscall (__NR_paccept, fd, addr, addrlen, mask, 8, flags)
#endif

#define PORT 57392

#define SOCK_CLOEXEC O_CLOEXEC

static pthread_barrier_t b;

static void *
tf (void *arg)
{
  pthread_barrier_wait (&b);
  int s = socket (AF_INET, SOCK_STREAM, 0);
  struct sockaddr_in sin;
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = htonl (INADDR_LOOPBACK);
  sin.sin_port = htons (PORT);
  connect (s, (const struct sockaddr *) &sin, sizeof (sin));
  close (s);

  pthread_barrier_wait (&b);
  s = socket (AF_INET, SOCK_STREAM, 0);
  sin.sin_port = htons (PORT);
  connect (s, (const struct sockaddr *) &sin, sizeof (sin));
  close (s);
  pthread_barrier_wait (&b);

  pthread_barrier_wait (&b);
  sleep (2);
  pthread_kill ((pthread_t) arg, SIGUSR1);

  return NULL;
}

static void
handler (int s)
{
}

int
main (void)
{
  pthread_barrier_init (&b, NULL, 2);

  struct sockaddr_in sin;
  pthread_t th;
  if (pthread_create (&th, NULL, tf, (void *) pthread_self ()) != 0)
    {
      puts ("pthread_create failed");
      return 1;
    }

  int s = socket (AF_INET, SOCK_STREAM, 0);
  int reuse = 1;
  setsockopt (s, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof (reuse));
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = htonl (INADDR_LOOPBACK);
  sin.sin_port = htons (PORT);
  bind (s, (struct sockaddr *) &sin, sizeof (sin));
  listen (s, SOMAXCONN);

  pthread_barrier_wait (&b);

  int s2 = paccept (s, NULL, 0, NULL, 0);
  if (s2 < 0)
    {
      puts ("paccept(0) failed");
      return 1;
    }

  int coe = fcntl (s2, F_GETFD);
  if (coe & FD_CLOEXEC)
    {
      puts ("paccept(0) set close-on-exec-flag");
      return 1;
    }
  close (s2);

  pthread_barrier_wait (&b);

  s2 = paccept (s, NULL, 0, NULL, SOCK_CLOEXEC);
  if (s2 < 0)
    {
      puts ("paccept(SOCK_CLOEXEC) failed");
      return 1;
    }

  coe = fcntl (s2, F_GETFD);
  if ((coe & FD_CLOEXEC) == 0)
    {
      puts ("paccept(SOCK_CLOEXEC) does not set close-on-exec flag");
      return 1;
    }
  close (s2);

  pthread_barrier_wait (&b);

  struct sigaction sa;
  sa.sa_handler = handler;
  sa.sa_flags = 0;
  sigemptyset (&sa.sa_mask);
  sigaction (SIGUSR1, &sa, NULL);

  sigset_t ss;
  pthread_sigmask (SIG_SETMASK, NULL, &ss);
  sigaddset (&ss, SIGUSR1);
  pthread_sigmask (SIG_SETMASK, &ss, NULL);

  sigdelset (&ss, SIGUSR1);
  alarm (4);
  pthread_barrier_wait (&b);

  errno = 0 ;
  s2 = paccept (s, NULL, 0, &ss, 0);
  if (s2 != -1 || errno != EINTR)
    {
      puts ("paccept did not fail with EINTR");
      return 1;
    }

  close (s);

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/unistd_64.h |    2 
 include/linux/net.h         |    3 +
 include/linux/syscalls.h    |    2 
 net/compat.c                |   52 ++++++++++++++++++++++--
 net/socket.c                |   71 ++++++++++++++++++++++++++++++----
 5 files changed, 118 insertions(+), 12 deletions(-)

diff -puN include/asm-x86/unistd_64.h~flag-parameters-paccept include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~flag-parameters-paccept
+++ a/include/asm-x86/unistd_64.h
@@ -639,6 +639,8 @@ __SYSCALL(__NR_fallocate, sys_fallocate)
 __SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
 #define __NR_timerfd_gettime			287
 __SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
+#define __NR_paccept				288
+__SYSCALL(__NR_paccept, sys_paccept)
 
 
 #ifndef __NO_STUBS
diff -puN include/linux/net.h~flag-parameters-paccept include/linux/net.h
--- a/include/linux/net.h~flag-parameters-paccept
+++ a/include/linux/net.h
@@ -47,6 +47,7 @@ struct net;
 #define SYS_GETSOCKOPT	15		/* sys_getsockopt(2)		*/
 #define SYS_SENDMSG	16		/* sys_sendmsg(2)		*/
 #define SYS_RECVMSG	17		/* sys_recvmsg(2)		*/
+#define SYS_PACCEPT	18		/* sys_paccept(2)		*/
 
 typedef enum {
 	SS_FREE = 0,			/* not allocated		*/
@@ -219,6 +220,8 @@ extern int 	     sock_map_fd(struct sock
 extern struct socket *sockfd_lookup(int fd, int *err);
 #define		     sockfd_put(sock) fput(sock->file)
 extern int	     net_ratelimit(void);
+extern long	     do_accept(int fd, struct sockaddr __user *upeer_sockaddr,
+			       int __user *upeer_addrlen, int flags);
 
 #define net_random()		random32()
 #define net_srandom(seed)	srandom32((__force u32)seed)
diff -puN include/linux/syscalls.h~flag-parameters-paccept include/linux/syscalls.h
--- a/include/linux/syscalls.h~flag-parameters-paccept
+++ a/include/linux/syscalls.h
@@ -409,6 +409,8 @@ asmlinkage long sys_getsockopt(int fd, i
 asmlinkage long sys_bind(int, struct sockaddr __user *, int);
 asmlinkage long sys_connect(int, struct sockaddr __user *, int);
 asmlinkage long sys_accept(int, struct sockaddr __user *, int __user *);
+asmlinkage long sys_paccept(int, struct sockaddr __user *, int __user *,
+			    const sigset_t *, size_t, int);
 asmlinkage long sys_getsockname(int, struct sockaddr __user *, int __user *);
 asmlinkage long sys_getpeername(int, struct sockaddr __user *, int __user *);
 asmlinkage long sys_send(int, void __user *, size_t, unsigned);
diff -puN net/compat.c~flag-parameters-paccept net/compat.c
--- a/net/compat.c~flag-parameters-paccept
+++ a/net/compat.c
@@ -722,9 +722,10 @@ EXPORT_SYMBOL(compat_mc_getsockopt);
 
 /* Argument list sizes for compat_sys_socketcall */
 #define AL(x) ((x) * sizeof(u32))
-static unsigned char nas[18]={AL(0),AL(3),AL(3),AL(3),AL(2),AL(3),
+static unsigned char nas[19]={AL(0),AL(3),AL(3),AL(3),AL(2),AL(3),
 				AL(3),AL(3),AL(4),AL(4),AL(4),AL(6),
-				AL(6),AL(2),AL(5),AL(5),AL(3),AL(3)};
+				AL(6),AL(2),AL(5),AL(5),AL(3),AL(3),
+				AL(6)};
 #undef AL
 
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg, unsigned flags)
@@ -737,13 +738,52 @@ asmlinkage long compat_sys_recvmsg(int f
 	return sys_recvmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
+asmlinkage long compat_sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
+				   int __user *upeer_addrlen,
+				   const compat_sigset_t __user *sigmask,
+				   compat_size_t sigsetsize, int flags)
+{
+	compat_sigset_t ss32;
+	sigset_t ksigmask, sigsaved;
+	int ret;
+
+	if (sigmask) {
+		if (sigsetsize != sizeof(compat_sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ss32, sigmask, sizeof(ss32)))
+			return -EFAULT;
+		sigset_from_compat(&ksigmask, &ss32);
+
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL)|sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+	}
+
+	ret = do_accept(fd, upeer_sockaddr, upeer_addrlen, flags);
+
+	if (ret == -ERESTARTNOHAND) {
+		/*
+		 * Don't restore the signal mask yet. Let do_signal() deliver
+		 * the signal on the way back to userspace, before the signal
+		 * mask is restored.
+		 */
+		if (sigmask) {
+			memcpy(&current->saved_sigmask, &sigsaved,
+			       sizeof(sigsaved));
+			set_thread_flag(TIF_RESTORE_SIGMASK);
+		}
+	} else if (sigmask)
+		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+
+	return ret;
+}
+
 asmlinkage long compat_sys_socketcall(int call, u32 __user *args)
 {
 	int ret;
 	u32 a[6];
 	u32 a0, a1;
 
-	if (call < SYS_SOCKET || call > SYS_RECVMSG)
+	if (call < SYS_SOCKET || call > SYS_PACCEPT)
 		return -EINVAL;
 	if (copy_from_user(a, args, nas[call]))
 		return -EFAULT;
@@ -764,7 +804,7 @@ asmlinkage long compat_sys_socketcall(in
 		ret = sys_listen(a0, a1);
 		break;
 	case SYS_ACCEPT:
-		ret = sys_accept(a0, compat_ptr(a1), compat_ptr(a[2]));
+		ret = do_accept(a0, compat_ptr(a1), compat_ptr(a[2]), 0);
 		break;
 	case SYS_GETSOCKNAME:
 		ret = sys_getsockname(a0, compat_ptr(a1), compat_ptr(a[2]));
@@ -804,6 +844,10 @@ asmlinkage long compat_sys_socketcall(in
 	case SYS_RECVMSG:
 		ret = compat_sys_recvmsg(a0, compat_ptr(a1), a[2]);
 		break;
+	case SYS_PACCEPT:
+		ret = compat_sys_paccept(a0, compat_ptr(a1), compat_ptr(a[2]),
+					 compat_ptr(a[3]), a[4], a[5]);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff -puN net/socket.c~flag-parameters-paccept net/socket.c
--- a/net/socket.c~flag-parameters-paccept
+++ a/net/socket.c
@@ -1429,14 +1429,17 @@ asmlinkage long sys_listen(int fd, int b
  *	clean when we restucture accept also.
  */
 
-asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
-			   int __user *upeer_addrlen)
+long do_accept(int fd, struct sockaddr __user *upeer_sockaddr,
+	       int __user *upeer_addrlen, int flags)
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
 	int err, len, newfd, fput_needed;
 	char address[MAX_SOCK_ADDR];
 
+	if (flags & ~SOCK_CLOEXEC)
+		return -EINVAL;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1454,7 +1457,7 @@ asmlinkage long sys_accept(int fd, struc
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = sock_alloc_fd(&newfile, 0);
+	newfd = sock_alloc_fd(&newfile, flags & O_CLOEXEC);
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
@@ -1507,6 +1510,50 @@ out_fd:
 	goto out_put;
 }
 
+asmlinkage long sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
+			    int __user *upeer_addrlen,
+			    const sigset_t __user *sigmask,
+			    size_t sigsetsize, int flags)
+{
+	sigset_t ksigmask, sigsaved;
+	int ret;
+
+	if (sigmask) {
+		/* XXX: Don't preclude handling different sized sigset_t's.  */
+		if (sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
+			return -EFAULT;
+
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL)|sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+        }
+
+	ret = do_accept(fd, upeer_sockaddr, upeer_addrlen, flags);
+
+	if (ret < 0 && signal_pending(current)) {
+		/*
+		 * Don't restore the signal mask yet. Let do_signal() deliver
+		 * the signal on the way back to userspace, before the signal
+		 * mask is restored.
+		 */
+		if (sigmask) {
+			memcpy(&current->saved_sigmask, &sigsaved,
+			       sizeof(sigsaved));
+			set_thread_flag(TIF_RESTORE_SIGMASK);
+		}
+	} else if (sigmask)
+		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+
+	return ret;
+}
+
+asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
+			   int __user *upeer_addrlen)
+{
+	return do_accept(fd, upeer_sockaddr, upeer_addrlen, 0);
+}
+
 /*
  *	Attempt to connect to a socket with the server address.  The address
  *	is in user space so we verify it is OK and move it to kernel space.
@@ -2017,10 +2064,11 @@ out:
 
 /* Argument list sizes for sys_socketcall */
 #define AL(x) ((x) * sizeof(unsigned long))
-static const unsigned char nargs[18]={
+static const unsigned char nargs[19]={
 	AL(0),AL(3),AL(3),AL(3),AL(2),AL(3),
 	AL(3),AL(3),AL(4),AL(4),AL(4),AL(6),
-	AL(6),AL(2),AL(5),AL(5),AL(3),AL(3)
+	AL(6),AL(2),AL(5),AL(5),AL(3),AL(3),
+	AL(6)
 };
 
 #undef AL
@@ -2039,7 +2087,7 @@ asmlinkage long sys_socketcall(int call,
 	unsigned long a0, a1;
 	int err;
 
-	if (call < 1 || call > SYS_RECVMSG)
+	if (call < 1 || call > SYS_PACCEPT)
 		return -EINVAL;
 
 	/* copy_from_user should be SMP safe. */
@@ -2070,8 +2118,8 @@ asmlinkage long sys_socketcall(int call,
 		break;
 	case SYS_ACCEPT:
 		err =
-		    sys_accept(a0, (struct sockaddr __user *)a1,
-			       (int __user *)a[2]);
+		    do_accept(a0, (struct sockaddr __user *)a1,
+			      (int __user *)a[2], 0);
 		break;
 	case SYS_GETSOCKNAME:
 		err =
@@ -2118,6 +2166,13 @@ asmlinkage long sys_socketcall(int call,
 	case SYS_RECVMSG:
 		err = sys_recvmsg(a0, (struct msghdr __user *)a1, a[2]);
 		break;
+	case SYS_PACCEPT:
+		err =
+		    sys_paccept(a0, (struct sockaddr __user *)a1,
+			        (int __user *)a[2],
+				(const sigset_t __user *) a[3],
+				a[4], a[5]);
+		break;
 	default:
 		err = -EINVAL;
 		break;
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
sys_pipe-fix-file-descriptor-leaks.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-paccept.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch


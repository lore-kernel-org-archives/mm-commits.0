From: akpm@linux-foundation.org
Subject: + sys_paccept-disable-paccept-until-api-design-is-resolved.patch added to -mm tree
Date: Wed, 17 Sep 2008 23:48:28 -0700
Message-ID: <200809180648.m8I6mS4R018833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbYIRGtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 02:49:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, alan@redhat.com, davem@davemloft.net, davidel@xmailserver.org, drepper@redhat.com, hch@lst.de, jakub@redhat.com, mtk.manpages@gmail.com, oleg@tv-sign.ru, roland@redhat.com, torvalds@linux-foundation.org


The patch titled
     sys_paccept: disable paccept() until API design is resolved
has been added to the -mm tree.  Its filename is
     sys_paccept-disable-paccept-until-api-design-is-resolved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_paccept: disable paccept() until API design is resolved
From: Michael Kerrisk <mtk.manpages@googlemail.com>

The reasons for disabling paccept() are as follows:

* The API is more complex than needed.  There is AFAICS no demonstrated
  use case that the sigset argument of this syscall serves that couldn't
  equally be served by the use of pselect/ppoll/epoll_pwait + traditional
  accept().  Roland seems to concur with this opinion
  (http://thread.gmane.org/gmane.linux.kernel/723953/focus=732255).  I
  have (more than once) asked Ulrich to explain otherwise
  (http://thread.gmane.org/gmane.linux.kernel/723952/focus=731018), but he
  does not respond, so one is left to assume that he doesn't know of such
  a case.

* The use of a sigset argument is not consistent with other I/O APIs
  that can block on a single file descriptor (e.g., read(), recv(),
  connect()).

* The behavior of paccept() when interrupted by a signal is IMO strange:
  the kernel restarts the system call if SA_RESTART was set for the
  handler.  I think that it should not do this -- that it should behave
  consistently with paccept()/ppoll()/epoll_pwait(), which never restart,
  regardless of SA_RESTART.  The reasoning here is that the very purpose
  of paccept() is to wait for a connection or a signal, and that
  restarting in the latter case is probably never useful.  (Note: Roland
  disagrees on this point, believing that rather paccept() should be
  consistent with accept() in its behavior wrt EINTR
  (http://thread.gmane.org/gmane.linux.kernel/723953/focus=732255).)

I believe that instead, a simpler API, consistent with Ulrich's other
recent additions, is preferable:

accept4(int fd, struct sockaddr *sa, socklen_t *salen, ind flags);

(This simpler API was originally proposed by Ulrich:
http://thread.gmane.org/gmane.linux.network/92072)

If this simpler API is added, then if we later decide that the sigset
argument really is required, then a suitable bit in 'flags' could be added
to indicate the presence of the sigset argument.

At this point, I am hoping we either will get a counter-argument from
Ulrich about why we really do need paccept()'s sigset argument, or that he
will resubmit the original accept4() patch.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Alan Cox <alan@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/socket.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN net/socket.c~sys_paccept-disable-paccept-until-api-design-is-resolved net/socket.c
--- a/net/socket.c~sys_paccept-disable-paccept-until-api-design-is-resolved
+++ a/net/socket.c
@@ -1511,6 +1511,7 @@ out_fd:
 	goto out_put;
 }
 
+#if 0
 #ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
 			    int __user *upeer_addrlen,
@@ -1564,6 +1565,7 @@ asmlinkage long sys_paccept(int fd, stru
 	return do_accept(fd, upeer_sockaddr, upeer_addrlen, flags);
 }
 #endif
+#endif
 
 asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
 			   int __user *upeer_addrlen)
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

sys_paccept-disable-paccept-until-api-design-is-resolved.patch
floppy-support-arbitrary-first-sector-numbers.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch


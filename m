From: akpm@linux-foundation.org
Subject: +
 kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch added to -mm tree
Date: Tue, 09 Jul 2013 15:48:02 -0700
Message-ID: <51dc9322.1M5bYHvjMSgYTpX3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3GIWsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 18:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rth@twiddle.net, oleg@redhat.com, mattst88@gmail.com, ink@jurassic.park.msu.ru, davem@davemloft.net, axboe@kernel.dk, mathieu.desnoyers@efficios.com

Subject: + kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch added to -mm tree
To: mathieu.desnoyers@efficios.com,axboe@kernel.dk,davem@davemloft.net,ink@jurassic.park.msu.ru,mattst88@gmail.com,oleg@redhat.com,rth@twiddle.net
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 15:48:02 -0700


The patch titled
     Subject: kernel-wide: fix missing validations on __get/__put/__copy_to/__copy_from_user()
has been added to the -mm tree.  Its filename is
     kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: kernel-wide: fix missing validations on __get/__put/__copy_to/__copy_from_user()

I found the following pattern that leads in to interesting findings:

grep -r "ret.*|=.*__put_user" *
grep -r "ret.*|=.*__get_user" *
grep -r "ret.*|=.*__copy" *

The __put_user() calls in compat_ioctl.c, ptrace compat, signal compat,
since those appear in compat code, we could probably expect the kernel
addresses not to be reachable in the lower 32-bit range, so I think they
might not be exploitable.

For the "__get_user" cases, I don't think those are exploitable: the worse
that can happen is that the kernel will copy kernel memory into in-kernel
buffers, and will fail immediately afterward.

The alpha csum_partial_copy_from_user() seems to be missing the
access_ok() check entirely.  The fix is inspired from x86.  This could
lead to information leak on alpha.  I also noticed that many architectures
map csum_partial_copy_from_user() to csum_partial_copy_generic(), but I
wonder if the latter is performing the access checks on every
architectures.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/csum_partial_copy.c |    5 ++
 arch/sparc/kernel/sys_sparc32.c    |   12 +++---
 block/compat_ioctl.c               |    2 -
 kernel/signal.c                    |    4 +-
 net/socket.c                       |   50 +++++++++++++--------------
 5 files changed, 39 insertions(+), 34 deletions(-)

diff -puN arch/alpha/lib/csum_partial_copy.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user arch/alpha/lib/csum_partial_copy.c
--- a/arch/alpha/lib/csum_partial_copy.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user
+++ a/arch/alpha/lib/csum_partial_copy.c
@@ -338,6 +338,11 @@ csum_partial_copy_from_user(const void _
 	unsigned long doff = 7 & (unsigned long) dst;
 
 	if (len) {
+		if (!access_ok(VERIFY_READ, src, len)) {
+			*errp = -EFAULT;
+			memset(dst, 0, len);
+			return sum;
+		}
 		if (!doff) {
 			if (!soff)
 				checksum = csum_partial_cfu_aligned(
diff -puN arch/sparc/kernel/sys_sparc32.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user arch/sparc/kernel/sys_sparc32.c
--- a/arch/sparc/kernel/sys_sparc32.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user
+++ a/arch/sparc/kernel/sys_sparc32.c
@@ -169,10 +169,10 @@ COMPAT_SYSCALL_DEFINE5(rt_sigaction, int
 		new_ka.ka_restorer = restorer;
 		ret = get_user(u_handler, &act->sa_handler);
 		new_ka.sa.sa_handler =  compat_ptr(u_handler);
-		ret |= __copy_from_user(&set32, &act->sa_mask, sizeof(compat_sigset_t));
+		ret |= copy_from_user(&set32, &act->sa_mask, sizeof(compat_sigset_t));
 		sigset_from_compat(&new_ka.sa.sa_mask, &set32);
-		ret |= __get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		ret |= __get_user(u_restorer, &act->sa_restorer);
+		ret |= get_user(new_ka.sa.sa_flags, &act->sa_flags);
+		ret |= get_user(u_restorer, &act->sa_restorer);
 		new_ka.sa.sa_restorer = compat_ptr(u_restorer);
                 if (ret)
                 	return -EFAULT;
@@ -183,9 +183,9 @@ COMPAT_SYSCALL_DEFINE5(rt_sigaction, int
 	if (!ret && oact) {
 		sigset_to_compat(&set32, &old_ka.sa.sa_mask);
 		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), &oact->sa_handler);
-		ret |= __copy_to_user(&oact->sa_mask, &set32, sizeof(compat_sigset_t));
-		ret |= __put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		ret |= __put_user(ptr_to_compat(old_ka.sa.sa_restorer), &oact->sa_restorer);
+		ret |= copy_to_user(&oact->sa_mask, &set32, sizeof(compat_sigset_t));
+		ret |= put_user(old_ka.sa.sa_flags, &oact->sa_flags);
+		ret |= put_user(ptr_to_compat(old_ka.sa.sa_restorer), &oact->sa_restorer);
 		if (ret)
 			ret = -EFAULT;
         }
diff -puN block/compat_ioctl.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user block/compat_ioctl.c
--- a/block/compat_ioctl.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user
+++ a/block/compat_ioctl.c
@@ -70,7 +70,7 @@ static int compat_hdio_getgeo(struct gen
 		return ret;
 
 	ret = copy_to_user(ugeo, &geo, 4);
-	ret |= __put_user(geo.start, &ugeo->start);
+	ret |= put_user(geo.start, &ugeo->start);
 	if (ret)
 		ret = -EFAULT;
 
diff -puN kernel/ptrace.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user kernel/ptrace.c
diff -puN kernel/signal.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user kernel/signal.c
--- a/kernel/signal.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user
+++ a/kernel/signal.c
@@ -3394,7 +3394,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int
 		new_ka.sa.sa_restorer = compat_ptr(restorer);
 #endif
 		ret |= copy_from_user(&mask, &act->sa_mask, sizeof(mask));
-		ret |= __get_user(new_ka.sa.sa_flags, &act->sa_flags);
+		ret |= get_user(new_ka.sa.sa_flags, &act->sa_flags);
 		if (ret)
 			return -EFAULT;
 		sigset_from_compat(&new_ka.sa.sa_mask, &mask);
@@ -3406,7 +3406,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int
 		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), 
 			       &oact->sa_handler);
 		ret |= copy_to_user(&oact->sa_mask, &mask, sizeof(mask));
-		ret |= __put_user(old_ka.sa.sa_flags, &oact->sa_flags);
+		ret |= put_user(old_ka.sa.sa_flags, &oact->sa_flags);
 #ifdef __ARCH_HAS_SA_RESTORER
 		ret |= put_user(ptr_to_compat(old_ka.sa.sa_restorer),
 				&oact->sa_restorer);
diff -puN net/socket.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user net/socket.c
--- a/net/socket.c~kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user
+++ a/net/socket.c
@@ -3072,12 +3072,12 @@ static int compat_sioc_ifmap(struct net
 
 	uifmap32 = &uifr32->ifr_ifru.ifru_map;
 	err = copy_from_user(&ifr, uifr32, sizeof(ifr.ifr_name));
-	err |= __get_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
-	err |= __get_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
-	err |= __get_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
-	err |= __get_user(ifr.ifr_map.irq, &uifmap32->irq);
-	err |= __get_user(ifr.ifr_map.dma, &uifmap32->dma);
-	err |= __get_user(ifr.ifr_map.port, &uifmap32->port);
+	err |= get_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
+	err |= get_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
+	err |= get_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
+	err |= get_user(ifr.ifr_map.irq, &uifmap32->irq);
+	err |= get_user(ifr.ifr_map.dma, &uifmap32->dma);
+	err |= get_user(ifr.ifr_map.port, &uifmap32->port);
 	if (err)
 		return -EFAULT;
 
@@ -3088,12 +3088,12 @@ static int compat_sioc_ifmap(struct net
 
 	if (cmd == SIOCGIFMAP && !err) {
 		err = copy_to_user(uifr32, &ifr, sizeof(ifr.ifr_name));
-		err |= __put_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
-		err |= __put_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
-		err |= __put_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
-		err |= __put_user(ifr.ifr_map.irq, &uifmap32->irq);
-		err |= __put_user(ifr.ifr_map.dma, &uifmap32->dma);
-		err |= __put_user(ifr.ifr_map.port, &uifmap32->port);
+		err |= put_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
+		err |= put_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
+		err |= put_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
+		err |= put_user(ifr.ifr_map.irq, &uifmap32->irq);
+		err |= put_user(ifr.ifr_map.dma, &uifmap32->dma);
+		err |= put_user(ifr.ifr_map.port, &uifmap32->port);
 		if (err)
 			err = -EFAULT;
 	}
@@ -3167,25 +3167,25 @@ static int routing_ioctl(struct net *net
 		struct in6_rtmsg32 __user *ur6 = argp;
 		ret = copy_from_user(&r6.rtmsg_dst, &(ur6->rtmsg_dst),
 			3 * sizeof(struct in6_addr));
-		ret |= __get_user(r6.rtmsg_type, &(ur6->rtmsg_type));
-		ret |= __get_user(r6.rtmsg_dst_len, &(ur6->rtmsg_dst_len));
-		ret |= __get_user(r6.rtmsg_src_len, &(ur6->rtmsg_src_len));
-		ret |= __get_user(r6.rtmsg_metric, &(ur6->rtmsg_metric));
-		ret |= __get_user(r6.rtmsg_info, &(ur6->rtmsg_info));
-		ret |= __get_user(r6.rtmsg_flags, &(ur6->rtmsg_flags));
-		ret |= __get_user(r6.rtmsg_ifindex, &(ur6->rtmsg_ifindex));
+		ret |= get_user(r6.rtmsg_type, &(ur6->rtmsg_type));
+		ret |= get_user(r6.rtmsg_dst_len, &(ur6->rtmsg_dst_len));
+		ret |= get_user(r6.rtmsg_src_len, &(ur6->rtmsg_src_len));
+		ret |= get_user(r6.rtmsg_metric, &(ur6->rtmsg_metric));
+		ret |= get_user(r6.rtmsg_info, &(ur6->rtmsg_info));
+		ret |= get_user(r6.rtmsg_flags, &(ur6->rtmsg_flags));
+		ret |= get_user(r6.rtmsg_ifindex, &(ur6->rtmsg_ifindex));
 
 		r = (void *) &r6;
 	} else { /* ipv4 */
 		struct rtentry32 __user *ur4 = argp;
 		ret = copy_from_user(&r4.rt_dst, &(ur4->rt_dst),
 					3 * sizeof(struct sockaddr));
-		ret |= __get_user(r4.rt_flags, &(ur4->rt_flags));
-		ret |= __get_user(r4.rt_metric, &(ur4->rt_metric));
-		ret |= __get_user(r4.rt_mtu, &(ur4->rt_mtu));
-		ret |= __get_user(r4.rt_window, &(ur4->rt_window));
-		ret |= __get_user(r4.rt_irtt, &(ur4->rt_irtt));
-		ret |= __get_user(rtdev, &(ur4->rt_dev));
+		ret |= get_user(r4.rt_flags, &(ur4->rt_flags));
+		ret |= get_user(r4.rt_metric, &(ur4->rt_metric));
+		ret |= get_user(r4.rt_mtu, &(ur4->rt_mtu));
+		ret |= get_user(r4.rt_window, &(ur4->rt_window));
+		ret |= get_user(r4.rt_irtt, &(ur4->rt_irtt));
+		ret |= get_user(rtdev, &(ur4->rt_dev));
 		if (rtdev) {
 			ret |= copy_from_user(devname, compat_ptr(rtdev), 15);
 			r4.rt_dev = (char __user __force *)devname;
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch


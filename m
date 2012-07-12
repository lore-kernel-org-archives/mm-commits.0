From: akpm@linux-foundation.org
Subject: + nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:28:13 -0700
Message-ID: <20120712212814.6AAE1100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55659 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161093Ab2GLV2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:28:16 -0400
Received: by qabg24 with SMTP id g24so301088qab.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:28:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: nbd: set SOCK_MEMALLOC for access to PFMEMALLOC reserves
has been added to the -mm tree.  Its filename is
     nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: nbd: set SOCK_MEMALLOC for access to PFMEMALLOC reserves

Set SOCK_MEMALLOC on the NBD socket to allow access to PFMEMALLOC reserves
so pages backed by NBD, particularly if swap related, can be cleaned to
prevent the machine being deadlocked.  It is still possible that the
PFMEMALLOC reserves get depleted resulting in deadlock but this can be
resolved by the administrator by increasing min_free_kbytes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves
+++ a/drivers/block/nbd.c
@@ -154,6 +154,7 @@ static int sock_xmit(struct nbd_device *
 	struct msghdr msg;
 	struct kvec iov;
 	sigset_t blocked, oldset;
+	unsigned long pflags = current->flags;
 
 	if (unlikely(!sock)) {
 		dev_err(disk_to_dev(nbd->disk),
@@ -167,8 +168,9 @@ static int sock_xmit(struct nbd_device *
 	siginitsetinv(&blocked, sigmask(SIGKILL));
 	sigprocmask(SIG_SETMASK, &blocked, &oldset);
 
+	current->flags |= PF_MEMALLOC;
 	do {
-		sock->sk->sk_allocation = GFP_NOIO;
+		sock->sk->sk_allocation = GFP_NOIO | __GFP_MEMALLOC;
 		iov.iov_base = buf;
 		iov.iov_len = size;
 		msg.msg_name = NULL;
@@ -214,6 +216,7 @@ static int sock_xmit(struct nbd_device *
 	} while (size > 0);
 
 	sigprocmask(SIG_SETMASK, &oldset, NULL);
+	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 
 	return result;
 }
@@ -405,6 +408,7 @@ static int nbd_do_it(struct nbd_device *
 
 	BUG_ON(nbd->magic != NBD_MAGIC);
 
+	sk_set_memalloc(nbd->sock->sk);
 	nbd->pid = task_pid_nr(current);
 	ret = device_create_file(disk_to_dev(nbd->disk), &pid_attr);
 	if (ret) {
_
Subject: Subject: nbd: set SOCK_MEMALLOC for access to PFMEMALLOC reserves

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch


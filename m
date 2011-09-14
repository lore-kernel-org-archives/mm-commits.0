From: akpm@linux-foundation.org
Subject: + net-netfilter-nf_conntrack_netlinkc-fix-oops-on-container-destroy.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:43:36 -0700
Message-ID: <201109142043.p8EKhahi027001@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:22726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1INUos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex@alex.org.uk, davem@davemloft.net, kaber@trash.net, stable@kernel.org


The patch titled
     net/netfilter/nf_conntrack_netlink.c: fix Oops on container destroy
has been added to the -mm tree.  Its filename is
     net-netfilter-nf_conntrack_netlinkc-fix-oops-on-container-destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destroy
From: Alex Bligh <alex@alex.org.uk>

Problem:

A repeatable Oops can be caused if a container with networking
unshared is destroyed when it has nf_conntrack entries yet to expire.

A copy of the oops follows below. A perl program generating the oops
repeatably is attached inline below.

Analysis:

The oops is called from cleanup_net when the namespace is
destroyed. conntrack iterates through outstanding events and calls
death_by_timeout on each of them, which in turn produces a call to
ctnetlink_conntrack_event. This calls nf_netlink_has_listeners, which
oopses because net->nfnl is NULL.

The perl program generates the container through fork() then
clone(NS_NEWNET). I does not explicitly	set up netlink
explicitly set up netlink, but I presume it was set up else net->nfnl
would have been NULL earlier (i.e. when an earlier connection
timed out). This would thus suggest that net->nfnl is made NULL
during the destruction of the container, which I think is done by
nfnetlink_net_exit_batch.

I can see that the various subsystems are deinitialised in the opposite
order to which the relevant register_pernet_subsys calls are called,
and both nf_conntrack and nfnetlink_net_ops register their relevant
subsystems. If nfnetlink_net_ops registered later than nfconntrack,
then its exit routine would have been called first, which would cause
the oops described. I am not sure there is anything to prevent this
happening in a container environment.

Whilst there's perhaps a more complex problem revolving around ordering
of subsystem deinit, it seems to me that missing a netlink event on a
container that is dying is not a disaster. An early check for net->nfnl
being non-NULL in ctnetlink_conntrack_event appears to fix this. There
may remain a potential race condition if it becomes NULL immediately
after being checked (I am not sure any lock is held at this point or
how synchronisation for subsystem deinitialization works).

Patch:

The patch attached should apply on everything from 2.6.26 (if not before)
onwards; it appears to be a problem on all kernels. This was taken against
Ubuntu-3.0.0-11.17 which is very close to 3.0.4. I have torture-tested it
with the above perl script for 15 minutes or so; the perl script hung the
machine within 20 seconds without this patch.

Applicability:

If this is the right solution, it should be applied to all stable kernels
as well as head. Apart from the minor overhead of checking one variable
against NULL, it can never 'do the wrong thing', because if net->nfnl
is NULL, an oops will inevitably result. Therefore, checking is a reasonable
thing to do unless it can be proven than net->nfnl will never be NULL.

Check net->nfnl for NULL in ctnetlink_conntrack_event to avoid Oops on
container destroy

Signed-off-by: Alex Bligh <alex@alex.org.uk>
Cc: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_conntrack_netlink.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN net/netfilter/nf_conntrack_netlink.c~fix-repeatable-oops-on-container-destroy-with-conntrack net/netfilter/nf_conntrack_netlink.c
--- a/net/netfilter/nf_conntrack_netlink.c~fix-repeatable-oops-on-container-destroy-with-conntrack
+++ a/net/netfilter/nf_conntrack_netlink.c
@@ -570,6 +570,11 @@ ctnetlink_conntrack_event(unsigned int e
 		return 0;
 
 	net = nf_ct_net(ct);
+
+	/* container deinit, netlink may have died before death_by_timeout */
+	if (!net->nfnl)
+		return 0;
+
 	if (!item->report && !nfnetlink_has_listeners(net, group))
 		return 0;
 
_

Patches currently in -mm which might be from alex@alex.org.uk are

net-netfilter-nf_conntrack_netlinkc-fix-oops-on-container-destroy.patch


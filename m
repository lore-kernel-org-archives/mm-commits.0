From: akpm@linux-foundation.org
Subject: + ip-justification-for-local-port-range-robustness.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:18:13 -0700
Message-ID: <200710182118.l9ILIDWK031649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbXJRVSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:18:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarapov@redhat.com, davem@davemloft.net, shemminger@linux-foundation.org


The patch titled
     ip: justification for local port range robustness
has been added to the -mm tree.  Its filename is
     ip-justification-for-local-port-range-robustness.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ip: justification for local port range robustness
From: Anton Arapov <aarapov@redhat.com>

There is a justifying patch for Stephen's patches.  Stephen's patches
disallows using a port range of one single port and brakes the meaning of the
'remaining' variable, in some places it has different meaning.  My patch gives
back the sense of 'remaining' variable.  It should mean how many ports are
remaining and nothing else.  Also my patch allows using a single port.

I am sure we must be able to use mentioned port range, this does not
restricted by documentation and does not brake current behavior.

usefull links:
Patches posted by Stephen Hemminger
  http://marc.info/?l=linux-netdev&m=119206106218187&w=2
  http://marc.info/?l=linux-netdev&m=119206109918235&w=2

Andrew Morton's comment
  http://marc.info/?l=linux-kernel&m=119248225007737&w=2

  1. Allows using a port range of one single port.
  2. Gives back sense of 'remaining' variable.

Signed-off-by: Anton Arapov <aarapov@redhat.com>
Acked-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/cma.c   |    5 +++--
 net/ipv4/inet_connection_sock.c |    2 +-
 net/ipv4/inet_hashtables.c      |    2 +-
 net/ipv4/sysctl_net_ipv4.c      |    4 ++--
 net/ipv4/udp.c                  |    5 +++--
 net/ipv6/inet6_hashtables.c     |    2 +-
 6 files changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/infiniband/core/cma.c~ip-justification-for-local-port-range-robustness drivers/infiniband/core/cma.c
--- a/drivers/infiniband/core/cma.c~ip-justification-for-local-port-range-robustness
+++ a/drivers/infiniband/core/cma.c
@@ -2803,11 +2803,12 @@ static void cma_remove_one(struct ib_dev
 
 static int cma_init(void)
 {
-	int ret, low, high;
+	int ret, low, high, remaining;
 
 	get_random_bytes(&next_port, sizeof next_port);
 	inet_get_local_port_range(&low, &high);
-	next_port = ((unsigned int) next_port % (high - low)) + low;
+	remaining = (high - low) + 1;
+	next_port = ((unsigned int) next_port % remaining) + low;
 
 	cma_wq = create_singlethread_workqueue("rdma_cm");
 	if (!cma_wq)
diff -puN net/ipv4/inet_connection_sock.c~ip-justification-for-local-port-range-robustness net/ipv4/inet_connection_sock.c
--- a/net/ipv4/inet_connection_sock.c~ip-justification-for-local-port-range-robustness
+++ a/net/ipv4/inet_connection_sock.c
@@ -93,7 +93,7 @@ int inet_csk_get_port(struct inet_hashin
 		int remaining, rover, low, high;
 
 		inet_get_local_port_range(&low, &high);
-		remaining = high - low;
+		remaining = (high - low) + 1;
 		rover = net_random() % remaining + low;
 
 		do {
diff -puN net/ipv4/inet_hashtables.c~ip-justification-for-local-port-range-robustness net/ipv4/inet_hashtables.c
--- a/net/ipv4/inet_hashtables.c~ip-justification-for-local-port-range-robustness
+++ a/net/ipv4/inet_hashtables.c
@@ -286,7 +286,7 @@ int inet_hash_connect(struct inet_timewa
 		struct inet_timewait_sock *tw = NULL;
 
 		inet_get_local_port_range(&low, &high);
-		remaining = high - low;
+		remaining = (high - low) + 1;
 
 		local_bh_disable();
 		for (i = 1; i <= remaining; i++) {
diff -puN net/ipv4/sysctl_net_ipv4.c~ip-justification-for-local-port-range-robustness net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c~ip-justification-for-local-port-range-robustness
+++ a/net/ipv4/sysctl_net_ipv4.c
@@ -122,7 +122,7 @@ static int ipv4_local_port_range(ctl_tab
 	ret = proc_dointvec_minmax(&tmp, write, filp, buffer, lenp, ppos);
 
 	if (write && ret == 0) {
-		if (range[1] <= range[0])
+		if (range[1] < range[0])
 			ret = -EINVAL;
 		else
 			set_local_port_range(range);
@@ -150,7 +150,7 @@ static int ipv4_sysctl_local_port_range(
 
 	ret = sysctl_intvec(&tmp, name, nlen, oldval, oldlenp, newval, newlen);
 	if (ret == 0 && newval && newlen) {
-		if (range[1] <= range[0])
+		if (range[1] < range[0])
 			ret = -EINVAL;
 		else
 			set_local_port_range(range);
diff -puN net/ipv4/udp.c~ip-justification-for-local-port-range-robustness net/ipv4/udp.c
--- a/net/ipv4/udp.c~ip-justification-for-local-port-range-robustness
+++ a/net/ipv4/udp.c
@@ -147,13 +147,14 @@ int __udp_lib_get_port(struct sock *sk, 
 	write_lock_bh(&udp_hash_lock);
 
 	if (!snum) {
-		int i, low, high;
+		int i, low, high, remaining;
 		unsigned rover, best, best_size_so_far;
 
 		inet_get_local_port_range(&low, &high);
+		remaining = (high - low) + 1;
 
 		best_size_so_far = UINT_MAX;
-		best = rover = net_random() % (high - low) + low;
+		best = rover = net_random() % remaining + low;
 
 		/* 1st pass: look for empty (or shortest) hash chain */
 		for (i = 0; i < UDP_HTABLE_SIZE; i++) {
diff -puN net/ipv6/inet6_hashtables.c~ip-justification-for-local-port-range-robustness net/ipv6/inet6_hashtables.c
--- a/net/ipv6/inet6_hashtables.c~ip-justification-for-local-port-range-robustness
+++ a/net/ipv6/inet6_hashtables.c
@@ -261,7 +261,7 @@ int inet6_hash_connect(struct inet_timew
 		struct inet_timewait_sock *tw = NULL;
 
 		inet_get_local_port_range(&low, &high);
-		remaining = high - low;
+		remaining = (high - low) + 1;
 
 		local_bh_disable();
 		for (i = 1; i <= remaining; i++) {
_

Patches currently in -mm which might be from aarapov@redhat.com are

origin.patch
ip-justification-for-local-port-range-robustness.patch

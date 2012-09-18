From: akpm@linux-foundation.org
Subject: [merged] include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:05:07 -0700
Message-ID: <20120918190508.3BE575C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60295 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab2IRTFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:05:11 -0400
Received: by eaac1 with SMTP id c1so8572eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:05:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, davem@davemloft.net, js1304@gmail.com, mgorman@suse.de, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/net/sock.h: squelch compiler warning in sk_rmem_schedule()
has been removed from the -mm tree.  Its filename was
     include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chuck Lever <chuck.lever@oracle.com>
Subject: include/net/sock.h: squelch compiler warning in sk_rmem_schedule()

In file included from linux/include/linux/tcp.h:227:0,
                 from linux/include/linux/ipv6.h:221,
                 from linux/include/net/ipv6.h:16,
                 from linux/include/linux/sunrpc/clnt.h:26,
                 from linux/net/sunrpc/stats.c:22:
linux/include/net/sock.h: In function `sk_rmem_schedule':
linux/nfs-2.6/include/net/sock.h:1339:13: warning: comparison between
  signed and unsigned integer expressions [-Wsign-compare]

Seen with gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2) using the
-Wextra option.

c76562b6 ("netvm: prevent a stream-specific deadlock") accidentally
replaced the "size" parameter of sk_rmem_schedule() with an unsigned int. 
This changes the semantics of the comparison in the return statement.

In sk_wmem_schedule we have syntactically the same comparison, but "size"
is a signed integer.  In addition, __sk_mem_schedule() takes a signed
integer for its "size" parameter, so there is an implicit type conversion
in sk_rmem_schedule() anyway.

Revert the "size" parameter back to a signed integer so that the semantics
of the expressions in both sk_[rw]mem_schedule() are exactly the same.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/net/sock.h~include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule include/net/sock.h
--- a/include/net/sock.h~include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule
+++ a/include/net/sock.h
@@ -1332,7 +1332,7 @@ static inline bool sk_wmem_schedule(stru
 }
 
 static inline bool
-sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, unsigned int size)
+sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
 {
 	if (!sk_has_account(sk))
 		return true;
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
linux-next.patch


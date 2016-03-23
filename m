From: akpm@linux-foundation.org
Subject: [merged]
 net-sctp-use-in_compat_syscall-for-sctp_getsockopt_connectx3.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:40:47 -0700
Message-ID: <56f2d51f.jb5vO4JwCumj3G2c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbcCWRks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, davem@davemloft.net, nhorman@tuxdriver.com, vyasevich@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/sctp: use in_compat_syscall for sctp_getsockopt_connectx3
has been removed from the -mm tree.  Its filename was
     net-sctp-use-in_compat_syscall-for-sctp_getsockopt_connectx3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: net/sctp: use in_compat_syscall for sctp_getsockopt_connectx3

SCTP unfortunately has a different ABI for SCTP_SOCKOPT_CONNECTX3
for 32-bit and 64-bit callers.  Use in_compat_syscall to correctly
distinguish them on all architectures.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sctp/socket.c~net-sctp-use-in_compat_syscall-for-sctp_getsockopt_connectx3 net/sctp/socket.c
--- a/net/sctp/socket.c~net-sctp-use-in_compat_syscall-for-sctp_getsockopt_connectx3
+++ a/net/sctp/socket.c
@@ -1389,7 +1389,7 @@ static int sctp_getsockopt_connectx3(str
 	int err = 0;
 
 #ifdef CONFIG_COMPAT
-	if (is_compat_task()) {
+	if (in_compat_syscall()) {
 		struct compat_sctp_getaddrs_old param32;
 
 		if (len < sizeof(param32))
_

Patches currently in -mm which might be from luto@kernel.org are



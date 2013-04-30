From: akpm@linux-foundation.org
Subject: [merged] net-rename-random32-to-prandom.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:03:08 -0700
Message-ID: <20130430190308.7634B31C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:39201 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3TDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:03:09 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so87581ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:03:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net: rename random32 to prandom
has been removed from the -mm tree.  Its filename was
     net-rename-random32-to-prandom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: net: rename random32 to prandom

Commit 496f2f93b1cc286f5a4f4f9acdc1e5314978683f ("random32: rename
random32 to prandom") renamed random32() and srandom32() to prandom_u32()
and prandom_seed() respectively.

net_random() and net_srandom() need to be redefined with prandom_* in
order to finish the naming transition.

While I'm at it, enclose macro argument of net_srandom() with parenthesis.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/net.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/net.h~net-rename-random32-to-prandom include/linux/net.h
--- a/include/linux/net.h~net-rename-random32-to-prandom
+++ a/include/linux/net.h
@@ -240,8 +240,8 @@ do {								\
 #define net_dbg_ratelimited(fmt, ...)				\
 	net_ratelimited_function(pr_debug, fmt, ##__VA_ARGS__)
 
-#define net_random()		random32()
-#define net_srandom(seed)	srandom32((__force u32)seed)
+#define net_random()		prandom_u32()
+#define net_srandom(seed)	prandom_seed((__force u32)(seed))
 
 extern int   	     kernel_sendmsg(struct socket *sock, struct msghdr *msg,
 				    struct kvec *vec, size_t num, size_t len);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch


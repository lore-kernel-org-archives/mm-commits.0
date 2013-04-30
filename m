From: akpm@linux-foundation.org
Subject: [merged] net-sunrpc-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:53 -0700
Message-ID: <20130430190253.80D8A5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39392 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:54 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so87591yen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Trond.Myklebust@netapp.com, bfields@fieldses.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net/sunrpc: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     net-sunrpc-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: net/sunrpc: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/gss_krb5_wrap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/sunrpc/auth_gss/gss_krb5_wrap.c~net-sunrpc-rename-random32-to-prandom_u32 net/sunrpc/auth_gss/gss_krb5_wrap.c
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c~net-sunrpc-rename-random32-to-prandom_u32
+++ a/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -130,8 +130,8 @@ gss_krb5_make_confounder(char *p, u32 co
 
 	/* initialize to random value */
 	if (i == 0) {
-		i = random32();
-		i = (i << 32) | random32();
+		i = prandom_u32();
+		i = (i << 32) | prandom_u32();
 	}
 
 	switch (conflen) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch


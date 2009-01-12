From: akpm@linux-foundation.org
Subject: - net-bridge-netfilter-move-a-dereference-below-a-null-test.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:30 -0800
Message-ID: <200901121958.n0CJwUVN027656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759AbZALT7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 14:59:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     net/bridge/netfilter: move a dereference below a NULL test
has been removed from the -mm tree.  Its filename was
     net-bridge-netfilter-move-a-dereference-below-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/bridge/netfilter: move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bridge/netfilter/ebtables.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/bridge/netfilter/ebtables.c~net-bridge-netfilter-move-a-dereference-below-a-null-test net/bridge/netfilter/ebtables.c
--- a/net/bridge/netfilter/ebtables.c~net-bridge-netfilter-move-a-dereference-below-a-null-test
+++ a/net/bridge/netfilter/ebtables.c
@@ -85,12 +85,13 @@ static inline int ebt_do_match (struct e
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
 {
 	int i = 0;
-	const char *devname = device->name;
+	const char *devname;
 
 	if (*entry == '\0')
 		return 0;
 	if (!device)
 		return 1;
+	devname = device->name;
 	/* 1 is the wildcard token */
 	while (entry[i] != '\0' && entry[i] != 1 && entry[i] == devname[i])
 		i++;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch


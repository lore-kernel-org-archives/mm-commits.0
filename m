From: akpm@osdl.org
Subject: - x25-add-missing-sock_put-in-x25_receive_data.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:46:53 -0800
Message-ID: <200701222046.l0MKkrO1001592@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbXAVUrE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ahendry@tusc.com.au, andrew.hendry@gmail.com, mm-commits@vger.kernel.org


The patch titled
     X.25 Add missing sock_put in x25_receive_data
has been removed from the -mm tree.  Its filename was
     x25-add-missing-sock_put-in-x25_receive_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: X.25 Add missing sock_put in x25_receive_data
From: ahendry <ahendry@tusc.com.au>

__x25_find_socket does a sock_hold.  This adds a missing sock_put in
x25_receive_data.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/x25/x25_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/x25/x25_dev.c~x25-add-missing-sock_put-in-x25_receive_data net/x25/x25_dev.c
--- a/net/x25/x25_dev.c~x25-add-missing-sock_put-in-x25_receive_data
+++ a/net/x25/x25_dev.c
@@ -56,6 +56,7 @@ static int x25_receive_data(struct sk_bu
 			sk_add_backlog(sk, skb);
 		}
 		bh_unlock_sock(sk);
+		sock_put(sk);
 		return queued;
 	}
 
_

Patches currently in -mm which might be from ahendry@tusc.com.au are

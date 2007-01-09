From: akpm@osdl.org
Subject: + x25-add-missing-sock_put-in-x25_receive_data.patch added to -mm tree
Date: Mon, 08 Jan 2007 20:31:24 -0800
Message-ID: <200701090431.l094VOZX028441@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbXAIEbr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 23:31:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ahendry@tusc.com.au, andrew.hendry@gmail.com


The patch titled
     X.25 Add missing sock_put in x25_receive_data
has been added to the -mm tree.  Its filename is
     x25-add-missing-sock_put-in-x25_receive_data.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x25-add-missing-sock_put-in-x25_receive_data.patch

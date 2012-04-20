From: akpm@linux-foundation.org
Subject: [merged] w1-add-fast-search-for-single-slave-bus.patch removed from -mm tree
Date: Fri, 20 Apr 2012 13:12:21 -0700
Message-ID: <20120420201221.D8E81A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:37693 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DTUMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 16:12:22 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so1144921yen.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 13:12:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h.feurstein@gmail.com, dagenaisj@sonatest.com, greg@kroah.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: w1: add fast search for single slave bus
has been removed from the -mm tree.  Its filename was
     w1-add-fast-search-for-single-slave-bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hubert Feurstein <h.feurstein@gmail.com>
Subject: w1: add fast search for single slave bus

This enables a much more efficient way of device searching.  It uses the
1-wire read-rom operation which allows the direct reading of the slave
address.  BUT this works only with exactly one slave on the bus.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Cc: Jean-Franois Dagenais <dagenaisj@sonatest.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/w1/w1.c~w1-add-fast-search-for-single-slave-bus drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-add-fast-search-for-single-slave-bus
+++ a/drivers/w1/w1.c
@@ -902,6 +902,16 @@ void w1_search(struct w1_master *dev, u8
 			break;
 		}
 
+		/* Do fast search on single slave bus */
+		if (dev->max_slave_count == 1) {
+			w1_write_8(dev, W1_READ_ROM);
+
+			if (w1_read_block(dev, (u8 *)&rn, 8) == 8 && rn)
+				cb(dev, rn);
+
+			break;
+		}
+
 		/* Start the search */
 		w1_write_8(dev, search_type);
 		for (i = 0; i < 64; ++i) {
_

Patches currently in -mm which might be from h.feurstein@gmail.com are



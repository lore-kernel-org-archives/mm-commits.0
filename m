From: akpm@linux-foundation.org
Subject: + w1-add-fast-search-for-single-slave-bus.patch added to -mm tree
Date: Fri, 20 Apr 2012 13:12:00 -0700
Message-ID: <20120420201200.9BEF8A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:37693 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DTUMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 16:12:02 -0400
Received: by yenq2 with SMTP id q2so1144921yen.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 13:12:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h.feurstein@gmail.com, dagenaisj@sonatest.com, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: w1: add fast search for single slave bus
has been added to the -mm tree.  Its filename is
     w1-add-fast-search-for-single-slave-bus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: w1: add fast search for single slave bus

Patches currently in -mm which might be from h.feurstein@gmail.com are

w1-add-fast-search-for-single-slave-bus.patch


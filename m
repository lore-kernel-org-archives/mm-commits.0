From: akpm@osdl.org
Subject: + ipmi-fix-timeout-list-handling.patch added to -mm tree
Date: Tue, 30 Jan 2007 11:45:08 -0800
Message-ID: <200701301945.l0UJj83j026973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbXA3TsW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 14:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amatus@ocgnet.org, minyard@acm.org


The patch titled
     IPMI: fix timeout list handling
has been added to the -mm tree.  Its filename is
     ipmi-fix-timeout-list-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IPMI: fix timeout list handling
From: David Barksdale <amatus@ocgnet.org>

Fix a dangling pointer bug in ipmi_timeout_handler.  A list of timedout
messages is not re-initialized before reuse, causing the head of the list
to point to freed memory.

Signed-off-by: David Barksdale <amatus@ocgnet.org>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-timeout-list-handling drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-timeout-list-handling
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -3654,8 +3654,6 @@ static void ipmi_timeout_handler(long ti
 	unsigned long        flags;
 	int                  i;
 
-	INIT_LIST_HEAD(&timeouts);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
 		/* See if any waiting messages need to be processed. */
@@ -3676,6 +3674,7 @@ static void ipmi_timeout_handler(long ti
 		/* Go through the seq table and find any messages that
 		   have timed out, putting them in the timeouts
 		   list. */
+		INIT_LIST_HEAD(&timeouts);
 		spin_lock_irqsave(&intf->seq_lock, flags);
 		for (i = 0; i < IPMI_IPMB_NUM_SEQ; i++)
 			check_msg_timeout(intf, &(intf->seq_table[i]),
_

Patches currently in -mm which might be from amatus@ocgnet.org are

ipmi-fix-timeout-list-handling.patch

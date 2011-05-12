From: akpm@linux-foundation.org
Subject: + net-irda-ircomm_ttyc-use-flip-buffers-to-deliver-data.patch added to -mm tree
Date: Thu, 12 May 2011 14:35:12 -0700
Message-ID: <201105122135.p4CLZCAo002906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757879Ab1ELVfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 17:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit.virdi@st.com, alan@linux.intel.com, sameo@linux.intel.com


The patch titled
     net/irda/ircomm_tty.c: use flip buffers to deliver data
has been added to the -mm tree.  Its filename is
     net-irda-ircomm_ttyc-use-flip-buffers-to-deliver-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/irda/ircomm_tty.c: use flip buffers to deliver data
From: Amit Virdi <amit.virdi@st.com>

use tty_insert_flip_string() and tty_flip_buffer_push() to deliver
incoming data packets from the IrDA device instead of delivering the
packets directly to the line discipline.  Following later approach
resulted in warning "Sleeping function called from invalid context".

Signed-off-by: Amit Virdi <amit.virdi@st.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/irda/ircomm/ircomm_tty.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN net/irda/ircomm/ircomm_tty.c~net-irda-ircomm_ttyc-use-flip-buffers-to-deliver-data net/irda/ircomm/ircomm_tty.c
--- a/net/irda/ircomm/ircomm_tty.c~net-irda-ircomm_ttyc-use-flip-buffers-to-deliver-data
+++ a/net/irda/ircomm/ircomm_tty.c
@@ -38,6 +38,7 @@
 #include <linux/seq_file.h>
 #include <linux/termios.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>		/* for MODULE_ALIAS_CHARDEV_MAJOR */
 
@@ -1132,7 +1133,6 @@ static int ircomm_tty_data_indication(vo
 				      struct sk_buff *skb)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) instance;
-	struct tty_ldisc *ld;
 
 	IRDA_DEBUG(2, "%s()\n", __func__ );
 
@@ -1161,15 +1161,11 @@ static int ircomm_tty_data_indication(vo
 	}
 
 	/*
-	 * Just give it over to the line discipline. There is no need to
-	 * involve the flip buffers, since we are not running in an interrupt
-	 * handler
+	 * Use flip buffer functions since the code may be called from interrupt
+	 * context
 	 */

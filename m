From: akpm@linux-foundation.org
Subject: + gru-driver-v2-kernel-services-header-files.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:30:33 -0700
Message-ID: <200807010530.m615UXUa010818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbYGAFbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, andrea@qumranet.com, holt@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     GRU driver: kernel services header files
has been added to the -mm tree.  Its filename is
     gru-driver-v2-kernel-services-header-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU driver: kernel services header files
From: Jack Steiner <steiner@sgi.com>

The header file used to export GRU services to other kernel drivers such
as XPMEM or XPNET.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.h |  130 ++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff -puN /dev/null drivers/misc/sgi-gru/grukservices.h
--- /dev/null
+++ a/drivers/misc/sgi-gru/grukservices.h
@@ -0,0 +1,130 @@
+
+/*
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+#ifndef __GRU_KSERVICES_H_
+#define __GRU_KSERVICES_H_
+
+
+/*
+ * Message queues using the GRU to send/receive messages.
+ *
+ * These function allow the user to create a message queue for
+ * sending/receiving 1 or 2 cacheline messages using the GRU.
+ *
+ * Processes SENDING messages will use a kernel CBR/DSR to send
+ * the message. This is transparent to the caller.
+ *
+ * The receiver does not use any GRU resources.
+ *
+ * The functions support:
+ * 	- single receiver
+ * 	- multiple senders
+ *	- cross partition message
+ *
+ * Missing features ZZZ:
+ * 	- user options for dealing with timeouts, queue full, etc.
+ * 	- gru_create_message_queue() needs interrupt vector info
+ */
+
+/*
+ * Initialize a user allocated chunk of memory to be used as
+ * a message queue. The caller must ensure that the queue is
+ * in contiguous physical memory and is cacheline aligned.
+ *
+ * Message queue size is the total number of bytes allocated
+ * to the queue including a 2 cacheline header that is used
+ * to manage the queue.
+ *
+ *  Input:
+ * 	p	pointer to user allocated memory.
+ * 	bytes	size of message queue in bytes
+ *
+ *  Errors:
+ *  	0	OK
+ *  	>0	error
+ */
+extern int gru_create_message_queue(void *p, unsigned int bytes);
+
+/*
+ * Send a message to a message queue
+ *
+ *   Input:
+ * 	xmq	message queue - must be a UV global physical address
+ * 	mesg	pointer to message. Must be 64-bit aligned
+ * 	bytes	size of message in bytes
+ *
+ *   Output:
+ *      0	message sent
+ *     >0	Send failure - see error codes below
+ *
+ */
+extern int gru_send_message_gpa(unsigned long mq_gpa, void *mesg,
+						unsigned int bytes);
+
+/* Status values for gru_send_message() */
+#define MQE_OK			0	/* message sent successfully */
+#define MQE_CONGESTION		1	/* temporary congestion, try again */
+#define MQE_QUEUE_FULL		2	/* queue is full */
+#define MQE_PAGE_OVERFLOW	3	/* queue overflowed a page */
+#define MQE_UNEXPECTED_CB_ERR	4	/* unexpected CB error */
+#define MQE_BUG_NO_RESOURCES	10	/* BUG - could not alloc GRU cb/dsr */
+
+/*
+ * Advance the receive pointer for the message queue to the next message.
+ * Note: current API requires messages to be gotten & freed in order. Future
+ * API extensions may allow for out-of-order freeing.
+ *
+ *   Input
+ * 	mq	message queue
+ * 	mesq	message being freed
+ */
+extern void gru_free_message(void *mq, void *mesq);
+
+/*
+ * Get next message from message queue. Returns pointer to
+ * message OR NULL if no message present.
+ * User must call gru_free_message() after message is processed
+ * in order to move the queue pointers to next message.
+ *
+ *   Input
+ * 	mq	message queue
+ *
+ *   Output:
+ *	p	pointer to message
+ *	NULL	no message available
+ */
+extern void *gru_get_next_message(void *mq);
+
+
+/*
+ * Copy data using the GRU. Source or destination can be located in a remote
+ * partition.
+ *
+ *    Input:
+ *    	dest_gpa	destination global physical address
+ *    	src_gpa		source global physical address
+ *    	bytes		number of bytes to copy
+ *
+ *    Output:
+ *	0		OK
+ *	>0		error
+ */
+extern int gru_copy_gpa(unsigned long dest_gpa, unsigned long src_gpa,
+							unsigned int bytes);
+
+#endif 		/* __GRU_KSERVICES_H_ */
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-driver-v2-hardware-data-structures.patch
gru-driver-v2-gru-instructions-macros.patch
gru-driver-v2-driver-internal-header-files.patch
gru-driver-v2-kernel-services-header-files.patch
gru-driver-v2-driver-initialization-file-vma-ops.patch
gru-driver-v2-page-faults-exceptions.patch
gru-driver-v2-kernel-services-provide-by-driver.patch
gru-driver-v2-resource-management.patch
gru-driver-v2-proc-interfaces.patch
gru-driver-v2-tlb-flushing-mmuops-callouts.patch
gru-driver-v2-driver-makefile.patch
gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v2-driver-misc-makefile-kconfig-changes.patch


From: akpm@linux-foundation.org
Subject: - ipmi-style-fixes-in-the-system-interface-code.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:52 -0700
Message-ID: <200804300544.m3U5iqi1029449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758021AbYD3Fqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, rocky.craig@hp.com, schulz@schwaar.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: Style fixes in the system interface code
has been removed from the -mm tree.  Its filename was
     ipmi-style-fixes-in-the-system-interface-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPMI: Style fixes in the system interface code
From: Corey Minyard <cminyard@mvista.com>

Lots of style fixes for the IPMI system interface driver.  No functional
changes.  Basically fixes everything reported by checkpatch and fixes the
comment style.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Rocky Craig <rocky.craig@hp.com>
Cc: Hannes Schulz <schulz@schwaar.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_bt_sm.c   |  153 +++++----
 drivers/char/ipmi/ipmi_kcs_sm.c  |  153 +++++----
 drivers/char/ipmi/ipmi_si_intf.c |  466 ++++++++++++++++-------------
 drivers/char/ipmi/ipmi_si_sm.h   |   89 +++--
 drivers/char/ipmi/ipmi_smic_sm.c |  149 ++++-----
 5 files changed, 574 insertions(+), 436 deletions(-)

diff -puN drivers/char/ipmi/ipmi_bt_sm.c~ipmi-style-fixes-in-the-system-interface-code drivers/char/ipmi/ipmi_bt_sm.c
--- a/drivers/char/ipmi/ipmi_bt_sm.c~ipmi-style-fixes-in-the-system-interface-code
+++ a/drivers/char/ipmi/ipmi_bt_sm.c
@@ -37,26 +37,32 @@
 #define BT_DEBUG_ENABLE	1	/* Generic messages */
 #define BT_DEBUG_MSG	2	/* Prints all request/response buffers */
 #define BT_DEBUG_STATES	4	/* Verbose look at state changes */
-/* BT_DEBUG_OFF must be zero to correspond to the default uninitialized
-   value */
+/*
+ * BT_DEBUG_OFF must be zero to correspond to the default uninitialized
+ * value
+ */
 
 static int bt_debug; /* 0 == BT_DEBUG_OFF */
 
 module_param(bt_debug, int, 0644);
 MODULE_PARM_DESC(bt_debug, "debug bitmask, 1=enable, 2=messages, 4=states");
 
-/* Typical "Get BT Capabilities" values are 2-3 retries, 5-10 seconds,
-   and 64 byte buffers.  However, one HP implementation wants 255 bytes of
-   buffer (with a documented message of 160 bytes) so go for the max.
-   Since the Open IPMI architecture is single-message oriented at this
-   stage, the queue depth of BT is of no concern. */
+/*
+ * Typical "Get BT Capabilities" values are 2-3 retries, 5-10 seconds,
+ * and 64 byte buffers.  However, one HP implementation wants 255 bytes of
+ * buffer (with a documented message of 160 bytes) so go for the max.
+ * Since the Open IPMI architecture is single-message oriented at this
+ * stage, the queue depth of BT is of no concern.
+ */
 
 #define BT_NORMAL_TIMEOUT	5	/* seconds */
 #define BT_NORMAL_RETRY_LIMIT	2
 #define BT_RESET_DELAY		6	/* seconds after warm reset */
 
-/* States are written in chronological order and usually cover
-   multiple rows of the state table discussion in the IPMI spec. */
+/*
+ * States are written in chronological order and usually cover
+ * multiple rows of the state table discussion in the IPMI spec.
+ */
 
 enum bt_states {
 	BT_STATE_IDLE = 0,	/* Order is critical in this list */
@@ -76,10 +82,12 @@ enum bt_states {
 	BT_STATE_LONG_BUSY	/* BT doesn't get hosed :-) */
 };
 
-/* Macros seen at the end of state "case" blocks.  They help with legibility
-   and debugging. */
+/*
+ * Macros seen at the end of state "case" blocks.  They help with legibility
+ * and debugging.
+ */
 
-#define BT_STATE_CHANGE(X,Y) { bt->state = X; return Y; }
+#define BT_STATE_CHANGE(X, Y) { bt->state = X; return Y; }
 
 #define BT_SI_SM_RETURN(Y)   { last_printed = BT_STATE_PRINTME; return Y; }
 
@@ -110,11 +118,13 @@ struct si_sm_data {
 #define BT_H_BUSY	0x40
 #define BT_B_BUSY	0x80
 
-/* Some bits are toggled on each write: write once to set it, once
-   more to clear it; writing a zero does nothing.  To absolutely
-   clear it, check its state and write if set.  This avoids the "get
-   current then use as mask" scheme to modify one bit.  Note that the
-   variable "bt" is hardcoded into these macros. */
+/*
+ * Some bits are toggled on each write: write once to set it, once
+ * more to clear it; writing a zero does nothing.  To absolutely
+ * clear it, check its state and write if set.  This avoids the "get
+ * current then use as mask" scheme to modify one bit.  Note that the
+ * variable "bt" is hardcoded into these macros.
+ */
 
 #define BT_STATUS	bt->io->inputb(bt->io, 0)
 #define BT_CONTROL(x)	bt->io->outputb(bt->io, 0, x)
@@ -125,8 +135,10 @@ struct si_sm_data {
 #define BT_INTMASK_R	bt->io->inputb(bt->io, 2)
 #define BT_INTMASK_W(x)	bt->io->outputb(bt->io, 2, x)
 
-/* Convenience routines for debugging.  These are not multi-open safe!
-   Note the macros have hardcoded variables in them. */
+/*
+ * Convenience routines for debugging.  These are not multi-open safe!
+ * Note the macros have hardcoded variables in them.
+ */
 
 static char *state2txt(unsigned char state)
 {
@@ -182,7 +194,8 @@ static char *status2txt(unsigned char st
 static unsigned int bt_init_data(struct si_sm_data *bt, struct si_sm_io *io)
 {
 	memset(bt, 0, sizeof(struct si_sm_data));
-	if (bt->io != io) {		/* external: one-time only things */
+	if (bt->io != io) {
+		/* external: one-time only things */
 		bt->io = io;
 		bt->seq = 0;
 	}
@@ -229,7 +242,7 @@ static int bt_start_transaction(struct s
 		printk(KERN_WARNING "BT: +++++++++++++++++ New command\n");
 		printk(KERN_WARNING "BT: NetFn/LUN CMD [%d data]:", size - 2);
 		for (i = 0; i < size; i ++)
-			printk (" %02x", data[i]);
+			printk(" %02x", data[i]);
 		printk("\n");
 	}
 	bt->write_data[0] = size + 1;	/* all data plus seq byte */
@@ -246,8 +259,10 @@ static int bt_start_transaction(struct s
 	return 0;
 }
 
-/* After the upper state machine has been told SI_SM_TRANSACTION_COMPLETE
-   it calls this.  Strip out the length and seq bytes. */
+/*
+ * After the upper state machine has been told SI_SM_TRANSACTION_COMPLETE
+ * it calls this.  Strip out the length and seq bytes.
+ */
 
 static int bt_get_result(struct si_sm_data *bt,
 			 unsigned char *data,
@@ -269,10 +284,10 @@ static int bt_get_result(struct si_sm_da
 		memcpy(data + 2, bt->read_data + 4, msg_len - 2);
 
 	if (bt_debug & BT_DEBUG_MSG) {
-		printk (KERN_WARNING "BT: result %d bytes:", msg_len);
+		printk(KERN_WARNING "BT: result %d bytes:", msg_len);
 		for (i = 0; i < msg_len; i++)
 			printk(" %02x", data[i]);
-		printk ("\n");
+		printk("\n");
 	}
 	return msg_len;
 }
@@ -292,8 +307,10 @@ static void reset_flags(struct si_sm_dat
 	BT_INTMASK_W(BT_BMC_HWRST);
 }
 
-/* Get rid of an unwanted/stale response.  This should only be needed for
-   BMCs that support multiple outstanding requests. */
+/*
+ * Get rid of an unwanted/stale response.  This should only be needed for
+ * BMCs that support multiple outstanding requests.
+ */
 
 static void drain_BMC2HOST(struct si_sm_data *bt)
 {
@@ -326,8 +343,8 @@ static inline void write_all_bytes(struc
 		printk(KERN_WARNING "BT: write %d bytes seq=0x%02X",
 			bt->write_count, bt->seq);
 		for (i = 0; i < bt->write_count; i++)
-			printk (" %02x", bt->write_data[i]);
-		printk ("\n");
+			printk(" %02x", bt->write_data[i]);
+		printk("\n");
 	}
 	for (i = 0; i < bt->write_count; i++)
 		HOST2BMC(bt->write_data[i]);
@@ -337,8 +354,10 @@ static inline int read_all_bytes(struct 
 {
 	unsigned char i;
 
-	/* length is "framing info", minimum = 4: NetFn, Seq, Cmd, cCode.
-	   Keep layout of first four bytes aligned with write_data[] */
+	/*
+	 * length is "framing info", minimum = 4: NetFn, Seq, Cmd, cCode.
+	 * Keep layout of first four bytes aligned with write_data[]
+	 */
 
 	bt->read_data[0] = BMC2HOST;
 	bt->read_count = bt->read_data[0];
@@ -362,8 +381,8 @@ static inline int read_all_bytes(struct 
 		if (max > 16)
 			max = 16;
 		for (i = 0; i < max; i++)
-			printk (" %02x", bt->read_data[i]);
-		printk ("%s\n", bt->read_count == max ? "" : " ...");
+			printk(KERN_CONT " %02x", bt->read_data[i]);
+		printk(KERN_CONT "%s\n", bt->read_count == max ? "" : " ...");
 	}
 
 	/* per the spec, the (NetFn[1], Seq[2], Cmd[3]) tuples must match */
@@ -402,8 +421,10 @@ static enum si_sm_result error_recovery(
 	printk(KERN_WARNING "IPMI BT: %s in %s %s ", 	/* open-ended line */
 		reason, STATE2TXT, STATUS2TXT);
 
-	/* Per the IPMI spec, retries are based on the sequence number
-	   known only to this module, so manage a restart here. */
+	/*
+	 * Per the IPMI spec, retries are based on the sequence number
+	 * known only to this module, so manage a restart here.
+	 */
 	(bt->error_retries)++;
 	if (bt->error_retries < bt->BT_CAP_retries) {
 		printk("%d retries left\n",
@@ -412,8 +433,8 @@ static enum si_sm_result error_recovery(
 		return SI_SM_CALL_WITHOUT_DELAY;
 	}
 
-	printk("failed %d retries, sending error response\n",
-		bt->BT_CAP_retries);
+	printk(KERN_WARNING "failed %d retries, sending error response\n",
+	       bt->BT_CAP_retries);
 	if (!bt->nonzero_status)
 		printk(KERN_ERR "IPMI BT: stuck, try power cycle\n");
 
@@ -424,8 +445,10 @@ static enum si_sm_result error_recovery(
 		return SI_SM_CALL_WITHOUT_DELAY;
 	}
 
-	/* Concoct a useful error message, set up the next state, and
-	   be done with this sequence. */
+	/*
+	 * Concoct a useful error message, set up the next state, and
+	 * be done with this sequence.
+	 */
 
 	bt->state = BT_STATE_IDLE;
 	switch (cCode) {
@@ -461,10 +484,12 @@ static enum si_sm_result bt_event(struct
 		last_printed = bt->state;
 	}
 
-	/* Commands that time out may still (eventually) provide a response.
-	   This stale response will get in the way of a new response so remove
-	   it if possible (hopefully during IDLE).  Even if it comes up later
-	   it will be rejected by its (now-forgotten) seq number. */
+	/*
+	 * Commands that time out may still (eventually) provide a response.
+	 * This stale response will get in the way of a new response so remove
+	 * it if possible (hopefully during IDLE).  Even if it comes up later
+	 * it will be rejected by its (now-forgotten) seq number.
+	 */
 
 	if ((bt->state < BT_STATE_WRITE_BYTES) && (status & BT_B2H_ATN)) {
 		drain_BMC2HOST(bt);
@@ -472,7 +497,8 @@ static enum si_sm_result bt_event(struct
 	}
 
 	if ((bt->state != BT_STATE_IDLE) &&
-	    (bt->state <  BT_STATE_PRINTME)) {		/* check timeout */
+	    (bt->state <  BT_STATE_PRINTME)) {
+		/* check timeout */
 		bt->timeout -= time;
 		if ((bt->timeout < 0) && (bt->state < BT_STATE_RESET1))
 			return error_recovery(bt,
@@ -482,8 +508,10 @@ static enum si_sm_result bt_event(struct
 
 	switch (bt->state) {
 
-	/* Idle state first checks for asynchronous messages from another
-	   channel, then does some opportunistic housekeeping. */
+	/*
+	 * Idle state first checks for asynchronous messages from another
+	 * channel, then does some opportunistic housekeeping.
+	 */
 
 	case BT_STATE_IDLE:
 		if (status & BT_SMS_ATN) {
@@ -531,16 +559,19 @@ static enum si_sm_result bt_event(struct
 			BT_SI_SM_RETURN(SI_SM_CALL_WITH_DELAY);
 		BT_CONTROL(BT_H_BUSY);		/* set */
 
-		/* Uncached, ordered writes should just proceeed serially but
-		   some BMCs don't clear B2H_ATN with one hit.  Fast-path a
-		   workaround without too much penalty to the general case. */
+		/*
+		 * Uncached, ordered writes should just proceeed serially but
+		 * some BMCs don't clear B2H_ATN with one hit.  Fast-path a
+		 * workaround without too much penalty to the general case.
+		 */
 
 		BT_CONTROL(BT_B2H_ATN);		/* clear it to ACK the BMC */
 		BT_STATE_CHANGE(BT_STATE_CLEAR_B2H,
 				SI_SM_CALL_WITHOUT_DELAY);
 
 	case BT_STATE_CLEAR_B2H:
-		if (status & BT_B2H_ATN) {	/* keep hitting it */
+		if (status & BT_B2H_ATN) {
+			/* keep hitting it */
 			BT_CONTROL(BT_B2H_ATN);
 			BT_SI_SM_RETURN(SI_SM_CALL_WITH_DELAY);
 		}
@@ -548,7 +579,8 @@ static enum si_sm_result bt_event(struct
 				SI_SM_CALL_WITHOUT_DELAY);
 
 	case BT_STATE_READ_BYTES:
-		if (!(status & BT_H_BUSY))	/* check in case of retry */
+		if (!(status & BT_H_BUSY))
+			/* check in case of retry */
 			BT_CONTROL(BT_H_BUSY);
 		BT_CONTROL(BT_CLR_RD_PTR);	/* start of BMC2HOST buffer */
 		i = read_all_bytes(bt);		/* true == packet seq match */
@@ -599,8 +631,10 @@ static enum si_sm_result bt_event(struct
 		BT_STATE_CHANGE(BT_STATE_XACTION_START,
 				SI_SM_CALL_WITH_DELAY);
 
-	/* Get BT Capabilities, using timing of upper level state machine.
-	   Set outreqs to prevent infinite loop on timeout. */
+	/*
+	 * Get BT Capabilities, using timing of upper level state machine.
+	 * Set outreqs to prevent infinite loop on timeout.
+	 */
 	case BT_STATE_CAPABILITIES_BEGIN:
 		bt->BT_CAP_outreqs = 1;
 		{
@@ -638,10 +672,12 @@ static enum si_sm_result bt_event(struct
 
 static int bt_detect(struct si_sm_data *bt)
 {
-	/* It's impossible for the BT status and interrupt registers to be
-	   all 1's, (assuming a properly functioning, self-initialized BMC)
-	   but that's what you get from reading a bogus address, so we
-	   test that first.  The calling routine uses negative logic. */
+	/*
+	 * It's impossible for the BT status and interrupt registers to be
+	 * all 1's, (assuming a properly functioning, self-initialized BMC)
+	 * but that's what you get from reading a bogus address, so we
+	 * test that first.  The calling routine uses negative logic.
+	 */
 
 	if ((BT_STATUS == 0xFF) && (BT_INTMASK_R == 0xFF))
 		return 1;
@@ -658,8 +694,7 @@ static int bt_size(void)
 	return sizeof(struct si_sm_data);
 }
 
-struct si_sm_handlers bt_smi_handlers =
-{
+struct si_sm_handlers bt_smi_handlers = {
 	.init_data		= bt_init_data,
 	.start_transaction	= bt_start_transaction,
 	.get_result		= bt_get_result,
diff -puN drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-style-fixes-in-the-system-interface-code drivers/char/ipmi/ipmi_kcs_sm.c
--- a/drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-style-fixes-in-the-system-interface-code
+++ a/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -60,37 +60,58 @@ MODULE_PARM_DESC(kcs_debug, "debug bitma
 
 /* The states the KCS driver may be in. */
 enum kcs_states {
-	KCS_IDLE,		/* The KCS interface is currently
-                                   doing nothing. */
-	KCS_START_OP,		/* We are starting an operation.  The
-				   data is in the output buffer, but
-				   nothing has been done to the
-				   interface yet.  This was added to
-				   the state machine in the spec to
-				   wait for the initial IBF. */
-	KCS_WAIT_WRITE_START,	/* We have written a write cmd to the
-				   interface. */
-	KCS_WAIT_WRITE,		/* We are writing bytes to the
-                                   interface. */
-	KCS_WAIT_WRITE_END,	/* We have written the write end cmd
-                                   to the interface, and still need to
-                                   write the last byte. */
-	KCS_WAIT_READ,		/* We are waiting to read data from
-				   the interface. */
-	KCS_ERROR0,		/* State to transition to the error
-				   handler, this was added to the
-				   state machine in the spec to be
-				   sure IBF was there. */
-	KCS_ERROR1,		/* First stage error handler, wait for
-                                   the interface to respond. */
-	KCS_ERROR2,		/* The abort cmd has been written,
-				   wait for the interface to
-				   respond. */
-	KCS_ERROR3,		/* We wrote some data to the
-				   interface, wait for it to switch to
-				   read mode. */
-	KCS_HOSED		/* The hardware failed to follow the
-				   state machine. */
+	/* The KCS interface is currently doing nothing. */
+	KCS_IDLE,
+
+	/*
+	 * We are starting an operation.  The data is in the output
+	 * buffer, but nothing has been done to the interface yet.  This
+	 * was added to the state machine in the spec to wait for the
+	 * initial IBF.
+	 */
+	KCS_START_OP,
+
+	/* We have written a write cmd to the interface. */
+	KCS_WAIT_WRITE_START,
+
+	/* We are writing bytes to the interface. */
+	KCS_WAIT_WRITE,
+
+	/*
+	 * We have written the write end cmd to the interface, and
+	 * still need to write the last byte.
+	 */
+	KCS_WAIT_WRITE_END,
+
+	/* We are waiting to read data from the interface. */
+	KCS_WAIT_READ,
+
+	/*
+	 * State to transition to the error handler, this was added to
+	 * the state machine in the spec to be sure IBF was there.
+	 */
+	KCS_ERROR0,
+
+	/*
+	 * First stage error handler, wait for the interface to
+	 * respond.
+	 */
+	KCS_ERROR1,
+
+	/*
+	 * The abort cmd has been written, wait for the interface to
+	 * respond.
+	 */
+	KCS_ERROR2,
+
+	/*
+	 * We wrote some data to the interface, wait for it to switch
+	 * to read mode.
+	 */
+	KCS_ERROR3,
+
+	/* The hardware failed to follow the state machine. */
+	KCS_HOSED
 };
 
 #define MAX_KCS_READ_SIZE IPMI_MAX_MSG_LENGTH
@@ -102,8 +123,7 @@ enum kcs_states {
 #define MAX_ERROR_RETRIES 10
 #define ERROR0_OBF_WAIT_JIFFIES (2*HZ)
 
-struct si_sm_data
-{
+struct si_sm_data {
 	enum kcs_states  state;
 	struct si_sm_io *io;
 	unsigned char    write_data[MAX_KCS_WRITE_SIZE];
@@ -187,7 +207,8 @@ static inline void start_error_recovery(
 	(kcs->error_retries)++;
 	if (kcs->error_retries > MAX_ERROR_RETRIES) {
 		if (kcs_debug & KCS_DEBUG_ENABLE)
-			printk(KERN_DEBUG "ipmi_kcs_sm: kcs hosed: %s\n", reason);
+			printk(KERN_DEBUG "ipmi_kcs_sm: kcs hosed: %s\n",
+			       reason);
 		kcs->state = KCS_HOSED;
 	} else {
 		kcs->error0_timeout = jiffies + ERROR0_OBF_WAIT_JIFFIES;
@@ -271,10 +292,9 @@ static int start_kcs_transaction(struct 
 
 	if (kcs_debug & KCS_DEBUG_MSG) {
 		printk(KERN_DEBUG "start_kcs_transaction -");
-		for (i = 0; i < size; i ++) {
+		for (i = 0; i < size; i++)
 			printk(" %02x", (unsigned char) (data [i]));
-		}
-		printk ("\n");
+		printk("\n");
 	}
 	kcs->error_retries = 0;
 	memcpy(kcs->write_data, data, size);
@@ -305,9 +325,11 @@ static int get_kcs_result(struct si_sm_d
 		kcs->read_pos = 3;
 	}
 	if (kcs->truncated) {
-		/* Report a truncated error.  We might overwrite
-		   another error, but that's too bad, the user needs
-		   to know it was truncated. */
+		/*
+		 * Report a truncated error.  We might overwrite
+		 * another error, but that's too bad, the user needs
+		 * to know it was truncated.
+		 */
 		data[2] = IPMI_ERR_MSG_TRUNCATED;
 		kcs->truncated = 0;
 	}
@@ -315,9 +337,11 @@ static int get_kcs_result(struct si_sm_d
 	return kcs->read_pos;
 }
 
-/* This implements the state machine defined in the IPMI manual, see
-   that for details on how this works.  Divide that flowchart into
-   sections delimited by "Wait for IBF" and this will become clear. */
+/*
+ * This implements the state machine defined in the IPMI manual, see
+ * that for details on how this works.  Divide that flowchart into
+ * sections delimited by "Wait for IBF" and this will become clear.
+ */
 static enum si_sm_result kcs_event(struct si_sm_data *kcs, long time)
 {
 	unsigned char status;
@@ -388,11 +412,12 @@ static enum si_sm_result kcs_event(struc
 			write_next_byte(kcs);
 		}
 		break;
-		
+
 	case KCS_WAIT_WRITE_END:
 		if (state != KCS_WRITE_STATE) {
 			start_error_recovery(kcs,
-					     "Not in write state for write end");
+					     "Not in write state"
+					     " for write end");
 			break;
 		}
 		clear_obf(kcs, status);
@@ -413,13 +438,15 @@ static enum si_sm_result kcs_event(struc
 				return SI_SM_CALL_WITH_DELAY;
 			read_next_byte(kcs);
 		} else {
-			/* We don't implement this exactly like the state
-			   machine in the spec.  Some broken hardware
-			   does not write the final dummy byte to the
-			   read register.  Thus obf will never go high
-			   here.  We just go straight to idle, and we
-			   handle clearing out obf in idle state if it
-			   happens to come in. */
+			/*
+			 * We don't implement this exactly like the state
+			 * machine in the spec.  Some broken hardware
+			 * does not write the final dummy byte to the
+			 * read register.  Thus obf will never go high
+			 * here.  We just go straight to idle, and we
+			 * handle clearing out obf in idle state if it
+			 * happens to come in.
+			 */
 			clear_obf(kcs, status);
 			kcs->orig_write_count = 0;
 			kcs->state = KCS_IDLE;
@@ -430,7 +457,8 @@ static enum si_sm_result kcs_event(struc
 	case KCS_ERROR0:
 		clear_obf(kcs, status);
 		status = read_status(kcs);
-		if  (GET_STATUS_OBF(status)) /* controller isn't responding */
+		if (GET_STATUS_OBF(status))
+			/* controller isn't responding */
 			if (time_before(jiffies, kcs->error0_timeout))
 				return SI_SM_CALL_WITH_TICK_DELAY;
 		write_cmd(kcs, KCS_GET_STATUS_ABORT);
@@ -442,7 +470,7 @@ static enum si_sm_result kcs_event(struc
 		write_data(kcs, 0);
 		kcs->state = KCS_ERROR2;
 		break;
-		
+
 	case KCS_ERROR2:
 		if (state != KCS_READ_STATE) {
 			start_error_recovery(kcs,
@@ -456,7 +484,7 @@ static enum si_sm_result kcs_event(struc
 		write_data(kcs, KCS_READ_BYTE);
 		kcs->state = KCS_ERROR3;
 		break;
-		
+
 	case KCS_ERROR3:
 		if (state != KCS_IDLE_STATE) {
 			start_error_recovery(kcs,
@@ -475,7 +503,7 @@ static enum si_sm_result kcs_event(struc
 			return SI_SM_TRANSACTION_COMPLETE;
 		}
 		break;
-			
+
 	case KCS_HOSED:
 		break;
 	}
@@ -495,10 +523,12 @@ static int kcs_size(void)
 
 static int kcs_detect(struct si_sm_data *kcs)
 {
-	/* It's impossible for the KCS status register to be all 1's,
-	   (assuming a properly functioning, self-initialized BMC)
-	   but that's what you get from reading a bogus address, so we
-	   test that first. */
+	/*
+	 * It's impossible for the KCS status register to be all 1's,
+	 * (assuming a properly functioning, self-initialized BMC)
+	 * but that's what you get from reading a bogus address, so we
+	 * test that first.
+	 */
 	if (read_status(kcs) == 0xff)
 		return 1;
 
@@ -509,8 +539,7 @@ static void kcs_cleanup(struct si_sm_dat
 {
 }
 
-struct si_sm_handlers kcs_smi_handlers =
-{
+struct si_sm_handlers kcs_smi_handlers = {
 	.init_data         = init_kcs_data,
 	.start_transaction = start_kcs_transaction,
 	.get_result        = get_kcs_result,
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-style-fixes-in-the-system-interface-code drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-style-fixes-in-the-system-interface-code
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -80,7 +80,7 @@
 #define SI_USEC_PER_JIFFY	(1000000/HZ)
 #define SI_TIMEOUT_JIFFIES	(SI_TIMEOUT_TIME_USEC/SI_USEC_PER_JIFFY)
 #define SI_SHORT_TIMEOUT_USEC  250 /* .25ms when the SM request a
-                                       short timeout */
+				      short timeout */
 
 /* Bit for BMC global enables. */
 #define IPMI_BMC_RCV_MSG_INTR     0x01
@@ -114,8 +114,7 @@ static char *si_to_str[] = { "kcs", "smi
 
 #define DEVICE_NAME "ipmi_si"
 
-static struct device_driver ipmi_driver =
-{
+static struct device_driver ipmi_driver = {
 	.name = DEVICE_NAME,
 	.bus = &platform_bus_type
 };
@@ -169,8 +168,7 @@ enum si_stat_indexes {
 	SI_NUM_STATS
 };
 
-struct smi_info
-{
+struct smi_info {
 	int                    intf_num;
 	ipmi_smi_t             intf;
 	struct si_sm_data      *si_sm;
@@ -183,8 +181,10 @@ struct smi_info
 	struct ipmi_smi_msg    *curr_msg;
 	enum si_intf_state     si_state;
 
-	/* Used to handle the various types of I/O that can occur with
-           IPMI */
+	/*
+	 * Used to handle the various types of I/O that can occur with
+	 * IPMI
+	 */
 	struct si_sm_io io;
 	int (*io_setup)(struct smi_info *info);
 	void (*io_cleanup)(struct smi_info *info);
@@ -195,15 +195,18 @@ struct smi_info
 	void (*addr_source_cleanup)(struct smi_info *info);
 	void *addr_source_data;
 
-	/* Per-OEM handler, called from handle_flags().
-	   Returns 1 when handle_flags() needs to be re-run
-	   or 0 indicating it set si_state itself.
-	*/
+	/*
+	 * Per-OEM handler, called from handle_flags().  Returns 1
+	 * when handle_flags() needs to be re-run or 0 indicating it
+	 * set si_state itself.
+	 */
 	int (*oem_data_avail_handler)(struct smi_info *smi_info);
 
-	/* Flags from the last GET_MSG_FLAGS command, used when an ATTN
-	   is set to hold the flags until we are done handling everything
-	   from the flags. */
+	/*
+	 * Flags from the last GET_MSG_FLAGS command, used when an ATTN
+	 * is set to hold the flags until we are done handling everything
+	 * from the flags.
+	 */
 #define RECEIVE_MSG_AVAIL	0x01
 #define EVENT_MSG_BUFFER_FULL	0x02
 #define WDT_PRE_TIMEOUT_INT	0x08
@@ -211,25 +214,31 @@ struct smi_info
 #define OEM1_DATA_AVAIL     0x40
 #define OEM2_DATA_AVAIL     0x80
 #define OEM_DATA_AVAIL      (OEM0_DATA_AVAIL | \
-                             OEM1_DATA_AVAIL | \
-                             OEM2_DATA_AVAIL)
+			     OEM1_DATA_AVAIL | \
+			     OEM2_DATA_AVAIL)
 	unsigned char       msg_flags;
 
-	/* If set to true, this will request events the next time the
-	   state machine is idle. */
+	/*
+	 * If set to true, this will request events the next time the
+	 * state machine is idle.
+	 */
 	atomic_t            req_events;
 
-	/* If true, run the state machine to completion on every send
-	   call.  Generally used after a panic to make sure stuff goes
-	   out. */
+	/*
+	 * If true, run the state machine to completion on every send
+	 * call.  Generally used after a panic to make sure stuff goes
+	 * out.
+	 */
 	int                 run_to_completion;
 
 	/* The I/O port of an SI interface. */
 	int                 port;
 
-	/* The space between start addresses of the two ports.  For
-	   instance, if the first port is 0xca2 and the spacing is 4, then
-	   the second port is 0xca6. */
+	/*
+	 * The space between start addresses of the two ports.  For
+	 * instance, if the first port is 0xca2 and the spacing is 4, then
+	 * the second port is 0xca6.
+	 */
 	unsigned int        spacing;
 
 	/* zero if no irq; */
@@ -244,10 +253,12 @@ struct smi_info
 	/* Used to gracefully stop the timer without race conditions. */
 	atomic_t            stop_operation;
 
-	/* The driver will disable interrupts when it gets into a
-	   situation where it cannot handle messages due to lack of
-	   memory.  Once that situation clears up, it will re-enable
-	   interrupts. */
+	/*
+	 * The driver will disable interrupts when it gets into a
+	 * situation where it cannot handle messages due to lack of
+	 * memory.  Once that situation clears up, it will re-enable
+	 * interrupts.
+	 */
 	int interrupt_disabled;
 
 	/* From the get device id response... */
@@ -257,8 +268,10 @@ struct smi_info
 	struct device *dev;
 	struct platform_device *pdev;
 
-	 /* True if we allocated the device, false if it came from
-	  * someplace else (like PCI). */
+	/*
+	 * True if we allocated the device, false if it came from
+	 * someplace else (like PCI).
+	 */
 	int dev_registered;
 
 	/* Slave address, could be reported from DMI. */
@@ -267,7 +280,7 @@ struct smi_info
 	/* Counters and things for the proc filesystem. */
 	atomic_t stats[SI_NUM_STATS];
 
-        struct task_struct *thread;
+	struct task_struct *thread;
 
 	struct list_head link;
 };
@@ -288,7 +301,7 @@ static int try_smi_init(struct smi_info 
 static void cleanup_one_si(struct smi_info *to_clean);
 
 static ATOMIC_NOTIFIER_HEAD(xaction_notifier_list);
-static int register_xaction_notifier(struct notifier_block * nb)
+static int register_xaction_notifier(struct notifier_block *nb)
 {
 	return atomic_notifier_chain_register(&xaction_notifier_list, nb);
 }
@@ -297,7 +310,7 @@ static void deliver_recv_msg(struct smi_
 			     struct ipmi_smi_msg *msg)
 {
 	/* Deliver the message to the upper layer with the lock
-           released. */
+	   released. */
 	spin_unlock(&(smi_info->si_lock));
 	ipmi_smi_msg_received(smi_info->intf, msg);
 	spin_lock(&(smi_info->si_lock));
@@ -329,8 +342,10 @@ static enum si_sm_result start_next_msg(
 	struct timeval t;
 #endif
 
-	/* No need to save flags, we aleady have interrupts off and we
-	   already hold the SMI lock. */
+	/*
+	 * No need to save flags, we aleady have interrupts off and we
+	 * already hold the SMI lock.
+	 */
 	if (!smi_info->run_to_completion)
 		spin_lock(&(smi_info->msg_lock));
 
@@ -353,7 +368,7 @@ static enum si_sm_result start_next_msg(
 						link);
 #ifdef DEBUG_TIMING
 		do_gettimeofday(&t);
-		printk("**Start2: %d.%9.9d\n", t.tv_sec, t.tv_usec);
+		printk(KERN_DEBUG "**Start2: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 		err = atomic_notifier_call_chain(&xaction_notifier_list,
 				0, smi_info);
@@ -365,13 +380,12 @@ static enum si_sm_result start_next_msg(
 			smi_info->si_sm,
 			smi_info->curr_msg->data,
 			smi_info->curr_msg->data_size);
-		if (err) {
+		if (err)
 			return_hosed_msg(smi_info, err);
-		}
 
 		rv = SI_SM_CALL_WITHOUT_DELAY;
 	}
-	out:
+ out:
 	if (!smi_info->run_to_completion)
 		spin_unlock(&(smi_info->msg_lock));
 
@@ -382,8 +396,10 @@ static void start_enable_irq(struct smi_
 {
 	unsigned char msg[2];
 
-	/* If we are enabling interrupts, we have to tell the
-	   BMC to use them. */
+	/*
+	 * If we are enabling interrupts, we have to tell the
+	 * BMC to use them.
+	 */
 	msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
 	msg[1] = IPMI_GET_BMC_GLOBAL_ENABLES_CMD;
 
@@ -415,10 +431,12 @@ static void start_clear_flags(struct smi
 	smi_info->si_state = SI_CLEARING_FLAGS;
 }
 
-/* When we have a situtaion where we run out of memory and cannot
-   allocate messages, we just leave them in the BMC and run the system
-   polled until we can allocate some memory.  Once we have some
-   memory, we will re-enable the interrupt. */
+/*
+ * When we have a situtaion where we run out of memory and cannot
+ * allocate messages, we just leave them in the BMC and run the system
+ * polled until we can allocate some memory.  Once we have some
+ * memory, we will re-enable the interrupt.
+ */
 static inline void disable_si_irq(struct smi_info *smi_info)
 {
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
@@ -486,12 +504,11 @@ static void handle_flags(struct smi_info
 			smi_info->curr_msg->data_size);
 		smi_info->si_state = SI_GETTING_EVENTS;
 	} else if (smi_info->msg_flags & OEM_DATA_AVAIL &&
-	           smi_info->oem_data_avail_handler) {
+		   smi_info->oem_data_avail_handler) {
 		if (smi_info->oem_data_avail_handler(smi_info))
 			goto retry;
-	} else {
+	} else
 		smi_info->si_state = SI_NORMAL;
-	}
 }
 
 static void handle_transaction_done(struct smi_info *smi_info)
@@ -501,7 +518,7 @@ static void handle_transaction_done(stru
 	struct timeval t;
 
 	do_gettimeofday(&t);
-	printk("**Done: %d.%9.9d\n", t.tv_sec, t.tv_usec);
+	printk(KERN_DEBUG "**Done: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 	switch (smi_info->si_state) {
 	case SI_NORMAL:
@@ -514,9 +531,11 @@ static void handle_transaction_done(stru
 				smi_info->curr_msg->rsp,
 				IPMI_MAX_MSG_LENGTH);
 
-		/* Do this here becase deliver_recv_msg() releases the
-		   lock, and a new message can be put in during the
-		   time the lock is released. */
+		/*
+		 * Do this here becase deliver_recv_msg() releases the
+		 * lock, and a new message can be put in during the
+		 * time the lock is released.
+		 */
 		msg = smi_info->curr_msg;
 		smi_info->curr_msg = NULL;
 		deliver_recv_msg(smi_info, msg);
@@ -530,12 +549,13 @@ static void handle_transaction_done(stru
 		/* We got the flags from the SMI, now handle them. */
 		len = smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
 		if (msg[2] != 0) {
-			/* Error fetching flags, just give up for
-			   now. */
+			/* Error fetching flags, just give up for now. */
 			smi_info->si_state = SI_NORMAL;
 		} else if (len < 4) {
-			/* Hmm, no flags.  That's technically illegal, but
-			   don't use uninitialized data. */
+			/*
+			 * Hmm, no flags.  That's technically illegal, but
+			 * don't use uninitialized data.
+			 */
 			smi_info->si_state = SI_NORMAL;
 		} else {
 			smi_info->msg_flags = msg[3];
@@ -572,9 +592,11 @@ static void handle_transaction_done(stru
 				smi_info->curr_msg->rsp,
 				IPMI_MAX_MSG_LENGTH);
 
-		/* Do this here becase deliver_recv_msg() releases the
-		   lock, and a new message can be put in during the
-		   time the lock is released. */
+		/*
+		 * Do this here becase deliver_recv_msg() releases the
+		 * lock, and a new message can be put in during the
+		 * time the lock is released.
+		 */
 		msg = smi_info->curr_msg;
 		smi_info->curr_msg = NULL;
 		if (msg->rsp[2] != 0) {
@@ -587,10 +609,12 @@ static void handle_transaction_done(stru
 		} else {
 			smi_inc_stat(smi_info, events);
 
-			/* Do this before we deliver the message
-			   because delivering the message releases the
-			   lock and something else can mess with the
-			   state. */
+			/*
+			 * Do this before we deliver the message
+			 * because delivering the message releases the
+			 * lock and something else can mess with the
+			 * state.
+			 */
 			handle_flags(smi_info);
 
 			deliver_recv_msg(smi_info, msg);
@@ -606,9 +630,11 @@ static void handle_transaction_done(stru
 				smi_info->curr_msg->rsp,
 				IPMI_MAX_MSG_LENGTH);
 
-		/* Do this here becase deliver_recv_msg() releases the
-		   lock, and a new message can be put in during the
-		   time the lock is released. */
+		/*
+		 * Do this here becase deliver_recv_msg() releases the
+		 * lock, and a new message can be put in during the
+		 * time the lock is released.
+		 */
 		msg = smi_info->curr_msg;
 		smi_info->curr_msg = NULL;
 		if (msg->rsp[2] != 0) {
@@ -621,10 +647,12 @@ static void handle_transaction_done(stru
 		} else {
 			smi_inc_stat(smi_info, incoming_messages);
 
-			/* Do this before we deliver the message
-			   because delivering the message releases the
-			   lock and something else can mess with the
-			   state. */
+			/*
+			 * Do this before we deliver the message
+			 * because delivering the message releases the
+			 * lock and something else can mess with the
+			 * state.
+			 */
 			handle_flags(smi_info);
 
 			deliver_recv_msg(smi_info, msg);
@@ -712,46 +740,49 @@ static void handle_transaction_done(stru
 	}
 }
 
-/* Called on timeouts and events.  Timeouts should pass the elapsed
-   time, interrupts should pass in zero.  Must be called with
-   si_lock held and interrupts disabled. */
+/*
+ * Called on timeouts and events.  Timeouts should pass the elapsed
+ * time, interrupts should pass in zero.  Must be called with
+ * si_lock held and interrupts disabled.
+ */
 static enum si_sm_result smi_event_handler(struct smi_info *smi_info,
 					   int time)
 {
 	enum si_sm_result si_sm_result;
 
  restart:
-	/* There used to be a loop here that waited a little while
-	   (around 25us) before giving up.  That turned out to be
-	   pointless, the minimum delays I was seeing were in the 300us
-	   range, which is far too long to wait in an interrupt.  So
-	   we just run until the state machine tells us something
-	   happened or it needs a delay. */
+	/*
+	 * There used to be a loop here that waited a little while
+	 * (around 25us) before giving up.  That turned out to be
+	 * pointless, the minimum delays I was seeing were in the 300us
+	 * range, which is far too long to wait in an interrupt.  So
+	 * we just run until the state machine tells us something
+	 * happened or it needs a delay.
+	 */
 	si_sm_result = smi_info->handlers->event(smi_info->si_sm, time);
 	time = 0;
 	while (si_sm_result == SI_SM_CALL_WITHOUT_DELAY)
-	{
 		si_sm_result = smi_info->handlers->event(smi_info->si_sm, 0);
-	}
 
-	if (si_sm_result == SI_SM_TRANSACTION_COMPLETE)
-	{
+	if (si_sm_result == SI_SM_TRANSACTION_COMPLETE) {
 		smi_inc_stat(smi_info, complete_transactions);
 
 		handle_transaction_done(smi_info);
 		si_sm_result = smi_info->handlers->event(smi_info->si_sm, 0);
-	}
-	else if (si_sm_result == SI_SM_HOSED)
-	{
+	} else if (si_sm_result == SI_SM_HOSED) {
 		smi_inc_stat(smi_info, hosed_count);
 
-		/* Do the before return_hosed_msg, because that
-		   releases the lock. */
+		/*
+		 * Do the before return_hosed_msg, because that
+		 * releases the lock.
+		 */
 		smi_info->si_state = SI_NORMAL;
 		if (smi_info->curr_msg != NULL) {
-			/* If we were handling a user message, format
-                           a response to send to the upper layer to
-                           tell it about the error. */
+			/*
+			 * If we were handling a user message, format
+			 * a response to send to the upper layer to
+			 * tell it about the error.
+			 */
 			return_hosed_msg(smi_info, IPMI_ERR_UNSPECIFIED);
 		}
 		si_sm_result = smi_info->handlers->event(smi_info->si_sm, 0);
@@ -761,17 +792,18 @@ static enum si_sm_result smi_event_handl
 	 * We prefer handling attn over new messages.  But don't do
 	 * this if there is not yet an upper layer to handle anything.
 	 */
-	if (likely(smi_info->intf) && si_sm_result == SI_SM_ATTN)
-	{
+	if (likely(smi_info->intf) && si_sm_result == SI_SM_ATTN) {
 		unsigned char msg[2];
 
 		smi_inc_stat(smi_info, attentions);
 
-		/* Got a attn, send down a get message flags to see
-                   what's causing it.  It would be better to handle
-                   this in the upper layer, but due to the way
-                   interrupts work with the SMI, that's not really
-                   possible. */
+		/*
+		 * Got a attn, send down a get message flags to see
+		 * what's causing it.  It would be better to handle
+		 * this in the upper layer, but due to the way
+		 * interrupts work with the SMI, that's not really
+		 * possible.
+		 */
 		msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
 		msg[1] = IPMI_GET_MSG_FLAGS_CMD;
 
@@ -788,13 +820,14 @@ static enum si_sm_result smi_event_handl
 		si_sm_result = start_next_msg(smi_info);
 		if (si_sm_result != SI_SM_IDLE)
 			goto restart;
-        }
+	}
 
 	if ((si_sm_result == SI_SM_IDLE)
-	    && (atomic_read(&smi_info->req_events)))
-	{
-		/* We are idle and the upper layer requested that I fetch
-		   events, so do so. */
+	    && (atomic_read(&smi_info->req_events))) {
+		/*
+		 * We are idle and the upper layer requested that I fetch
+		 * events, so do so.
+		 */
 		atomic_set(&smi_info->req_events, 0);
 
 		smi_info->curr_msg = ipmi_alloc_smi_msg();
@@ -871,11 +904,8 @@ static void sender(void                *
 	spin_unlock_irqrestore(&smi_info->msg_lock, flags);
 
 	spin_lock_irqsave(&smi_info->si_lock, flags);
-	if ((smi_info->si_state == SI_NORMAL)
-	    && (smi_info->curr_msg == NULL))
-	{
+	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL)
 		start_next_msg(smi_info);
-	}
 	spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
@@ -906,9 +936,8 @@ static int ipmi_thread(void *data)
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		smi_result = smi_event_handler(smi_info, 0);
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
-		if (smi_result == SI_SM_CALL_WITHOUT_DELAY) {
-			/* do nothing */
-		}
+		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
+			; /* do nothing */
 		else if (smi_result == SI_SM_CALL_WITH_DELAY)
 			schedule();
 		else
@@ -959,7 +988,7 @@ static void smi_timeout(unsigned long da
 	spin_lock_irqsave(&(smi_info->si_lock), flags);
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
-	printk("**Timer: %d.%9.9d\n", t.tv_sec, t.tv_usec);
+	printk(KERN_DEBUG "**Timer: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 	jiffies_now = jiffies;
 	time_diff = (((long)jiffies_now - (long)smi_info->last_timeout_jiffies)
@@ -977,8 +1006,10 @@ static void smi_timeout(unsigned long da
 		goto do_add_timer;
 	}
 
-	/* If the state machine asks for a short delay, then shorten
-           the timer timeout. */
+	/*
+	 * If the state machine asks for a short delay, then shorten
+	 * the timer timeout.
+	 */
 	if (smi_result == SI_SM_CALL_WITH_DELAY) {
 		smi_inc_stat(smi_info, short_timeouts);
 		smi_info->si_timer.expires = jiffies + 1;
@@ -1005,7 +1036,7 @@ static irqreturn_t si_irq_handler(int ir
 
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
-	printk("**Interrupt: %d.%9.9d\n", t.tv_sec, t.tv_usec);
+	printk(KERN_DEBUG "**Interrupt: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 	smi_event_handler(smi_info, 0);
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
@@ -1048,7 +1079,7 @@ static int smi_start_processing(void    
 	 * The BT interface is efficient enough to not need a thread,
 	 * and there is no need for a thread if we have interrupts.
 	 */
- 	else if ((new_smi->si_type != SI_BT) && (!new_smi->irq))
+	else if ((new_smi->si_type != SI_BT) && (!new_smi->irq))
 		enable = 1;
 
 	if (enable) {
@@ -1074,8 +1105,7 @@ static void set_maintenance_mode(void *s
 		atomic_set(&smi_info->req_events, 0);
 }
 
-static struct ipmi_smi_handlers handlers =
-{
+static struct ipmi_smi_handlers handlers = {
 	.owner                  = THIS_MODULE,
 	.start_processing       = smi_start_processing,
 	.sender			= sender,
@@ -1085,8 +1115,10 @@ static struct ipmi_smi_handlers handlers
 	.poll			= poll,
 };
 
-/* There can be 4 IO ports passed in (with or without IRQs), 4 addresses,
-   a default IO port, and 1 ACPI/SPMI address.  That sets SI_MAX_DRIVERS */
+/*
+ * There can be 4 IO ports passed in (with or without IRQs), 4 addresses,
+ * a default IO port, and 1 ACPI/SPMI address.  That sets SI_MAX_DRIVERS.
+ */
 
 static LIST_HEAD(smi_infos);
 static DEFINE_MUTEX(smi_infos_lock);
@@ -1277,10 +1309,9 @@ static void port_cleanup(struct smi_info
 	int          idx;
 
 	if (addr) {
-	  	for (idx = 0; idx < info->io_size; idx++) {
+		for (idx = 0; idx < info->io_size; idx++)
 			release_region(addr + idx * info->io.regspacing,
 				       info->io.regsize);
-		}
 	}
 }
 
@@ -1294,8 +1325,10 @@ static int port_setup(struct smi_info *i
 
 	info->io_cleanup = port_cleanup;
 
-	/* Figure out the actual inb/inw/inl/etc routine to use based
-	   upon the register size. */
+	/*
+	 * Figure out the actual inb/inw/inl/etc routine to use based
+	 * upon the register size.
+	 */
 	switch (info->io.regsize) {
 	case 1:
 		info->io.inputb = port_inb;
@@ -1310,17 +1343,18 @@ static int port_setup(struct smi_info *i
 		info->io.outputb = port_outl;
 		break;
 	default:
-		printk("ipmi_si: Invalid register size: %d\n",
+		printk(KERN_WARNING "ipmi_si: Invalid register size: %d\n",
 		       info->io.regsize);
 		return -EINVAL;
 	}
 
-	/* Some BIOSes reserve disjoint I/O regions in their ACPI
+	/*
+	 * Some BIOSes reserve disjoint I/O regions in their ACPI
 	 * tables.  This causes problems when trying to register the
 	 * entire I/O region.  Therefore we must register each I/O
 	 * port separately.
 	 */
-  	for (idx = 0; idx < info->io_size; idx++) {
+	for (idx = 0; idx < info->io_size; idx++) {
 		if (request_region(addr + idx * info->io.regspacing,
 				   info->io.regsize, DEVICE_NAME) == NULL) {
 			/* Undo allocations */
@@ -1408,8 +1442,10 @@ static int mem_setup(struct smi_info *in
 
 	info->io_cleanup = mem_cleanup;
 
-	/* Figure out the actual readb/readw/readl/etc routine to use based
-	   upon the register size. */
+	/*
+	 * Figure out the actual readb/readw/readl/etc routine to use based
+	 * upon the register size.
+	 */
 	switch (info->io.regsize) {
 	case 1:
 		info->io.inputb = intf_mem_inb;
@@ -1430,16 +1466,18 @@ static int mem_setup(struct smi_info *in
 		break;
 #endif
 	default:
-		printk("ipmi_si: Invalid register size: %d\n",
+		printk(KERN_WARNING "ipmi_si: Invalid register size: %d\n",
 		       info->io.regsize);
 		return -EINVAL;
 	}
 
-	/* Calculate the total amount of memory to claim.  This is an
+	/*
+	 * Calculate the total amount of memory to claim.  This is an
 	 * unusual looking calculation, but it avoids claiming any
 	 * more memory than it has to.  It will claim everything
 	 * between the first address to the end of the last full
-	 * register. */
+	 * register.
+	 */
 	mapsize = ((info->io_size * info->io.regspacing)
 		   - (info->io.regspacing - info->io.regsize));
 
@@ -1769,9 +1807,11 @@ static __devinit void hardcode_find_bmc(
 
 #include <linux/acpi.h>
 
-/* Once we get an ACPI failure, we don't try any more, because we go
-   through the tables sequentially.  Once we don't find a table, there
-   are no more. */
+/*
+ * Once we get an ACPI failure, we don't try any more, because we go
+ * through the tables sequentially.  Once we don't find a table, there
+ * are no more.
+ */
 static int acpi_failure;
 
 /* For GPE-type interrupts. */
@@ -1834,7 +1874,8 @@ static int acpi_gpe_irq_setup(struct smi
 
 /*
  * Defined at
- * http://h21007.www2.hp.com/dspp/files/unprotected/devresource/Docs/TechPapers/IA64/hpspmi.pdf
+ * http://h21007.www2.hp.com/dspp/files/unprotected/devresource/
+ * Docs/TechPapers/IA64/hpspmi.pdf
  */
 struct SPMITable {
 	s8	Signature[4];
@@ -1856,14 +1897,18 @@ struct SPMITable {
 	 */
 	u8	InterruptType;
 
-	/* If bit 0 of InterruptType is set, then this is the SCI
-           interrupt in the GPEx_STS register. */
+	/*
+	 * If bit 0 of InterruptType is set, then this is the SCI
+	 * interrupt in the GPEx_STS register.
+	 */
 	u8	GPE;
 
 	s16	Reserved;
 
-	/* If bit 1 of InterruptType is set, then this is the I/O
-           APIC/SAPIC interrupt. */
+	/*
+	 * If bit 1 of InterruptType is set, then this is the I/O
+	 * APIC/SAPIC interrupt.
+	 */
 	u32	GlobalSystemInterrupt;
 
 	/* The actual register address. */
@@ -1881,7 +1926,7 @@ static __devinit int try_init_acpi(struc
 
 	if (spmi->IPMIlegacy != 1) {
 	    printk(KERN_INFO "IPMI: Bad SPMI legacy %d\n", spmi->IPMIlegacy);
-  	    return -ENODEV;
+	    return -ENODEV;
 	}
 
 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
@@ -1898,8 +1943,7 @@ static __devinit int try_init_acpi(struc
 	info->addr_source = "ACPI";
 
 	/* Figure out the interface type. */
-	switch (spmi->InterfaceType)
-	{
+	switch (spmi->InterfaceType) {
 	case 1:	/* KCS */
 		info->si_type = SI_KCS;
 		break;
@@ -1947,7 +1991,8 @@ static __devinit int try_init_acpi(struc
 		info->io.addr_type = IPMI_IO_ADDR_SPACE;
 	} else {
 		kfree(info);
-		printk("ipmi_si: Unknown ACPI I/O Address type\n");
+		printk(KERN_WARNING
+		       "ipmi_si: Unknown ACPI I/O Address type\n");
 		return -EIO;
 	}
 	info->io.addr_data = spmi->addr.address;
@@ -1981,8 +2026,7 @@ static __devinit void acpi_find_bmc(void
 #endif
 
 #ifdef CONFIG_DMI
-struct dmi_ipmi_data
-{
+struct dmi_ipmi_data {
 	u8   		type;
 	u8   		addr_space;
 	unsigned long	base_addr;
@@ -2007,11 +2051,10 @@ static int __devinit decode_dmi(const st
 			/* I/O */
 			base_addr &= 0xFFFE;
 			dmi->addr_space = IPMI_IO_ADDR_SPACE;
-		}
-		else {
+		} else
 			/* Memory */
 			dmi->addr_space = IPMI_MEM_ADDR_SPACE;
-		}
+
 		/* If bit 4 of byte 0x10 is set, then the lsb for the address
 		   is odd. */
 		dmi->base_addr = base_addr | ((data[0x10] & 0x10) >> 4);
@@ -2020,7 +2063,7 @@ static int __devinit decode_dmi(const st
 
 		/* The top two bits of byte 0x10 hold the register spacing. */
 		reg_spacing = (data[0x10] & 0xC0) >> 6;
-		switch(reg_spacing){
+		switch (reg_spacing) {
 		case 0x00: /* Byte boundaries */
 		    dmi->offset = 1;
 		    break;
@@ -2036,12 +2079,14 @@ static int __devinit decode_dmi(const st
 		}
 	} else {
 		/* Old DMI spec. */
-		/* Note that technically, the lower bit of the base
+		/*
+		 * Note that technically, the lower bit of the base
 		 * address should be 1 if the address is I/O and 0 if
 		 * the address is in memory.  So many systems get that
 		 * wrong (and all that I have seen are I/O) so we just
 		 * ignore that bit and assume I/O.  Systems that use
-		 * memory should use the newer spec, anyway. */
+		 * memory should use the newer spec, anyway.
+		 */
 		dmi->base_addr = base_addr & 0xfffe;
 		dmi->addr_space = IPMI_IO_ADDR_SPACE;
 		dmi->offset = 1;
@@ -2248,13 +2293,13 @@ static struct pci_device_id ipmi_pci_dev
 MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);
 
 static struct pci_driver ipmi_pci_driver = {
-        .name =         DEVICE_NAME,
-        .id_table =     ipmi_pci_devices,
-        .probe =        ipmi_pci_probe,
-        .remove =       __devexit_p(ipmi_pci_remove),
+	.name =         DEVICE_NAME,
+	.id_table =     ipmi_pci_devices,
+	.probe =        ipmi_pci_probe,
+	.remove =       __devexit_p(ipmi_pci_remove),
 #ifdef CONFIG_PM
-        .suspend =      ipmi_pci_suspend,
-        .resume =       ipmi_pci_resume,
+	.suspend =      ipmi_pci_suspend,
+	.resume =       ipmi_pci_resume,
 #endif
 };
 #endif /* CONFIG_PCI */
@@ -2324,7 +2369,7 @@ static int __devinit ipmi_of_probe(struc
 		info->io.addr_data, info->io.regsize, info->io.regspacing,
 		info->irq);
 
-	dev->dev.driver_data = (void*) info;
+	dev->dev.driver_data = (void *) info;
 
 	return try_smi_init(info);
 }
@@ -2337,14 +2382,16 @@ static int __devexit ipmi_of_remove(stru
 
 static struct of_device_id ipmi_match[] =
 {
-	{ .type = "ipmi", .compatible = "ipmi-kcs",  .data = (void *)(unsigned long) SI_KCS },
-	{ .type = "ipmi", .compatible = "ipmi-smic", .data = (void *)(unsigned long) SI_SMIC },
-	{ .type = "ipmi", .compatible = "ipmi-bt",   .data = (void *)(unsigned long) SI_BT },
+	{ .type = "ipmi", .compatible = "ipmi-kcs",
+	  .data = (void *)(unsigned long) SI_KCS },
+	{ .type = "ipmi", .compatible = "ipmi-smic",
+	  .data = (void *)(unsigned long) SI_SMIC },
+	{ .type = "ipmi", .compatible = "ipmi-bt",
+	  .data = (void *)(unsigned long) SI_BT },
 	{},
 };
 
-static struct of_platform_driver ipmi_of_platform_driver =
-{
+static struct of_platform_driver ipmi_of_platform_driver = {
 	.name		= "ipmi",
 	.match_table	= ipmi_match,
 	.probe		= ipmi_of_probe,
@@ -2365,32 +2412,32 @@ static int try_get_dev_id(struct smi_inf
 	if (!resp)
 		return -ENOMEM;
 
-	/* Do a Get Device ID command, since it comes back with some
-	   useful info. */
+	/*
+	 * Do a Get Device ID command, since it comes back with some
+	 * useful info.
+	 */
 	msg[0] = IPMI_NETFN_APP_REQUEST << 2;
 	msg[1] = IPMI_GET_DEVICE_ID_CMD;
 	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 2);
 
 	smi_result = smi_info->handlers->event(smi_info->si_sm, 0);
-	for (;;)
-	{
+	for (;;) {
 		if (smi_result == SI_SM_CALL_WITH_DELAY ||
 		    smi_result == SI_SM_CALL_WITH_TICK_DELAY) {
 			schedule_timeout_uninterruptible(1);
 			smi_result = smi_info->handlers->event(
 				smi_info->si_sm, 100);
-		}
-		else if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
-		{
+		} else if (smi_result == SI_SM_CALL_WITHOUT_DELAY) {
 			smi_result = smi_info->handlers->event(
 				smi_info->si_sm, 0);
-		}
-		else
+		} else
 			break;
 	}
 	if (smi_result == SI_SM_HOSED) {
-		/* We couldn't get the state machine to run, so whatever's at
-		   the port is probably not an IPMI SMI interface. */
+		/*
+		 * We couldn't get the state machine to run, so whatever's at
+		 * the port is probably not an IPMI SMI interface.
+		 */
 		rv = -ENODEV;
 		goto out;
 	}
@@ -2476,7 +2523,7 @@ static int param_read_proc(char *page, c
 static int oem_data_avail_to_receive_msg_avail(struct smi_info *smi_info)
 {
 	smi_info->msg_flags = ((smi_info->msg_flags & ~OEM_DATA_AVAIL) |
-			      	RECEIVE_MSG_AVAIL);
+			       RECEIVE_MSG_AVAIL);
 	return 1;
 }
 
@@ -2518,10 +2565,9 @@ static void setup_dell_poweredge_oem_dat
 		    id->ipmi_version   == DELL_POWEREDGE_8G_BMC_IPMI_VERSION) {
 			smi_info->oem_data_avail_handler =
 				oem_data_avail_to_receive_msg_avail;
-		}
-		else if (ipmi_version_major(id) < 1 ||
-			 (ipmi_version_major(id) == 1 &&
-			  ipmi_version_minor(id) < 5)) {
+		} else if (ipmi_version_major(id) < 1 ||
+			   (ipmi_version_major(id) == 1 &&
+			    ipmi_version_minor(id) < 5)) {
 			smi_info->oem_data_avail_handler =
 				oem_data_avail_to_receive_msg_avail;
 		}
@@ -2613,8 +2659,10 @@ static void setup_xaction_handlers(struc
 static inline void wait_for_timer_and_thread(struct smi_info *smi_info)
 {
 	if (smi_info->intf) {
-		/* The timer and thread are only running if the
-		   interface has been started up and registered. */
+		/*
+		 * The timer and thread are only running if the
+		 * interface has been started up and registered.
+		 */
 		if (smi_info->thread != NULL)
 			kthread_stop(smi_info->thread);
 		del_timer_sync(&smi_info->si_timer);
@@ -2739,7 +2787,7 @@ static int try_smi_init(struct smi_info 
 	/* Allocate the state machine's data and initialize it. */
 	new_smi->si_sm = kmalloc(new_smi->handlers->size(), GFP_KERNEL);
 	if (!new_smi->si_sm) {
-		printk(" Could not allocate state machine memory\n");
+		printk(KERN_ERR "Could not allocate state machine memory\n");
 		rv = -ENOMEM;
 		goto out_err;
 	}
@@ -2749,7 +2797,7 @@ static int try_smi_init(struct smi_info 
 	/* Now that we know the I/O size, we can set up the I/O. */
 	rv = new_smi->io_setup(new_smi);
 	if (rv) {
-		printk(" Could not set up I/O space\n");
+		printk(KERN_ERR "Could not set up I/O space\n");
 		goto out_err;
 	}
 
@@ -2765,8 +2813,10 @@ static int try_smi_init(struct smi_info 
 		goto out_err;
 	}
 
-	/* Attempt a get device id command.  If it fails, we probably
-           don't have a BMC here. */
+	/*
+	 * Attempt a get device id command.  If it fails, we probably
+	 * don't have a BMC here.
+	 */
 	rv = try_get_dev_id(new_smi);
 	if (rv) {
 		if (new_smi->addr_source)
@@ -2791,16 +2841,20 @@ static int try_smi_init(struct smi_info 
 	new_smi->intf_num = smi_num;
 	smi_num++;
 
-	/* Start clearing the flags before we enable interrupts or the
-	   timer to avoid racing with the timer. */
+	/*
+	 * Start clearing the flags before we enable interrupts or the
+	 * timer to avoid racing with the timer.
+	 */
 	start_clear_flags(new_smi);
 	/* IRQ is defined to be set when non-zero. */
 	if (new_smi->irq)
 		new_smi->si_state = SI_CLEARING_FLAGS_THEN_SET_IRQ;
 
 	if (!new_smi->dev) {
-		/* If we don't already have a device from something
-		 * else (like PCI), then register a new one. */
+		/*
+		 * If we don't already have a device from something
+		 * else (like PCI), then register a new one.
+		 */
 		new_smi->pdev = platform_device_alloc("ipmi_si",
 						      new_smi->intf_num);
 		if (rv) {
@@ -2871,7 +2925,8 @@ static int try_smi_init(struct smi_info 
 
 	mutex_unlock(&smi_infos_lock);
 
-	printk(KERN_INFO "IPMI %s interface initialized\n",si_to_str[new_smi->si_type]);
+	printk(KERN_INFO "IPMI %s interface initialized\n",
+	       si_to_str[new_smi->si_type]);
 
 	return 0;
 
@@ -2886,9 +2941,11 @@ static int try_smi_init(struct smi_info 
 	if (new_smi->irq_cleanup)
 		new_smi->irq_cleanup(new_smi);
 
-	/* Wait until we know that we are out of any interrupt
-	   handlers might have been running before we freed the
-	   interrupt. */
+	/*
+	 * Wait until we know that we are out of any interrupt
+	 * handlers might have been running before we freed the
+	 * interrupt.
+	 */
 	synchronize_sched();
 
 	if (new_smi->si_sm) {
@@ -2960,11 +3017,10 @@ static __devinit int init_ipmi_si(void)
 
 #ifdef CONFIG_PCI
 	rv = pci_register_driver(&ipmi_pci_driver);
-	if (rv){
+	if (rv)
 		printk(KERN_ERR
 		       "init_ipmi_si: Unable to register PCI driver: %d\n",
 		       rv);
-	}
 #endif
 
 #ifdef CONFIG_PPC_OF
@@ -2993,7 +3049,8 @@ static __devinit int init_ipmi_si(void)
 		of_unregister_platform_driver(&ipmi_of_platform_driver);
 #endif
 		driver_unregister(&ipmi_driver);
-		printk("ipmi_si: Unable to find any System Interface(s)\n");
+		printk(KERN_WARNING
+		       "ipmi_si: Unable to find any System Interface(s)\n");
 		return -ENODEV;
 	} else {
 		mutex_unlock(&smi_infos_lock);
@@ -3015,13 +3072,17 @@ static void cleanup_one_si(struct smi_in
 	/* Tell the driver that we are shutting down. */
 	atomic_inc(&to_clean->stop_operation);
 
-	/* Make sure the timer and thread are stopped and will not run
-	   again. */
+	/*
+	 * Make sure the timer and thread are stopped and will not run
+	 * again.
+	 */
 	wait_for_timer_and_thread(to_clean);
 
-	/* Timeouts are stopped, now make sure the interrupts are off
-	   for the device.  A little tricky with locks to make sure
-	   there are no races. */
+	/*
+	 * Timeouts are stopped, now make sure the interrupts are off
+	 * for the device.  A little tricky with locks to make sure
+	 * there are no races.
+	 */
 	spin_lock_irqsave(&to_clean->si_lock, flags);
 	while (to_clean->curr_msg || (to_clean->si_state != SI_NORMAL)) {
 		spin_unlock_irqrestore(&to_clean->si_lock, flags);
@@ -3092,4 +3153,5 @@ module_exit(cleanup_ipmi_si);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
-MODULE_DESCRIPTION("Interface to the IPMI driver for the KCS, SMIC, and BT system interfaces.");
+MODULE_DESCRIPTION("Interface to the IPMI driver for the KCS, SMIC, and BT"
+		   " system interfaces.");
diff -puN drivers/char/ipmi/ipmi_si_sm.h~ipmi-style-fixes-in-the-system-interface-code drivers/char/ipmi/ipmi_si_sm.h
--- a/drivers/char/ipmi/ipmi_si_sm.h~ipmi-style-fixes-in-the-system-interface-code
+++ a/drivers/char/ipmi/ipmi_si_sm.h
@@ -34,22 +34,27 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-/* This is defined by the state machines themselves, it is an opaque
-   data type for them to use. */
+/*
+ * This is defined by the state machines themselves, it is an opaque
+ * data type for them to use.
+ */
 struct si_sm_data;
 
-/* The structure for doing I/O in the state machine.  The state
-   machine doesn't have the actual I/O routines, they are done through
-   this interface. */
-struct si_sm_io
-{
+/*
+ * The structure for doing I/O in the state machine.  The state
+ * machine doesn't have the actual I/O routines, they are done through
+ * this interface.
+ */
+struct si_sm_io {
 	unsigned char (*inputb)(struct si_sm_io *io, unsigned int offset);
 	void (*outputb)(struct si_sm_io *io,
 			unsigned int  offset,
 			unsigned char b);
 
-	/* Generic info used by the actual handling routines, the
-           state machine shouldn't touch these. */
+	/*
+	 * Generic info used by the actual handling routines, the
+	 * state machine shouldn't touch these.
+	 */
 	void __iomem *addr;
 	int  regspacing;
 	int  regsize;
@@ -59,53 +64,67 @@ struct si_sm_io
 };
 
 /* Results of SMI events. */
-enum si_sm_result
-{
+enum si_sm_result {
 	SI_SM_CALL_WITHOUT_DELAY, /* Call the driver again immediately */
 	SI_SM_CALL_WITH_DELAY,	/* Delay some before calling again. */
-	SI_SM_CALL_WITH_TICK_DELAY,	/* Delay at least 1 tick before calling again. */
+	SI_SM_CALL_WITH_TICK_DELAY,/* Delay >=1 tick before calling again. */
 	SI_SM_TRANSACTION_COMPLETE, /* A transaction is finished. */
 	SI_SM_IDLE,		/* The SM is in idle state. */
 	SI_SM_HOSED,		/* The hardware violated the state machine. */
-	SI_SM_ATTN		/* The hardware is asserting attn and the
-				   state machine is idle. */
+
+	/*
+	 * The hardware is asserting attn and the state machine is
+	 * idle.
+	 */
+	SI_SM_ATTN
 };
 
 /* Handlers for the SMI state machine. */
-struct si_sm_handlers
-{
-	/* Put the version number of the state machine here so the
-           upper layer can print it. */
+struct si_sm_handlers {
+	/*
+	 * Put the version number of the state machine here so the
+	 * upper layer can print it.
+	 */
 	char *version;
 
-	/* Initialize the data and return the amount of I/O space to
-           reserve for the space. */
+	/*
+	 * Initialize the data and return the amount of I/O space to
+	 * reserve for the space.
+	 */
 	unsigned int (*init_data)(struct si_sm_data *smi,
 				  struct si_sm_io   *io);
 
-	/* Start a new transaction in the state machine.  This will
-	   return -2 if the state machine is not idle, -1 if the size
-	   is invalid (to large or too small), or 0 if the transaction
-	   is successfully completed. */
+	/*
+	 * Start a new transaction in the state machine.  This will
+	 * return -2 if the state machine is not idle, -1 if the size
+	 * is invalid (to large or too small), or 0 if the transaction
+	 * is successfully completed.
+	 */
 	int (*start_transaction)(struct si_sm_data *smi,
 				 unsigned char *data, unsigned int size);
 
-	/* Return the results after the transaction.  This will return
-	   -1 if the buffer is too small, zero if no transaction is
-	   present, or the actual length of the result data. */
+	/*
+	 * Return the results after the transaction.  This will return
+	 * -1 if the buffer is too small, zero if no transaction is
+	 * present, or the actual length of the result data.
+	 */
 	int (*get_result)(struct si_sm_data *smi,
 			  unsigned char *data, unsigned int length);
 
-	/* Call this periodically (for a polled interface) or upon
-	   receiving an interrupt (for a interrupt-driven interface).
-	   If interrupt driven, you should probably poll this
-	   periodically when not in idle state.  This should be called
-	   with the time that passed since the last call, if it is
-	   significant.  Time is in microseconds. */
+	/*
+	 * Call this periodically (for a polled interface) or upon
+	 * receiving an interrupt (for a interrupt-driven interface).
+	 * If interrupt driven, you should probably poll this
+	 * periodically when not in idle state.  This should be called
+	 * with the time that passed since the last call, if it is
+	 * significant.  Time is in microseconds.
+	 */
 	enum si_sm_result (*event)(struct si_sm_data *smi, long time);
 
-	/* Attempt to detect an SMI.  Returns 0 on success or nonzero
-           on failure. */
+	/*
+	 * Attempt to detect an SMI.  Returns 0 on success or nonzero
+	 * on failure.
+	 */
 	int (*detect)(struct si_sm_data *smi);
 
 	/* The interface is shutting down, so clean it up. */
diff -puN drivers/char/ipmi/ipmi_smic_sm.c~ipmi-style-fixes-in-the-system-interface-code drivers/char/ipmi/ipmi_smic_sm.c
--- a/drivers/char/ipmi/ipmi_smic_sm.c~ipmi-style-fixes-in-the-system-interface-code
+++ a/drivers/char/ipmi/ipmi_smic_sm.c
@@ -85,6 +85,7 @@ enum smic_states {
 /* SMIC Flags Register Bits */
 #define SMIC_RX_DATA_READY	0x80
 #define SMIC_TX_DATA_READY	0x40
+
 /*
  * SMIC_SMI and SMIC_EVM_DATA_AVAIL are only used by
  * a few systems, and then only by Systems Management
@@ -104,23 +105,22 @@ enum smic_states {
 #define	EC_ILLEGAL_COMMAND	0x04
 #define	EC_BUFFER_FULL		0x05
 
-struct si_sm_data
-{
+struct si_sm_data {
 	enum smic_states state;
 	struct si_sm_io *io;
-        unsigned char	 write_data[MAX_SMIC_WRITE_SIZE];
-        int		 write_pos;
-        int		 write_count;
-        int		 orig_write_count;
-        unsigned char	 read_data[MAX_SMIC_READ_SIZE];
-        int		 read_pos;
-        int		 truncated;
-        unsigned int	 error_retries;
-        long		 smic_timeout;
+	unsigned char	 write_data[MAX_SMIC_WRITE_SIZE];
+	int		 write_pos;
+	int		 write_count;
+	int		 orig_write_count;
+	unsigned char	 read_data[MAX_SMIC_READ_SIZE];
+	int		 read_pos;
+	int		 truncated;
+	unsigned int	 error_retries;
+	long		 smic_timeout;
 };
 
-static unsigned int init_smic_data (struct si_sm_data *smic,
-				    struct si_sm_io *io)
+static unsigned int init_smic_data(struct si_sm_data *smic,
+				   struct si_sm_io *io)
 {
 	smic->state = SMIC_IDLE;
 	smic->io = io;
@@ -150,11 +150,10 @@ static int start_smic_transaction(struct
 		return IPMI_NOT_IN_MY_STATE_ERR;
 
 	if (smic_debug & SMIC_DEBUG_MSG) {
-		printk(KERN_INFO "start_smic_transaction -");
-		for (i = 0; i < size; i ++) {
-			printk (" %02x", (unsigned char) (data [i]));
-		}
-		printk ("\n");
+		printk(KERN_DEBUG "start_smic_transaction -");
+		for (i = 0; i < size; i++)
+			printk(" %02x", (unsigned char) data[i]);
+		printk("\n");
 	}
 	smic->error_retries = 0;
 	memcpy(smic->write_data, data, size);
@@ -173,11 +172,10 @@ static int smic_get_result(struct si_sm_
 	int i;
 
 	if (smic_debug & SMIC_DEBUG_MSG) {
-		printk (KERN_INFO "smic_get result -");
-		for (i = 0; i < smic->read_pos; i ++) {
-			printk (" %02x", (smic->read_data [i]));
-		}
-		printk ("\n");
+		printk(KERN_DEBUG "smic_get result -");
+		for (i = 0; i < smic->read_pos; i++)
+			printk(" %02x", smic->read_data[i]);
+		printk("\n");
 	}
 	if (length < smic->read_pos) {
 		smic->read_pos = length;
@@ -223,8 +221,8 @@ static inline void write_smic_control(st
 	smic->io->outputb(smic->io, 1, control);
 }
 
-static inline void write_si_sm_data (struct si_sm_data *smic,
-				   unsigned char   data)
+static inline void write_si_sm_data(struct si_sm_data *smic,
+				    unsigned char   data)
 {
 	smic->io->outputb(smic->io, 0, data);
 }
@@ -233,10 +231,9 @@ static inline void start_error_recovery(
 {
 	(smic->error_retries)++;
 	if (smic->error_retries > SMIC_MAX_ERROR_RETRIES) {
-		if (smic_debug & SMIC_DEBUG_ENABLE) {
+		if (smic_debug & SMIC_DEBUG_ENABLE)
 			printk(KERN_WARNING
 			       "ipmi_smic_drv: smic hosed: %s\n", reason);
-		}
 		smic->state = SMIC_HOSED;
 	} else {
 		smic->write_count = smic->orig_write_count;
@@ -254,14 +251,14 @@ static inline void write_next_byte(struc
 	(smic->write_count)--;
 }
 
-static inline void read_next_byte (struct si_sm_data *smic)
+static inline void read_next_byte(struct si_sm_data *smic)
 {
 	if (smic->read_pos >= MAX_SMIC_READ_SIZE) {
-		read_smic_data (smic);
+		read_smic_data(smic);
 		smic->truncated = 1;
 	} else {
 		smic->read_data[smic->read_pos] = read_smic_data(smic);
-		(smic->read_pos)++;
+		smic->read_pos++;
 	}
 }
 
@@ -336,7 +333,7 @@ static inline void read_next_byte (struc
 	SMIC_SC_SMS_RD_END	0xC6
 */
 
-static enum si_sm_result smic_event (struct si_sm_data *smic, long time)
+static enum si_sm_result smic_event(struct si_sm_data *smic, long time)
 {
 	unsigned char status;
 	unsigned char flags;
@@ -347,13 +344,15 @@ static enum si_sm_result smic_event (str
 		return SI_SM_HOSED;
 	}
 	if (smic->state != SMIC_IDLE) {
-		if (smic_debug & SMIC_DEBUG_STATES) {
-			printk(KERN_INFO
+		if (smic_debug & SMIC_DEBUG_STATES)
+			printk(KERN_DEBUG
 			       "smic_event - smic->smic_timeout = %ld,"
 			       " time = %ld\n",
 			       smic->smic_timeout, time);
-		}
-/* FIXME: smic_event is sometimes called with time > SMIC_RETRY_TIMEOUT */
+		/*
+		 * FIXME: smic_event is sometimes called with time >
+		 * SMIC_RETRY_TIMEOUT
+		 */
 		if (time < SMIC_RETRY_TIMEOUT) {
 			smic->smic_timeout -= time;
 			if (smic->smic_timeout < 0) {
@@ -366,9 +365,9 @@ static enum si_sm_result smic_event (str
 	if (flags & SMIC_FLAG_BSY)
 		return SI_SM_CALL_WITH_DELAY;
 
-	status = read_smic_status (smic);
+	status = read_smic_status(smic);
 	if (smic_debug & SMIC_DEBUG_STATES)
-		printk(KERN_INFO
+		printk(KERN_DEBUG
 		       "smic_event - state = %d, flags = 0x%02x,"
 		       " status = 0x%02x\n",
 		       smic->state, flags, status);
@@ -377,9 +376,7 @@ static enum si_sm_result smic_event (str
 	case SMIC_IDLE:
 		/* in IDLE we check for available messages */
 		if (flags & SMIC_SMS_DATA_AVAIL)
-		{
 			return SI_SM_ATTN;
-		}
 		return SI_SM_IDLE;
 
 	case SMIC_START_OP:
@@ -391,7 +388,7 @@ static enum si_sm_result smic_event (str
 
 	case SMIC_OP_OK:
 		if (status != SMIC_SC_SMS_READY) {
-				/* this should not happen */
+			/* this should not happen */
 			start_error_recovery(smic,
 					     "state = SMIC_OP_OK,"
 					     " status != SMIC_SC_SMS_READY");
@@ -411,8 +408,10 @@ static enum si_sm_result smic_event (str
 					     "status != SMIC_SC_SMS_WR_START");
 			return SI_SM_CALL_WITH_DELAY;
 		}
-		/* we must not issue WR_(NEXT|END) unless
-                   TX_DATA_READY is set */
+		/*
+		 * we must not issue WR_(NEXT|END) unless
+		 * TX_DATA_READY is set
+		 * */
 		if (flags & SMIC_TX_DATA_READY) {
 			if (smic->write_count == 1) {
 				/* last byte */
@@ -424,10 +423,8 @@ static enum si_sm_result smic_event (str
 			}
 			write_next_byte(smic);
 			write_smic_flags(smic, flags | SMIC_FLAG_BSY);
-		}
-		else {
+		} else
 			return SI_SM_CALL_WITH_DELAY;
-		}
 		break;
 
 	case SMIC_WRITE_NEXT:
@@ -442,52 +439,48 @@ static enum si_sm_result smic_event (str
 			if (smic->write_count == 1) {
 				write_smic_control(smic, SMIC_CC_SMS_WR_END);
 				smic->state = SMIC_WRITE_END;
-			}
-			else {
+			} else {
 				write_smic_control(smic, SMIC_CC_SMS_WR_NEXT);
 				smic->state = SMIC_WRITE_NEXT;
 			}
 			write_next_byte(smic);
 			write_smic_flags(smic, flags | SMIC_FLAG_BSY);
-		}
-		else {
+		} else
 			return SI_SM_CALL_WITH_DELAY;
-		}
 		break;
 
 	case SMIC_WRITE_END:
 		if (status != SMIC_SC_SMS_WR_END) {
-			start_error_recovery (smic,
-					      "state = SMIC_WRITE_END, "
-					      "status != SMIC_SC_SMS_WR_END");
+			start_error_recovery(smic,
+					     "state = SMIC_WRITE_END, "
+					     "status != SMIC_SC_SMS_WR_END");
 			return SI_SM_CALL_WITH_DELAY;
 		}
 		/* data register holds an error code */
 		data = read_smic_data(smic);
 		if (data != 0) {
-			if (smic_debug & SMIC_DEBUG_ENABLE) {
-				printk(KERN_INFO
+			if (smic_debug & SMIC_DEBUG_ENABLE)
+				printk(KERN_DEBUG
 				       "SMIC_WRITE_END: data = %02x\n", data);
-			}
 			start_error_recovery(smic,
 					     "state = SMIC_WRITE_END, "
 					     "data != SUCCESS");
 			return SI_SM_CALL_WITH_DELAY;
-		} else {
+		} else
 			smic->state = SMIC_WRITE2READ;
-		}
 		break;
 
 	case SMIC_WRITE2READ:
-		/* we must wait for RX_DATA_READY to be set before we
-                   can continue */
+		/*
+		 * we must wait for RX_DATA_READY to be set before we
+		 * can continue
+		 */
 		if (flags & SMIC_RX_DATA_READY) {
 			write_smic_control(smic, SMIC_CC_SMS_RD_START);
 			write_smic_flags(smic, flags | SMIC_FLAG_BSY);
 			smic->state = SMIC_READ_START;
-		} else {
+		} else
 			return SI_SM_CALL_WITH_DELAY;
-		}
 		break;
 
 	case SMIC_READ_START:
@@ -502,15 +495,16 @@ static enum si_sm_result smic_event (str
 			write_smic_control(smic, SMIC_CC_SMS_RD_NEXT);
 			write_smic_flags(smic, flags | SMIC_FLAG_BSY);
 			smic->state = SMIC_READ_NEXT;
-		} else {
+		} else
 			return SI_SM_CALL_WITH_DELAY;
-		}
 		break;
 
 	case SMIC_READ_NEXT:
 		switch (status) {
-		/* smic tells us that this is the last byte to be read
-                   --> clean up */
+		/*
+		 * smic tells us that this is the last byte to be read
+		 * --> clean up
+		 */
 		case SMIC_SC_SMS_RD_END:
 			read_next_byte(smic);
 			write_smic_control(smic, SMIC_CC_SMS_RD_END);
@@ -523,9 +517,8 @@ static enum si_sm_result smic_event (str
 				write_smic_control(smic, SMIC_CC_SMS_RD_NEXT);
 				write_smic_flags(smic, flags | SMIC_FLAG_BSY);
 				smic->state = SMIC_READ_NEXT;
-			} else {
+			} else
 				return SI_SM_CALL_WITH_DELAY;
-			}
 			break;
 		default:
 			start_error_recovery(
@@ -546,10 +539,9 @@ static enum si_sm_result smic_event (str
 		data = read_smic_data(smic);
 		/* data register holds an error code */
 		if (data != 0) {
-			if (smic_debug & SMIC_DEBUG_ENABLE) {
-				printk(KERN_INFO
+			if (smic_debug & SMIC_DEBUG_ENABLE)
+				printk(KERN_DEBUG
 				       "SMIC_READ_END: data = %02x\n", data);
-			}
 			start_error_recovery(smic,
 					     "state = SMIC_READ_END, "
 					     "data != SUCCESS");
@@ -565,7 +557,7 @@ static enum si_sm_result smic_event (str
 
 	default:
 		if (smic_debug & SMIC_DEBUG_ENABLE) {
-			printk(KERN_WARNING "smic->state = %d\n", smic->state);
+			printk(KERN_DEBUG "smic->state = %d\n", smic->state);
 			start_error_recovery(smic, "state = UNKNOWN");
 			return SI_SM_CALL_WITH_DELAY;
 		}
@@ -576,10 +568,12 @@ static enum si_sm_result smic_event (str
 
 static int smic_detect(struct si_sm_data *smic)
 {
-	/* It's impossible for the SMIC fnags register to be all 1's,
-	   (assuming a properly functioning, self-initialized BMC)
-	   but that's what you get from reading a bogus address, so we
-	   test that first. */
+	/*
+	 * It's impossible for the SMIC fnags register to be all 1's,
+	 * (assuming a properly functioning, self-initialized BMC)
+	 * but that's what you get from reading a bogus address, so we
+	 * test that first.
+	 */
 	if (read_smic_flags(smic) == 0xff)
 		return 1;
 
@@ -595,8 +589,7 @@ static int smic_size(void)
 	return sizeof(struct si_sm_data);
 }
 
-struct si_sm_handlers smic_smi_handlers =
-{
+struct si_sm_handlers smic_smi_handlers = {
 	.init_data         = init_smic_data,
 	.start_transaction = start_smic_transaction,
 	.get_result        = smic_get_result,
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch


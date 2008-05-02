From: akpm@linux-foundation.org
Subject: + drivers-misc-sgi-xp-clean-up-return-values.patch added to -mm tree
Date: Thu, 01 May 2008 22:10:06 -0700
Message-ID: <200805020510.m425A60t010622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbYEBFKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 01:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, holt@sgi.com


The patch titled
     drivers/misc/sgi-xp: clean up return values
has been added to the -mm tree.  Its filename is
     drivers-misc-sgi-xp-clean-up-return-values.patch

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
Subject: drivers/misc/sgi-xp: clean up return values
From: Dean Nelson <dcn@sgi.com>

Make XP return values more generic to XP and not so tied to XPC by changing
enum xpc_retval to xp_retval, along with changing return value prefixes from
xpc to xp.  Also, cleanup a comment block that referenced some of these return
values as well as the handling of BTE related return values.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Acked-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h            |  293 +++++++++-----------------
 drivers/misc/sgi-xp/xp_main.c       |   38 +--
 drivers/misc/sgi-xp/xpc.h           |   71 +-----
 drivers/misc/sgi-xp/xpc_channel.c   |  166 +++++++-------
 drivers/misc/sgi-xp/xpc_main.c      |   44 +--
 drivers/misc/sgi-xp/xpc_partition.c |   64 ++---
 drivers/misc/sgi-xp/xpnet.c         |   18 -
 7 files changed, 292 insertions(+), 402 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~drivers-misc-sgi-xp-clean-up-return-values drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~drivers-misc-sgi-xp-clean-up-return-values
+++ a/drivers/misc/sgi-xp/xp.h
@@ -157,215 +157,136 @@ struct xpc_msg {
 /*
  * Define the return values and values passed to user's callout functions.
  * (It is important to add new value codes at the end just preceding
- * xpcUnknownReason, which must have the highest numerical value.)
+ * xpUnknownReason, which must have the highest numerical value.)
  */
-enum xpc_retval {
-	xpcSuccess = 0,
+enum xp_retval {
+	xpSuccess = 0,
 
-	xpcNotConnected,	/*  1: channel is not connected */
-	xpcConnected,		/*  2: channel connected (opened) */
-	xpcRETIRED1,		/*  3: (formerly xpcDisconnected) */
+	xpNotConnected,		/*  1: channel is not connected */
+	xpConnected,		/*  2: channel connected (opened) */
+	xpRETIRED1,		/*  3: (formerly xpDisconnected) */
 
-	xpcMsgReceived,		/*  4: message received */
-	xpcMsgDelivered,	/*  5: message delivered and acknowledged */
+	xpMsgReceived,		/*  4: message received */
+	xpMsgDelivered,		/*  5: message delivered and acknowledged */
 
-	xpcRETIRED2,		/*  6: (formerly xpcTransferFailed) */
+	xpRETIRED2,		/*  6: (formerly xpTransferFailed) */
 
-	xpcNoWait,		/*  7: operation would require wait */
-	xpcRetry,		/*  8: retry operation */
-	xpcTimeout,		/*  9: timeout in xpc_allocate_msg_wait() */
-	xpcInterrupted,		/* 10: interrupted wait */
+	xpNoWait,		/*  7: operation would require wait */
+	xpRetry,		/*  8: retry operation */
+	xpTimeout,		/*  9: timeout in xpc_allocate_msg_wait() */
+	xpInterrupted,		/* 10: interrupted wait */
 
-	xpcUnequalMsgSizes,	/* 11: message size disparity between sides */
-	xpcInvalidAddress,	/* 12: invalid address */
+	xpUnequalMsgSizes,	/* 11: message size disparity between sides */
+	xpInvalidAddress,	/* 12: invalid address */
 
-	xpcNoMemory,		/* 13: no memory available for XPC structures */
-	xpcLackOfResources,	/* 14: insufficient resources for operation */
-	xpcUnregistered,	/* 15: channel is not registered */
-	xpcAlreadyRegistered,	/* 16: channel is already registered */
+	xpNoMemory,		/* 13: no memory available for XPC structures */
+	xpLackOfResources,	/* 14: insufficient resources for operation */
+	xpUnregistered,		/* 15: channel is not registered */
+	xpAlreadyRegistered,	/* 16: channel is already registered */
 
-	xpcPartitionDown,	/* 17: remote partition is down */
-	xpcNotLoaded,		/* 18: XPC module is not loaded */
-	xpcUnloading,		/* 19: this side is unloading XPC module */
+	xpPartitionDown,	/* 17: remote partition is down */
+	xpNotLoaded,		/* 18: XPC module is not loaded */
+	xpUnloading,		/* 19: this side is unloading XPC module */
 
-	xpcBadMagic,		/* 20: XPC MAGIC string not found */
+	xpBadMagic,		/* 20: XPC MAGIC string not found */
 
-	xpcReactivating,	/* 21: remote partition was reactivated */
+	xpReactivating,		/* 21: remote partition was reactivated */
 
-	xpcUnregistering,	/* 22: this side is unregistering channel */
-	xpcOtherUnregistering,	/* 23: other side is unregistering channel */
+	xpUnregistering,	/* 22: this side is unregistering channel */
+	xpOtherUnregistering,	/* 23: other side is unregistering channel */
 
-	xpcCloneKThread,	/* 24: cloning kernel thread */
-	xpcCloneKThreadFailed,	/* 25: cloning kernel thread failed */
+	xpCloneKThread,		/* 24: cloning kernel thread */
+	xpCloneKThreadFailed,	/* 25: cloning kernel thread failed */
 
-	xpcNoHeartbeat,		/* 26: remote partition has no heartbeat */
+	xpNoHeartbeat,		/* 26: remote partition has no heartbeat */
 
-	xpcPioReadError,	/* 27: PIO read error */
-	xpcPhysAddrRegFailed,	/* 28: registration of phys addr range failed */
+	xpPioReadError,		/* 27: PIO read error */
+	xpPhysAddrRegFailed,	/* 28: registration of phys addr range failed */
 
-	xpcBteDirectoryError,	/* 29: maps to BTEFAIL_DIR */
-	xpcBtePoisonError,	/* 30: maps to BTEFAIL_POISON */
-	xpcBteWriteError,	/* 31: maps to BTEFAIL_WERR */
-	xpcBteAccessError,	/* 32: maps to BTEFAIL_ACCESS */
-	xpcBtePWriteError,	/* 33: maps to BTEFAIL_PWERR */
-	xpcBtePReadError,	/* 34: maps to BTEFAIL_PRERR */
-	xpcBteTimeOutError,	/* 35: maps to BTEFAIL_TOUT */
-	xpcBteXtalkError,	/* 36: maps to BTEFAIL_XTERR */
-	xpcBteNotAvailable,	/* 37: maps to BTEFAIL_NOTAVAIL */
-	xpcBteUnmappedError,	/* 38: unmapped BTEFAIL_ error */
+	xpRETIRED3,		/* 29: (formerly xpBteDirectoryError) */
+	xpRETIRED4,		/* 30: (formerly xpBtePoisonError) */
+	xpRETIRED5,		/* 31: (formerly xpBteWriteError) */
+	xpRETIRED6,		/* 32: (formerly xpBteAccessError) */
+	xpRETIRED7,		/* 33: (formerly xpBtePWriteError) */
+	xpRETIRED8,		/* 34: (formerly xpBtePReadError) */
+	xpRETIRED9,		/* 35: (formerly xpBteTimeOutError) */
+	xpRETIRED10,		/* 36: (formerly xpBteXtalkError) */
+	xpRETIRED11,		/* 37: (formerly xpBteNotAvailable) */
+	xpRETIRED12,		/* 38: (formerly xpBteUnmappedError) */
 
-	xpcBadVersion,		/* 39: bad version number */
-	xpcVarsNotSet,		/* 40: the XPC variables are not set up */
-	xpcNoRsvdPageAddr,	/* 41: unable to get rsvd page's phys addr */
-	xpcInvalidPartid,	/* 42: invalid partition ID */
-	xpcLocalPartid,		/* 43: local partition ID */
+	xpBadVersion,		/* 39: bad version number */
+	xpVarsNotSet,		/* 40: the XPC variables are not set up */
+	xpNoRsvdPageAddr,	/* 41: unable to get rsvd page's phys addr */
+	xpInvalidPartid,	/* 42: invalid partition ID */
+	xpLocalPartid,		/* 43: local partition ID */
 
-	xpcOtherGoingDown,	/* 44: other side going down, reason unknown */
-	xpcSystemGoingDown,	/* 45: system is going down, reason unknown */
-	xpcSystemHalt,		/* 46: system is being halted */
-	xpcSystemReboot,	/* 47: system is being rebooted */
-	xpcSystemPoweroff,	/* 48: system is being powered off */
+	xpOtherGoingDown,	/* 44: other side going down, reason unknown */
+	xpSystemGoingDown,	/* 45: system is going down, reason unknown */
+	xpSystemHalt,		/* 46: system is being halted */
+	xpSystemReboot,		/* 47: system is being rebooted */
+	xpSystemPoweroff,	/* 48: system is being powered off */
 
-	xpcDisconnecting,	/* 49: channel disconnecting (closing) */
+	xpDisconnecting,	/* 49: channel disconnecting (closing) */
 
-	xpcOpenCloseError,	/* 50: channel open/close protocol error */
+	xpOpenCloseError,	/* 50: channel open/close protocol error */
 
-	xpcDisconnected,	/* 51: channel disconnected (closed) */
+	xpDisconnected,		/* 51: channel disconnected (closed) */
 
-	xpcBteSh2Start,		/* 52: BTE CRB timeout */
+	xpBteCopyError,		/* 52: bte_copy() returned error */
 
-				/* 53: 0x1 BTE Error Response Short */
-	xpcBteSh2RspShort = xpcBteSh2Start + BTEFAIL_SH2_RESP_SHORT,
-
-				/* 54: 0x2 BTE Error Response Long */
-	xpcBteSh2RspLong = xpcBteSh2Start + BTEFAIL_SH2_RESP_LONG,
-
-				/* 56: 0x4 BTE Error Response DSB */
-	xpcBteSh2RspDSB = xpcBteSh2Start + BTEFAIL_SH2_RESP_DSP,
-
-				/* 60: 0x8 BTE Error Response Access */
-	xpcBteSh2RspAccess = xpcBteSh2Start + BTEFAIL_SH2_RESP_ACCESS,
-
-				/* 68: 0x10 BTE Error CRB timeout */
-	xpcBteSh2CRBTO = xpcBteSh2Start + BTEFAIL_SH2_CRB_TO,
-
-				/* 84: 0x20 BTE Error NACK limit */
-	xpcBteSh2NACKLimit = xpcBteSh2Start + BTEFAIL_SH2_NACK_LIMIT,
-
-				/* 115: BTE end */
-	xpcBteSh2End = xpcBteSh2Start + BTEFAIL_SH2_ALL,
-
-	xpcUnknownReason	/* 116: unknown reason - must be last in enum */
+	xpUnknownReason		/* 53: unknown reason - must be last in enum */
 };
 
 /*
- * Define the callout function types used by XPC to update the user on
- * connection activity and state changes (via the user function registered by
- * xpc_connect()) and to notify them of messages received and delivered (via
- * the user function registered by xpc_send_notify()).
- *
- * The two function types are xpc_channel_func and xpc_notify_func and
- * both share the following arguments, with the exception of "data", which
- * only xpc_channel_func has.
+ * Define the callout function type used by XPC to update the user on
+ * connection activity and state changes via the user function registered
+ * by xpc_connect().
  *
  * Arguments:
  *
- *	reason - reason code. (See following table.)
+ *	reason - reason code.
  *	partid - partition ID associated with condition.
  *	ch_number - channel # associated with condition.
- *	data - pointer to optional data. (See following table.)
+ *	data - pointer to optional data.
  *	key - pointer to optional user-defined value provided as the "key"
- *	      argument to xpc_connect() or xpc_send_notify().
+ *	      argument to xpc_connect().
+ *
+ * A reason code of xpConnected indicates that a connection has been
+ * established to the specified partition on the specified channel. The data
+ * argument indicates the max number of entries allowed in the message queue.
+ *
+ * A reason code of xpMsgReceived indicates that a XPC message arrived from
+ * the specified partition on the specified channel. The data argument
+ * specifies the address of the message's payload. The user must call
+ * xpc_received() when finished with the payload.
+ *
+ * All other reason codes indicate failure. The data argmument is NULL.
+ * When a failure reason code is received, one can assume that the channel
+ * is not connected.
+ */
+typedef void (*xpc_channel_func) (enum xp_retval reason, partid_t partid,
+				  int ch_number, void *data, void *key);
+
+/*
+ * Define the callout function type used by XPC to notify the user of
+ * messages received and delivered via the user function registered by
+ * xpc_send_notify().
  *
- * In the following table the "Optional Data" column applies to callouts made
- * to functions registered by xpc_connect(). A "NA" in that column indicates
- * that this reason code can be passed to functions registered by
- * xpc_send_notify() (i.e. they don't have data arguments).
+ * Arguments:
  *
- * Also, the first three reason codes in the following table indicate
- * success, whereas the others indicate failure. When a failure reason code
- * is received, one can assume that the channel is not connected.
+ *	reason - reason code.
+ *	partid - partition ID associated with condition.
+ *	ch_number - channel # associated with condition.
+ *	key - pointer to optional user-defined value provided as the "key"
+ *	      argument to xpc_send_notify().
  *
+ * A reason code of xpMsgDelivered indicates that the message was delivered
+ * to the intended recipient and that they have acknowledged its receipt by
+ * calling xpc_received().
  *
- * Reason Code          | Cause                          | Optional Data
- * =====================+================================+=====================
- * xpcConnected         | connection has been established| max #of entries
- *                      | to the specified partition on  | allowed in message
- *                      | the specified channel          | queue
- * ---------------------+--------------------------------+---------------------
- * xpcMsgReceived       | an XPC message arrived from    | address of payload
- *                      | the specified partition on the |
- *                      | specified channel              | [the user must call
- *                      |                                | xpc_received() when
- *                      |                                | finished with the
- *                      |                                | payload]
- * ---------------------+--------------------------------+---------------------
- * xpcMsgDelivered      | notification that the message  | NA
- *                      | was delivered to the intended  |
- *                      | recipient and that they have   |
- *                      | acknowledged its receipt by    |
- *                      | calling xpc_received()         |
- * =====================+================================+=====================
- * xpcUnequalMsgSizes   | can't connect to the specified | NULL
- *                      | partition on the specified     |
- *                      | channel because of mismatched  |
- *                      | message sizes                  |
- * ---------------------+--------------------------------+---------------------
- * xpcNoMemory          | insufficient memory avaiable   | NULL
- *                      | to allocate message queue      |
- * ---------------------+--------------------------------+---------------------
- * xpcLackOfResources   | lack of resources to create    | NULL
- *                      | the necessary kthreads to      |
- *                      | support the channel            |
- * ---------------------+--------------------------------+---------------------
- * xpcUnregistering     | this side's user has           | NULL or NA
- *                      | unregistered by calling        |
- *                      | xpc_disconnect()               |
- * ---------------------+--------------------------------+---------------------
- * xpcOtherUnregistering| the other side's user has      | NULL or NA
- *                      | unregistered by calling        |
- *                      | xpc_disconnect()               |
- * ---------------------+--------------------------------+---------------------
- * xpcNoHeartbeat       | the other side's XPC is no     | NULL or NA
- *                      | longer heartbeating            |
- *                      |                                |
- * ---------------------+--------------------------------+---------------------
- * xpcUnloading         | this side's XPC module is      | NULL or NA
- *                      | being unloaded                 |
- *                      |                                |
- * ---------------------+--------------------------------+---------------------
- * xpcOtherUnloading    | the other side's XPC module is | NULL or NA
- *                      | is being unloaded              |
- *                      |                                |
- * ---------------------+--------------------------------+---------------------
- * xpcPioReadError      | xp_nofault_PIOR() returned an  | NULL or NA
- *                      | error while sending an IPI     |
- *                      |                                |
- * ---------------------+--------------------------------+---------------------
- * xpcInvalidAddress    | the address either received or | NULL or NA
- *                      | sent by the specified partition|
- *                      | is invalid                     |
- * ---------------------+--------------------------------+---------------------
- * xpcBteNotAvailable   | attempt to pull data from the  | NULL or NA
- * xpcBtePoisonError    | specified partition over the   |
- * xpcBteWriteError     | specified channel via a        |
- * xpcBteAccessError    | bte_copy() failed              |
- * xpcBteTimeOutError   |                                |
- * xpcBteXtalkError     |                                |
- * xpcBteDirectoryError |                                |
- * xpcBteGenericError   |                                |
- * xpcBteUnmappedError  |                                |
- * ---------------------+--------------------------------+---------------------
- * xpcUnknownReason     | the specified channel to the   | NULL or NA
- *                      | specified partition was        |
- *                      | unavailable for unknown reasons|
- * =====================+================================+=====================
+ * All other reason codes indicate failure.
  */
-
-typedef void (*xpc_channel_func) (enum xpc_retval reason, partid_t partid,
-				  int ch_number, void *data, void *key);
-
-typedef void (*xpc_notify_func) (enum xpc_retval reason, partid_t partid,
+typedef void (*xpc_notify_func) (enum xp_retval reason, partid_t partid,
 				 int ch_number, void *key);
 
 /*
@@ -401,43 +322,43 @@ struct xpc_registration {
 struct xpc_interface {
 	void (*connect) (int);
 	void (*disconnect) (int);
-	enum xpc_retval (*allocate) (partid_t, int, u32, void **);
-	enum xpc_retval (*send) (partid_t, int, void *);
-	enum xpc_retval (*send_notify) (partid_t, int, void *,
+	enum xp_retval (*allocate) (partid_t, int, u32, void **);
+	enum xp_retval (*send) (partid_t, int, void *);
+	enum xp_retval (*send_notify) (partid_t, int, void *,
 					xpc_notify_func, void *);
 	void (*received) (partid_t, int, void *);
-	enum xpc_retval (*partid_to_nasids) (partid_t, void *);
+	enum xp_retval (*partid_to_nasids) (partid_t, void *);
 };
 
 extern struct xpc_interface xpc_interface;
 
 extern void xpc_set_interface(void (*)(int),
 			      void (*)(int),
-			      enum xpc_retval (*)(partid_t, int, u32, void **),
-			      enum xpc_retval (*)(partid_t, int, void *),
-			      enum xpc_retval (*)(partid_t, int, void *,
+			      enum xp_retval (*)(partid_t, int, u32, void **),
+			      enum xp_retval (*)(partid_t, int, void *),
+			      enum xp_retval (*)(partid_t, int, void *,
 						  xpc_notify_func, void *),
 			      void (*)(partid_t, int, void *),
-			      enum xpc_retval (*)(partid_t, void *));
+			      enum xp_retval (*)(partid_t, void *));
 extern void xpc_clear_interface(void);
 
-extern enum xpc_retval xpc_connect(int, xpc_channel_func, void *, u16,
+extern enum xp_retval xpc_connect(int, xpc_channel_func, void *, u16,
 				   u16, u32, u32);
 extern void xpc_disconnect(int);
 
-static inline enum xpc_retval
+static inline enum xp_retval
 xpc_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
 {
 	return xpc_interface.allocate(partid, ch_number, flags, payload);
 }
 
-static inline enum xpc_retval
+static inline enum xp_retval
 xpc_send(partid_t partid, int ch_number, void *payload)
 {
 	return xpc_interface.send(partid, ch_number, payload);
 }
 
-static inline enum xpc_retval
+static inline enum xp_retval
 xpc_send_notify(partid_t partid, int ch_number, void *payload,
 		xpc_notify_func func, void *key)
 {
@@ -450,7 +371,7 @@ xpc_received(partid_t partid, int ch_num
 	return xpc_interface.received(partid, ch_number, payload);
 }
 
-static inline enum xpc_retval
+static inline enum xp_retval
 xpc_partid_to_nasids(partid_t partid, void *nasids)
 {
 	return xpc_interface.partid_to_nasids(partid, nasids);
diff -puN drivers/misc/sgi-xp/xp_main.c~drivers-misc-sgi-xp-clean-up-return-values drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~drivers-misc-sgi-xp-clean-up-return-values
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -42,21 +42,21 @@ EXPORT_SYMBOL_GPL(xpc_registrations);
 /*
  * Initialize the XPC interface to indicate that XPC isn't loaded.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_notloaded(void)
 {
-	return xpcNotLoaded;
+	return xpNotLoaded;
 }
 
 struct xpc_interface xpc_interface = {
 	(void (*)(int))xpc_notloaded,
 	(void (*)(int))xpc_notloaded,
-	(enum xpc_retval(*)(partid_t, int, u32, void **))xpc_notloaded,
-	(enum xpc_retval(*)(partid_t, int, void *))xpc_notloaded,
-	(enum xpc_retval(*)(partid_t, int, void *, xpc_notify_func, void *))
+	(enum xp_retval(*)(partid_t, int, u32, void **))xpc_notloaded,
+	(enum xp_retval(*)(partid_t, int, void *))xpc_notloaded,
+	(enum xp_retval(*)(partid_t, int, void *, xpc_notify_func, void *))
 	    xpc_notloaded,
 	(void (*)(partid_t, int, void *))xpc_notloaded,
-	(enum xpc_retval(*)(partid_t, void *))xpc_notloaded
+	(enum xp_retval(*)(partid_t, void *))xpc_notloaded
 };
 EXPORT_SYMBOL_GPL(xpc_interface);
 
@@ -66,12 +66,12 @@ EXPORT_SYMBOL_GPL(xpc_interface);
 void
 xpc_set_interface(void (*connect) (int),
 		  void (*disconnect) (int),
-		  enum xpc_retval (*allocate) (partid_t, int, u32, void **),
-		  enum xpc_retval (*send) (partid_t, int, void *),
-		  enum xpc_retval (*send_notify) (partid_t, int, void *,
+		  enum xp_retval (*allocate) (partid_t, int, u32, void **),
+		  enum xp_retval (*send) (partid_t, int, void *),
+		  enum xp_retval (*send_notify) (partid_t, int, void *,
 						  xpc_notify_func, void *),
 		  void (*received) (partid_t, int, void *),
-		  enum xpc_retval (*partid_to_nasids) (partid_t, void *))
+		  enum xp_retval (*partid_to_nasids) (partid_t, void *))
 {
 	xpc_interface.connect = connect;
 	xpc_interface.disconnect = disconnect;
@@ -91,16 +91,16 @@ xpc_clear_interface(void)
 {
 	xpc_interface.connect = (void (*)(int))xpc_notloaded;
 	xpc_interface.disconnect = (void (*)(int))xpc_notloaded;
-	xpc_interface.allocate = (enum xpc_retval(*)(partid_t, int, u32,
+	xpc_interface.allocate = (enum xp_retval(*)(partid_t, int, u32,
 						     void **))xpc_notloaded;
-	xpc_interface.send = (enum xpc_retval(*)(partid_t, int, void *))
+	xpc_interface.send = (enum xp_retval(*)(partid_t, int, void *))
 	    xpc_notloaded;
-	xpc_interface.send_notify = (enum xpc_retval(*)(partid_t, int, void *,
+	xpc_interface.send_notify = (enum xp_retval(*)(partid_t, int, void *,
 							xpc_notify_func,
 							void *))xpc_notloaded;
 	xpc_interface.received = (void (*)(partid_t, int, void *))
 	    xpc_notloaded;
-	xpc_interface.partid_to_nasids = (enum xpc_retval(*)(partid_t, void *))
+	xpc_interface.partid_to_nasids = (enum xp_retval(*)(partid_t, void *))
 	    xpc_notloaded;
 }
 EXPORT_SYMBOL_GPL(xpc_clear_interface);
@@ -123,13 +123,13 @@ EXPORT_SYMBOL_GPL(xpc_clear_interface);
  *	nentries - max #of XPC message entries a message queue can contain.
  *		   The actual number, which is determined when a connection
  * 		   is established and may be less then requested, will be
- *		   passed to the user via the xpcConnected callout.
+ *		   passed to the user via the xpConnected callout.
  *	assigned_limit - max number of kthreads allowed to be processing
  * 			 messages (per connection) at any given instant.
  *	idle_limit - max number of kthreads allowed to be idle at any given
  * 		     instant.
  */
-enum xpc_retval
+enum xp_retval
 xpc_connect(int ch_number, xpc_channel_func func, void *key, u16 payload_size,
 	    u16 nentries, u32 assigned_limit, u32 idle_limit)
 {
@@ -143,12 +143,12 @@ xpc_connect(int ch_number, xpc_channel_f
 	registration = &xpc_registrations[ch_number];
 
 	if (mutex_lock_interruptible(&registration->mutex) != 0)
-		return xpcInterrupted;
+		return xpInterrupted;
 
 	/* if XPC_CHANNEL_REGISTERED(ch_number) */
 	if (registration->func != NULL) {
 		mutex_unlock(&registration->mutex);
-		return xpcAlreadyRegistered;
+		return xpAlreadyRegistered;
 	}
 
 	/* register the channel for connection */
@@ -163,7 +163,7 @@ xpc_connect(int ch_number, xpc_channel_f
 
 	xpc_interface.connect(ch_number);
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 EXPORT_SYMBOL_GPL(xpc_connect);
 
diff -puN drivers/misc/sgi-xp/xpc.h~drivers-misc-sgi-xp-clean-up-return-values drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~drivers-misc-sgi-xp-clean-up-return-values
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -412,7 +412,7 @@ struct xpc_channel {
 	spinlock_t lock;	/* lock for updating this structure */
 	u32 flags;		/* general flags */
 
-	enum xpc_retval reason;	/* reason why channel is disconnect'g */
+	enum xp_retval reason;	/* reason why channel is disconnect'g */
 	int reason_line;	/* line# disconnect initiated from */
 
 	u16 number;		/* channel # */
@@ -522,7 +522,7 @@ struct xpc_partition {
 	spinlock_t act_lock;	/* protect updating of act_state */
 	u8 act_state;		/* from XPC HB viewpoint */
 	u8 remote_vars_version;	/* version# of partition's vars */
-	enum xpc_retval reason;	/* reason partition is deactivating */
+	enum xp_retval reason;	/* reason partition is deactivating */
 	int reason_line;	/* line# deactivation initiated from */
 	int reactivate_nasid;	/* nasid in partition to reactivate */
 
@@ -646,31 +646,31 @@ extern void xpc_allow_IPI_ops(void);
 extern void xpc_restrict_IPI_ops(void);
 extern int xpc_identify_act_IRQ_sender(void);
 extern int xpc_partition_disengaged(struct xpc_partition *);
-extern enum xpc_retval xpc_mark_partition_active(struct xpc_partition *);
+extern enum xp_retval xpc_mark_partition_active(struct xpc_partition *);
 extern void xpc_mark_partition_inactive(struct xpc_partition *);
 extern void xpc_discovery(void);
 extern void xpc_check_remote_hb(void);
 extern void xpc_deactivate_partition(const int, struct xpc_partition *,
-				     enum xpc_retval);
-extern enum xpc_retval xpc_initiate_partid_to_nasids(partid_t, void *);
+				     enum xp_retval);
+extern enum xp_retval xpc_initiate_partid_to_nasids(partid_t, void *);
 
 /* found in xpc_channel.c */
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
-extern enum xpc_retval xpc_initiate_allocate(partid_t, int, u32, void **);
-extern enum xpc_retval xpc_initiate_send(partid_t, int, void *);
-extern enum xpc_retval xpc_initiate_send_notify(partid_t, int, void *,
-						xpc_notify_func, void *);
+extern enum xp_retval xpc_initiate_allocate(partid_t, int, u32, void **);
+extern enum xp_retval xpc_initiate_send(partid_t, int, void *);
+extern enum xp_retval xpc_initiate_send_notify(partid_t, int, void *,
+					       xpc_notify_func, void *);
 extern void xpc_initiate_received(partid_t, int, void *);
-extern enum xpc_retval xpc_setup_infrastructure(struct xpc_partition *);
-extern enum xpc_retval xpc_pull_remote_vars_part(struct xpc_partition *);
+extern enum xp_retval xpc_setup_infrastructure(struct xpc_partition *);
+extern enum xp_retval xpc_pull_remote_vars_part(struct xpc_partition *);
 extern void xpc_process_channel_activity(struct xpc_partition *);
 extern void xpc_connected_callout(struct xpc_channel *);
 extern void xpc_deliver_msg(struct xpc_channel *);
 extern void xpc_disconnect_channel(const int, struct xpc_channel *,
-				   enum xpc_retval, unsigned long *);
-extern void xpc_disconnect_callout(struct xpc_channel *, enum xpc_retval);
-extern void xpc_partition_going_down(struct xpc_partition *, enum xpc_retval);
+				   enum xp_retval, unsigned long *);
+extern void xpc_disconnect_callout(struct xpc_channel *, enum xp_retval);
+extern void xpc_partition_going_down(struct xpc_partition *, enum xp_retval);
 extern void xpc_teardown_infrastructure(struct xpc_partition *);
 
 static inline void
@@ -901,7 +901,7 @@ xpc_IPI_receive(AMO_t *amo)
 	return FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_CLEAR);
 }
 
-static inline enum xpc_retval
+static inline enum xp_retval
 xpc_IPI_send(AMO_t *amo, u64 flag, int nasid, int phys_cpuid, int vector)
 {
 	int ret = 0;
@@ -923,7 +923,7 @@ xpc_IPI_send(AMO_t *amo, u64 flag, int n
 
 	local_irq_restore(irq_flags);
 
-	return ((ret == 0) ? xpcSuccess : xpcPioReadError);
+	return ((ret == 0) ? xpSuccess : xpPioReadError);
 }
 
 /*
@@ -992,7 +992,7 @@ xpc_notify_IRQ_send(struct xpc_channel *
 		    unsigned long *irq_flags)
 {
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	if (likely(part->act_state != XPC_P_DEACTIVATING)) {
 		ret = xpc_IPI_send(part->remote_IPI_amo_va,
@@ -1001,7 +1001,7 @@ xpc_notify_IRQ_send(struct xpc_channel *
 				   part->remote_IPI_phys_cpuid, SGI_XPC_NOTIFY);
 		dev_dbg(xpc_chan, "%s sent to partid=%d, channel=%d, ret=%d\n",
 			ipi_flag_string, ch->partid, ch->number, ret);
-		if (unlikely(ret != xpcSuccess)) {
+		if (unlikely(ret != xpSuccess)) {
 			if (irq_flags != NULL)
 				spin_unlock_irqrestore(&ch->lock, *irq_flags);
 			XPC_DEACTIVATE_PARTITION(part, ret);
@@ -1123,41 +1123,10 @@ xpc_IPI_init(int index)
 	return amo;
 }
 
-static inline enum xpc_retval
+static inline enum xp_retval
 xpc_map_bte_errors(bte_result_t error)
 {
-	if (error == BTE_SUCCESS)
-		return xpcSuccess;
-
-	if (is_shub2()) {
-		if (BTE_VALID_SH2_ERROR(error))
-			return xpcBteSh2Start + error;
-		return xpcBteUnmappedError;
-	}
-	switch (error) {
-	case BTE_SUCCESS:
-		return xpcSuccess;
-	case BTEFAIL_DIR:
-		return xpcBteDirectoryError;
-	case BTEFAIL_POISON:
-		return xpcBtePoisonError;
-	case BTEFAIL_WERR:
-		return xpcBteWriteError;
-	case BTEFAIL_ACCESS:
-		return xpcBteAccessError;
-	case BTEFAIL_PWERR:
-		return xpcBtePWriteError;
-	case BTEFAIL_PRERR:
-		return xpcBtePReadError;
-	case BTEFAIL_TOUT:
-		return xpcBteTimeOutError;
-	case BTEFAIL_XTERR:
-		return xpcBteXtalkError;
-	case BTEFAIL_NOTAVAIL:
-		return xpcBteNotAvailable;
-	default:
-		return xpcBteUnmappedError;
-	}
+	return ((error == BTE_SUCCESS) ? xpSuccess : xpBteCopyError);
 }
 
 /*
diff -puN drivers/misc/sgi-xp/xpc_channel.c~drivers-misc-sgi-xp-clean-up-return-values drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~drivers-misc-sgi-xp-clean-up-return-values
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -90,7 +90,7 @@ xpc_initialize_channels(struct xpc_parti
  * Setup the infrastructure necessary to support XPartition Communication
  * between the specified remote partition and the local one.
  */
-enum xpc_retval
+enum xp_retval
 xpc_setup_infrastructure(struct xpc_partition *part)
 {
 	int ret, cpuid;
@@ -114,7 +114,7 @@ xpc_setup_infrastructure(struct xpc_part
 				 GFP_KERNEL);
 	if (part->channels == NULL) {
 		dev_err(xpc_chan, "can't get memory for channels\n");
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	part->nchannels = XPC_NCHANNELS;
@@ -129,7 +129,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->channels = NULL;
 		dev_err(xpc_chan, "can't get memory for local get/put "
 			"values\n");
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	part->remote_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
@@ -143,7 +143,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	/* allocate all the required open and close args */
@@ -159,7 +159,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	part->remote_openclose_args =
@@ -175,7 +175,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcNoMemory;
+		return xpNoMemory;
 	}
 
 	xpc_initialize_channels(part, partid);
@@ -209,7 +209,7 @@ xpc_setup_infrastructure(struct xpc_part
 		part->local_GPs = NULL;
 		kfree(part->channels);
 		part->channels = NULL;
-		return xpcLackOfResources;
+		return xpLackOfResources;
 	}
 
 	/* Setup a timer to check for dropped IPIs */
@@ -243,7 +243,7 @@ xpc_setup_infrastructure(struct xpc_part
 	xpc_vars_part[partid].nchannels = part->nchannels;
 	xpc_vars_part[partid].magic = XPC_VP_MAGIC1;
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 /*
@@ -254,7 +254,7 @@ xpc_setup_infrastructure(struct xpc_part
  * dst must be a cacheline aligned virtual address on this partition.
  * cnt must be an cacheline sized
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_pull_remote_cachelines(struct xpc_partition *part, void *dst,
 			   const void *src, size_t cnt)
 {
@@ -270,7 +270,7 @@ xpc_pull_remote_cachelines(struct xpc_pa
 	bte_ret = xp_bte_copy((u64)src, (u64)dst, (u64)cnt,
 			      (BTE_NORMAL | BTE_WACQUIRE), NULL);
 	if (bte_ret == BTE_SUCCESS)
-		return xpcSuccess;
+		return xpSuccess;
 
 	dev_dbg(xpc_chan, "xp_bte_copy() from partition %d failed, ret=%d\n",
 		XPC_PARTID(part), bte_ret);
@@ -282,7 +282,7 @@ xpc_pull_remote_cachelines(struct xpc_pa
  * Pull the remote per partition specific variables from the specified
  * partition.
  */
-enum xpc_retval
+enum xp_retval
 xpc_pull_remote_vars_part(struct xpc_partition *part)
 {
 	u8 buffer[L1_CACHE_BYTES * 2];
@@ -291,7 +291,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 	struct xpc_vars_part *pulled_entry;
 	u64 remote_entry_cacheline_pa, remote_entry_pa;
 	partid_t partid = XPC_PARTID(part);
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	/* pull the cacheline that contains the variables we're interested in */
 
@@ -311,7 +311,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 	ret = xpc_pull_remote_cachelines(part, pulled_entry_cacheline,
 					 (void *)remote_entry_cacheline_pa,
 					 L1_CACHE_BYTES);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 		dev_dbg(xpc_chan, "failed to pull XPC vars_part from "
 			"partition %d, ret=%d\n", partid, ret);
 		return ret;
@@ -326,11 +326,11 @@ xpc_pull_remote_vars_part(struct xpc_par
 			dev_dbg(xpc_chan, "partition %d's XPC vars_part for "
 				"partition %d has bad magic value (=0x%lx)\n",
 				partid, sn_partition_id, pulled_entry->magic);
-			return xpcBadMagic;
+			return xpBadMagic;
 		}
 
 		/* they've not been initialized yet */
-		return xpcRetry;
+		return xpRetry;
 	}
 
 	if (xpc_vars_part[partid].magic == XPC_VP_MAGIC1) {
@@ -344,7 +344,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 			dev_err(xpc_chan, "partition %d's XPC vars_part for "
 				"partition %d are not valid\n", partid,
 				sn_partition_id);
-			return xpcInvalidAddress;
+			return xpInvalidAddress;
 		}
 
 		/* the variables we imported look to be valid */
@@ -366,9 +366,9 @@ xpc_pull_remote_vars_part(struct xpc_par
 	}
 
 	if (pulled_entry->magic == XPC_VP_MAGIC1)
-		return xpcRetry;
+		return xpRetry;
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 /*
@@ -379,7 +379,7 @@ xpc_get_IPI_flags(struct xpc_partition *
 {
 	unsigned long irq_flags;
 	u64 IPI_amo;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	/*
 	 * See if there are any IPI flags to be handled.
@@ -398,7 +398,7 @@ xpc_get_IPI_flags(struct xpc_partition *
 						 (void *)part->
 						 remote_openclose_args_pa,
 						 XPC_OPENCLOSE_ARGS_SIZE);
-		if (ret != xpcSuccess) {
+		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 
 			dev_dbg(xpc_chan, "failed to pull openclose args from "
@@ -414,7 +414,7 @@ xpc_get_IPI_flags(struct xpc_partition *
 		ret = xpc_pull_remote_cachelines(part, part->remote_GPs,
 						 (void *)part->remote_GPs_pa,
 						 XPC_GP_SIZE);
-		if (ret != xpcSuccess) {
+		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 
 			dev_dbg(xpc_chan, "failed to pull GPs from partition "
@@ -431,7 +431,7 @@ xpc_get_IPI_flags(struct xpc_partition *
 /*
  * Allocate the local message queue and the notify queue.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_local_msgqueue(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
@@ -464,18 +464,18 @@ xpc_allocate_local_msgqueue(struct xpc_c
 			ch->local_nentries = nentries;
 		}
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpcSuccess;
+		return xpSuccess;
 	}
 
 	dev_dbg(xpc_chan, "can't get memory for local message queue and notify "
 		"queue, partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpcNoMemory;
+	return xpNoMemory;
 }
 
 /*
  * Allocate the cached remote message queue.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_remote_msgqueue(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
@@ -502,12 +502,12 @@ xpc_allocate_remote_msgqueue(struct xpc_
 			ch->remote_nentries = nentries;
 		}
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpcSuccess;
+		return xpSuccess;
 	}
 
 	dev_dbg(xpc_chan, "can't get memory for cached remote message queue, "
 		"partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpcNoMemory;
+	return xpNoMemory;
 }
 
 /*
@@ -515,20 +515,20 @@ xpc_allocate_remote_msgqueue(struct xpc_
  *
  * Note: Assumes all of the channel sizes are filled in.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_msgqueues(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	DBUG_ON(ch->flags & XPC_C_SETUP);
 
 	ret = xpc_allocate_local_msgqueue(ch);
-	if (ret != xpcSuccess)
+	if (ret != xpSuccess)
 		return ret;
 
 	ret = xpc_allocate_remote_msgqueue(ch);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 		kfree(ch->local_msgqueue_base);
 		ch->local_msgqueue = NULL;
 		kfree(ch->notify_queue);
@@ -540,7 +540,7 @@ xpc_allocate_msgqueues(struct xpc_channe
 	ch->flags |= XPC_C_SETUP;
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 /*
@@ -552,7 +552,7 @@ xpc_allocate_msgqueues(struct xpc_channe
 static void
 xpc_process_connect(struct xpc_channel *ch, unsigned long *irq_flags)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	DBUG_ON(!spin_is_locked(&ch->lock));
 
@@ -568,7 +568,7 @@ xpc_process_connect(struct xpc_channel *
 		ret = xpc_allocate_msgqueues(ch);
 		spin_lock_irqsave(&ch->lock, *irq_flags);
 
-		if (ret != xpcSuccess)
+		if (ret != xpSuccess)
 			XPC_DISCONNECT_CHANNEL(ch, ret, irq_flags);
 
 		if (ch->flags & (XPC_C_CONNECTED | XPC_C_DISCONNECTING))
@@ -603,7 +603,7 @@ xpc_process_connect(struct xpc_channel *
  * Notify those who wanted to be notified upon delivery of their message.
  */
 static void
-xpc_notify_senders(struct xpc_channel *ch, enum xpc_retval reason, s64 put)
+xpc_notify_senders(struct xpc_channel *ch, enum xp_retval reason, s64 put)
 {
 	struct xpc_notify *notify;
 	u8 notify_type;
@@ -748,7 +748,7 @@ xpc_process_disconnect(struct xpc_channe
 
 	if (ch->flags & XPC_C_DISCONNECTINGCALLOUT_MADE) {
 		spin_unlock_irqrestore(&ch->lock, *irq_flags);
-		xpc_disconnect_callout(ch, xpcDisconnected);
+		xpc_disconnect_callout(ch, xpDisconnected);
 		spin_lock_irqsave(&ch->lock, *irq_flags);
 	}
 
@@ -791,7 +791,7 @@ xpc_process_openclose_IPI(struct xpc_par
 	struct xpc_openclose_args *args =
 	    &part->remote_openclose_args[ch_number];
 	struct xpc_channel *ch = &part->channels[ch_number];
-	enum xpc_retval reason;
+	enum xp_retval reason;
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
 
@@ -871,10 +871,10 @@ again:
 
 		if (!(ch->flags & XPC_C_DISCONNECTING)) {
 			reason = args->reason;
-			if (reason <= xpcSuccess || reason > xpcUnknownReason)
-				reason = xpcUnknownReason;
-			else if (reason == xpcUnregistering)
-				reason = xpcOtherUnregistering;
+			if (reason <= xpSuccess || reason > xpUnknownReason)
+				reason = xpUnknownReason;
+			else if (reason == xpUnregistering)
+				reason = xpOtherUnregistering;
 
 			XPC_DISCONNECT_CHANNEL(ch, reason, &irq_flags);
 
@@ -961,7 +961,7 @@ again:
 
 		if (ch->flags & XPC_C_OPENREQUEST) {
 			if (args->msg_size != ch->msg_size) {
-				XPC_DISCONNECT_CHANNEL(ch, xpcUnequalMsgSizes,
+				XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
 						       &irq_flags);
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 				return;
@@ -991,7 +991,7 @@ again:
 			return;
 		}
 		if (!(ch->flags & XPC_C_OPENREQUEST)) {
-			XPC_DISCONNECT_CHANNEL(ch, xpcOpenCloseError,
+			XPC_DISCONNECT_CHANNEL(ch, xpOpenCloseError,
 					       &irq_flags);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
@@ -1042,18 +1042,18 @@ again:
 /*
  * Attempt to establish a channel connection to a remote partition.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_connect_channel(struct xpc_channel *ch)
 {
 	unsigned long irq_flags;
 	struct xpc_registration *registration = &xpc_registrations[ch->number];
 
 	if (mutex_trylock(&registration->mutex) == 0)
-		return xpcRetry;
+		return xpRetry;
 
 	if (!XPC_CHANNEL_REGISTERED(ch->number)) {
 		mutex_unlock(&registration->mutex);
-		return xpcUnregistered;
+		return xpUnregistered;
 	}
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
@@ -1095,10 +1095,10 @@ xpc_connect_channel(struct xpc_channel *
 			 * the channel lock as needed.
 			 */
 			mutex_unlock(&registration->mutex);
-			XPC_DISCONNECT_CHANNEL(ch, xpcUnequalMsgSizes,
+			XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
 					       &irq_flags);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return xpcUnequalMsgSizes;
+			return xpUnequalMsgSizes;
 		}
 	} else {
 		ch->msg_size = registration->msg_size;
@@ -1120,7 +1120,7 @@ xpc_connect_channel(struct xpc_channel *
 
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 /*
@@ -1203,7 +1203,7 @@ xpc_process_msg_IPI(struct xpc_partition
 			 * Notify senders that messages sent have been
 			 * received and delivered by the other side.
 			 */
-			xpc_notify_senders(ch, xpcMsgDelivered,
+			xpc_notify_senders(ch, xpMsgDelivered,
 					   ch->remote_GP.get);
 		}
 
@@ -1335,7 +1335,7 @@ xpc_process_channel_activity(struct xpc_
  * at the same time.
  */
 void
-xpc_partition_going_down(struct xpc_partition *part, enum xpc_retval reason)
+xpc_partition_going_down(struct xpc_partition *part, enum xp_retval reason)
 {
 	unsigned long irq_flags;
 	int ch_number;
@@ -1456,13 +1456,13 @@ xpc_connected_callout(struct xpc_channel
 	/* let the registerer know that a connection has been established */
 
 	if (ch->func != NULL) {
-		dev_dbg(xpc_chan, "ch->func() called, reason=xpcConnected, "
+		dev_dbg(xpc_chan, "ch->func() called, reason=xpConnected, "
 			"partid=%d, channel=%d\n", ch->partid, ch->number);
 
-		ch->func(xpcConnected, ch->partid, ch->number,
+		ch->func(xpConnected, ch->partid, ch->number,
 			 (void *)(u64)ch->local_nentries, ch->key);
 
-		dev_dbg(xpc_chan, "ch->func() returned, reason=xpcConnected, "
+		dev_dbg(xpc_chan, "ch->func() returned, reason=xpConnected, "
 			"partid=%d, channel=%d\n", ch->partid, ch->number);
 	}
 }
@@ -1503,7 +1503,7 @@ xpc_initiate_disconnect(int ch_number)
 			if (!(ch->flags & XPC_C_DISCONNECTED)) {
 				ch->flags |= XPC_C_WDISCONNECT;
 
-				XPC_DISCONNECT_CHANNEL(ch, xpcUnregistering,
+				XPC_DISCONNECT_CHANNEL(ch, xpUnregistering,
 						       &irq_flags);
 			}
 
@@ -1528,7 +1528,7 @@ xpc_initiate_disconnect(int ch_number)
  */
 void
 xpc_disconnect_channel(const int line, struct xpc_channel *ch,
-		       enum xpc_retval reason, unsigned long *irq_flags)
+		       enum xp_retval reason, unsigned long *irq_flags)
 {
 	u32 channel_was_connected = (ch->flags & XPC_C_CONNECTED);
 
@@ -1563,7 +1563,7 @@ xpc_disconnect_channel(const int line, s
 
 	} else if ((ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) &&
 		   !(ch->flags & XPC_C_DISCONNECTINGCALLOUT)) {
-		/* start a kthread that will do the xpcDisconnecting callout */
+		/* start a kthread that will do the xpDisconnecting callout */
 		xpc_create_kthreads(ch, 1, 1);
 	}
 
@@ -1575,7 +1575,7 @@ xpc_disconnect_channel(const int line, s
 }
 
 void
-xpc_disconnect_callout(struct xpc_channel *ch, enum xpc_retval reason)
+xpc_disconnect_callout(struct xpc_channel *ch, enum xp_retval reason)
 {
 	/*
 	 * Let the channel's registerer know that the channel is being
@@ -1598,13 +1598,13 @@ xpc_disconnect_callout(struct xpc_channe
  * Wait for a message entry to become available for the specified channel,
  * but don't wait any longer than 1 jiffy.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_msg_wait(struct xpc_channel *ch)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
-		DBUG_ON(ch->reason == xpcInterrupted);
+		DBUG_ON(ch->reason == xpInterrupted);
 		return ch->reason;
 	}
 
@@ -1614,11 +1614,11 @@ xpc_allocate_msg_wait(struct xpc_channel
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
 		ret = ch->reason;
-		DBUG_ON(ch->reason == xpcInterrupted);
+		DBUG_ON(ch->reason == xpInterrupted);
 	} else if (ret == 0) {
-		ret = xpcTimeout;
+		ret = xpTimeout;
 	} else {
-		ret = xpcInterrupted;
+		ret = xpInterrupted;
 	}
 
 	return ret;
@@ -1628,12 +1628,12 @@ xpc_allocate_msg_wait(struct xpc_channel
  * Allocate an entry for a message from the message queue associated with the
  * specified channel.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_allocate_msg(struct xpc_channel *ch, u32 flags,
 		 struct xpc_msg **address_of_msg)
 {
 	struct xpc_msg *msg;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 	s64 put;
 
 	/* this reference will be dropped in xpc_send_msg() */
@@ -1645,7 +1645,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
 	}
 	if (!(ch->flags & XPC_C_CONNECTED)) {
 		xpc_msgqueue_deref(ch);
-		return xpcNotConnected;
+		return xpNotConnected;
 	}
 
 	/*
@@ -1653,7 +1653,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
 	 * If none are available, we'll make sure that we grab the latest
 	 * GP values.
 	 */
-	ret = xpcTimeout;
+	ret = xpTimeout;
 
 	while (1) {
 
@@ -1683,16 +1683,16 @@ xpc_allocate_msg(struct xpc_channel *ch,
 		 * that will cause the IPI handler to fetch the latest
 		 * GP values as if an IPI was sent by the other side.
 		 */
-		if (ret == xpcTimeout)
+		if (ret == xpTimeout)
 			xpc_IPI_send_local_msgrequest(ch);
 
 		if (flags & XPC_NOWAIT) {
 			xpc_msgqueue_deref(ch);
-			return xpcNoWait;
+			return xpNoWait;
 		}
 
 		ret = xpc_allocate_msg_wait(ch);
-		if (ret != xpcInterrupted && ret != xpcTimeout) {
+		if (ret != xpInterrupted && ret != xpTimeout) {
 			xpc_msgqueue_deref(ch);
 			return ret;
 		}
@@ -1711,7 +1711,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
 
 	*address_of_msg = msg;
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 /*
@@ -1727,11 +1727,11 @@ xpc_allocate_msg(struct xpc_channel *ch,
  *	payload - address of the allocated payload area pointer (filled in on
  * 	          return) in which the user-defined message is constructed.
  */
-enum xpc_retval
+enum xp_retval
 xpc_initiate_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
-	enum xpc_retval ret = xpcUnknownReason;
+	enum xp_retval ret = xpUnknownReason;
 	struct xpc_msg *msg = NULL;
 
 	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
@@ -1814,11 +1814,11 @@ xpc_send_msgs(struct xpc_channel *ch, s6
  * local message queue's Put value and sends an IPI to the partition the
  * message is being sent to.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_send_msg(struct xpc_channel *ch, struct xpc_msg *msg, u8 notify_type,
 	     xpc_notify_func func, void *key)
 {
-	enum xpc_retval ret = xpcSuccess;
+	enum xp_retval ret = xpSuccess;
 	struct xpc_notify *notify = notify;
 	s64 put, msg_number = msg->number;
 
@@ -1908,12 +1908,12 @@ xpc_send_msg(struct xpc_channel *ch, str
  *	payload - pointer to the payload area allocated via
  *			xpc_initiate_allocate().
  */
-enum xpc_retval
+enum xp_retval
 xpc_initiate_send(partid_t partid, int ch_number, void *payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
 		partid, ch_number);
@@ -1957,13 +1957,13 @@ xpc_initiate_send(partid_t partid, int c
  *		  receipt. THIS FUNCTION MUST BE NON-BLOCKING.
  *	key - user-defined key to be passed to the function when it's called.
  */
-enum xpc_retval
+enum xp_retval
 xpc_initiate_send_notify(partid_t partid, int ch_number, void *payload,
 			 xpc_notify_func func, void *key)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
 		partid, ch_number);
@@ -1985,7 +1985,7 @@ xpc_pull_remote_msg(struct xpc_channel *
 	struct xpc_msg *remote_msg, *msg;
 	u32 msg_index, nmsgs;
 	u64 msg_offset;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	if (mutex_lock_interruptible(&ch->msg_to_pull_mutex) != 0) {
 		/* we were interrupted by a signal */
@@ -2012,7 +2012,7 @@ xpc_pull_remote_msg(struct xpc_channel *
 
 		ret = xpc_pull_remote_cachelines(part, msg, remote_msg,
 						 nmsgs * ch->msg_size);
-		if (ret != xpcSuccess) {
+		if (ret != xpSuccess) {
 
 			dev_dbg(xpc_chan, "failed to pull %d msgs starting with"
 				" msg %ld from partition %d, channel=%d, "
@@ -2112,7 +2112,7 @@ xpc_deliver_msg(struct xpc_channel *ch)
 				ch->number);
 
 			/* deliver the message to its intended recipient */
-			ch->func(xpcMsgReceived, ch->partid, ch->number,
+			ch->func(xpMsgReceived, ch->partid, ch->number,
 				 &msg->payload, ch->key);
 
 			dev_dbg(xpc_chan, "ch->func() returned, msg=0x%p, "
diff -puN drivers/misc/sgi-xp/xpc_main.c~drivers-misc-sgi-xp-clean-up-return-values drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~drivers-misc-sgi-xp-clean-up-return-values
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -315,13 +315,13 @@ xpc_initiate_discovery(void *ignore)
  * the XPC per partition variables from the remote partition and waiting for
  * the remote partition to pull ours.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_make_first_contact(struct xpc_partition *part)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
-	while ((ret = xpc_pull_remote_vars_part(part)) != xpcSuccess) {
-		if (ret != xpcRetry) {
+	while ((ret = xpc_pull_remote_vars_part(part)) != xpSuccess) {
+		if (ret != xpRetry) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 			return ret;
 		}
@@ -406,7 +406,7 @@ xpc_partition_up(struct xpc_partition *p
 
 	dev_dbg(xpc_chan, "activating partition %d\n", XPC_PARTID(part));
 
-	if (xpc_setup_infrastructure(part) != xpcSuccess)
+	if (xpc_setup_infrastructure(part) != xpSuccess)
 		return;
 
 	/*
@@ -418,7 +418,7 @@ xpc_partition_up(struct xpc_partition *p
 
 	(void)xpc_part_ref(part);	/* this will always succeed */
 
-	if (xpc_make_first_contact(part) == xpcSuccess)
+	if (xpc_make_first_contact(part) == xpSuccess)
 		xpc_channel_mgr(part);
 
 	xpc_part_deref(part);
@@ -470,7 +470,7 @@ xpc_activating(void *__partid)
 
 		spin_lock_irqsave(&part->act_lock, irq_flags);
 		part->act_state = XPC_P_INACTIVE;
-		XPC_SET_REASON(part, xpcPhysAddrRegFailed, __LINE__);
+		XPC_SET_REASON(part, xpPhysAddrRegFailed, __LINE__);
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
 		part->remote_rp_pa = 0;
 		return 0;
@@ -488,7 +488,7 @@ xpc_activating(void *__partid)
 	xpc_disallow_hb(partid, xpc_vars);
 	xpc_mark_partition_inactive(part);
 
-	if (part->reason == xpcReactivating) {
+	if (part->reason == xpReactivating) {
 		/* interrupting ourselves results in activating partition */
 		xpc_IPI_send_reactivate(part);
 	}
@@ -508,7 +508,7 @@ xpc_activate_partition(struct xpc_partit
 	DBUG_ON(part->act_state != XPC_P_INACTIVE);
 
 	part->act_state = XPC_P_ACTIVATION_REQ;
-	XPC_SET_REASON(part, xpcCloneKThread, __LINE__);
+	XPC_SET_REASON(part, xpCloneKThread, __LINE__);
 
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
 
@@ -517,7 +517,7 @@ xpc_activate_partition(struct xpc_partit
 	if (IS_ERR(kthread)) {
 		spin_lock_irqsave(&part->act_lock, irq_flags);
 		part->act_state = XPC_P_INACTIVE;
-		XPC_SET_REASON(part, xpcCloneKThreadFailed, __LINE__);
+		XPC_SET_REASON(part, xpCloneKThreadFailed, __LINE__);
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
 	}
 }
@@ -696,7 +696,7 @@ xpc_kthread_start(void *args)
 		ch->flags |= XPC_C_DISCONNECTINGCALLOUT;
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
 
-		xpc_disconnect_callout(ch, xpcDisconnecting);
+		xpc_disconnect_callout(ch, xpDisconnecting);
 
 		spin_lock_irqsave(&ch->lock, irq_flags);
 		ch->flags |= XPC_C_DISCONNECTINGCALLOUT_MADE;
@@ -776,7 +776,7 @@ xpc_create_kthreads(struct xpc_channel *
 			 * then we'll deadlock if all other kthreads assigned
 			 * to this channel are blocked in the channel's
 			 * registerer, because the only thing that will unblock
-			 * them is the xpcDisconnecting callout that this
+			 * them is the xpDisconnecting callout that this
 			 * failed kthread_run() would have made.
 			 */
 
@@ -796,7 +796,7 @@ xpc_create_kthreads(struct xpc_channel *
 				 * to function.
 				 */
 				spin_lock_irqsave(&ch->lock, irq_flags);
-				XPC_DISCONNECT_CHANNEL(ch, xpcLackOfResources,
+				XPC_DISCONNECT_CHANNEL(ch, xpLackOfResources,
 						       &irq_flags);
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 			}
@@ -857,7 +857,7 @@ xpc_disconnect_wait(int ch_number)
 }
 
 static void
-xpc_do_exit(enum xpc_retval reason)
+xpc_do_exit(enum xp_retval reason)
 {
 	partid_t partid;
 	int active_part_count, printed_waiting_msg = 0;
@@ -955,7 +955,7 @@ xpc_do_exit(enum xpc_retval reason)
 	del_timer_sync(&xpc_hb_timer);
 	DBUG_ON(xpc_vars->heartbeating_to_mask != 0);
 
-	if (reason == xpcUnloading) {
+	if (reason == xpUnloading) {
 		/* take ourselves off of the reboot_notifier_list */
 		(void)unregister_reboot_notifier(&xpc_reboot_notifier);
 
@@ -981,20 +981,20 @@ xpc_do_exit(enum xpc_retval reason)
 static int
 xpc_system_reboot(struct notifier_block *nb, unsigned long event, void *unused)
 {
-	enum xpc_retval reason;
+	enum xp_retval reason;
 
 	switch (event) {
 	case SYS_RESTART:
-		reason = xpcSystemReboot;
+		reason = xpSystemReboot;
 		break;
 	case SYS_HALT:
-		reason = xpcSystemHalt;
+		reason = xpSystemHalt;
 		break;
 	case SYS_POWER_OFF:
-		reason = xpcSystemPoweroff;
+		reason = xpSystemPoweroff;
 		break;
 	default:
-		reason = xpcSystemGoingDown;
+		reason = xpSystemGoingDown;
 	}
 
 	xpc_do_exit(reason);
@@ -1279,7 +1279,7 @@ xpc_init(void)
 		/* mark this new thread as a non-starter */
 		complete(&xpc_discovery_exited);
 
-		xpc_do_exit(xpcUnloading);
+		xpc_do_exit(xpUnloading);
 		return -EBUSY;
 	}
 
@@ -1297,7 +1297,7 @@ module_init(xpc_init);
 void __exit
 xpc_exit(void)
 {
-	xpc_do_exit(xpcUnloading);
+	xpc_do_exit(xpUnloading);
 }
 
 module_exit(xpc_exit);
diff -puN drivers/misc/sgi-xp/xpc_partition.c~drivers-misc-sgi-xp-clean-up-return-values drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~drivers-misc-sgi-xp-clean-up-return-values
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -444,7 +444,7 @@ xpc_check_remote_hb(void)
 		     (remote_vars->heartbeat_offline == 0)) ||
 		    !xpc_hb_allowed(sn_partition_id, remote_vars)) {
 
-			XPC_DEACTIVATE_PARTITION(part, xpcNoHeartbeat);
+			XPC_DEACTIVATE_PARTITION(part, xpNoHeartbeat);
 			continue;
 		}
 
@@ -459,7 +459,7 @@ xpc_check_remote_hb(void)
  * is large enough to contain a copy of their reserved page header and
  * part_nasids mask.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_get_remote_rp(int nasid, u64 *discovered_nasids,
 		  struct xpc_rsvd_page *remote_rp, u64 *remote_rp_pa)
 {
@@ -469,7 +469,7 @@ xpc_get_remote_rp(int nasid, u64 *discov
 
 	*remote_rp_pa = xpc_get_rsvd_page_pa(nasid);
 	if (*remote_rp_pa == 0)
-		return xpcNoRsvdPageAddr;
+		return xpNoRsvdPageAddr;
 
 	/* pull over the reserved page header and part_nasids mask */
 	bres = xp_bte_copy(*remote_rp_pa, (u64)remote_rp,
@@ -489,18 +489,18 @@ xpc_get_remote_rp(int nasid, u64 *discov
 
 	if (remote_rp->partid < 1 ||
 	    remote_rp->partid > (XP_MAX_PARTITIONS - 1)) {
-		return xpcInvalidPartid;
+		return xpInvalidPartid;
 	}
 
 	if (remote_rp->partid == sn_partition_id)
-		return xpcLocalPartid;
+		return xpLocalPartid;
 
 	if (XPC_VERSION_MAJOR(remote_rp->version) !=
 	    XPC_VERSION_MAJOR(XPC_RP_VERSION)) {
-		return xpcBadVersion;
+		return xpBadVersion;
 	}
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 /*
@@ -509,13 +509,13 @@ xpc_get_remote_rp(int nasid, u64 *discov
  * remote_vars points to a buffer that is cacheline aligned for BTE copies and
  * assumed to be of size XPC_RP_VARS_SIZE.
  */
-static enum xpc_retval
+static enum xp_retval
 xpc_get_remote_vars(u64 remote_vars_pa, struct xpc_vars *remote_vars)
 {
 	int bres;
 
 	if (remote_vars_pa == 0)
-		return xpcVarsNotSet;
+		return xpVarsNotSet;
 
 	/* pull over the cross partition variables */
 	bres = xp_bte_copy(remote_vars_pa, (u64)remote_vars, XPC_RP_VARS_SIZE,
@@ -525,10 +525,10 @@ xpc_get_remote_vars(u64 remote_vars_pa, 
 
 	if (XPC_VERSION_MAJOR(remote_vars->version) !=
 	    XPC_VERSION_MAJOR(XPC_V_VERSION)) {
-		return xpcBadVersion;
+		return xpBadVersion;
 	}
 
-	return xpcSuccess;
+	return xpSuccess;
 }
 
 /*
@@ -606,14 +606,14 @@ xpc_identify_act_IRQ_req(int nasid)
 	struct timespec remote_rp_stamp = { 0, 0 };
 	partid_t partid;
 	struct xpc_partition *part;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	/* pull over the reserved page structure */
 
 	remote_rp = (struct xpc_rsvd_page *)xpc_remote_copy_buffer;
 
 	ret = xpc_get_remote_rp(nasid, NULL, remote_rp, &remote_rp_pa);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 		dev_warn(xpc_part, "unable to get reserved page from nasid %d, "
 			 "which sent interrupt, reason=%d\n", nasid, ret);
 		return;
@@ -632,7 +632,7 @@ xpc_identify_act_IRQ_req(int nasid)
 	remote_vars = (struct xpc_vars *)xpc_remote_copy_buffer;
 
 	ret = xpc_get_remote_vars(remote_vars_pa, remote_vars);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 
 		dev_warn(xpc_part, "unable to get XPC variables from nasid %d, "
 			 "which sent interrupt, reason=%d\n", nasid, ret);
@@ -699,7 +699,7 @@ xpc_identify_act_IRQ_req(int nasid)
 					  &remote_rp_stamp, remote_rp_pa,
 					  remote_vars_pa, remote_vars);
 		part->reactivate_nasid = nasid;
-		XPC_DEACTIVATE_PARTITION(part, xpcReactivating);
+		XPC_DEACTIVATE_PARTITION(part, xpReactivating);
 		return;
 	}
 
@@ -754,11 +754,11 @@ xpc_identify_act_IRQ_req(int nasid)
 
 	if (reactivate) {
 		part->reactivate_nasid = nasid;
-		XPC_DEACTIVATE_PARTITION(part, xpcReactivating);
+		XPC_DEACTIVATE_PARTITION(part, xpReactivating);
 
 	} else if (XPC_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version) &&
 		   xpc_partition_disengage_requested(1UL << partid)) {
-		XPC_DEACTIVATE_PARTITION(part, xpcOtherGoingDown);
+		XPC_DEACTIVATE_PARTITION(part, xpOtherGoingDown);
 	}
 }
 
@@ -870,20 +870,20 @@ xpc_partition_disengaged(struct xpc_part
 /*
  * Mark specified partition as active.
  */
-enum xpc_retval
+enum xp_retval
 xpc_mark_partition_active(struct xpc_partition *part)
 {
 	unsigned long irq_flags;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	dev_dbg(xpc_part, "setting partition %d to ACTIVE\n", XPC_PARTID(part));
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
 	if (part->act_state == XPC_P_ACTIVATING) {
 		part->act_state = XPC_P_ACTIVE;
-		ret = xpcSuccess;
+		ret = xpSuccess;
 	} else {
-		DBUG_ON(part->reason == xpcSuccess);
+		DBUG_ON(part->reason == xpSuccess);
 		ret = part->reason;
 	}
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
@@ -896,7 +896,7 @@ xpc_mark_partition_active(struct xpc_par
  */
 void
 xpc_deactivate_partition(const int line, struct xpc_partition *part,
-			 enum xpc_retval reason)
+			 enum xp_retval reason)
 {
 	unsigned long irq_flags;
 
@@ -905,15 +905,15 @@ xpc_deactivate_partition(const int line,
 	if (part->act_state == XPC_P_INACTIVE) {
 		XPC_SET_REASON(part, reason, line);
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
-		if (reason == xpcReactivating) {
+		if (reason == xpReactivating) {
 			/* we interrupt ourselves to reactivate partition */
 			xpc_IPI_send_reactivate(part);
 		}
 		return;
 	}
 	if (part->act_state == XPC_P_DEACTIVATING) {
-		if ((part->reason == xpcUnloading && reason != xpcUnloading) ||
-		    reason == xpcReactivating) {
+		if ((part->reason == xpUnloading && reason != xpUnloading) ||
+		    reason == xpReactivating) {
 			XPC_SET_REASON(part, reason, line);
 		}
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
@@ -985,7 +985,7 @@ xpc_discovery(void)
 	partid_t partid;
 	struct xpc_partition *part;
 	u64 *discovered_nasids;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	remote_rp = xpc_kmalloc_cacheline_aligned(XPC_RP_HEADER_SIZE +
 						  xp_nasid_mask_bytes,
@@ -1063,12 +1063,12 @@ xpc_discovery(void)
 
 			ret = xpc_get_remote_rp(nasid, discovered_nasids,
 						remote_rp, &remote_rp_pa);
-			if (ret != xpcSuccess) {
+			if (ret != xpSuccess) {
 				dev_dbg(xpc_part, "unable to get reserved page "
 					"from nasid %d, reason=%d\n", nasid,
 					ret);
 
-				if (ret == xpcLocalPartid)
+				if (ret == xpLocalPartid)
 					break;
 
 				continue;
@@ -1082,7 +1082,7 @@ xpc_discovery(void)
 			/* pull over the cross partition variables */
 
 			ret = xpc_get_remote_vars(remote_vars_pa, remote_vars);
-			if (ret != xpcSuccess) {
+			if (ret != xpSuccess) {
 				dev_dbg(xpc_part, "unable to get XPC variables "
 					"from nasid %d, reason=%d\n", nasid,
 					ret);
@@ -1116,7 +1116,7 @@ xpc_discovery(void)
 					"register xp_addr region 0x%016lx\n",
 					partid, remote_vars->amos_page_pa);
 
-				XPC_SET_REASON(part, xpcPhysAddrRegFailed,
+				XPC_SET_REASON(part, xpPhysAddrRegFailed,
 					       __LINE__);
 				break;
 			}
@@ -1151,7 +1151,7 @@ xpc_discovery(void)
  * Given a partid, get the nasids owned by that partition from the
  * remote partition's reserved page.
  */
-enum xpc_retval
+enum xp_retval
 xpc_initiate_partid_to_nasids(partid_t partid, void *nasid_mask)
 {
 	struct xpc_partition *part;
@@ -1160,7 +1160,7 @@ xpc_initiate_partid_to_nasids(partid_t p
 
 	part = &xpc_partitions[partid];
 	if (part->remote_rp_pa == 0)
-		return xpcPartitionDown;
+		return xpPartitionDown;
 
 	memset(nasid_mask, 0, XP_NASID_MASK_BYTES);
 
diff -puN drivers/misc/sgi-xp/xpnet.c~drivers-misc-sgi-xp-clean-up-return-values drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~drivers-misc-sgi-xp-clean-up-return-values
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -282,7 +282,7 @@ xpnet_receive(partid_t partid, int chann
  * state or message reception on a connection.
  */
 static void
-xpnet_connection_activity(enum xpc_retval reason, partid_t partid, int channel,
+xpnet_connection_activity(enum xp_retval reason, partid_t partid, int channel,
 			  void *data, void *key)
 {
 	long bp;
@@ -291,13 +291,13 @@ xpnet_connection_activity(enum xpc_retva
 	DBUG_ON(channel != XPC_NET_CHANNEL);
 
 	switch (reason) {
-	case xpcMsgReceived:	/* message received */
+	case xpMsgReceived:	/* message received */
 		DBUG_ON(data == NULL);
 
 		xpnet_receive(partid, channel, (struct xpnet_message *)data);
 		break;
 
-	case xpcConnected:	/* connection completed to a partition */
+	case xpConnected:	/* connection completed to a partition */
 		spin_lock_bh(&xpnet_broadcast_lock);
 		xpnet_broadcast_partitions |= 1UL << (partid - 1);
 		bp = xpnet_broadcast_partitions;
@@ -330,7 +330,7 @@ xpnet_connection_activity(enum xpc_retva
 static int
 xpnet_dev_open(struct net_device *dev)
 {
-	enum xpc_retval ret;
+	enum xp_retval ret;
 
 	dev_dbg(xpnet, "calling xpc_connect(%d, 0x%p, NULL, %ld, %ld, %ld, "
 		"%ld)\n", XPC_NET_CHANNEL, xpnet_connection_activity,
@@ -340,7 +340,7 @@ xpnet_dev_open(struct net_device *dev)
 	ret = xpc_connect(XPC_NET_CHANNEL, xpnet_connection_activity, NULL,
 			  XPNET_MSG_SIZE, XPNET_MSG_NENTRIES,
 			  XPNET_MAX_KTHREADS, XPNET_MAX_IDLE_KTHREADS);
-	if (ret != xpcSuccess) {
+	if (ret != xpSuccess) {
 		dev_err(xpnet, "ifconfig up of %s failed on XPC connect, "
 			"ret=%d\n", dev->name, ret);
 
@@ -407,7 +407,7 @@ xpnet_dev_get_stats(struct net_device *d
  * release the skb and then release our pending message structure.
  */
 static void
-xpnet_send_completed(enum xpc_retval reason, partid_t partid, int channel,
+xpnet_send_completed(enum xp_retval reason, partid_t partid, int channel,
 		     void *__qm)
 {
 	struct xpnet_pending_msg *queued_msg = (struct xpnet_pending_msg *)__qm;
@@ -439,7 +439,7 @@ static int
 xpnet_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xpnet_pending_msg *queued_msg;
-	enum xpc_retval ret;
+	enum xp_retval ret;
 	struct xpnet_message *msg;
 	u64 start_addr, end_addr;
 	long dp;
@@ -528,7 +528,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 
 		ret = xpc_allocate(dest_partid, XPC_NET_CHANNEL,
 				   XPC_NOWAIT, (void **)&msg);
-		if (unlikely(ret != xpcSuccess))
+		if (unlikely(ret != xpSuccess))
 			continue;
 
 		msg->embedded_bytes = embedded_bytes;
@@ -557,7 +557,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 
 		ret = xpc_send_notify(dest_partid, XPC_NET_CHANNEL, msg,
 				      xpnet_send_completed, queued_msg);
-		if (unlikely(ret != xpcSuccess)) {
+		if (unlikely(ret != xpSuccess)) {
 			atomic_dec(&queued_msg->use_count);
 			continue;
 		}
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch
drivers-misc-sgi-xp-clean-up-return-values.patch


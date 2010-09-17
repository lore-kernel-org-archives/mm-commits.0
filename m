From: akpm@linux-foundation.org
Subject: + memstick-a-few-changes-to-core.patch added to -mm tree
Date: Fri, 17 Sep 2010 16:17:53 -0700
Message-ID: <201009172317.o8HNHrV9015793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754222Ab0IQXRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 19:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, maximlevisky@gmail.com, oakad@yahoo.com


The patch titled
     memstick: a few changes to core
has been added to the -mm tree.  Its filename is
     memstick-a-few-changes-to-core.patch

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
Subject: memstick: a few changes to core
From: Maxim Levitsky <maximlevitsky@gmail.com>

I add here few helpers that should make memstick block driver a bit
simplier.  Currently only my forthcoming ms_block.c will use them, but I
plan to make mspro_blk use them too.

- Bump the buffer in TPC request from 15 to 32 bytes This allows to read
  all regs from device in easy manner

- Add 6 bytes to ms_registers.  Last 6 registers are readable but
  reserved.  Unfortunelly some drivers/hardware have problem transferring
  non-power of two data packets.  That really just papers over a bug in
  jmicron driver, but temporarly untill that is fixed.

Signed-off-by: Maxim Levitsky <maximlevisky@gmail.com>
Acked-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |  109 +++++++++++++++++++++++++++++
 include/linux/memstick.h         |   23 +++++-
 2 files changed, 131 insertions(+), 1 deletion(-)

diff -puN drivers/memstick/core/memstick.c~memstick-a-few-changes-to-core drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-a-few-changes-to-core
+++ a/drivers/memstick/core/memstick.c
@@ -362,6 +362,13 @@ static int h_memstick_set_rw_addr(struct
 	}
 }
 
+
+static int h_mspro_block_default_bad(struct memstick_dev *card,
+				     struct memstick_request **mrq)
+{
+	return -ENXIO;
+}
+
 /**
  * memstick_set_rw_addr - issue SET_RW_REG_ADDR request and wait for it to
  *                        complete
@@ -377,6 +384,108 @@ int memstick_set_rw_addr(struct memstick
 }
 EXPORT_SYMBOL(memstick_set_rw_addr);
 
+
+/**
+ * memstick_fetch_request - initialize new request to use by request handler
+ * @card - card to use
+ * @mrq - request to initialize
+ */
+void memstick_fetch_request(struct memstick_dev *card,
+					struct memstick_request **mrq)
+{
+	if (*mrq == NULL) {
+		*mrq = &card->current_mrq;
+		(*mrq)->error = 0;
+		card->state = 0;
+	}
+}
+EXPORT_SYMBOL(memstick_fetch_request);
+
+/**
+ * memstick_complete_req - signal that request is completed
+ * @card - card to use
+ * @mrq - request to use
+ * @error - result of the request
+ *
+ * Card drivers can use that function to signal end of request
+ */
+int memstick_complete_request(struct memstick_dev *card,
+			struct memstick_request *req, int error)
+{
+	if (error)
+		req->error = error;
+
+	card->state = -1;
+	card->next_request = h_mspro_block_default_bad;
+	complete(&card->mrq_complete);
+	return -EAGAIN;
+}
+EXPORT_SYMBOL(memstick_complete_request);
+
+/**
+ * ms_send_int_request - optionaly init new MS_TPC_GET_INT.
+ * if last request already contains the int flags, reuse them
+ * returns 1 if new request was initialized
+ * Will artifictially return MEMSTICK_INT_CMDNAK if this function was
+ * called more that once in 300 msecs without memstick_finish_int_request
+ * in between
+ * @card - card to use
+ * @mrq - request to use
+ */
+
+int memstick_send_int_request(struct memstick_dev *card,
+					struct memstick_request *req)
+{
+	if (!card->int_polling) {
+		card->int_poll_start_time = jiffies;
+		card->int_polling = true;
+	} else if (time_after(jiffies,
+			card->int_poll_start_time + msecs_to_jiffies(300))) {
+		req->data[0] |= MEMSTICK_INT_CMDNAK;
+		return 0;
+	}
+
+	if ((card->caps & MEMSTICK_CAP_AUTO_GET_INT) && req->need_card_int) {
+		BUG_ON(req->error);
+		req->data[0] = req->int_reg;
+		req->need_card_int = 0;
+		return 0;
+	} else {
+		memstick_init_req(req, MS_TPC_GET_INT, NULL, 1);
+		return 1;
+	}
+}
+EXPORT_SYMBOL(memstick_send_int_request);
+
+/**
+ * Signal success of int polling, and cancel timeout
+ * Use this if you use memstick_send_int_request
+ * @card - card to use
+ */
+void memstick_finish_int_request(struct memstick_dev *card)
+{
+	card->int_polling = false;
+}
+EXPORT_SYMBOL(memstick_finish_int_request);
+
+/**
+ * memstick_do_request_handler - runs state machine untill it finishes
+ * helper to be used in card drivers
+ * @card - card to use
+ * next_request - the state machine
+ */
+int memstick_do_request_handler(struct memstick_dev *card,
+	int   (*next_request)(struct memstick_dev *card,
+					struct memstick_request **mrq))
+{
+	card->next_request = next_request;
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+	return card->current_mrq.error;
+}
+EXPORT_SYMBOL(memstick_do_request_handler);
+
+
 static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 {
 	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
diff -puN include/linux/memstick.h~memstick-a-few-changes-to-core include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-a-few-changes-to-core
+++ a/include/linux/memstick.h
@@ -92,6 +92,7 @@ struct ms_register {
 	unsigned char                 reserved[8];
 	struct ms_param_register      param;
 	struct ms_extra_data_register extra_data;
+	unsigned char                 reserved2[6];
 } __attribute__((packed));
 
 struct mspro_param_register {
@@ -247,7 +248,7 @@ struct memstick_request {
 		struct scatterlist sg;
 		struct {
 			unsigned char data_len;
-			unsigned char data[15];
+			unsigned char data[32];
 		};
 	};
 };
@@ -270,6 +271,12 @@ struct memstick_dev {
 	void                     (*start)(struct memstick_dev *card);
 
 	struct device            dev;
+
+	/* Private area for request processing */
+	bool			 int_polling;
+	unsigned long		 int_poll_start_time;
+	int			 state;
+	int			 caps;
 };
 
 struct memstick_host {
@@ -329,6 +336,20 @@ void memstick_new_req(struct memstick_ho
 
 int memstick_set_rw_addr(struct memstick_dev *card);
 
+void memstick_fetch_request(struct memstick_dev *card,
+					struct memstick_request **mrq);
+int memstick_complete_request(struct memstick_dev *card,
+			struct memstick_request *req, int error);
+
+int memstick_send_int_request(struct memstick_dev *card,
+					struct memstick_request *req);
+
+void memstick_finish_int_request(struct memstick_dev *card);
+
+int memstick_do_request_handler(struct memstick_dev *card,
+	int   (*next_request)(struct memstick_dev *card,
+				struct memstick_request **mrq));
+
 static inline void *memstick_priv(struct memstick_host *host)
 {
 	return (void *)host->private;
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
drivers-media-ir-ene_irc-fix-null-dereference.patch
memstick-a-few-changes-to-core.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch


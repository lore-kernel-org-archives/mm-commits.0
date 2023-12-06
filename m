Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9CAC4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 18:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjLFSVT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 13:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjLFSVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 13:21:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF9D4B
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 10:21:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E94C433C8;
        Wed,  6 Dec 2023 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701886884;
        bh=m9hTY5yXe6wXTB3JkfLLv8t3WuNMebArvwHfR1k/nIQ=;
        h=Date:To:From:Subject:From;
        b=WYmvdJPTOhiJcwTG1q9Ugd4mS+M8eSVwjQ7dKQTZw0KC0cWAsw6wSgsMKvCO/qyra
         999Fkb8yyNQef5+Y9JZra8/ork6IgV5kh7Q++5QAe0FIHxtu7iEN+XGb3JPDH50Rch
         87CPfZi4gVRId/DhYwgcda2CQ7qQyluDYorzLBd0=
Date:   Wed, 06 Dec 2023 10:21:23 -0800
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        alex.bou9@gmail.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-tsi721-fix-kernel-doc-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20231206182124.53E94C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix kernel-doc warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-tsi721-fix-kernel-doc-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-tsi721-fix-kernel-doc-warnings.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: rapidio/tsi721: fix kernel-doc warnings
Date: Wed, 6 Dec 2023 09:55:28 -0800

Correct kernel-doc comments in tsi721.c and tsi721_dma.c to prevent
warnings from scripts/kernel-doc.

tsi721_dma.c:293: warning: expecting prototype for tsi721_omsg_msix(). Prototype was for tsi721_bdma_msix() instead

tsi721.c:215: warning: Function parameter or member 'data' not described in 'tsi721_cread_dma'
tsi721.c:215: warning: Excess function parameter 'val' description in 'tsi721_cread_dma'
tsi721.c:238: warning: Function parameter or member 'data' not described in 'tsi721_cwrite_dma'
tsi721.c:238: warning: Excess function parameter 'val' description in 'tsi721_cwrite_dma'
tsi721.c:2548: warning: Function parameter or member 'attr' not described in 'tsi721_query_mport'
tsi721.c:2548: warning: Excess function parameter 'mbox' description in 'tsi721_query_mport'
and 27 warnings like this one:
tsi721.c:59: warning: No description found for return value of 'tsi721_lcread'

Link: https://lkml.kernel.org/r/20231206175528.16386-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c     |   67 +++++++++++++++++++------
 drivers/rapidio/devices/tsi721_dma.c |    4 +
 2 files changed, 55 insertions(+), 16 deletions(-)

--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-kernel-doc-warnings
+++ a/drivers/rapidio/devices/tsi721.c
@@ -51,8 +51,9 @@ static void tsi721_imsg_handler(struct t
  * @len: Length (in bytes) of the maintenance transaction
  * @data: Value to be read into
  *
- * Generates a local SREP space read. Returns %0 on
- * success or %-EINVAL on failure.
+ * Generates a local SREP space read.
+ *
+ * Returns: %0 on success or %-EINVAL on failure.
  */
 static int tsi721_lcread(struct rio_mport *mport, int index, u32 offset,
 			 int len, u32 *data)
@@ -75,8 +76,9 @@ static int tsi721_lcread(struct rio_mpor
  * @len: Length (in bytes) of the maintenance transaction
  * @data: Value to be written
  *
- * Generates a local write into SREP configuration space. Returns %0 on
- * success or %-EINVAL on failure.
+ * Generates a local write into SREP configuration space.
+ *
+ * Returns: %0 on success or %-EINVAL on failure.
  */
 static int tsi721_lcwrite(struct rio_mport *mport, int index, u32 offset,
 			  int len, u32 data)
@@ -104,7 +106,7 @@ static int tsi721_lcwrite(struct rio_mpo
  * @do_wr: Operation flag (1 == MAINT_WR)
  *
  * Generates a RapidIO maintenance transaction (Read or Write).
- * Returns %0 on success and %-EINVAL or %-EFAULT on failure.
+ * Returns: %0 on success and %-EINVAL or %-EFAULT on failure.
  */
 static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
 			u16 destid, u8 hopcount, u32 offset, int len,
@@ -205,10 +207,10 @@ err_out:
  * @hopcount: Number of hops to target device
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
- * @val: Location to be read into
+ * @data: Location to be read into
  *
  * Generates a RapidIO maintenance read transaction.
- * Returns %0 on success and %-EINVAL or %-EFAULT on failure.
+ * Returns: %0 on success and %-EINVAL or %-EFAULT on failure.
  */
 static int tsi721_cread_dma(struct rio_mport *mport, int index, u16 destid,
 			u8 hopcount, u32 offset, int len, u32 *data)
@@ -228,10 +230,10 @@ static int tsi721_cread_dma(struct rio_m
  * @hopcount: Number of hops to target device
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
- * @val: Value to be written
+ * @data: Value to be written
  *
  * Generates a RapidIO maintenance write transaction.
- * Returns %0 on success and %-EINVAL or %-EFAULT on failure.
+ * Returns: %0 on success and %-EINVAL or %-EFAULT on failure.
  */
 static int tsi721_cwrite_dma(struct rio_mport *mport, int index, u16 destid,
 			 u8 hopcount, u32 offset, int len, u32 data)
@@ -250,6 +252,8 @@ static int tsi721_cwrite_dma(struct rio_
  * Handles inbound port-write interrupts. Copies PW message from an internal
  * buffer into PW message FIFO and schedules deferred routine to process
  * queued messages.
+ *
+ * Returns: %0
  */
 static int
 tsi721_pw_handler(struct tsi721_device *priv)
@@ -307,6 +311,8 @@ static void tsi721_pw_dpc(struct work_st
  * tsi721_pw_enable - enable/disable port-write interface init
  * @mport: Master port implementing the port write unit
  * @enable:    1=enable; 0=disable port-write message handling
+ *
+ * Returns: %0
  */
 static int tsi721_pw_enable(struct rio_mport *mport, int enable)
 {
@@ -336,7 +342,9 @@ static int tsi721_pw_enable(struct rio_m
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell
  *
- * Sends a RapidIO doorbell message. Always returns %0.
+ * Sends a RapidIO doorbell message.
+ *
+ * Returns: %0
  */
 static int tsi721_dsend(struct rio_mport *mport, int index,
 			u16 destid, u16 data)
@@ -361,6 +369,8 @@ static int tsi721_dsend(struct rio_mport
  * Handles inbound doorbell interrupts. Copies doorbell entry from an internal
  * buffer into DB message FIFO and schedules deferred  routine to process
  * queued DBs.
+ *
+ * Returns: %0
  */
 static int
 tsi721_dbell_handler(struct tsi721_device *priv)
@@ -453,6 +463,8 @@ static void tsi721_db_dpc(struct work_st
  *
  * Handles Tsi721 interrupts signaled using MSI and INTA. Checks reported
  * interrupt events and calls an event-specific handler(s).
+ *
+ * Returns: %IRQ_HANDLED or %IRQ_NONE
  */
 static irqreturn_t tsi721_irqhandler(int irq, void *ptr)
 {
@@ -607,6 +619,8 @@ static void tsi721_interrupts_init(struc
  * @ptr: Pointer to interrupt-specific data (tsi721_device structure)
  *
  * Handles outbound messaging interrupts signaled using MSI-X.
+ *
+ * Returns: %IRQ_HANDLED
  */
 static irqreturn_t tsi721_omsg_msix(int irq, void *ptr)
 {
@@ -624,6 +638,8 @@ static irqreturn_t tsi721_omsg_msix(int
  * @ptr: Pointer to interrupt-specific data (tsi721_device structure)
  *
  * Handles inbound messaging interrupts signaled using MSI-X.
+ *
+ * Returns: %IRQ_HANDLED
  */
 static irqreturn_t tsi721_imsg_msix(int irq, void *ptr)
 {
@@ -641,6 +657,8 @@ static irqreturn_t tsi721_imsg_msix(int
  * @ptr: Pointer to interrupt-specific data (tsi721_device structure)
  *
  * Handles Tsi721 interrupts from SRIO MAC.
+ *
+ * Returns: %IRQ_HANDLED
  */
 static irqreturn_t tsi721_srio_msix(int irq, void *ptr)
 {
@@ -663,6 +681,8 @@ static irqreturn_t tsi721_srio_msix(int
  * Handles Tsi721 interrupts from SR2PC Channel.
  * NOTE: At this moment services only one SR2PC channel associated with inbound
  * doorbells.
+ *
+ * Returns: %IRQ_HANDLED
  */
 static irqreturn_t tsi721_sr2pc_ch_msix(int irq, void *ptr)
 {
@@ -689,6 +709,8 @@ static irqreturn_t tsi721_sr2pc_ch_msix(
  * Registers MSI-X interrupt service routines for interrupts that are active
  * immediately after mport initialization. Messaging interrupt service routines
  * should be registered during corresponding open requests.
+ *
+ * Returns: %0 on success or -errno value on failure.
  */
 static int tsi721_request_msix(struct tsi721_device *priv)
 {
@@ -717,6 +739,8 @@ static int tsi721_request_msix(struct ts
  *
  * Configures MSI-X support for Tsi721. Supports only an exact number
  * of requested vectors.
+ *
+ * Returns: %0 on success or -errno value on failure.
  */
 static int tsi721_enable_msix(struct tsi721_device *priv)
 {
@@ -1334,7 +1358,7 @@ static void tsi721_close_sr2pc_mapping(s
  * @priv: pointer to tsi721 private data
  *
  * Initializes inbound port write handler.
- * Returns %0 on success or %-ENOMEM on failure.
+ * Returns: %0 on success or %-ENOMEM on failure.
  */
 static int tsi721_port_write_init(struct tsi721_device *priv)
 {
@@ -1412,7 +1436,8 @@ static void tsi721_doorbell_free(struct
  *
  * Initialize BDMA channel allocated for RapidIO maintenance read/write
  * request generation
- * Returns %0 on success or %-ENOMEM on failure.
+ *
+ * Returns: %0 on success or %-ENOMEM on failure.
  */
 static int tsi721_bdma_maint_init(struct tsi721_device *priv)
 {
@@ -1662,6 +1687,8 @@ tsi721_omsg_interrupt_disable(struct tsi
  * @mbox: Outbound mailbox
  * @buffer: Message to add to outbound queue
  * @len: Length of message
+ *
+ * Returns: %0 on success or -errno value on failure.
  */
 static int
 tsi721_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
@@ -1869,6 +1896,8 @@ no_sts_update:
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
  * @entries: Number of entries in the outbound mailbox ring
+ *
+ * Returns: %0 on success or -errno value on failure.
  */
 static int tsi721_open_outb_mbox(struct rio_mport *mport, void *dev_id,
 				 int mbox, int entries)
@@ -2156,6 +2185,8 @@ static void tsi721_imsg_handler(struct t
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
  * @entries: Number of entries in the inbound mailbox ring
+ *
+ * Returns: %0 on success or -errno value on failure.
  */
 static int tsi721_open_inb_mbox(struct rio_mport *mport, void *dev_id,
 				int mbox, int entries)
@@ -2409,6 +2440,8 @@ static void tsi721_close_inb_mbox(struct
  * @mport: Master port implementing the Inbound Messaging Engine
  * @mbox: Inbound mailbox number
  * @buf: Buffer to add to inbound queue
+ *
+ * Returns: %0 on success or -errno value on failure.
  */
 static int tsi721_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
 {
@@ -2439,7 +2472,7 @@ out:
  * @mport: Master port implementing the Inbound Messaging Engine
  * @mbox: Inbound mailbox number
  *
- * Returns pointer to the message on success or NULL on failure.
+ * Returns: pointer to the message on success or %NULL on failure.
  */
 static void *tsi721_get_inb_message(struct rio_mport *mport, int mbox)
 {
@@ -2507,6 +2540,8 @@ out:
  * @priv: pointer to tsi721 private data
  *
  * Configures Tsi721 messaging engine.
+ *
+ * Returns: %0
  */
 static int tsi721_messages_init(struct tsi721_device *priv)
 {
@@ -2539,9 +2574,9 @@ static int tsi721_messages_init(struct t
 /**
  * tsi721_query_mport - Fetch inbound message from the Tsi721 MSG Queue
  * @mport: Master port implementing the Inbound Messaging Engine
- * @mbox: Inbound mailbox number
+ * @attr: mport device attributes
  *
- * Returns pointer to the message on success or NULL on failure.
+ * Returns: pointer to the message on success or %NULL on failure.
  */
 static int tsi721_query_mport(struct rio_mport *mport,
 			      struct rio_mport_attr *attr)
@@ -2653,6 +2688,8 @@ static void tsi721_mport_release(struct
  * @priv: pointer to tsi721 private data
  *
  * Configures Tsi721 as RapidIO master port.
+ *
+ * Returns: %0 on success or -errno value on failure.
  */
 static int tsi721_setup_mport(struct tsi721_device *priv)
 {
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721-fix-kernel-doc-warnings
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -283,11 +283,13 @@ void tsi721_bdma_handler(struct tsi721_b
 
 #ifdef CONFIG_PCI_MSI
 /**
- * tsi721_omsg_msix - MSI-X interrupt handler for BDMA channels
+ * tsi721_bdma_msix - MSI-X interrupt handler for BDMA channels
  * @irq: Linux interrupt number
  * @ptr: Pointer to interrupt-specific data (BDMA channel structure)
  *
  * Handles BDMA channel interrupts signaled using MSI-X.
+ *
+ * Returns: %IRQ_HANDLED
  */
 static irqreturn_t tsi721_bdma_msix(int irq, void *ptr)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rapidio-tsi721-fix-kernel-doc-warnings.patch


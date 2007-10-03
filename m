From: akpm@linux-foundation.org
Subject: + change-struct-marker-users.patch added to -mm tree
Date: Wed, 03 Oct 2007 15:22:25 -0700
Message-ID: <200710032222.l93MMPd0011585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756810AbXJCWXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 18:23:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, James.Bottomley@SteelEye.com, ctindel@users.sourceforge.net, david.somayajulu@qlogic.com, fubar@us.ibm.com, ravi.anand@qlogic.com


The patch titled
     Change struct marker users
has been added to the -mm tree.  Its filename is
     change-struct-marker-users.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Change struct marker users
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Prior to use struct marker in the linux kernel markers, we need to clean
two drivers which use this structure name.

Change bonding driver types :
- struct marker to struct bond_marker.
- marker_t to bond_marker_t.
- marker_header to bond_marker_header.
- marker_header_t to bond_marker_header_t.

Change qla4xxx struct marker_entry usage :
- Change struct marker_entry for struct qla4_marker_entry.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Chad Tindel <ctindel@users.sourceforge.net>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: David Somayajulu <david.somayajulu@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/bonding/bond_3ad.c~change-struct-marker-users drivers/net/bonding/bond_3ad.c
--- a/drivers/net/bonding/bond_3ad.c~change-struct-marker-users
+++ a/drivers/net/bonding/bond_3ad.c
@@ -126,7 +126,7 @@ static struct aggregator *__get_active_a
 
 // ================= main 802.3ad protocol functions ==================
 static int ad_lacpdu_send(struct port *port);
-static int ad_marker_send(struct port *port, struct marker *marker);
+static int ad_marker_send(struct port *port, struct bond_marker *marker);
 static void ad_mux_machine(struct port *port);
 static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port);
 static void ad_tx_machine(struct port *port);
@@ -139,8 +139,8 @@ static void ad_initialize_port(struct po
 static void ad_initialize_lacpdu(struct lacpdu *Lacpdu);
 static void ad_enable_collecting_distributing(struct port *port);
 static void ad_disable_collecting_distributing(struct port *port);
-static void ad_marker_info_received(struct marker *marker_info, struct port *port);
-static void ad_marker_response_received(struct marker *marker, struct port *port);
+static void ad_marker_info_received(struct bond_marker *marker_info, struct port *port);
+static void ad_marker_response_received(struct bond_marker *marker, struct port *port);
 
 
 /////////////////////////////////////////////////////////////////////////////////
@@ -889,12 +889,12 @@ static int ad_lacpdu_send(struct port *p
  * Returns:   0 on success
  *          < 0 on error
  */
-static int ad_marker_send(struct port *port, struct marker *marker)
+static int ad_marker_send(struct port *port, struct bond_marker *marker)
 {
 	struct slave *slave = port->slave;
 	struct sk_buff *skb;
-	struct marker_header *marker_header;
-	int length = sizeof(struct marker_header);
+	struct bond_marker_header *marker_header;
+	int length = sizeof(struct bond_marker_header);
 	struct mac_addr lacpdu_multicast_address = AD_MULTICAST_LACPDU_ADDR;
 
 	skb = dev_alloc_skb(length + 16);
@@ -909,7 +909,7 @@ static int ad_marker_send(struct port *p
 	skb->network_header = skb->mac_header + ETH_HLEN;
 	skb->protocol = PKT_TYPE_LACPDU;
 
-	marker_header = (struct marker_header *)skb_put(skb, length);
+	marker_header = (struct bond_marker_header *)skb_put(skb, length);
 
 	marker_header->ad_header.destination_address = lacpdu_multicast_address;
 	/* Note: source addres is set to be the member's PERMANENT address, because we use it
@@ -1709,7 +1709,7 @@ static void ad_disable_collecting_distri
  */
 static void ad_marker_info_send(struct port *port)
 {
-	struct marker marker;
+	struct bond_marker marker;
 	u16 index;
 
 	// fill the marker PDU with the appropriate values
@@ -1742,13 +1742,14 @@ static void ad_marker_info_send(struct p
  * @port: the port we're looking at
  *
  */
-static void ad_marker_info_received(struct marker *marker_info,struct port *port)
+static void ad_marker_info_received(struct bond_marker *marker_info,
+	struct port *port)
 {
-	struct marker marker;
+	struct bond_marker marker;
 
 	// copy the received marker data to the response marker
 	//marker = *marker_info;
-	memcpy(&marker, marker_info, sizeof(struct marker));
+	memcpy(&marker, marker_info, sizeof(struct bond_marker));
 	// change the marker subtype to marker response
 	marker.tlv_type=AD_MARKER_RESPONSE_SUBTYPE;
 	// send the marker response
@@ -1767,7 +1768,8 @@ static void ad_marker_info_received(stru
  * response for marker PDU's, in this stage, but only to respond to marker
  * information.
  */
-static void ad_marker_response_received(struct marker *marker, struct port *port)
+static void ad_marker_response_received(struct bond_marker *marker,
+	struct port *port)
 {
 	marker=NULL; // just to satisfy the compiler
 	port=NULL;  // just to satisfy the compiler
@@ -2164,15 +2166,15 @@ static void bond_3ad_rx_indication(struc
 		case AD_TYPE_MARKER:
 			// No need to convert fields to Little Endian since we don't use the marker's fields.
 
-			switch (((struct marker *)lacpdu)->tlv_type) {
+			switch (((struct bond_marker *)lacpdu)->tlv_type) {
 			case AD_MARKER_INFORMATION_SUBTYPE:
 				dprintk("Received Marker Information on port %d\n", port->actor_port_number);
-				ad_marker_info_received((struct marker *)lacpdu, port);
+				ad_marker_info_received((struct bond_marker *)lacpdu, port);
 				break;
 
 			case AD_MARKER_RESPONSE_SUBTYPE:
 				dprintk("Received Marker Response on port %d\n", port->actor_port_number);
-				ad_marker_response_received((struct marker *)lacpdu, port);
+				ad_marker_response_received((struct bond_marker *)lacpdu, port);
 				break;
 
 			default:
diff -puN drivers/net/bonding/bond_3ad.h~change-struct-marker-users drivers/net/bonding/bond_3ad.h
--- a/drivers/net/bonding/bond_3ad.h~change-struct-marker-users
+++ a/drivers/net/bonding/bond_3ad.h
@@ -92,7 +92,7 @@ typedef enum {
 typedef enum {
 	AD_MARKER_INFORMATION_SUBTYPE = 1, // marker imformation subtype
 	AD_MARKER_RESPONSE_SUBTYPE     // marker response subtype
-} marker_subtype_t;
+} bond_marker_subtype_t;
 
 // timers types(43.4.9 in the 802.3ad standard)
 typedef enum {
@@ -148,7 +148,7 @@ typedef struct lacpdu_header {
 } lacpdu_header_t;
 
 // Marker Protocol Data Unit(PDU) structure(43.5.3.2 in the 802.3ad standard)
-typedef struct marker {
+typedef struct bond_marker {
 	u8 subtype;		 //  = 0x02  (marker PDU)
 	u8 version_number;	 //  = 0x01
 	u8 tlv_type;		 //  = 0x01  (marker information)
@@ -161,12 +161,12 @@ typedef struct marker {
 	u8 tlv_type_terminator;	     //  = 0x00
 	u8 terminator_length;	     //  = 0x00
 	u8 reserved_90[90];	     //  = 0
-} marker_t;
+} bond_marker_t;
 
-typedef struct marker_header {
+typedef struct bond_marker_header {
 	struct ad_header ad_header;
-	struct marker marker;
-} marker_header_t;
+	struct bond_marker marker;
+} bond_marker_header_t;
 
 #pragma pack()
 
diff -puN drivers/scsi/qla4xxx/ql4_fw.h~change-struct-marker-users drivers/scsi/qla4xxx/ql4_fw.h
--- a/drivers/scsi/qla4xxx/ql4_fw.h~change-struct-marker-users
+++ a/drivers/scsi/qla4xxx/ql4_fw.h
@@ -671,7 +671,7 @@ struct continuation_t1_entry {
 #define ET_CONTINUE	ET_CONT_T1
 
 /* Marker entry structure*/
-struct marker_entry {
+struct qla4_marker_entry {
 	struct qla4_header hdr;	/* 00-03 */
 
 	uint32_t system_defined; /* 04-07 */
diff -puN drivers/scsi/qla4xxx/ql4_iocb.c~change-struct-marker-users drivers/scsi/qla4xxx/ql4_iocb.c
--- a/drivers/scsi/qla4xxx/ql4_iocb.c~change-struct-marker-users
+++ a/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -69,7 +69,7 @@ static int qla4xxx_get_req_pkt(struct sc
 static int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
 				    struct ddb_entry *ddb_entry, int lun)
 {
-	struct marker_entry *marker_entry;
+	struct qla4_marker_entry *marker_entry;
 	unsigned long flags = 0;
 	uint8_t status = QLA_SUCCESS;
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-documentation-update-2.patch
local_t-update-documentation.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-alignment-fix.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-documentation.patch

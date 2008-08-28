From: akpm@linux-foundation.org
Subject: + e1000-fix-stack-size.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:52:25 -0700
Message-ID: <200808280352.m7S3qPlA005977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755AbYH1Dx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torvalds@linux-foundation.org, auke-jan.h.kok@intel.com, emil.s.tantilov@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com


The patch titled
     e1000: fix stack size
has been added to the -mm tree.  Its filename is
     e1000-fix-stack-size.patch

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
Subject: e1000: fix stack size
From: Linus Torvalds <torvalds@linux-foundation.org>

Shrink the stack from 1152 bytes to 192 bytes (the first version, that
only did the e1000_option part, got it down to 600 bytes).  About half
comes from not using multiple "e1000_option" structures, the other half
comes from turning the "e1000_opt_list[]" arrays into "static const"
instead, so that gcc doesn't copy them onto the stack.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reveiewed-by: Auke Kok <auke-jan.h.kok@intel.com>
Tested-by: Emil Tantilov <emil.s.tantilov@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_param.c |   81 ++++++++++++++++--------------
 1 file changed, 45 insertions(+), 36 deletions(-)

diff -puN drivers/net/e1000/e1000_param.c~e1000-fix-stack-size drivers/net/e1000/e1000_param.c
--- a/drivers/net/e1000/e1000_param.c~e1000-fix-stack-size
+++ a/drivers/net/e1000/e1000_param.c
@@ -208,7 +208,7 @@ struct e1000_option {
 		} r;
 		struct { /* list_option info */
 			int nr;
-			struct e1000_opt_list { int i; char *str; } *p;
+			const struct e1000_opt_list { int i; char *str; } *p;
 		} l;
 	} arg;
 };
@@ -242,7 +242,7 @@ static int __devinit e1000_validate_opti
 		break;
 	case list_option: {
 		int i;
-		struct e1000_opt_list *ent;
+		const struct e1000_opt_list *ent;
 
 		for (i = 0; i < opt->arg.l.nr; i++) {
 			ent = &opt->arg.l.p[i];
@@ -279,7 +279,9 @@ static void e1000_check_copper_options(s
 
 void __devinit e1000_check_options(struct e1000_adapter *adapter)
 {
+	struct e1000_option opt;
 	int bd = adapter->bd_number;
+
 	if (bd >= E1000_MAX_NIC) {
 		DPRINTK(PROBE, NOTICE,
 		       "Warning: no configuration for board #%i\n", bd);
@@ -287,19 +289,21 @@ void __devinit e1000_check_options(struc
 	}
 
 	{ /* Transmit Descriptor Count */
-		struct e1000_option opt = {
+		struct e1000_tx_ring *tx_ring = adapter->tx_ring;
+		int i;
+		e1000_mac_type mac_type = adapter->hw.mac_type;
+
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Transmit Descriptors",
 			.err  = "using default of "
 				__MODULE_STRING(E1000_DEFAULT_TXD),
 			.def  = E1000_DEFAULT_TXD,
-			.arg  = { .r = { .min = E1000_MIN_TXD }}
+			.arg  = { .r = {
+				.min = E1000_MIN_TXD,
+				.max = mac_type < e1000_82544 ? E1000_MAX_TXD : E1000_MAX_82544_TXD
+				}}
 		};
-		struct e1000_tx_ring *tx_ring = adapter->tx_ring;
-		int i;
-		e1000_mac_type mac_type = adapter->hw.mac_type;
-		opt.arg.r.max = mac_type < e1000_82544 ?
-			E1000_MAX_TXD : E1000_MAX_82544_TXD;
 
 		if (num_TxDescriptors > bd) {
 			tx_ring->count = TxDescriptors[bd];
@@ -313,19 +317,21 @@ void __devinit e1000_check_options(struc
 			tx_ring[i].count = tx_ring->count;
 	}
 	{ /* Receive Descriptor Count */
-		struct e1000_option opt = {
+		struct e1000_rx_ring *rx_ring = adapter->rx_ring;
+		int i;
+		e1000_mac_type mac_type = adapter->hw.mac_type;
+
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Receive Descriptors",
 			.err  = "using default of "
 				__MODULE_STRING(E1000_DEFAULT_RXD),
 			.def  = E1000_DEFAULT_RXD,
-			.arg  = { .r = { .min = E1000_MIN_RXD }}
+			.arg  = { .r = {
+				.min = E1000_MIN_RXD,
+				.max = mac_type < e1000_82544 ? E1000_MAX_RXD : E1000_MAX_82544_RXD
+			}}
 		};
-		struct e1000_rx_ring *rx_ring = adapter->rx_ring;
-		int i;
-		e1000_mac_type mac_type = adapter->hw.mac_type;
-		opt.arg.r.max = mac_type < e1000_82544 ? E1000_MAX_RXD :
-			E1000_MAX_82544_RXD;
 
 		if (num_RxDescriptors > bd) {
 			rx_ring->count = RxDescriptors[bd];
@@ -339,7 +345,7 @@ void __devinit e1000_check_options(struc
 			rx_ring[i].count = rx_ring->count;
 	}
 	{ /* Checksum Offload Enable/Disable */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = enable_option,
 			.name = "Checksum Offload",
 			.err  = "defaulting to Enabled",
@@ -363,7 +369,7 @@ void __devinit e1000_check_options(struc
 			 { E1000_FC_FULL,    "Flow Control Enabled" },
 			 { E1000_FC_DEFAULT, "Flow Control Hardware Default" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "Flow Control",
 			.err  = "reading default settings from EEPROM",
@@ -381,7 +387,7 @@ void __devinit e1000_check_options(struc
 		}
 	}
 	{ /* Transmit Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Transmit Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_TIDV),
@@ -399,7 +405,7 @@ void __devinit e1000_check_options(struc
 		}
 	}
 	{ /* Transmit Absolute Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Transmit Absolute Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_TADV),
@@ -417,7 +423,7 @@ void __devinit e1000_check_options(struc
 		}
 	}
 	{ /* Receive Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Receive Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_RDTR),
@@ -435,7 +441,7 @@ void __devinit e1000_check_options(struc
 		}
 	}
 	{ /* Receive Absolute Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Receive Absolute Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_RADV),
@@ -453,7 +459,7 @@ void __devinit e1000_check_options(struc
 		}
 	}
 	{ /* Interrupt Throttling Rate */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Interrupt Throttling Rate (ints/sec)",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_ITR),
@@ -497,7 +503,7 @@ void __devinit e1000_check_options(struc
 		}
 	}
 	{ /* Smart Power Down */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = enable_option,
 			.name = "PHY Smart Power Down",
 			.err  = "defaulting to Disabled",
@@ -513,7 +519,7 @@ void __devinit e1000_check_options(struc
 		}
 	}
 	{ /* Kumeran Lock Loss Workaround */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = enable_option,
 			.name = "Kumeran Lock Loss Workaround",
 			.err  = "defaulting to Enabled",
@@ -578,16 +584,18 @@ static void __devinit e1000_check_fiber_
 
 static void __devinit e1000_check_copper_options(struct e1000_adapter *adapter)
 {
+	struct e1000_option opt;
 	unsigned int speed, dplx, an;
 	int bd = adapter->bd_number;
 
 	{ /* Speed */
-		struct e1000_opt_list speed_list[] = {{          0, "" },
-						      {   SPEED_10, "" },
-						      {  SPEED_100, "" },
-						      { SPEED_1000, "" }};
+		static const struct e1000_opt_list speed_list[] = {
+			{          0, "" },
+			{   SPEED_10, "" },
+			{  SPEED_100, "" },
+			{ SPEED_1000, "" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "Speed",
 			.err  = "parameter ignored",
@@ -604,11 +612,12 @@ static void __devinit e1000_check_copper
 		}
 	}
 	{ /* Duplex */
-		struct e1000_opt_list dplx_list[] = {{           0, "" },
-						     { HALF_DUPLEX, "" },
-						     { FULL_DUPLEX, "" }};
+		static const struct e1000_opt_list dplx_list[] = {
+			{           0, "" },
+			{ HALF_DUPLEX, "" },
+			{ FULL_DUPLEX, "" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "Duplex",
 			.err  = "parameter ignored",
@@ -637,7 +646,7 @@ static void __devinit e1000_check_copper
 		       "parameter ignored\n");
 		adapter->hw.autoneg_advertised = AUTONEG_ADV_DEFAULT;
 	} else { /* Autoneg */
-		struct e1000_opt_list an_list[] =
+		static const struct e1000_opt_list an_list[] =
 			#define AA "AutoNeg advertising "
 			{{ 0x01, AA "10/HD" },
 			 { 0x02, AA "10/FD" },
@@ -671,7 +680,7 @@ static void __devinit e1000_check_copper
 			 { 0x2e, AA "1000/FD, 100/FD, 100/HD, 10/FD" },
 			 { 0x2f, AA "1000/FD, 100/FD, 100/HD, 10/FD, 10/HD" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "AutoNeg",
 			.err  = "parameter ignored",
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

origin.patch
linux-next.patch
e1000-fix-stack-size.patch
workaround-for-a-pci-restoring-bug.patch


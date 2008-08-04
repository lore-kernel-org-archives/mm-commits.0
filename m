From: akpm@linux-foundation.org
Subject: - atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:13 -0700
Message-ID: <200808042007.m74K7Dfr027761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761979AbYHDUH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, chas@cmf.nrl.navy.mil, mm-commits@vger.kernel.org


The patch titled
     atm: fix const assignment/discard warnings in the ATM networking driver
has been removed from the -mm tree.  Its filename was
     atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atm: fix const assignment/discard warnings in the ATM networking driver
From: David Howells <dhowells@redhat.com>

Fix const assignment/discard warnings in the ATM networking driver.

The lane2_assoc_ind() function needed its arguments changing to match changes
in the lane2_ops struct (patch 61c33e012964ce358b42d2a1e9cd309af5dab02b).

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/atm/mpc.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN net/atm/mpc.c~atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver net/atm/mpc.c
--- a/net/atm/mpc.c~atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver
+++ a/net/atm/mpc.c
@@ -62,11 +62,13 @@ static void MPOA_cache_impos_rcvd(struct
 static void set_mpc_ctrl_addr_rcvd(struct k_message *mesg, struct mpoa_client *mpc);
 static void set_mps_mac_addr_rcvd(struct k_message *mesg, struct mpoa_client *mpc);
 
-static uint8_t *copy_macs(struct mpoa_client *mpc, uint8_t *router_mac,
-			  uint8_t *tlvs, uint8_t mps_macs, uint8_t device_type);
+static const uint8_t *copy_macs(struct mpoa_client *mpc,
+				const uint8_t *router_mac,
+				const uint8_t *tlvs, uint8_t mps_macs,
+				uint8_t device_type);
 static void purge_egress_shortcut(struct atm_vcc *vcc, eg_cache_entry *entry);
 
-static void send_set_mps_ctrl_addr(char *addr, struct mpoa_client *mpc);
+static void send_set_mps_ctrl_addr(const char *addr, struct mpoa_client *mpc);
 static void mpoad_close(struct atm_vcc *vcc);
 static int msg_from_mpoad(struct atm_vcc *vcc, struct sk_buff *skb);
 
@@ -351,12 +353,12 @@ static const char *mpoa_device_type_stri
  * lec sees a TLV it uses the pointer to call this function.
  *
  */
-static void lane2_assoc_ind(struct net_device *dev, uint8_t *mac_addr,
-			    uint8_t *tlvs, uint32_t sizeoftlvs)
+static void lane2_assoc_ind(struct net_device *dev, const u8 *mac_addr,
+			    const u8 *tlvs, u32 sizeoftlvs)
 {
 	uint32_t type;
 	uint8_t length, mpoa_device_type, number_of_mps_macs;
-	uint8_t *end_of_tlvs;
+	const uint8_t *end_of_tlvs;
 	struct mpoa_client *mpc;
 
 	mpoa_device_type = number_of_mps_macs = 0; /* silence gcc */
@@ -430,8 +432,10 @@ static void lane2_assoc_ind(struct net_d
  * plus the possible MAC address(es) to mpc->mps_macs.
  * For a freshly allocated MPOA client mpc->mps_macs == 0.
  */
-static uint8_t *copy_macs(struct mpoa_client *mpc, uint8_t *router_mac,
-			  uint8_t *tlvs, uint8_t mps_macs, uint8_t device_type)
+static const uint8_t *copy_macs(struct mpoa_client *mpc,
+				const uint8_t *router_mac,
+				const uint8_t *tlvs, uint8_t mps_macs,
+				uint8_t device_type)
 {
 	int num_macs;
 	num_macs = (mps_macs > 1) ? mps_macs : 1;
@@ -811,7 +815,7 @@ static int atm_mpoa_mpoad_attach (struct
 	return arg;
 }
 
-static void send_set_mps_ctrl_addr(char *addr, struct mpoa_client *mpc)
+static void send_set_mps_ctrl_addr(const char *addr, struct mpoa_client *mpc)
 {
 	struct k_message mesg;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mutex-subsystem-synchro-test-module.patch


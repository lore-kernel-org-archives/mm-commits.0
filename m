From: akpm@linux-foundation.org
Subject: - bonding-fix-up-parameter-parsing.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:25 -0800
Message-ID: <200801212314.m0LNEP5x024995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759429AbYAUXTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fubar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     bonding: fix up parameter parsing
has been removed from the -mm tree.  Its filename was
     bonding-fix-up-parameter-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bonding: fix up parameter parsing
From: Jay Vosburgh <fubar@us.ibm.com>

A recent change to add an additional hash policy modified bond_parse_parm, but
it now does not correctly match parameters passed in via sysfs.

Rewrote bond_parse_parm to handle (a) parameter matches that are substrings of
one another and (b) user input with whitespace (e.g., sysfs input often has a
trailing newline).

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c  |   23 ++++++++++++++++-------
 drivers/net/bonding/bond_sysfs.c |    8 ++++----
 drivers/net/bonding/bonding.h    |    4 +++-
 3 files changed, 23 insertions(+), 12 deletions(-)

diff -puN drivers/net/bonding/bond_main.c~bonding-fix-up-parameter-parsing drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-fix-up-parameter-parsing
+++ a/drivers/net/bonding/bond_main.c
@@ -4540,18 +4540,27 @@ static void bond_free_all(void)
 
 /*
  * Convert string input module parms.  Accept either the
- * number of the mode or its string name.
+ * number of the mode or its string name.  A bit complicated because
+ * some mode names are substrings of other names, and calls from sysfs
+ * may have whitespace in the name (trailing newlines, for example).
  */
-int bond_parse_parm(char *mode_arg, struct bond_parm_tbl *tbl)
+int bond_parse_parm(const char *buf, struct bond_parm_tbl *tbl)
 {
-	int i;
+	int mode = -1, i, rv;
+	char modestr[BOND_MAX_MODENAME_LEN + 1] = { 0, };
+
+	rv = sscanf(buf, "%d", &mode);
+	if (!rv) {
+		rv = sscanf(buf, "%20s", modestr);
+		if (!rv)
+			return -1;
+	}
 
 	for (i = 0; tbl[i].modename; i++) {
-		if ((isdigit(*mode_arg) &&
-		     tbl[i].mode == simple_strtol(mode_arg, NULL, 0)) ||
-		    (strcmp(mode_arg, tbl[i].modename) == 0)) {
+		if (mode == tbl[i].mode)
+			return tbl[i].mode;
+		if (strcmp(modestr, tbl[i].modename) == 0)
 			return tbl[i].mode;
-		}
 	}
 
 	return -1;
diff -puN drivers/net/bonding/bond_sysfs.c~bonding-fix-up-parameter-parsing drivers/net/bonding/bond_sysfs.c
--- a/drivers/net/bonding/bond_sysfs.c~bonding-fix-up-parameter-parsing
+++ a/drivers/net/bonding/bond_sysfs.c
@@ -423,7 +423,7 @@ static ssize_t bonding_store_mode(struct
 		goto out;
 	}
 
-	new_value = bond_parse_parm((char *)buf, bond_mode_tbl);
+	new_value = bond_parse_parm(buf, bond_mode_tbl);
 	if (new_value < 0)  {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Ignoring invalid mode value %.*s.\n",
@@ -478,7 +478,7 @@ static ssize_t bonding_store_xmit_hash(s
 		goto out;
 	}
 
-	new_value = bond_parse_parm((char *)buf, xmit_hashtype_tbl);
+	new_value = bond_parse_parm(buf, xmit_hashtype_tbl);
 	if (new_value < 0)  {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Ignoring invalid xmit hash policy value %.*s.\n",
@@ -518,7 +518,7 @@ static ssize_t bonding_store_arp_validat
 	int new_value;
 	struct bonding *bond = to_bond(d);
 
-	new_value = bond_parse_parm((char *)buf, arp_validate_tbl);
+	new_value = bond_parse_parm(buf, arp_validate_tbl);
 	if (new_value < 0) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Ignoring invalid arp_validate value %s\n",
@@ -941,7 +941,7 @@ static ssize_t bonding_store_lacp(struct
 		goto out;
 	}
 
-	new_value = bond_parse_parm((char *)buf, bond_lacp_tbl);
+	new_value = bond_parse_parm(buf, bond_lacp_tbl);
 
 	if ((new_value == 1) || (new_value == 0)) {
 		bond->params.lacp_fast = new_value;
diff -puN drivers/net/bonding/bonding.h~bonding-fix-up-parameter-parsing drivers/net/bonding/bonding.h
--- a/drivers/net/bonding/bonding.h~bonding-fix-up-parameter-parsing
+++ a/drivers/net/bonding/bonding.h
@@ -141,6 +141,8 @@ struct bond_parm_tbl {
 	int mode;
 };
 
+#define BOND_MAX_MODENAME_LEN 20
+
 struct vlan_entry {
 	struct list_head vlan_list;
 	__be32 vlan_ip;
@@ -314,7 +316,7 @@ void bond_mii_monitor(struct work_struct
 void bond_loadbalance_arp_mon(struct work_struct *);
 void bond_activebackup_arp_mon(struct work_struct *);
 void bond_set_mode_ops(struct bonding *bond, int mode);
-int bond_parse_parm(char *mode_arg, struct bond_parm_tbl *tbl);
+int bond_parse_parm(const char *mode_arg, struct bond_parm_tbl *tbl);
 void bond_select_active_slave(struct bonding *bond);
 void bond_change_active_slave(struct bonding *bond, struct slave *new_active);
 void bond_register_arp(struct bonding *);
_

Patches currently in -mm which might be from fubar@us.ibm.com are

origin.patch
git-net.patch

From: akpm@linux-foundation.org
Subject: - net-ehea-bcmc_regs-semaphore-to-mutex.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:50 -0700
Message-ID: <200803312018.m2VKIoWL024087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbYCaUkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, jeff@garzik.org, raisch@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     netdev: ehea: bcmc_regs semaphore to mutex
has been removed from the -mm tree.  Its filename was
     net-ehea-bcmc_regs-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: ehea: bcmc_regs semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Convert the ehea_bcmc_regs.lock to a mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/net/ehea/ehea.h~net-ehea-bcmc_regs-semaphore-to-mutex drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~net-ehea-bcmc_regs-semaphore-to-mutex
+++ a/drivers/net/ehea/ehea.h
@@ -434,7 +434,7 @@ struct ehea_bcmc_reg_entry {
 struct ehea_bcmc_reg_array {
 	struct ehea_bcmc_reg_entry *arr;
 	int num_entries;
-	struct semaphore lock;
+	struct mutex lock;
 };
 
 #define EHEA_PORT_UP 1
diff -puN drivers/net/ehea/ehea_main.c~net-ehea-bcmc_regs-semaphore-to-mutex drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~net-ehea-bcmc_regs-semaphore-to-mutex
+++ a/drivers/net/ehea/ehea_main.c
@@ -1759,7 +1759,7 @@ static int ehea_set_mac_addr(struct net_
 
 	memcpy(dev->dev_addr, mac_addr->sa_data, dev->addr_len);
 
-	down(&ehea_bcmc_regs.lock);
+	mutex_lock(&ehea_bcmc_regs.lock);
 
 	/* Deregister old MAC in pHYP */
 	ret = ehea_broadcast_reg_helper(port, H_DEREG_BCMC);
@@ -1777,7 +1777,7 @@ static int ehea_set_mac_addr(struct net_
 
 out_upregs:
 	ehea_update_bcmc_registrations();
-	up(&ehea_bcmc_regs.lock);
+	mutex_unlock(&ehea_bcmc_regs.lock);
 out_free:
 	kfree(cb0);
 out:
@@ -1939,7 +1939,7 @@ static void ehea_set_multicast_list(stru
 	}
 	ehea_promiscuous(dev, 0);
 
-	down(&ehea_bcmc_regs.lock);
+	mutex_lock(&ehea_bcmc_regs.lock);
 
 	if (dev->flags & IFF_ALLMULTI) {
 		ehea_allmulti(dev, 1);
@@ -1970,7 +1970,7 @@ static void ehea_set_multicast_list(stru
 	}
 out:
 	ehea_update_bcmc_registrations();
-	up(&ehea_bcmc_regs.lock);
+	mutex_unlock(&ehea_bcmc_regs.lock);
 	return;
 }
 
@@ -2491,7 +2491,7 @@ static int ehea_up(struct net_device *de
 		}
 	}
 
-	down(&ehea_bcmc_regs.lock);
+	mutex_lock(&ehea_bcmc_regs.lock);
 
 	ret = ehea_broadcast_reg_helper(port, H_REG_BCMC);
 	if (ret) {
@@ -2514,7 +2514,7 @@ out:
 		ehea_info("Failed starting %s. ret=%i", dev->name, ret);
 
 	ehea_update_bcmc_registrations();
-	up(&ehea_bcmc_regs.lock);
+	mutex_unlock(&ehea_bcmc_regs.lock);
 
 	ehea_update_firmware_handles();
 	mutex_unlock(&ehea_fw_handles.lock);
@@ -2569,7 +2569,7 @@ static int ehea_down(struct net_device *
 
 	mutex_lock(&ehea_fw_handles.lock);
 
-	down(&ehea_bcmc_regs.lock);
+	mutex_lock(&ehea_bcmc_regs.lock);
 	ehea_drop_multicast_list(dev);
 	ehea_broadcast_reg_helper(port, H_DEREG_BCMC);
 
@@ -2578,7 +2578,7 @@ static int ehea_down(struct net_device *
 	port->state = EHEA_PORT_DOWN;
 
 	ehea_update_bcmc_registrations();
-	up(&ehea_bcmc_regs.lock);
+	mutex_unlock(&ehea_bcmc_regs.lock);
 
 	ret = ehea_clean_all_portres(port);
 	if (ret)
@@ -3545,7 +3545,7 @@ int __init ehea_module_init(void)
 	memset(&ehea_bcmc_regs, 0, sizeof(ehea_bcmc_regs));
 
 	mutex_init(&ehea_fw_handles.lock);
-	sema_init(&ehea_bcmc_regs.lock, 1);
+	mutex_init(&ehea_bcmc_regs.lock);
 
 	ret = check_module_parm();
 	if (ret)
_

Patches currently in -mm which might be from dwalker@mvista.com are

git-net.patch
usb-u132-hcd-driver-style-clean-up.patch
usb-u132-hcd-driver-semaphore-to-mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
likely_prof-changed-to-use-proc_create.patch


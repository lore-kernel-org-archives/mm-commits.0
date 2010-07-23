From: akpm@linux-foundation.org
Subject: + e1000e-register-pm_qos-request-on-hardware-activation.patch added to -mm tree
Date: Fri, 23 Jul 2010 12:53:56 -0700
Message-ID: <201007231953.o6NJruZd005139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab0GWTy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Jul 2010 15:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@mickler.org, jeffrey.t.kirsher@intel.com


The patch titled
     e1000e: register pm_qos request on hardware activation
has been added to the -mm tree.  Its filename is
     e1000e-register-pm_qos-request-on-hardware-activation.patch

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
Subject: e1000e: register pm_qos request on hardware activation
From: Florian Mickler <florian@mickler.org>

The pm_qos_add_request call has to register the pm_qos request with the
pm_qos susbsystem before first use of the pm_qos request via
pm_qos_update_request.

As pm_qos changed to use plists there is no benefit in registering and
unregistering the pm_qos request on ifup/ifdown and thus we move the
registering into e1000_open and the unregistering in e1000_close.

This fixes the following warning:

[    1.786060] WARNING: at kernel/pm_qos_params.c:264
pm_qos_update_request+0x28/0x54()
[    1.786088] Hardware name: Latitude E6500
[    1.787045] pm_qos_update_request() called for unknown object
[    1.787966] Modules linked in:
[    1.788940] Pid: 1, comm: swapper Not tainted 2.6.35-rc5-mmotm0719 #1
[    1.790035] Call Trace:
[    1.791121]  [<ffffffff81037335>] warn_slowpath_common+0x80/0x98
[    1.792205]  [<ffffffff810373e1>] warn_slowpath_fmt+0x41/0x43
[    1.793279]  [<ffffffff81057c14>] pm_qos_update_request+0x28/0x54
[    1.794347]  [<ffffffff8134889e>] e1000_configure+0x421/0x459
[    1.795393]  [<ffffffff8134afbd>] e1000_open+0xbd/0x37c
[    1.796436]  [<ffffffff8105743a>] ? raw_notifier_call_chain+0xf/0x11
[    1.797491]  [<ffffffff8145f948>] __dev_open+0xae/0xe2
[    1.798547]  [<ffffffff8145f997>] dev_open+0x1b/0x49
[    1.799612]  [<ffffffff8146e36e>] netpoll_setup+0x84/0x259
[    1.800685]  [<ffffffff81b5037c>] init_netconsole+0xbc/0x21f
[    1.801744]  [<ffffffff81b5026c>] ? sir_wq_init+0x0/0x35
[    1.802793]  [<ffffffff81b502c0>] ? init_netconsole+0x0/0x21f
[    1.803845]  [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
[    1.804885]  [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
[    1.805915]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[    1.806937]  [<ffffffff81590e00>] ? restore_args+0x0/0x30
[    1.807955]  [<ffffffff81b2cb76>] ? kernel_init+0x0/0x1c2
[    1.808958]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
[    1.809958] ---[ end trace 84b562a00a60539e ]---

Signed-off-by: Florian Mickler <florian@mickler.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-register-pm_qos-request-on-hardware-activation drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-register-pm_qos-request-on-hardware-activation
+++ a/drivers/net/e1000e/netdev.c
@@ -3218,12 +3218,6 @@ int e1000e_up(struct e1000_adapter *adap
 {
 	struct e1000_hw *hw = &adapter->hw;
 
-	/* DMA latency requirement to workaround early-receive/jumbo issue */
-	if (adapter->flags & FLAG_HAS_ERT)
-		pm_qos_add_request(&adapter->netdev->pm_qos_req,
-				   PM_QOS_CPU_DMA_LATENCY,
-				   PM_QOS_DEFAULT_VALUE);
-
 	/* hardware has been reset, we need to reload some things */
 	e1000_configure(adapter);
 
@@ -3287,9 +3281,6 @@ void e1000e_down(struct e1000_adapter *a
 	e1000_clean_tx_ring(adapter);
 	e1000_clean_rx_ring(adapter);
 
-	if (adapter->flags & FLAG_HAS_ERT)
-		pm_qos_remove_request(&adapter->netdev->pm_qos_req);
-
 	/*
 	 * TODO: for power management, we could drop the link and
 	 * pci_disable_device here.
@@ -3524,6 +3515,12 @@ static int e1000_open(struct net_device 
 	     E1000_MNG_DHCP_COOKIE_STATUS_VLAN))
 		e1000_update_mng_vlan(adapter);
 
+	/* DMA latency requirement to workaround early-receive/jumbo issue */
+	if (adapter->flags & FLAG_HAS_ERT)
+		pm_qos_add_request(&adapter->netdev->pm_qos_req,
+				   PM_QOS_CPU_DMA_LATENCY,
+				   PM_QOS_DEFAULT_VALUE);
+
 	/*
 	 * before we allocate an interrupt, we must be ready to handle it.
 	 * Setting DEBUG_SHIRQ in the kernel makes it fire an interrupt
@@ -3628,6 +3625,9 @@ static int e1000_close(struct net_device
 	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_release_hw_control(adapter);
 
+	if (adapter->flags & FLAG_HAS_ERT)
+		pm_qos_remove_request(&adapter->netdev->pm_qos_req);
+
 	pm_runtime_put_sync(&pdev->dev);
 
 	return 0;
_

Patches currently in -mm which might be from florian@mickler.org are

e1000e-register-pm_qos-request-on-hardware-activation.patch


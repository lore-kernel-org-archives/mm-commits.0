From: akpm@linux-foundation.org
Subject: + i7core_edac-fix-panic-in-udimm-sysfs-attributes-registration.patch added to -mm tree
Date: Thu, 23 Sep 2010 12:04:27 -0700
Message-ID: <201009231904.o8NJ4SLX012897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab0IWTEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 15:04:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, dougthompson@xmission.com, mchehab@redhat.com, stable@kernel.org


The patch titled
     i7core_edac: fix panic in udimm sysfs attributes registration
has been added to the -mm tree.  Its filename is
     i7core_edac-fix-panic-in-udimm-sysfs-attributes-registration.patch

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
Subject: i7core_edac: fix panic in udimm sysfs attributes registration
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Array of udimm sysfs attributes was not ended with NULL marker, leading to
dereference of random memory.

EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file udimm0
EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file udimm1
EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file udimm2
BUG: unable to handle kernel NULL pointer dereference at 00000000000001a4
IP: [<ffffffff81330b36>] edac_create_mci_instance_attributes+0x148/0x1f1
PGD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file:
CPU 3
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.36-rc3-nv+ #483 P6T SE/System Product Name
RIP: 0010:[<ffffffff81330b36>]  [<ffffffff81330b36>] edac_create_mci_instance_attributes+0x148/0x1f1
(...)
Call Trace:
 [<ffffffff81330b86>] edac_create_mci_instance_attributes+0x198/0x1f1
 [<ffffffff81330c9a>] edac_create_sysfs_mci_device+0xbb/0x2b2
 [<ffffffff8132f533>] edac_mc_add_mc+0x46b/0x557
 [<ffffffff81428901>] i7core_probe+0xccf/0xec0
 [<ffffffff81230193>] local_pci_probe+0x12/0x16
 [<ffffffff8123097b>] pci_device_probe+0x60/0x8f
 [<ffffffff812b65c9>] ? driver_sysfs_add+0x6b/0x90
 [<ffffffff812b6711>] driver_probe_device+0xa7/0x136
 [<ffffffff812b67f8>] __driver_attach+0x58/0x7c
 [<ffffffff812b67a0>] ? __driver_attach+0x0/0x7c
 [<ffffffff812b5ed4>] bus_for_each_dev+0x4e/0x83
 [<ffffffff812b655c>] driver_attach+0x19/0x1b
 [<ffffffff812b5834>] bus_add_driver+0x12b/0x277
 [<ffffffff812b6ac1>] driver_register+0x99/0x10a
 [<ffffffff81230be8>] __pci_register_driver+0x63/0xd3
 [<ffffffff818bd6fa>] i7core_init+0x9a/0xbb
 [<ffffffff818bd660>] ? i7core_init+0x0/0xbb
 [<ffffffff81000210>] do_one_initcall+0x7a/0x12e
 [<ffffffff81897689>] kernel_init+0x143/0x1cc
 [<ffffffff8102edd4>] kernel_thread_helper+0x4/0x10
 [<ffffffff814357ad>] ? restore_args+0x0/0x30
 [<ffffffff81897546>] ? kernel_init+0x0/0x1cc
 [<ffffffff8102edd0>] ? kernel_thread_helper+0x0/0x10
Code: 24 49 89 44 24 08 4c 89 20 48 8b 43 10 4d 89 74 24 58 49 89 44 24 50 83 3d d7 13 53 00 00 78 22 48 8b 43 10 48 c7 c2 90 7e 66 81 <48> 8b 08 4d 89 f0 48 89 d6 48 c7 c7 7e a9 79 81 31 c0 e8 21 10
RIP  [<ffffffff81330b36>] edac_create_mci_instance_attributes+0x148/0x1f1
 RSP <ffff8801bfca7a30>
CR2: 00000000000001a4
---[ end trace 20de320855b81d78 ]---
Kernel panic - not syncing: Attempted to kill init!

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i7core_edac.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/edac/i7core_edac.c~i7core_edac-fix-panic-in-udimm-sysfs-attributes-registration drivers/edac/i7core_edac.c
--- a/drivers/edac/i7core_edac.c~i7core_edac-fix-panic-in-udimm-sysfs-attributes-registration
+++ a/drivers/edac/i7core_edac.c
@@ -1140,6 +1140,7 @@ static struct mcidev_sysfs_attribute i7c
 	ATTR_COUNTER(0),
 	ATTR_COUNTER(1),
 	ATTR_COUNTER(2),
+	{ .attr = { .name = NULL } }
 };
 
 static struct mcidev_sysfs_group i7core_udimm_counters = {
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

i7core_edac-fix-panic-in-udimm-sysfs-attributes-registration.patch


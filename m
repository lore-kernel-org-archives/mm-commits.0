From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_hotplug-refrain-from-adding-memory-into-an-impossible-node.patch
 added to -mm tree
Date: Mon, 20 Apr 2020 19:00:00 -0700
Message-ID: <20200421020000.ERvQihvy5%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDUCAC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 22:00:02 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, vishal.l.verma@intel.com


The patch titled
     Subject: mm/memory_hotplug: refrain from adding memory into an impossible node
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-refrain-from-adding-memory-into-an-impossible-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-refrain-from-adding-memory-into-an-impossible-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-refrain-from-adding-memory-into-an-impossible-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: mm/memory_hotplug: refrain from adding memory into an impossible node

A misbehaving qemu created a situation where the ACPI SRAT table
advertised one fewer proximity domains than intended.  The NFIT table did
describe all the expected proximity domains.  This caused the device dax
driver to assign an impossible target_node to the device, and when
hotplugged as system memory, this would fail with the following signature:

  [  +0.001627] BUG: kernel NULL pointer dereference, address: 0000000000000088
  [  +0.001331] #PF: supervisor read access in kernel mode
  [  +0.000975] #PF: error_code(0x0000) - not-present page
  [  +0.000976] PGD 80000001767d4067 P4D 80000001767d4067 PUD 10e0c4067 PMD 0
  [  +0.001338] Oops: 0000 [#1] SMP PTI
  [  +0.000676] CPU: 4 PID: 22737 Comm: kswapd3 Tainted: G           O      5.6.0-rc5 #9
  [  +0.001457] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
      BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  [  +0.001990] RIP: 0010:prepare_kswapd_sleep+0x7c/0xc0
  [  +0.000780] Code: 89 df e8 87 fd ff ff 89 c2 31 c0 84 d2 74 e6 0f 1f 44
                      00 00 48 8b 05 fb af 7a 01 48 63 93 88 1d 01 00 48 8b
		      84 d0 20 0f 00 00 <48> 3b 98 88 00 00 00 75 28 f0 80 a0
		      80 00 00 00 fe f0 80 a3 38 20
  [  +0.002877] RSP: 0018:ffffc900017a3e78 EFLAGS: 00010202
  [  +0.000805] RAX: 0000000000000000 RBX: ffff8881209e0000 RCX: 0000000000000000
  [  +0.001115] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffff8881209e0e80
  [  +0.001098] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000008000
  [  +0.001092] R10: 0000000000000000 R11: 0000000000000003 R12: 0000000000000003
  [  +0.001092] R13: 0000000000000003 R14: 0000000000000000 R15: ffffc900017a3ec8
  [  +0.001091] FS:  0000000000000000(0000) GS:ffff888318c00000(0000) knlGS:0000000000000000
  [  +0.001275] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  +0.000882] CR2: 0000000000000088 CR3: 0000000120b50002 CR4: 00000000001606e0
  [  +0.001095] Call Trace:
  [  +0.000388]  kswapd+0x103/0x520
  [  +0.000494]  ? finish_wait+0x80/0x80
  [  +0.000547]  ? balance_pgdat+0x5a0/0x5a0
  [  +0.000607]  kthread+0x120/0x140
  [  +0.000508]  ? kthread_create_on_node+0x60/0x60
  [  +0.000706]  ret_from_fork+0x3a/0x50

Add a check in the add_memory path to fail if the node to which we are
adding memory is in the node_possible_map

Link: http://lkml.kernel.org/r/20200416225438.15208-1-vishal.l.verma@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-refrain-from-adding-memory-into-an-impossible-node
+++ a/mm/memory_hotplug.c
@@ -1017,6 +1017,11 @@ int __ref add_memory_resource(int nid, s
 	if (ret)
 		return ret;
 
+	if (!node_possible(nid)) {
+		WARN(1, "node %d was absent from the node_possible_map\n", nid);
+		return -EINVAL;
+	}
+
 	mem_hotplug_begin();
 
 	/*
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

mm-memory_hotplug-refrain-from-adding-memory-into-an-impossible-node.patch

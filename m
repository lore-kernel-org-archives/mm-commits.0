From: akpm@linux-foundation.org
Subject: + powerpc-mm-allow-memory-hotplug-into-a-memoryless-node.patch
 added to -mm tree
Date: Mon, 14 Nov 2016 15:05:08 -0800
Message-ID: <582a4324.z9IuUfvQ7quLJEAw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940854AbcKNXFK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 18:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, apopple@au1.ibm.com, benh@kernel.crashing.org, bharata@linux.vnet.ibm.com, bsingharora@gmail.com, frowand.list@gmail.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, nfont@linux.vnet.ibm.com, paulus@samba.org, robh+dt@kernel.org, stewart@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: allow memory hotplug into a memoryless node
has been added to the -mm tree.  Its filename is
     powerpc-mm-allow-memory-hotplug-into-a-memoryless-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-allow-memory-hotplug-into-a-memoryless-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-allow-memory-hotplug-into-a-memoryless-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: powerpc/mm: allow memory hotplug into a memoryless node

Patch series "enable movable nodes on non-x86 configs", v7.

This patchset allows more configs to make use of movable nodes. When
CONFIG_MOVABLE_NODE is selected, there are two ways to introduce such
nodes into the system:

1. Discover movable nodes at boot. Currently this is only possible on
   x86, but we will enable configs supporting fdt to do the same.

2. Hotplug and online all of a node's memory using online_movable. This
   is already possible on any config supporting memory hotplug, not
   just x86, but the Kconfig doesn't say so. We will fix that.

We'll also remove some cruft on power which would prevent (2).



This patch (of 5):

Remove the check which prevents us from hotplugging into an empty node.

The original commit b226e4621245 ("[PATCH] powerpc: don't add memory to
empty node/zone"), states that this was intended to be a temporary measure.
It is a workaround for an oops which no longer occurs.

Link: http://lkml.kernel.org/r/1479160961-25840-2-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alistair Popple <apopple@au1.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/powerpc/mm/numa.c~powerpc-mm-allow-memory-hotplug-into-a-memoryless-node arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~powerpc-mm-allow-memory-hotplug-into-a-memoryless-node
+++ a/arch/powerpc/mm/numa.c
@@ -1085,7 +1085,7 @@ static int hot_add_node_scn_to_nid(unsig
 int hot_add_scn_to_nid(unsigned long scn_addr)
 {
 	struct device_node *memory = NULL;
-	int nid, found = 0;
+	int nid;
 
 	if (!numa_enabled || (min_common_depth < 0))
 		return first_online_node;
@@ -1101,17 +1101,6 @@ int hot_add_scn_to_nid(unsigned long scn
 	if (nid < 0 || !node_online(nid))
 		nid = first_online_node;
 
-	if (NODE_DATA(nid)->node_spanned_pages)
-		return nid;
-
-	for_each_online_node(nid) {
-		if (NODE_DATA(nid)->node_spanned_pages) {
-			found = 1;
-			break;
-		}
-	}

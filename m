From: akpm@linux-foundation.org
Subject: [to-be-updated] numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance.patch removed from -mm tree
Date: Tue, 22 Nov 2011 13:29:03 -0800
Message-ID: <201111222129.pAMLT3NP030138@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51299 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab1KVV3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 16:29:07 -0500
Received: by ywb5 with SMTP id 5so123204ywb.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 13:29:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pholasek@redhat.com, hpa@zytor.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86_64 NUMA emulation: add numa=fake parameter for custom nodes distance
has been removed from the -mm tree.  Its filename was
     numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Petr Holasek <pholasek@redhat.com>
Subject: x86_64 NUMA emulation: add numa=fake parameter for custom nodes distance

By default, when numa emulation is turned on, node distance table uses
physical distance, so for 4 nodes emulated on 1 physical table is

node   0   1   2   3
0:  10  10  10  10
1:  10  10  10  10
2:  10  10  10  10
3:  10  10  10  10

This patch adds new [distance] argument to

numa=fake=<number/size of nodes>[,distance]

When distance argument is used, it sets linear distance between nodes
like that:

    __distance__
___|___     ____|___     ________     ________
|       |   |        |   |        |   |        |
| node1 |---| node 2 |---| node 3 |---| node 4 |
|_______|   |________|   |________|   |________|
|                        |             |
|                        |             |
|____distance * 2________|             |
|                                      |
|____________distance * 3______________|

This feature might be useful for testing some numa awareness features in
both user and kernel spaces.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86/x86_64/boot-options.txt |    6 ++++--
 arch/x86/mm/numa_emulation.c              |   16 ++++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/numa_emulation.c~numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance arch/x86/mm/numa_emulation.c
--- a/arch/x86/mm/numa_emulation.c~numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance
+++ a/arch/x86/mm/numa_emulation.c
@@ -309,6 +309,8 @@ void __init numa_emulation(struct numa_m
 	u8 *phys_dist = NULL;
 	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
 	int max_emu_nid, dfl_phys_nid;
+	unsigned long dist_level;
+	char *c;
 	int i, j, ret;
 
 	if (!emu_cmdline)
@@ -404,6 +406,17 @@ void __init numa_emulation(struct numa_m
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
 			emu_nid_to_phys[i] = dfl_phys_nid;
 
+	/* load distance level parameter */
+	dist_level = -1;
+	c = strchr(emu_cmdline, ',');
+	if (c) {
+		c++;
+		ret = kstrtoul(c, 10, &dist_level);
+		if (ret < 0 || dist_level < LOCAL_DISTANCE ||
+				dist_level * max_emu_nid > ULONG_MAX)
+			dist_level = -1;
+	}
+
 	/* transform distance table */
 	numa_reset_distance();
 	for (i = 0; i < max_emu_nid + 1; i++) {
@@ -418,6 +431,9 @@ void __init numa_emulation(struct numa_m
 			else
 				dist = phys_dist[physi * numa_dist_cnt + physj];
 
+			if (dist_level != -1 && i != j)
+				dist = abs(i - j) * dist_level;
+
 			numa_set_distance(i, j, dist);
 		}
 	}
diff -puN Documentation/x86/x86_64/boot-options.txt~numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt~numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance
+++ a/Documentation/x86/x86_64/boot-options.txt
@@ -166,13 +166,15 @@ NUMA
 
   numa=noacpi   Don't parse the SRAT table for NUMA setup
 
-  numa=fake=<size>[MG]
+  numa=fake=<size>[MG][,distance]
 		If given as a memory unit, fills all system RAM with nodes of
 		size interleaved over physical nodes.
+		Optional distance sets linear distance between emulated nodes.
 
-  numa=fake=<N>
+  numa=fake=<N>[,distance]
 		If given as an integer, fills all system RAM with N fake nodes
 		interleaved over physical nodes.
+		Optional distance sets linear distance between emulated nodes.
 
 ACPI
 
_

Patches currently in -mm which might be from pholasek@redhat.com are



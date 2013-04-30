From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-add-note-on-safety-of-drain_zonestat.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:44 -0700
Message-ID: <20130430184944.721C15A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:38771 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3D3Stp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:45 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86679qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: add note on safety of drain_zonestat
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-note-on-safety-of-drain_zonestat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/vmstat: add note on safety of drain_zonestat

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/vmstat.c~mm-vmstat-add-note-on-safety-of-drain_zonestat mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-add-note-on-safety-of-drain_zonestat
+++ a/mm/vmstat.c
@@ -493,6 +493,10 @@ void refresh_cpu_vm_stats(int cpu)
 			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
 
+/*
+ * this is only called if !populated_zone(zone), which implies no other users of
+ * pset->vm_stat_diff[] exsist.
+ */
 void drain_zonestat(struct zone *zone, struct per_cpu_pageset *pset)
 {
 	int i;
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
linux-next.patch


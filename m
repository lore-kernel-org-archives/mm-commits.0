From: akpm@linux-foundation.org
Subject: + mm-vmstat-add-note-on-safety-of-drain_zonestat.patch added to -mm tree
Date: Mon, 15 Apr 2013 13:43:19 -0700
Message-ID: <20130415204319.5FBE05A41F7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:37612 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab3DOUnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:43:20 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so508086ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:43:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com


The patch titled
     Subject: mm/vmstat: add note on safety of drain_zonestat
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-note-on-safety-of-drain_zonestat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch
x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix.patch
mm-vmstat-add-note-on-safety-of-drain_zonestat.patch


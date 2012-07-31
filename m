From: akpm@linux-foundation.org
Subject: [merged] taskstats-check-nla_reserve-return.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:21 -0700
Message-ID: <20120731185422.0B86F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53898 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2GaSyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:23 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so295563lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, rucsoftsec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats: check nla_reserve() return
has been removed from the -mm tree.  Its filename was
     taskstats-check-nla_reserve-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: taskstats: check nla_reserve() return

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44621

Reported-by: <rucsoftsec@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/taskstats.c~taskstats-check-nla_reserve-return kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-check-nla_reserve-return
+++ a/kernel/taskstats.c
@@ -436,6 +436,11 @@ static int cgroupstats_user_cmd(struct s
 
 	na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
 				sizeof(struct cgroupstats));
+	if (na == NULL) {
+		rc = -EMSGSIZE;
+		goto err;
+	}
+
 	stats = nla_data(na);
 	memset(stats, 0, sizeof(*stats));
 
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch


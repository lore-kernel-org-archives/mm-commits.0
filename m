From: akpm@linux-foundation.org
Subject: + mm-vmscanc-try_to_freeze-returns-boolean.patch added to -mm tree
Date: Tue, 06 Nov 2012 15:37:59 -0800
Message-ID: <20121106233800.0437E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:43580 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KFXiC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 18:38:02 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so68532wib.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 15:38:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.liu@oracle.com


The patch titled
     Subject: mm/vmscan.c: try_to_freeze() returns boolean
has been added to the -mm tree.  Its filename is
     mm-vmscanc-try_to_freeze-returns-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: mm/vmscan.c: try_to_freeze() returns boolean

kswapd()->try_to_freeze() is defined to return a boolean, so it's better
to use a bool to hold its return value.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscanc-try_to_freeze-returns-boolean mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-try_to_freeze-returns-boolean
+++ a/mm/vmscan.c
@@ -2986,7 +2986,7 @@ static int kswapd(void *p)
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
 	balanced_classzone_idx = classzone_idx;
 	for ( ; ; ) {
-		int ret;
+		bool ret;
 
 		/*
 		 * If the last balance_pgdat was unsuccessful it's unlikely a
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch
mm-vmscanc-try_to_freeze-returns-boolean.patch


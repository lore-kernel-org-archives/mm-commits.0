From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix-2.patch removed from -mm tree
Date: Thu, 28 Jul 2016 14:50:23 -0700
Message-ID: <579a7e1f.pyI4xr6phY0pLq7k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbcG1VuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 17:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop unnecessary include file
has been removed from the -mm tree.  Its filename was
     mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix-2.patch

This patch was dropped because it was folded into mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: mm: drop unnecessary include file

Commmit e9be930fa6b5 ("mm: fix vm-scalability regression in cgroup-aware
workingset code") adds '#include <linux/mm.h>' to
include/linux/memcontrol.h.  This results in the following build error
when building hexagon images.

In file included from ./include/linux/memcontrol.h:32:0,
                 from ./include/linux/swap.h:8,
		 from ./arch/hexagon/include/asm/pgtable.h:27,
		 from mm/init-mm.c:9:
./include/linux/mm.h:322:2: error: unknown type name 'pmd_t'
./include/linux/mm.h:353:7: error: unknown type name 'pmd_t'
./include/linux/mm.h:414:30: error: unknown type name 'pmd_t'

The include file does not appear to be necessary, so just drop it.

Fixes: e9be930fa6b5 ("mm: fix vm-scalability regression in cgroup-aware workingset code")
Link: http://lkml.kernel.org/r/1469339408-9240-1-git-send-email-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix-2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix-2
+++ a/include/linux/memcontrol.h
@@ -29,7 +29,6 @@
 #include <linux/mmzone.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
-#include <linux/mm.h>
 
 struct mem_cgroup;
 struct page;
_

Patches currently in -mm which might be from linux@roeck-us.net are

mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch


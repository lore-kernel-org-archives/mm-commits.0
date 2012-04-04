From: akpm@linux-foundation.org
Subject: + memcg-fix-broken-boolen-expression.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:34:13 -0700
Message-ID: <20120404213413.99350A001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:55713 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab2DDVeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:34:15 -0400
Received: by eaaq10 with SMTP id q10so37984eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:34:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: fix broken boolen expression
has been added to the -mm tree.  Its filename is
     memcg-fix-broken-boolen-expression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: memcg: fix broken boolen expression

action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-broken-boolen-expression mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-broken-boolen-expression
+++ a/mm/memcontrol.c
@@ -2165,7 +2165,7 @@ static int __cpuinit memcg_cpu_hotplug_c
 	if (action == CPU_ONLINE)
 		return NOTIFY_OK;
 
-	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	for_each_mem_cgroup(iter)
_
Subject: Subject: memcg: fix broken boolen expression

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-fix-broken-boolen-expression.patch
memcg-mark-more-functions-variables-as-static.patch
memcg-remove-unused-variable.patch
memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch


From: akpm@linux-foundation.org
Subject: + memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:23:43 -0700
Message-ID: <20120404212343.58509A011D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:45291 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab2DDVXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:23:45 -0400
Received: by bkcjm19 with SMTP id jm19so37557bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:23:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: mark stat field of mem_cgroup struct as __percpu
has been added to the -mm tree.  Its filename is
     memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch

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
Subject: memcg: mark stat field of mem_cgroup struct as __percpu

It fixes a lot of sparse warnings.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu
+++ a/mm/memcontrol.c
@@ -304,7 +304,7 @@ struct mem_cgroup {
 	/*
 	 * percpu counter.
 	 */
-	struct mem_cgroup_stat_cpu *stat;
+	struct mem_cgroup_stat_cpu __percpu *stat;
 	/*
 	 * used when a cpu is offlined or other synchronizations
 	 * See mem_cgroup_read_stat().
_
Subject: Subject: memcg: mark stat field of mem_cgroup struct as __percpu

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-mark-more-functions-variables-as-static.patch
memcg-remove-unused-variable.patch
memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch


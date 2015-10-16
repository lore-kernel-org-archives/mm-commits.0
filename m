From: akpm@linux-foundation.org
Subject: + memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix.patch
 added to -mm tree
Date: Fri, 16 Oct 2015 13:21:54 -0700
Message-ID: <56215c62.3RVE8cjFPtT93A0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbbJPUVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 16:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: include linux/mm.h
has been added to the -mm tree.  Its filename is
     memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: memcg: include linux/mm.h

A recent change to the memcg code added a call to virt_to_head_page, which
is declared in linux/mm.h, but this is not necessarily included here and
will cause compile errors:

include/linux/memcontrol.h:841:9: error: implicit declaration of function 'virt_to_head_page' [-Werror=implicit-function-declaration]

This adds an explicit include statement that gets rid of the error.

Fixes: 1ead4c071978 ("memcg: simplify and inline __mem_cgroup_from_kmem")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix
+++ a/include/linux/memcontrol.h
@@ -27,6 +27,7 @@
 #include <linux/vmpressure.h>
 #include <linux/eventfd.h>
 #include <linux/mmzone.h>
+#include <linux/mm.h>
 #include <linux/writeback.h>
 
 struct mem_cgroup;
_

Patches currently in -mm which might be from arnd@arndb.de are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch


From: akpm@linux-foundation.org
Subject: [alternative-merged]
 memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix.patch removed from -mm tree
Date: Fri, 16 Oct 2015 15:17:10 -0700
Message-ID: <56217766.KhIShEU25asNDqIV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbbJPWRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 18:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: include linux/mm.h
has been removed from the -mm tree.  Its filename was
     memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix.patch

This patch was dropped because an alternative patch was merged

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

arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch


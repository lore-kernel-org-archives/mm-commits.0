From: akpm@linux-foundation.org
Subject: + mm-workingset-per-cgroup-cache-thrash-detection-fix.patch added to -mm tree
Date: Wed, 03 Feb 2016 13:25:08 -0800
Message-ID: <56b27034.dgzj6IiGuufnkVIp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbcBCVZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:25:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-workingset-per-cgroup-cache-thrash-detection-fix
has been added to the -mm tree.  Its filename is
     mm-workingset-per-cgroup-cache-thrash-detection-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-per-cgroup-cache-thrash-detection-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-per-cgroup-cache-thrash-detection-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: mm-workingset-per-cgroup-cache-thrash-detection-fix

Do not return from workingset_activation() with locked rcu and page.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-per-cgroup-cache-thrash-detection-fix mm/workingset.c
--- a/mm/workingset.c~mm-workingset-per-cgroup-cache-thrash-detection-fix
+++ a/mm/workingset.c
@@ -317,9 +317,10 @@ void workingset_activation(struct page *
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
 	if (!mem_cgroup_disabled() && !memcg)
-		return;
+		goto out;
 	lruvec = mem_cgroup_zone_lruvec(page_zone(page), memcg);
 	atomic_long_inc(&lruvec->inactive_age);
+out:
 	unlock_page_memcg(memcg);
 }
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-workingset-per-cgroup-cache-thrash-detection-fix.patch
zram-export-the-number-of-available-comp-streams.patch


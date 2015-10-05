From: akpm@linux-foundation.org
Subject: + memcg-convert-threshold-to-bytes.patch added to -mm tree
Date: Mon, 05 Oct 2015 15:03:26 -0700
Message-ID: <5612f3ae.bQCUnfVYw8Uj0q+v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbbJEWD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 18:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: convert threshold to bytes
has been added to the -mm tree.  Its filename is
     memcg-convert-threshold-to-bytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-convert-threshold-to-bytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-convert-threshold-to-bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: memcg: convert threshold to bytes

page_counter_memparse() returns pages for the threshold, while
mem_cgroup_usage() returns bytes for memory usage.  Convert the threshold
to bytes.

Looks a regression introduced by 3e32cb2e0a12b6915 ("memcg: rename
cgroup_event to mem_cgroup_event").

Signed-off-by: Shaohua Li <shli@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-convert-threshold-to-bytes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-convert-threshold-to-bytes
+++ a/mm/memcontrol.c
@@ -3407,6 +3407,7 @@ static int __mem_cgroup_usage_register_e
 	ret = page_counter_memparse(args, "-1", &threshold);
 	if (ret)
 		return ret;
+	threshold <<= PAGE_SHIFT;
 
 	mutex_lock(&memcg->thresholds_lock);
 
_

Patches currently in -mm which might be from shli@fb.com are

memcg-convert-threshold-to-bytes.patch


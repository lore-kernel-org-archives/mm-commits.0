From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch added
 to -mm tree
Date: Mon, 21 Sep 2015 14:29:21 -0700
Message-ID: <560076b1.Vh6TcGhTD32FBk7J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbbIUV3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 17:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: make mem_cgroup_inactive_anon_is_low() return bool
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/memcontrol: make mem_cgroup_inactive_anon_is_low() return bool

Make mem_cgroup_inactive_anon_is_low return bool due to this particular
function only using either one or zero as its return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool
+++ a/include/linux/memcontrol.h
@@ -383,7 +383,7 @@ unsigned long mem_cgroup_get_lru_size(st
 	return mz->lru_size[lru];
 }
 
-static inline int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
+static inline bool mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
 	unsigned long inactive_ratio;
 	unsigned long inactive;
@@ -586,10 +586,10 @@ static inline bool mem_cgroup_disabled(v
 	return true;
 }
 
-static inline int
+static inline bool
 mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
-	return 1;
+	return true;
 }
 
 static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
_

Patches currently in -mm which might be from bywxiaobai@163.com are

mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch
mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch
mm-oom_kill-introduce-is_sysrq_oom-helper.patch
mm-compaction-add-an-is_via_compact_memory-helper-function.patch
mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch
mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch


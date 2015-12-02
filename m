From: akpm@linux-foundation.org
Subject: + mm-fix-kerneldoc-on-mem_cgroup_replace_page.patch added to -mm
 tree
Date: Wed, 02 Dec 2015 13:52:35 -0800
Message-ID: <565f6823.zHoU7ZTP9iJDjUTL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbbLBVwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix kerneldoc on mem_cgroup_replace_page
has been added to the -mm tree.  Its filename is
     mm-fix-kerneldoc-on-mem_cgroup_replace_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-kerneldoc-on-mem_cgroup_replace_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-kerneldoc-on-mem_cgroup_replace_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix kerneldoc on mem_cgroup_replace_page

Whoops, I missed removing the kerneldoc comment of the lrucare arg removed
from mem_cgroup_replace_page; but it's a good comment, keep it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-fix-kerneldoc-on-mem_cgroup_replace_page mm/memcontrol.c
--- a/mm/memcontrol.c~mm-fix-kerneldoc-on-mem_cgroup_replace_page
+++ a/mm/memcontrol.c
@@ -5511,11 +5511,11 @@ void mem_cgroup_uncharge_list(struct lis
  * mem_cgroup_replace_page - migrate a charge to another page
  * @oldpage: currently charged page
  * @newpage: page to transfer the charge to
- * @lrucare: either or both pages might be on the LRU already
  *
  * Migrate the charge from @oldpage to @newpage.
  *
  * Both pages must be locked, @newpage->mapping must be set up.
+ * Either or both pages might be on the LRU already.
  */
 void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage)
 {
_

Patches currently in -mm which might be from hughd@google.com are

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-fix-kerneldoc-on-mem_cgroup_replace_page.patch
tmpfs-fix-shmem_evict_inode-warnings-on-i_blocks.patch


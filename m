From: akpm@linux-foundation.org
Subject: + mm-madvise-update-comment-on-sys_madvise.patch added to -mm
 tree
Date: Wed, 27 Jan 2016 12:11:56 -0800
Message-ID: <56a9248c.bNphC8e7k1T1oRrh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966785AbcA0UL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:11:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, gong.chen@linux.intel.com, jbaron@redhat.com, kirill@shutemov.name, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: update comment on sys_madvise()
has been added to the -mm tree.  Its filename is
     mm-madvise-update-comment-on-sys_madvise.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-update-comment-on-sys_madvise.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-update-comment-on-sys_madvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/madvise: update comment on sys_madvise()

Some new MADV_* advices are not documented in sys_madvise() comment.
So let's update it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/madvise.c~mm-madvise-update-comment-on-sys_madvise mm/madvise.c
--- a/mm/madvise.c~mm-madvise-update-comment-on-sys_madvise
+++ a/mm/madvise.c
@@ -639,14 +639,26 @@ madvise_behavior_valid(int behavior)
  *		some pages ahead.
  *  MADV_DONTNEED - the application is finished with the given range,
  *		so the kernel can free resources associated with it.
+ *  MADV_FREE - the application marks pages in the given range as lasyfree,
+ *		where actual purges are postponed until memory pressure happens.
  *  MADV_REMOVE - the application wants to free up the given range of
  *		pages and associated backing store.
  *  MADV_DONTFORK - omit this area from child's address space when forking:
  *		typically, to avoid COWing pages pinned by get_user_pages().
  *  MADV_DOFORK - cancel MADV_DONTFORK: no longer omit this area when forking.
+ *  MADV_HWPOISON - trigger memory error handler as if the given memory range
+ *		were corrupted by unrecoverable hardware memory failure.
+ *  MADV_SOFT_OFFLINE - try to soft-offline the given range of memory.
  *  MADV_MERGEABLE - the application recommends that KSM try to merge pages in
  *		this area with pages of identical content from other such areas.
  *  MADV_UNMERGEABLE- cancel MADV_MERGEABLE: no longer merge pages with others.
+ *  MADV_HUGEPAGE - the application wants to allocate transparent hugepages to
+ *		load the content of the given memory range.
+ *  MADV_NOHUGEPAGE - cancel MADV_HUGEPAGE: no longer allocate transparent
+ *		hugepages.
+ *  MADV_DONTDUMP - the application wants to prevent pages in the given range
+ *		from being included in its core dump.
+ *  MADV_DODUMP - cancel MADV_DONTDUMP: no longer exclude from core dump.
  *
  * return values:
  *  zero    - success
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch
mm-madvise-update-comment-on-sys_madvise.patch


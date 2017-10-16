From: akpm@linux-foundation.org
Subject: [merged]
 mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork.patch
 removed from -mm tree
Date: Mon, 16 Oct 2017 12:55:18 -0700
Message-ID: <20171016195518.Opz90EK5G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbdJPTzT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, yang.s@alibaba-inc.com


The patch titled
     Subject: mm/madvise.c: add description for MADV_WIPEONFORK and MADV_KEEPONFORK
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm/madvise.c: add description for MADV_WIPEONFORK and MADV_KEEPONFORK

mm/madvise.c has a brief description about all MADV_ flags.  Add a
description for the newly added MADV_WIPEONFORK and MADV_KEEPONFORK.

Although man page has the similar information, but it'd better to keep the
consistent with other flags.

Link: http://lkml.kernel.org/r/1506117328-88228-1-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork mm/madvise.c
--- a/mm/madvise.c~mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork
+++ a/mm/madvise.c
@@ -757,6 +757,9 @@ madvise_behavior_valid(int behavior)
  *  MADV_DONTFORK - omit this area from child's address space when forking:
  *		typically, to avoid COWing pages pinned by get_user_pages().
  *  MADV_DOFORK - cancel MADV_DONTFORK: no longer omit this area when forking.
+ *  MADV_WIPEONFORK - present the child process with zero-filled memory in this
+ *              range after a fork.
+ *  MADV_KEEPONFORK - undo the effect of MADV_WIPEONFORK
  *  MADV_HWPOISON - trigger memory error handler as if the given memory range
  *		were corrupted by unrecoverable hardware memory failure.
  *  MADV_SOFT_OFFLINE - try to soft-offline the given range of memory.
@@ -777,7 +780,9 @@ madvise_behavior_valid(int behavior)
  *  zero    - success
  *  -EINVAL - start + len < 0, start is not page-aligned,
  *		"behavior" is not a valid value, or application
- *		is attempting to release locked or shared pages.
+ *		is attempting to release locked or shared pages,
+ *		or the specified address range includes file, Huge TLB,
+ *		MAP_SHARED or VMPFNMAP range.
  *  -ENOMEM - addresses in the specified range are not currently
  *		mapped, or are outside the AS of the process.
  *  -EIO    - an I/O error occurred while paging in data.
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
mm-slabinfo-dump-config_slabinfo.patch
mm-slabinfo-dump-config_slabinfo-v11.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch


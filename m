From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-madvisemadv_free-fix.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 16:25:54 -0800
Message-ID: <56998e12.BuVUhuWckJtP7/Y1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030180AbcAPAZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mika.penttila@nextfour.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-madvisemadv_free-fix
has been removed from the -mm tree.  Its filename was
     mm-support-madvisemadv_free-fix.patch

This patch was dropped because it was folded into mm-support-madvisemadv_free.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-support-madvisemadv_free-fix

Cc: Mika Penttil <mika.penttila@nextfour.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/madvise.c~mm-support-madvisemadv_free-fix mm/madvise.c
--- a/mm/madvise.c~mm-support-madvisemadv_free-fix
+++ a/mm/madvise.c
@@ -307,6 +307,8 @@ static int madvise_free_pte_range(pmd_t
 				pte_offset_map_lock(mm, pmd, addr, &ptl);
 				goto out;
 			}
+			put_page(page);
+			unlock_page(page);
 			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 			pte--;
 			addr -= PAGE_SIZE;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-define-madv_free-for-some-arches.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazily-freed-pages-to-inactive-list.patch
mm-mark-stable-page-dirty-in-ksm.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_mkclean-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch


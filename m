From: akpm@linux-foundation.org
Subject: [merged] dax-improve-comment-about-truncate-race.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:43:19 -0700
Message-ID: <55f08bd7.1Zud+8Ntu0VNm+3c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: improve comment about truncate race
has been removed from the -mm tree.  Its filename was
     dax-improve-comment-about-truncate-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: improve comment about truncate race

Jan Kara pointed out I should be more explicit here about the perils of
racing against truncate.  The comment is mostly the same as for the PTE
case.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-improve-comment-about-truncate-race fs/dax.c
--- a/fs/dax.c~dax-improve-comment-about-truncate-race
+++ a/fs/dax.c
@@ -553,7 +553,12 @@ int __dax_pmd_fault(struct vm_area_struc
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
 		goto fallback;
 
-	/* Guard against a race with truncate */
+	/*
+	 * If a truncate happened while we were allocating blocks, we may
+	 * leave blocks allocated to the file that are beyond EOF.  We can't
+	 * take i_mutex here, so just leave them hanging; they'll be freed
+	 * when the file is deleted.
+	 */
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (pgoff >= size) {
 		result = VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from willy@linux.intel.com are



From: akpm@linux-foundation.org
Subject: + mm-update-comments-for-struct-pagemapping.patch added to -mm
 tree
Date: Wed, 27 Sep 2017 12:55:41 -0700
Message-ID: <59cc023d.XbPFkEZ+vhqaWIP+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdI0Tzm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 15:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update comments for struct page.mapping
has been added to the -mm tree.  Its filename is
     mm-update-comments-for-struct-pagemapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-comments-for-struct-pagemapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-comments-for-struct-pagemapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changbin Du <changbin.du@intel.com>
Subject: mm: update comments for struct page.mapping

struct page.mapping can be NULL or points to one object of type
address_space, anon_vma or KSM private structure.

Link: http://lkml.kernel.org/r/1506485067-15954-1-git-send-email-changbin.du@intel.com
Signed-off-by: Changbin Du <changbin.du@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-update-comments-for-struct-pagemapping include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-update-comments-for-struct-pagemapping
+++ a/include/linux/mm_types.h
@@ -47,8 +47,10 @@ struct page {
 						 * inode address_space, or NULL.
 						 * If page mapped as anonymous
 						 * memory, low bit is set, and
-						 * it points to anon_vma object:
-						 * see PAGE_MAPPING_ANON below.
+						 * it points to anon_vma object
+						 * or KSM private structure. See
+						 * PAGE_MAPPING_ANON and
+						 * PAGE_MAPPING_KSM.
 						 */
 		void *s_mem;			/* slab first object */
 		atomic_t compound_mapcount;	/* first tail page */
_

Patches currently in -mm which might be from changbin.du@intel.com are

mm-update-comments-for-struct-pagemapping.patch


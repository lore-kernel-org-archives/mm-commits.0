From: akpm@linux-foundation.org
Subject: + readahead-fix-null-filp-dereference.patch added to -mm tree
Date: Fri, 02 Apr 2010 16:49:59 -0700
Message-ID: <201004022349.o32NnxoR012094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab0DBXuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 19:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, kirill@shutemov.name, stable@kernel.org, yanzheng@21cn.com


The patch titled
     readahead: fix NULL filp dereference
has been added to the -mm tree.  Its filename is
     readahead-fix-null-filp-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: fix NULL filp dereference
From: Wu Fengguang <fengguang.wu@intel.com>

btrfs relocate_file_extent_cluster() calls us with NULL filp:

  [ 4005.426805] BUG: unable to handle kernel NULL pointer dereference at 00000021
  [ 4005.426818] IP: [<c109a130>] page_cache_sync_readahead+0x18/0x3e

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Yan Zheng <yanzheng@21cn.com>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-fix-null-filp-dereference mm/readahead.c
--- a/mm/readahead.c~readahead-fix-null-filp-dereference
+++ a/mm/readahead.c
@@ -503,7 +503,7 @@ void page_cache_sync_readahead(struct ad
 		return;
 
 	/* be dumb */
-	if (filp->f_mode & FMODE_RANDOM) {
+	if (filp && (filp->f_mode & FMODE_RANDOM)) {
 		force_page_cache_readahead(mapping, filp, offset, req_size);
 		return;
 	}
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
readahead-fix-null-filp-dereference.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-o_-bit-numbers-uniqueness-check-update.patch
vfs-o_-bit-numbers-uniqueness-check-fix.patch
vfs-o_-bit-numbers-uniqueness-check-fix-2.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-add-super-operation-writeback_inodes.patch


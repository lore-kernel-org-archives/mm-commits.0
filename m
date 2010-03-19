From: akpm@linux-foundation.org
Subject: + tmpfs-handle-mpol_local-mount-option-properly.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:10:47 -0700
Message-ID: <201003192310.o2JNAlNP017624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab0CSXLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     tmpfs: handle MPOL_LOCAL mount option properly
has been added to the -mm tree.  Its filename is
     tmpfs-handle-mpol_local-mount-option-properly.patch

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
Subject: tmpfs: handle MPOL_LOCAL mount option properly
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
shmem_sb_info) added mpol=local mount option.  but its feature is broken
since it was born.  because such code always return 1 (i.e.  mount
failure).

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mempolicy.c~tmpfs-handle-mpol_local-mount-option-properly mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-handle-mpol_local-mount-option-properly
+++ a/mm/mempolicy.c
@@ -2214,6 +2214,7 @@ int mpol_parse_str(char *str, struct mem
 		if (nodelist)
 			goto out;
 		mode = MPOL_PREFERRED;
+		err = 0;
 		break;
 	case MPOL_DEFAULT:
 		/*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
tmpfs-fix-oops-on-mounts-with-mpol=default.patch
tmpfs-mpol=bind-0-dont-cause-mount-error.patch
tmpfs-handle-mpol_local-mount-option-properly.patch
tmpfs-cleanup-mpol_parse_str.patch
doc-add-the-documentation-for-mpol=local.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists-fix.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch


From: akpm@linux-foundation.org
Subject: + vmalloc-remove-confusing-comment-on-vwrite.patch added to -mm tree
Date: Wed, 09 Mar 2011 16:43:05 -0800
Message-ID: <201103100043.p2A0h5gT005569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab1CJAnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 19:43:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     vmalloc: remove confusing comment on vwrite()
has been added to the -mm tree.  Its filename is
     vmalloc-remove-confusing-comment-on-vwrite.patch

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
Subject: vmalloc: remove confusing comment on vwrite()
From: Namhyung Kim <namhyung@gmail.com>

KM_USER1 is never used for vwrite() path so the caller doesn't need to
guarantee it is not used.  Only the caller should guarantee is KM_USER0
and it is commented already.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-remove-confusing-comment-on-vwrite mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-remove-confusing-comment-on-vwrite
+++ a/mm/vmalloc.c
@@ -1935,8 +1935,6 @@ finished:
  *	should know vmalloc() area is valid and can use memcpy().
  *	This is for routines which have to access vmalloc area without
  *	any informaion, as /dev/kmem.
- *
- *	The caller should guarantee KM_USER1 is not used.
  */
 
 long vwrite(char *buf, char *addr, unsigned long count)
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mempolicy-remove-redundant-check-in-__mpol_equal.patch
vmalloc-remove-confusing-comment-on-vwrite.patch
select-remove-unused-max_select_seconds.patch


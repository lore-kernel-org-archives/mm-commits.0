From: akpm@linux-foundation.org
Subject: [merged] vmalloc-remove-confusing-comment-on-vwrite.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:05 -0700
Message-ID: <201103232041.p2NKfg6t028673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933424Ab1CWUmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmalloc: remove confusing comment on vwrite()
has been removed from the -mm tree.  Its filename was
     vmalloc-remove-confusing-comment-on-vwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2003,8 +2003,6 @@ finished:
  *	should know vmalloc() area is valid and can use memcpy().
  *	This is for routines which have to access vmalloc area without
  *	any informaion, as /dev/kmem.
- *
- *	The caller should guarantee KM_USER1 is not used.
  */
 
 long vwrite(char *buf, char *addr, unsigned long count)
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch


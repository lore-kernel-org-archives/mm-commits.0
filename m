From: akpm@linux-foundation.org
Subject: + memcg-use-vzalloc-instead-of-vmalloc.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:40:03 -0700
Message-ID: <201108161637.p7GGbBQQ002958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526Ab1HPQhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com


The patch titled
     memcg: use vzalloc instead of vmalloc
has been added to the -mm tree.  Its filename is
     memcg-use-vzalloc-instead-of-vmalloc.patch

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
Subject: memcg: use vzalloc instead of vmalloc
From: Bob Liu <lliubbo@gmail.com>

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_cgroup.c~memcg-use-vzalloc-instead-of-vmalloc mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-use-vzalloc-instead-of-vmalloc
+++ a/mm/page_cgroup.c
@@ -513,11 +513,10 @@ int swap_cgroup_swapon(int type, unsigne
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
-	array = vmalloc(array_size);
+	array = vzalloc(array_size);
 	if (!array)
 		goto nomem;
 
-	memset(array, 0, array_size);
 	ctrl = &swap_cgroup_ctrl[type];
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl->length = length;
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
memcg-use-vzalloc-instead-of-vmalloc.patch


From: akpm@linux-foundation.org
Subject: + mm-fix-some-indenting-in-cmpxchg_double_slab.patch added to -mm tree
Date: Thu, 15 May 2014 15:25:41 -0700
Message-ID: <53753ee5.GFObU0kOKFHyfCeX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaEOWZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 18:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, cl@linux-foundation.org, dan.carpenter@oracle.com

Subject: + mm-fix-some-indenting-in-cmpxchg_double_slab.patch added to -mm tree
To: dan.carpenter@oracle.com,cl@linux-foundation.org,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 15:25:41 -0700


The patch titled
     Subject: mm/slub.c: fix some indenting in cmpxchg_double_slab()
has been added to the -mm tree.  Its filename is
     mm-fix-some-indenting-in-cmpxchg_double_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-indenting-in-cmpxchg_double_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-indenting-in-cmpxchg_double_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/slub.c: fix some indenting in cmpxchg_double_slab()

The return statement goes with the cmpxchg_double() condition so it needs
to be indented another tab.

Also these days the fashion is to line function parameters up, and it
looks nicer that way because then the "freelist_new" is not at the same
indent level as the "return 1;".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~mm-fix-some-indenting-in-cmpxchg_double_slab mm/slub.c
--- a/mm/slub.c~mm-fix-some-indenting-in-cmpxchg_double_slab
+++ a/mm/slub.c
@@ -382,9 +382,9 @@ static inline bool __cmpxchg_double_slab
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
-			freelist_old, counters_old,
-			freelist_new, counters_new))
-		return 1;
+				   freelist_old, counters_old,
+				   freelist_new, counters_new))
+			return 1;
 	} else
 #endif
 	{
@@ -418,9 +418,9 @@ static inline bool cmpxchg_double_slab(s
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
-			freelist_old, counters_old,
-			freelist_new, counters_new))
-		return 1;
+				   freelist_old, counters_old,
+				   freelist_new, counters_new))
+			return 1;
 	} else
 #endif
 	{
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-fix-some-indenting-in-cmpxchg_double_slab.patch
lib-stringc-use-the-name-c-string-in-comments.patch
linux-next.patch


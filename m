From: akpm@linux-foundation.org
Subject: + kernel-groupsc-fix-integer-overflow-in-groups_search.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:55:08 -0700
Message-ID: <201009032355.o83Nt8eu019933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab0ICXzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmarchan@redhat.com, stable@kernel.org


The patch titled
     kernel/groups.c: fix integer overflow in groups_search
has been added to the -mm tree.  Its filename is
     kernel-groupsc-fix-integer-overflow-in-groups_search.patch

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
Subject: kernel/groups.c: fix integer overflow in groups_search
From: Jerome Marchand <jmarchan@redhat.com>

gid_t is a unsigned int.  If group_info contains a gid greater than
MAX_INT, groups_search() function may look on the wrong side of the search
tree.

This solves some unfair "permission denied" problems.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/groups.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/groups.c~kernel-groupsc-fix-integer-overflow-in-groups_search kernel/groups.c
--- a/kernel/groups.c~kernel-groupsc-fix-integer-overflow-in-groups_search
+++ a/kernel/groups.c
@@ -143,10 +143,9 @@ int groups_search(const struct group_inf
 	right = group_info->ngroups;
 	while (left < right) {
 		unsigned int mid = (left+right)/2;
-		int cmp = grp - GROUP_AT(group_info, mid);
-		if (cmp > 0)
+		if (grp > GROUP_AT(group_info, mid))
 			left = mid + 1;
-		else if (cmp < 0)
+		else if (grp < GROUP_AT(group_info, mid))
 			right = mid;
 		else
 			return 1;
_

Patches currently in -mm which might be from jmarchan@redhat.com are

linux-next.patch
kernel-groupsc-fix-integer-overflow-in-groups_search.patch


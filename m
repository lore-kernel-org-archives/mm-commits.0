From: akpm@linux-foundation.org
Subject: + kernel-groupsc-use-sort-library-function.patch added to -mm
 tree
Date: Thu, 15 Jun 2017 14:12:34 -0700
Message-ID: <5942f842.cf+SGvqkUzen/fha%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdFOVMf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 17:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, adobriyan@gmail.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/groups.c: use sort library function
has been added to the -mm tree.  Its filename is
     kernel-groupsc-use-sort-library-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-groupsc-use-sort-library-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-groupsc-use-sort-library-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/groups.c: use sort library function

setgroups is not exactly a hot path, so we might as well use the library
function instead of open-coding the sorting.  Saves ~150 bytes.

Link: http://lkml.kernel.org/r/1497301378-22739-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/groups.c |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff -puN kernel/groups.c~kernel-groupsc-use-sort-library-function kernel/groups.c
--- a/kernel/groups.c~kernel-groupsc-use-sort-library-function
+++ a/kernel/groups.c
@@ -5,6 +5,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/security.h>
+#include <linux/sort.h>
 #include <linux/syscalls.h>
 #include <linux/user_namespace.h>
 #include <linux/vmalloc.h>
@@ -76,32 +77,18 @@ static int groups_from_user(struct group
 	return 0;
 }
 
-/* a simple Shell sort */
-static void groups_sort(struct group_info *group_info)
+static int gid_cmp(const void *_a, const void *_b)
 {
-	int base, max, stride;
-	int gidsetsize = group_info->ngroups;
+	kgid_t a = *(kgid_t *)_a;
+	kgid_t b = *(kgid_t *)_b;
 
-	for (stride = 1; stride < gidsetsize; stride = 3 * stride + 1)
-		; /* nothing */
-	stride /= 3;
-
-	while (stride) {
-		max = gidsetsize - stride;
-		for (base = 0; base < max; base++) {
-			int left = base;
-			int right = left + stride;
-			kgid_t tmp = group_info->gid[right];
-
-			while (left >= 0 && gid_gt(group_info->gid[left], tmp)) {
-				group_info->gid[right] = group_info->gid[left];
-				right = left;
-				left -= stride;
-			}
-			group_info->gid[right] = tmp;
-		}
-		stride /= 3;
-	}
+	return gid_gt(a, b) - gid_lt(a, b);
+}
+
+static void groups_sort(struct group_info *group_info)
+{
+	sort(group_info->gid, group_info->ngroups, sizeof(*group_info->gid),
+	     gid_cmp, NULL);
 }
 
 /* a simple bsearch */
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

kernel-groupsc-use-sort-library-function.patch


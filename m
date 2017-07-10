From: akpm@linux-foundation.org
Subject: [patch 081/115] kernel/groups.c: use sort library function
Date: Mon, 10 Jul 2017 15:51:17 -0700
Message-ID: <20170710225117.lifQh40n5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754942AbdGJWvS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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

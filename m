From: akpm@linux-foundation.org
Subject: [merged] kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:23 -0700
Message-ID: <20121005202223.B6431100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56456 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:24 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so237754qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tmac@hp.com, linuxram@us.ibm.com, paul.gortmaker@gmail.com, weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource.c: fix stack overflow in __reserve_region_with_split()
has been removed from the -mm tree.  Its filename was
     kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: T Makphaibulchoke <tmac@hp.com>
Subject: kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Using a recurvise call add a non-conflicting region in
__reserve_region_with_split() could result in a stack overflow in the case
that the recursive calls are too deep.  Convert the recursive calls to an
iterative loop to avoid the problem.

Tested on a machine containing 135 regions.  The kernel no longer panicked
with stack overflow.

Also tested with code arbitrarily adding regions with no conflict,
embedding two consecutive conflicts and embedding two non-consecutive
conflicts.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@gmail.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   50 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff -puN kernel/resource.c~kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split
+++ a/kernel/resource.c
@@ -763,6 +763,7 @@ static void __init __reserve_region_with
 	struct resource *parent = root;
 	struct resource *conflict;
 	struct resource *res = kzalloc(sizeof(*res), GFP_ATOMIC);
+	struct resource *next_res = NULL;
 
 	if (!res)
 		return;
@@ -772,21 +773,46 @@ static void __init __reserve_region_with
 	res->end = end;
 	res->flags = IORESOURCE_BUSY;
 
-	conflict = __request_resource(parent, res);
-	if (!conflict)
-		return;
+	while (1) {
 
-	/* failed, split and try again */
-	kfree(res);
+		conflict = __request_resource(parent, res);
+		if (!conflict) {
+			if (!next_res)
+				break;
+			res = next_res;
+			next_res = NULL;
+			continue;
+		}
 
-	/* conflict covered whole area */
-	if (conflict->start <= start && conflict->end >= end)
-		return;
+		/* conflict covered whole area */
+		if (conflict->start <= res->start &&
+				conflict->end >= res->end) {
+			kfree(res);
+			WARN_ON(next_res);
+			break;
+		}
+
+		/* failed, split and try again */
+		if (conflict->start > res->start) {
+			end = res->end;
+			res->end = conflict->start - 1;
+			if (conflict->end < end) {
+				next_res = kzalloc(sizeof(*next_res),
+						GFP_ATOMIC);
+				if (!next_res) {
+					kfree(res);
+					break;
+				}
+				next_res->name = name;
+				next_res->start = conflict->end + 1;
+				next_res->end = end;
+				next_res->flags = IORESOURCE_BUSY;
+			}
+		} else {
+			res->start = conflict->end + 1;
+		}
+	}
 
-	if (conflict->start > start)
-		__reserve_region_with_split(root, start, conflict->start-1, name);
-	if (conflict->end < end)
-		__reserve_region_with_split(root, conflict->end+1, end, name);
 }
 
 void __init reserve_region_with_split(struct resource *root,
_

Patches currently in -mm which might be from tmac@hp.com are

origin.patch


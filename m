From: akpm@linux-foundation.org
Subject: + kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split.patch added to -mm tree
Date: Tue, 11 Sep 2012 15:02:50 -0700
Message-ID: <20120911220250.9901A1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:64051 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab2IKWCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 18:02:52 -0400
Received: by vcqp1 with SMTP id p1so117226vcq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 15:02:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tmac@hp.com, linuxram@us.ibm.com, paul.gortmaker@gmail.com, weiyang@linux.vnet.ibm.com


The patch titled
     Subject: kernel/resource.c: fix stack overflow in __reserve_region_with_split()
has been added to the -mm tree.  Its filename is
     kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

x86-mm-initc-devmem_is_allowed-off-by-one.patch
kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split.patch


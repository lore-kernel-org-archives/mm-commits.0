From: akpm@google.com
Subject: + vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node.patch added to -mm tree
Date: Mon, 26 Sep 2011 16:14:48 -0700
Message-ID: <201109262314.p8QNEmcj029568@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:49588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1IZXPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2011 19:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     Subject: vmscan.c: fix invalid strict_strtoul() check in write_scan_unevictable_node()
has been added to the -mm tree.  Its filename is
     vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node.patch

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
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: vmscan.c: fix invalid strict_strtoul() check in write_scan_unevictable_node()

write_scan_unevictable_node() checks the value req returned by
strict_strtoul() and returns 1 if req is 0.

However, when strict_strtoul() returns 0, it means successful conversion
of buf to unsigned long.

Due to this, the function was not proceeding to scan the zones for
unevictable pages even though we write a valid value to the
scan_unevictable_pages sys file.

Change this check slightly to check for invalid value in buf as well as 0
value stored in res after successful conversion via strict_strtoul.  In
both cases, we do not perform the scanning of this node's zones.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node mm/vmscan.c
--- a/mm/vmscan.c~vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node
+++ a/mm/vmscan.c
@@ -3503,8 +3503,8 @@ static ssize_t write_scan_unevictable_no
 	unsigned long res;
 	unsigned long req = strict_strtoul(buf, 10, &res);
 
-	if (!req)
-		return 1;	/* zero is no-op */
+	if (req || !res)
+		return 1; /* Invalid input or zero is no-op */
 
 	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
 		if (!populated_zone(zone))
_
Subject: Subject: vmscan.c: fix invalid strict_strtoul() check in write_scan_unevictable_node()

Patches currently in -mm which might be from consul.kautuk@gmail.com are

mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node.patch


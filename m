From: akpm@linux-foundation.org
Subject: [merged] mm-fix-off-by-one-bug-in-print_nodes_state.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:00 -0700
Message-ID: <20120531191400.3453BA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51543 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734Ab2EaTOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:02 -0400
Received: by faaa25 with SMTP id a25so75194faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ozaki.ryota@gmail.com, Lee.Schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix off-by-one bug in print_nodes_state()
has been removed from the -mm tree.  Its filename was
     mm-fix-off-by-one-bug-in-print_nodes_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ryota Ozaki <ozaki.ryota@gmail.com>
Subject: mm: fix off-by-one bug in print_nodes_state()

/sys/devices/system/node/{online,possible} outputs a garbage byte because
print_nodes_state() returns content size + 1.  To fix the bug, the patch
changes the use of cpuset_sprintf_cpulist to follow the use at other
places, which is clearer and safer.

This bug was introduced since v2.6.24 (bde631a51876f23e9).

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/base/node.c~mm-fix-off-by-one-bug-in-print_nodes_state drivers/base/node.c
--- a/drivers/base/node.c~mm-fix-off-by-one-bug-in-print_nodes_state
+++ a/drivers/base/node.c
@@ -592,11 +592,9 @@ static ssize_t print_nodes_state(enum no
 {
 	int n;
 
-	n = nodelist_scnprintf(buf, PAGE_SIZE, node_states[state]);
-	if (n > 0 && PAGE_SIZE > n + 1) {
-		*(buf + n++) = '\n';
-		*(buf + n++) = '\0';
-	}
+	n = nodelist_scnprintf(buf, PAGE_SIZE-2, node_states[state]);
+	buf[n++] = '\n';
+	buf[n] = '\0';
 	return n;
 }
 
_

Patches currently in -mm which might be from ozaki.ryota@gmail.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + mm-fix-off-by-one-bug-in-print_nodes_state.patch added to -mm tree
Date: Fri, 20 Apr 2012 13:06:08 -0700
Message-ID: <20120420200608.97A49A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53517 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2DTUGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 16:06:09 -0400
Received: by qabg24 with SMTP id g24so102518qab.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 13:06:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ozaki.ryota@gmail.com, Lee.Schermerhorn@hp.com


The patch titled
     Subject: mm: fix off-by-one bug in print_nodes_state()
has been added to the -mm tree.  Its filename is
     mm-fix-off-by-one-bug-in-print_nodes_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: fix off-by-one bug in print_nodes_state()

Patches currently in -mm which might be from ozaki.ryota@gmail.com are

mm-fix-off-by-one-bug-in-print_nodes_state.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch


From: akpm@linux-foundation.org
Subject: [merged] fault-inject-avoid-call-to-random32-if-fault-injection-is-disabled.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:40 -0700
Message-ID: <20120621192540.677C3A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33530 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760086Ab2FUTZl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:41 -0400
Received: by mail-ey0-f202.google.com with SMTP id o13so62854eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: avoid call to random32() if fault injection is disabled
has been removed from the -mm tree.  Its filename was
     fault-inject-avoid-call-to-random32-if-fault-injection-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Blanchard <anton@samba.org>
Subject: fault-inject: avoid call to random32() if fault injection is disabled

After enabling CONFIG_FAILSLAB I noticed random32 in profiles even if slub
fault injection wasn't enabled at runtime.

should_fail forces a comparison against random32() even if probability is
0:

        if (attr->probability <= random32() % 100)
                return false;

Add a check up front for probability == 0 and avoid all of the more
complicated checks.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/fault-inject.c~fault-inject-avoid-call-to-random32-if-fault-injection-is-disabled lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-avoid-call-to-random32-if-fault-injection-is-disabled
+++ a/lib/fault-inject.c
@@ -101,6 +101,10 @@ static inline bool fail_stacktrace(struc
 
 bool should_fail(struct fault_attr *attr, ssize_t size)
 {
+	/* No need to check any other properties if the probability is 0 */
+	if (attr->probability == 0)
+		return false;
+
 	if (attr->task_filter && !fail_task(attr, current))
 		return false;
 
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch


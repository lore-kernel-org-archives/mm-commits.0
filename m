From: akpm@linux-foundation.org
Subject: + fault-inject-avoid-call-to-random32-if-fault-injection-is-disabled.patch added to -mm tree
Date: Wed, 13 Jun 2012 14:40:02 -0700
Message-ID: <20120613214003.3C700A02A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51538 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2FMVkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 17:40:04 -0400
Received: by yenl3 with SMTP id l3so110717yen.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 14:40:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, akinobu.mita@gmail.com


The patch titled
     Subject: fault-inject: avoid call to random32() if fault injection is disabled
has been added to the -mm tree.  Its filename is
     fault-inject-avoid-call-to-random32-if-fault-injection-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fault-inject: avoid call to random32() if fault injection is disabled

Patches currently in -mm which might be from anton@samba.org are

fault-inject-avoid-call-to-random32-if-fault-injection-is-disabled.patch


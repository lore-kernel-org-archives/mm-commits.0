From: akpm@linux-foundation.org
Subject: + kernel-rangec-subtract_range-fix-the-broken-phrase-issued-by-printk.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:31:53 -0700
Message-ID: <20130319203153.6F2C85A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52179 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935Ab3CSUby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:31:54 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so88270qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:31:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linfeng@cn.fujitsu.com, yinghai@kernel.org


The patch titled
     Subject: kernel/range.c: subtract_range: fix the broken phrase issued by printk
has been added to the -mm tree.  Its filename is
     kernel-rangec-subtract_range-fix-the-broken-phrase-issued-by-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lin Feng <linfeng@cn.fujitsu.com>
Subject: kernel/range.c: subtract_range: fix the broken phrase issued by printk

Also replace deprecated printk(KERN_ERR...) with pr_err() as suggested
by Yinghai, attaching the function name to provide plenty info.

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/range.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/range.c~kernel-rangec-subtract_range-fix-the-broken-phrase-issued-by-printk kernel/range.c
--- a/kernel/range.c~kernel-rangec-subtract_range-fix-the-broken-phrase-issued-by-printk
+++ a/kernel/range.c
@@ -97,7 +97,8 @@ void subtract_range(struct range *range,
 				range[i].end = range[j].end;
 				range[i].start = end;
 			} else {
-				printk(KERN_ERR "run of slot in ranges\n");
+				pr_err("%s: run out of slot in ranges\n",
+					__func__);
 			}
 			range[j].end = start;
 			continue;
_

Patches currently in -mm which might be from linfeng@cn.fujitsu.com are

include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
kernel-rangec-subtract_range-fix-the-broken-phrase-issued-by-printk.patch


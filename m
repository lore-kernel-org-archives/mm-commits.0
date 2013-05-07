From: akpm@linux-foundation.org
Subject: [merged] kernel-rangec-subtract_range-fix-the-broken-phrase-issued-by-printk.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:56 -0700
Message-ID: <20130507174656.7911C5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37915 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab3EGRq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:58 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so85167vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linfeng@cn.fujitsu.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/range.c: subtract_range: fix the broken phrase issued by printk
has been removed from the -mm tree.  Its filename was
     kernel-rangec-subtract_range-fix-the-broken-phrase-issued-by-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch


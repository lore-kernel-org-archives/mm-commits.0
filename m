From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-remove-redundant-null-pointer-check.patch added to -mm tree
Date: Fri, 26 Apr 2013 13:26:57 -0700
Message-ID: <20130426202657.747A35A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58879 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab3DZU06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Apr 2013 16:26:58 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so474547ggm.5
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2013 13:26:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jlbec@evilplan.org, mfasheh@suse.de


The patch titled
     Subject: ocfs2/dlm: remove redundant null pointer check
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-remove-redundant-null-pointer-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: ocfs2/dlm: remove redundant null pointer check

kfree on a NULL pointer is a no-op.  Remove the redundant null pointer
check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-null-pointer-check fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-null-pointer-check
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1498,10 +1498,8 @@ leave:
 
 	dlm_put(dlm);
 	if (ret < 0) {
-		if (buf)
-			kfree(buf);
-		if (item)
-			kfree(item);
+		kfree(buf);
+		kfree(item);
 		mlog_errno(ret);
 	}
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch
ocfs2-dlm-remove-redundant-null-pointer-check.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch
drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch
drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch
drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch
drivers-rtc-rtc-ds1305c-use-devm_-apis.patch
drivers-rtc-rtc-ds1374c-use-devm_-apis.patch
drivers-rtc-rtc-ds3232c-use-devm_-apis.patch
drivers-rtc-rtc-m48t35c-use-devm_-apis.patch
drivers-rtc-rtc-max8925c-use-devm_-apis.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch


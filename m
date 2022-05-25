Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B7DC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbiEYRtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343506AbiEYRs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:48:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D75B55225
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D90E5B81E76
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98817C385B8;
        Wed, 25 May 2022 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500935;
        bh=mxdzZsxn81com9KK1Fg73SFnrLFvq6+XDAHi1hEMm2c=;
        h=Date:To:From:Subject:From;
        b=zoXVxdXWDtxCEM2FMYnrmKd2J9tcDYH3hG9JJvrNrMxNfLECpa7IrhBHSQhaoBjVU
         ybignDsxVywe8l4fEM9ZuQ21ZLK2IFajQNgAsPS3jfVPRy2n52ZjIcjnT1GkDxHugr
         gqhuxTR44WwihucQFA/WL/LNDMXzJdurZTk2562Q=
Date:   Wed, 25 May 2022 10:48:54 -0700
To:     mm-commits@vger.kernel.org, elver@google.com, liuyun01@kylinos.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-print-disabling-or-re-enabling-message.patch removed from -mm tree
Message-Id: <20220525174855.98817C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kfence: print disabling or re-enabling message
has been removed from the -mm tree.  Its filename was
     mm-kfence-print-disabling-or-re-enabling-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/kfence: print disabling or re-enabling message
Date: Wed, 18 May 2022 15:31:05 +0800

By printing information, we can friendly prompt the status change
information of kfence by dmesg and record by syslog.

Also, set kfence_enabled to false only when needed.

Link: https://lkml.kernel.org/r/20220518073105.3160335-1-liu.yun@linux.dev
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Co-developed-by: Marco Elver <elver@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~mm-kfence-print-disabling-or-re-enabling-message
+++ a/mm/kfence/core.c
@@ -69,8 +69,11 @@ static int param_set_sample_interval(con
 	if (ret < 0)
 		return ret;
 
-	if (!num) /* Using 0 to indicate KFENCE is disabled. */
+	/* Using 0 to indicate KFENCE is disabled. */
+	if (!num && READ_ONCE(kfence_enabled)) {
+		pr_info("disabled\n");
 		WRITE_ONCE(kfence_enabled, false);
+	}
 
 	*((unsigned long *)kp->arg) = num;
 
@@ -898,6 +901,7 @@ static int kfence_enable_late(void)
 
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	pr_info("re-enabled\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are



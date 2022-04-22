Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218EBC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 21:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiDVVhi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 17:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiDVVhh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 17:37:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0640D400EF3
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:38:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF92FCE2875
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EDCC385A4;
        Fri, 22 Apr 2022 20:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650659851;
        bh=4yRqnUbgPpL+O4i5xV4zb2vowTBdtWdpmfr1eLnhtK8=;
        h=Date:To:From:Subject:From;
        b=A9WHPKusdx+QQpatvd6lsT5GOdQK2nuNP8ISdxNV/ksDZlLhfxRp+vfMAs+YORgi8
         TU2iu84PIX4I6SJec5aBBiuDvY/nkK78Ojq0ZZqvP87N8Yl41c06G1SnSW9Y1cJRYP
         c0DtAIZ0xqv/+dr71vab11bwx2jNl5pPII2RM5BM=
Date:   Fri, 22 Apr 2022 13:37:30 -0700
To:     mm-commits@vger.kernel.org, sudarsana.kalluru@qlogic.com,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        anil.gurumurthy@qlogic.com, wangqing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220422203731.06EDCC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: bfa: use time_is_before_jiffies() instead of open coding it
has been added to the -mm tree.  Its filename is
     scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: scsi: bfa: use time_is_before_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-9-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfad_im.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/bfa/bfad_im.c~scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it
+++ a/drivers/scsi/bfa/bfad_im.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/jiffies.h>
 
 #include "bfad_drv.h"
 #include "bfad_im.h"
@@ -871,9 +872,9 @@ bfad_ramp_up_qdepth(struct bfad_itnim_s
 {
 	struct scsi_device *tmp_sdev;
 
-	if (((jiffies - itnim->last_ramp_up_time) >
+	if (time_is_before_jiffies(itnim->last_ramp_up_time +
 		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ) &&
-		((jiffies - itnim->last_queue_full_time) >
+		time_is_before_jiffies(itnim->last_queue_full_time +
 		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ)) {
 		shost_for_each_device(tmp_sdev, sdev->host) {
 			if (bfa_lun_queue_depth > tmp_sdev->queue_depth) {
_

Patches currently in -mm which might be from wangqing@vivo.com are

block-xen-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch
gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it.patch
hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch
md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF540C43217
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbiDZACk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbiDZACi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86D1120113
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5AC8CE1AC6
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041A2C385A7;
        Mon, 25 Apr 2022 23:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931162;
        bh=qvbLYOje0yeD2s2nhkKGqqij4Q7ivUDOHp03bxhMyZI=;
        h=Date:To:From:Subject:From;
        b=qLszE560s6UqHNQLFJO6aLG1gkzOqptHHFKYcq0ECXEz7Vf3NLiTA+X+IsjeHId9A
         CcqeGQtKY+OXXzVn2nnCuY88BDqfYApfyH/tKbYbDOYglxzIfe/w8nwiFUNFjhRcCW
         Af8YZXNgcQmVwFngcTYj9CWtp3jk4j42WmMioIik=
Date:   Mon, 25 Apr 2022 16:59:21 -0700
To:     mm-commits@vger.kernel.org, sudarsana.kalluru@qlogic.com,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        anil.gurumurthy@qlogic.com, wangqing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425235922.041A2C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: bfa: use time_is_before_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it had testing failures

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

net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch


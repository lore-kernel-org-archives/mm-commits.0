Return-Path: <SRS0=1ZdY=CA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6C4C433E3
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D54022BED
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598117377;
	bh=hmFSsrcUG3Gpt6P/NoCAC40V2sYAuTC4+A7LiTfDO2M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=v1/52Sx32oiB1wn9K6sMabA5nvVNwea0xsdbqMAXsvvQqMB0DHqQIcxOUS6ONqiaE
	 +jznL2qZSCc0PEMAIaUb40yW+RWoV9QHmUrHXzaPP7R+x/5V7p7++/cf97YMyxfXFK
	 5C1E3y9LMJUBOyIlrw50mbOLXaRSKfhSTmA0Nnok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgHVR3e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Aug 2020 13:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgHVR3d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149FA20724;
        Sat, 22 Aug 2020 17:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117372;
        bh=hmFSsrcUG3Gpt6P/NoCAC40V2sYAuTC4+A7LiTfDO2M=;
        h=Date:From:To:Subject:From;
        b=RhrOOXbHEDuFTCw/K11UFWr519nVV9DD4DEY8liJMEBIjYRyvmtmjzKX983Db0OqA
         r1yJafXGyiq+BxOPyl/WPKKUWYKbPC4cuiv7ycVGUJMc+cv1/fEAsaTMXfFcBoMxl2
         xJsbxvpnzSUCNQ2FvC1RFrHShGbzsqhxcOGcj7qg=
Date:   Sat, 22 Aug 2020 10:29:31 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20200822172931.FtX78iOwr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/opp/core.c |   41 -----------------------------------------
 1 file changed, 41 deletions(-)

--- a/drivers/opp/core.c~linux-next-git-rejects
+++ a/drivers/opp/core.c
@@ -914,37 +914,7 @@ int dev_pm_opp_set_rate(struct device *d
 	}
 
 	if (unlikely(!target_freq)) {
-<<<<<<< HEAD
-		/*
-		 * Some drivers need to support cases where some platforms may
-		 * have OPP table for the device, while others don't and
-		 * opp_set_rate() just needs to behave like clk_set_rate().
-		 */
-		if (!_get_opp_count(opp_table)) {
-			ret = 0;
-			goto put_opp_table;
-		}
-
-		if (!opp_table->required_opp_tables && !opp_table->regulators &&
-		    !opp_table->paths) {
-			dev_err(dev, "target frequency can't be 0\n");
-			ret = -EINVAL;
-			goto put_opp_table;
-		}
-
-		ret = _set_opp_bw(opp_table, NULL, dev, true);
-		if (ret)
-			goto put_opp_table;
-
-		if (opp_table->regulator_enabled) {
-			regulator_disable(opp_table->regulators[0]);
-			opp_table->regulator_enabled = false;
-		}
-
-		ret = _set_required_opps(dev, opp_table, NULL);
-=======
 		ret = _opp_set_rate_zero(dev, opp_table);
->>>>>>> linux-next/akpm-base
 		goto put_opp_table;
 	}
 
@@ -963,22 +933,11 @@ int dev_pm_opp_set_rate(struct device *d
 	old_freq = clk_get_rate(clk);
 
 	/* Return early if nothing to do */
-<<<<<<< HEAD
-	if (old_freq == freq) {
-		if (!opp_table->required_opp_tables && !opp_table->regulators &&
-		    !opp_table->paths) {
-			dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
-				__func__, freq);
-			ret = 0;
-			goto put_opp_table;
-		}
-=======
 	if (opp_table->enabled && old_freq == freq) {
 		dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
 			__func__, freq);
 		ret = 0;
 		goto put_opp_table;
->>>>>>> linux-next/akpm-base
 	}
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


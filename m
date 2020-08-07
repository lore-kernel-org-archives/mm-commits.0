Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979ADC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F15922CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781068;
	bh=3SUE6uPfKgAVqijImsS7I/IPEr0raTLy/24Tx7gc+uA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bnD/yKlM1kvhKwTIn041HCrJRHWH+s5AGhxDF45W0aKiE0nfwor1LvnHmOelwAjem
	 KvXT1CW5izk06/WIv9IzV66E+kHDHOLR+N/fC29COc8Fi7XqjNIStN+oELuOHuD0TO
	 1291xxesxtNDkCKFF6GTd7+SX7get/UWJqx0h2Ms=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGGRs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A5F9221E5;
        Fri,  7 Aug 2020 06:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781067;
        bh=3SUE6uPfKgAVqijImsS7I/IPEr0raTLy/24Tx7gc+uA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d2MwzfCi9blh0ovXU5OCEFMPy6Kr2Nw7t7Zl/pejto4J5LEw8Xaubs1PC+4KpHKdY
         bDhkhSeRMTX5vrOpRVO7DHi1tcSIVm8AVWS6coMTujO1wI1z3JQhq9DUzmxlRIZvVd
         vDpc5MsM86JUadq5SPm1kNMTSGg1fHbWEpaY1ATY=
Date:   Thu, 06 Aug 2020 23:17:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bleung@chromium.org, broonie@kernel.org,
        enric.balletbo@collabora.com, groeck@chromium.org, joe@perches.com,
        lgirdwood@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pihsun@chromium.org,
        rikard.falkeborn@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 014/163] const_structs.checkpatch: add
 regulator_ops
Message-ID: <20200807061746.Xki5F1zJ5%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: const_structs.checkpatch: add regulator_ops

Add regulator_ops to expected to be const list.

Link: http://lkml.kernel.org/r/dab1ba1aa03a8236933cfb7a28937efb0b808f13.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pi-Hsun Shih <pihsun@chromium.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-regulator_ops
+++ a/scripts/const_structs.checkpatch
@@ -44,6 +44,7 @@ platform_hibernation_ops
 platform_suspend_ops
 proto_ops
 regmap_access_table
+regulator_ops
 rpc_pipe_ops
 rtc_class_ops
 sd_desc
_

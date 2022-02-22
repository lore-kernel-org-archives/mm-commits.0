Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A76C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiBVCrP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:47:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiBVCrO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:47:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBF722BDE
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:46:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D7D86128E
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B23C340E9;
        Tue, 22 Feb 2022 02:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645498009;
        bh=FvI4Z/X7cHIKTe7e0FMqhkafCSsIksvLarGIxa3isU8=;
        h=Date:To:From:Subject:From;
        b=Em9eVvxxDFqF5V6BoVNED5+fQ8+nsH9DvPmiqwnYAuaz17ZKlF5CjMnEcyk4Qs+JN
         deEUioAanJ7MS4SY9B4hslPDc7w+AGhpeu4bHnk7B6Q1h2GWmUHBWetML51gn/zHlQ
         9946ozJ4+cpOv4PPlGtrFNb48wIdoB+MpnBY15yA=
Date:   Mon, 21 Feb 2022 18:46:49 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, tangmeng@uniontech.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-remove-unnecessary-config_kfence-option.patch added to -mm tree
Message-Id: <20220222024649.A2B23C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kfence: remove unnecessary CONFIG_KFENCE option
has been added to the -mm tree.  Its filename is
     mm-kfence-remove-unnecessary-config_kfence-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kfence-remove-unnecessary-config_kfence-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kfence-remove-unnecessary-config_kfence-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: tangmeng <tangmeng@uniontech.com>
Subject: mm/kfence: remove unnecessary CONFIG_KFENCE option

In mm/Makefile has:
obj-$(CONFIG_KFENCE) += kfence/

So that we don't need 'obj-$(CONFIG_KFENCE) :=' in mm/kfence/Makefile,
delete it from mm/kfence/Makefile.

Link: https://lkml.kernel.org/r/20220221065525.21344-1-tangmeng@uniontech.com
Signed-off-by: tangmeng <tangmeng@uniontech.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/Makefile~mm-kfence-remove-unnecessary-config_kfence-option
+++ a/mm/kfence/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_KFENCE) := core.o report.o
+obj-y := core.o report.o
 
 CFLAGS_kfence_test.o := -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
 obj-$(CONFIG_KFENCE_KUNIT_TEST) += kfence_test.o
_

Patches currently in -mm which might be from tangmeng@uniontech.com are

mm-kfence-remove-unnecessary-config_kfence-option.patch


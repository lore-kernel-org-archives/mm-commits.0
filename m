Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455DFC0502C
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiH0WNr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiH0WNn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:13:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EAC356D8
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 840A5B80A49
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B8CC433D7;
        Sat, 27 Aug 2022 22:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661638420;
        bh=lsiQ7UXuc5EdBTo7lHwbT8oLIbV7pZi2jYiwuqMHe6U=;
        h=Date:To:From:Subject:From;
        b=vwI9N6vbRgiC/K/32B9N8lxQbnRfdousNPDf17MlEXBogE0IrK3CdhCry4O2huFWw
         q45+QRd9uI2L8kthe40hkeHNtGjUAwDf2jUGeKfhcv4cB5WeTlicVJp4pXjvTYkDyk
         g4ufHX6LtsRhcyg0NRoTcE81mmR1l1Ib4ax9d3sw=
Date:   Sat, 27 Aug 2022 15:13:39 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-skip-confusing-print-info.patch added to mm-unstable branch
Message-Id: <20220827221340.45B8CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: skip confusing print info
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-skip-confusing-print-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-skip-confusing-print-info.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/zswap: skip confusing print info
Date: Sat, 27 Aug 2022 18:46:00 +0800

It's confusing when we disable zswap while zswap is init failed or has no
pool.  If no change required, just return directly.

Link: https://lkml.kernel.org/r/20220827104600.1813214-6-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/zswap.c~mm-zswap-skip-confusing-print-info
+++ a/mm/zswap.c
@@ -886,6 +886,15 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
+	bool res;
+
+	if (kstrtobool(val, &res))
+		return -EINVAL;
+
+	/* no change required */
+	if (res == *(bool *)kp->arg)
+		return 0;
+
 	if (system_state == SYSTEM_RUNNING) {
 		mutex_lock(&zswap_init_lock);
 		if (zswap_setup()) {
_

Patches currently in -mm which might be from liushixin2@huawei.com are

bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch
frontswap-skip-frontswap_ops-init-if-zswap-init-failed.patch
frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch


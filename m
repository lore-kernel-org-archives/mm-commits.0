Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA16C0502C
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 20:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiH2UD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 16:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiH2UDp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 16:03:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5632597D79
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 13:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 151A3B811CC
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 20:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FDAC433D6;
        Mon, 29 Aug 2022 20:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661803421;
        bh=T3Hbopy2dZkhwhcjcACmk5nhJbfU4dttEXPJkXtqWd0=;
        h=Date:To:From:Subject:From;
        b=HJYZCgp31uRRsPst0zCZCDl7Zg0sXsEv6TgBFJW1m/apaHtBOqlqQ4gkNSIyDQYa7
         9lsNjRcWrQJZKqBT0BpypmqvZGvOT0RenjcrO0iFdFBM51avubW1vacYmUNqmPWXd/
         gU/h9wlzanwFMgt2CBFLAeFaO0TTvG8phBOqfTL8=
Date:   Mon, 29 Aug 2022 13:03:40 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-skip-confusing-print-info.patch added to mm-unstable branch
Message-Id: <20220829200341.B1FDAC433D6@smtp.kernel.org>
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
Date: Mon, 29 Aug 2022 21:23:02 +0800

It's confusing when we disable zswap while zswap init failed or has no
pool.  If no change required, just return directly.

Link: https://lkml.kernel.org/r/20220829132302.3367054-7-liushixin2@huawei.com
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

revert-frontswap-remove-support-for-multiple-ops.patch
revert-mm-mark-swap_lock-and-swap_active_head-static.patch
revert-frontswap-simplify-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch


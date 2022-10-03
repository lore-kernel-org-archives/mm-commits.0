Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F8AC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJCVMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiJCVL0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B5E5142A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 093F3B81611
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB17C433D6;
        Mon,  3 Oct 2022 21:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831217;
        bh=JCXM6hezMm7H7x2a1BoXumxaG1YrERSc7ujOHk+YEZE=;
        h=Date:To:From:Subject:From;
        b=M/x43lLvbDOTpusybisZA69yU8dls/lkgDzMYR5vRaKdgt5jgad24qYnb2tTYfYRz
         JVrtR9aZhb2hMGV3NogApoQPoDwUnRp2OGj04X8eAWAr+cKeGx5oIhlGv36LBAkBRR
         NVJW2Dce2ZfN6cVzXWdDew8LT3DuWzc/SZ3jgBjA=
Date:   Mon, 03 Oct 2022 14:06:56 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        rusty@rustcorp.com.au, david@redhat.com, dan.j.williams@intel.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shuffle-convert-module_param_call-to-module_param_cb.patch removed from -mm tree
Message-Id: <20221003210657.9CB17C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shuffle: convert module_param_call to module_param_cb
has been removed from the -mm tree.  Its filename was
     mm-shuffle-convert-module_param_call-to-module_param_cb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/shuffle: convert module_param_call to module_param_cb
Date: Fri, 9 Sep 2022 16:39:47 +0800

module_param_call is now completely consistent with module_param_cb, so
there is no need to keep two macros.  Convert module_param_call to
module_param_cb since former is obsolete and latter is more kernel-ish.

Link: https://lkml.kernel.org/r/20220909083947.3595610-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Paul Russel <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shuffle.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/shuffle.c~mm-shuffle-convert-module_param_call-to-module_param_cb
+++ a/mm/shuffle.c
@@ -12,23 +12,22 @@
 DEFINE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 
 static bool shuffle_param;
-static int shuffle_show(char *buffer, const struct kernel_param *kp)
-{
-	return sprintf(buffer, "%c\n", shuffle_param ? 'Y' : 'N');
-}
 
-static __meminit int shuffle_store(const char *val,
+static __meminit int shuffle_param_set(const char *val,
 		const struct kernel_param *kp)
 {
-	int rc = param_set_bool(val, kp);
-
-	if (rc < 0)
-		return rc;
-	if (shuffle_param)
+	if (param_set_bool(val, kp))
+		return -EINVAL;
+	if (*(bool *)kp->arg)
 		static_branch_enable(&page_alloc_shuffle_key);
 	return 0;
 }
-module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
+
+static const struct kernel_param_ops shuffle_param_ops = {
+	.set = shuffle_param_set,
+	.get = param_get_bool,
+};
+module_param_cb(shuffle, &shuffle_param_ops, &shuffle_param, 0400);
 
 /*
  * For two pages to be swapped in the shuffle, they must be free (on a
_

Patches currently in -mm which might be from liushixin2@huawei.com are



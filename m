Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A81C6FA89
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiIIVyP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiIIVyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:54:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D26109D0B
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 234C1B82656
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB25C433C1;
        Fri,  9 Sep 2022 21:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662760450;
        bh=Wf+Y28N9nNq3BlJ0taB8uroksDEnMOT1SyTJ9L0w7Kk=;
        h=Date:To:From:Subject:From;
        b=eon6RpqBPxvuisZlzwJkQV65OwXmWN7rues2s8y8CnsrmEfQzQPDfFy04MSTPAqV5
         JFmogYUVv+w0HkkKSRibo9THwRfo/w+FcFILmG1yFMg08qqSbqI7vAPTy75Mxi+O9R
         0929ITY61XfSOckuG/RDr5aBFSN6c1Ej4+7emJ1o=
Date:   Fri, 09 Sep 2022 14:54:09 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        rusty@rustcorp.com.au, david@redhat.com, dan.j.williams@intel.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shuffle-convert-module_param_call-to-module_param_cb.patch added to mm-unstable branch
Message-Id: <20220909215410.AAB25C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shuffle: convert module_param_call to module_param_cb
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shuffle-convert-module_param_call-to-module_param_cb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shuffle-convert-module_param_call-to-module_param_cb.patch

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

mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch
mm-kmemleak-make-create_object-return-void.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch
mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch
mm-shuffle-convert-module_param_call-to-module_param_cb.patch


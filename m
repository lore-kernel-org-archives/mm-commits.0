Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB08ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbiH0DKE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344959AbiH0DKD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:10:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAED5FC5
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0763AB83387
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B2AC433D6;
        Sat, 27 Aug 2022 03:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661569798;
        bh=b7KoK/aFpP7ASqeDOUR62rCAOEsQs4JPDo58/4c3iiU=;
        h=Date:To:From:Subject:From;
        b=qhBRYJHLmxj809ZTyT7S5KKpu5tDrvHvVsJpZMt99cU8WyCg3VR4LLNhHTPQMVz+J
         Braq5tvR9nTFi9cpEd2KxvEc7bvuCKl7/t39iDcMgvRxVMuiH0Sjh4MkzWdrPbzWPe
         aKMdNGH/jsdz7xrY6RS+SV16bycwHH3x3LgKWsRQ=
Date:   Fri, 26 Aug 2022 20:09:57 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fail_function-fix-wrong-use-of-fei_attr_remove.patch added to mm-nonmm-unstable branch
Message-Id: <20220827030958.96B2AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fail_function: fix wrong use of fei_attr_remove()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fail_function-fix-wrong-use-of-fei_attr_remove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fail_function-fix-wrong-use-of-fei_attr_remove.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: fail_function: fix wrong use of fei_attr_remove()
Date: Fri, 26 Aug 2022 15:33:37 +0800

If register_kprobe() fails, the new attr is not added to the list yet, so
it should call fei_attr_free() intstead.

Link: https://lkml.kernel.org/r/20220826073337.2085798-3-yangyingliang@huawei.com
Fixes: 4b1a29a7f542 ("error-injection: Support fault injection framework")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fail_function.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fail_function.c~fail_function-fix-wrong-use-of-fei_attr_remove
+++ a/kernel/fail_function.c
@@ -295,7 +295,7 @@ static ssize_t fei_write(struct file *fi
 
 	ret = register_kprobe(&attr->kp);
 	if (ret) {
-		fei_attr_remove(attr);
+		fei_attr_free(attr);
 		goto out;
 	}
 	fei_debugfs_add_attr(attr);
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

nommu-remove-uses-of-vma-linked-list-fix.patch
fail_function-switch-to-memdup_user_nul-helper.patch
fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch
fail_function-fix-wrong-use-of-fei_attr_remove.patch


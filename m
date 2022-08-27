Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2147CECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiH0DKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242913AbiH0DJ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:09:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE98F585
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58A9E61DC9
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6603C433C1;
        Sat, 27 Aug 2022 03:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661569796;
        bh=FL0yr1fUC6LzuOgAJYzpNNp0wpqA7MmPbfYsamb7y7I=;
        h=Date:To:From:Subject:From;
        b=pHyrHMrJ0KSx8hwxHAuRFA3CJQXdpHHPdMHjopArh3FGq9HxIMQkRyeKpxGHpHbf0
         4RamJH2LgRZP7s5RPSijOoDxLE8s3VPBdSQl/42b9p6IZo12gppXjPpJFe1es2N/Py
         7BmR06yT6E1FedxPSLHoZqYfmedaROMv0u0fGnVg=
Date:   Fri, 26 Aug 2022 20:09:55 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch added to mm-nonmm-unstable branch
Message-Id: <20220827030956.A6603C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fail_function: refctor code of checking return value of register_kprobe()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch

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
Subject: fail_function: refctor code of checking return value of register_kprobe()
Date: Fri, 26 Aug 2022 15:33:36 +0800

Refactor the error handling of register_kprobe() to improve readability. 
No functional change.

Link: https://lkml.kernel.org/r/20220826073337.2085798-2-yangyingliang@huawei.com
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fail_function.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/fail_function.c~fail_function-refctor-code-of-checking-return-value-of-register_kprobe
+++ a/kernel/fail_function.c
@@ -294,14 +294,13 @@ static ssize_t fei_write(struct file *fi
 	}
 
 	ret = register_kprobe(&attr->kp);
-	if (!ret)
-		fei_debugfs_add_attr(attr);
-	if (ret < 0)
+	if (ret) {
 		fei_attr_remove(attr);
-	else {
-		list_add_tail(&attr->list, &fei_attr_list);
-		ret = count;
+		goto out;
 	}
+	fei_debugfs_add_attr(attr);
+	list_add_tail(&attr->list, &fei_attr_list);
+	ret = count;
 out:
 	mutex_unlock(&fei_lock);
 	kfree(buf);
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

nommu-remove-uses-of-vma-linked-list-fix.patch
fail_function-switch-to-memdup_user_nul-helper.patch
fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch
fail_function-fix-wrong-use-of-fei_attr_remove.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D66ECAAD4
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344843AbiH0DKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiH0DJ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:09:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7226AF581
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29D20B83387
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF93AC433D6;
        Sat, 27 Aug 2022 03:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661569794;
        bh=6FSFfEYbjD7UwVN6M3DDxqXh1GCMptipd303jOOLxrE=;
        h=Date:To:From:Subject:From;
        b=AHa1G14JGo4msWcdFGCgmqqoITJLKR5eF2Jd3cvNpMdOLFV8YivziZtCJ0vuWY/VR
         RLVfVKDJP5vi1ISLFqPaFzy8oFtk3lIEbQIM45iujvseo/RfHlpa40zpbniki4og5y
         KJfIq24zDl0Qhq0kiTR4neBO/7L9K2DzynAsB+UU=
Date:   Fri, 26 Aug 2022 20:09:53 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fail_function-switch-to-memdup_user_nul-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20220827030954.AF93AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fail_function: switch to memdup_user_nul() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fail_function-switch-to-memdup_user_nul-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fail_function-switch-to-memdup_user_nul-helper.patch

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
Subject: fail_function: switch to memdup_user_nul() helper
Date: Fri, 26 Aug 2022 15:33:35 +0800

Use memdup_user_nul() helper instead of open-coding to simplify the code.

Link: https://lkml.kernel.org/r/20220826073337.2085798-1-yangyingliang@huawei.com
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fail_function.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/kernel/fail_function.c~fail_function-switch-to-memdup_user_nul-helper
+++ a/kernel/fail_function.c
@@ -247,15 +247,11 @@ static ssize_t fei_write(struct file *fi
 	/* cut off if it is too long */
 	if (count > KSYM_NAME_LEN)
 		count = KSYM_NAME_LEN;
-	buf = kmalloc(count + 1, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, buffer, count)) {
-		ret = -EFAULT;
-		goto out_free;
-	}
-	buf[count] = '\0';
+
+	buf = memdup_user_nul(buffer, count);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
 	sym = strstrip(buf);
 
 	mutex_lock(&fei_lock);
@@ -308,7 +304,6 @@ static ssize_t fei_write(struct file *fi
 	}
 out:
 	mutex_unlock(&fei_lock);
-out_free:
 	kfree(buf);
 	return ret;
 }
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

nommu-remove-uses-of-vma-linked-list-fix.patch
fail_function-switch-to-memdup_user_nul-helper.patch
fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch
fail_function-fix-wrong-use-of-fei_attr_remove.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042BCC6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiILE6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiILE5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3D6220F9
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FFE9B80B21
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF58C433D6;
        Mon, 12 Sep 2022 04:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958614;
        bh=iIu8FGuaoQvgM/DkvMhs+bIxdsfd2JFqAioOKsk0ZK8=;
        h=Date:To:From:Subject:From;
        b=kmYH4LMSpfdzRvkVMVhQBxKZjaiNeDBc2h2oHOYXxfcpzhU9c2+ncO9aTC9Zmwzb0
         FThD+Am6igZN3GAQwugqwh8sqgRG6n4se/qiWSQ0M7gykDHjdSCGycnbDurAm0+f7+
         WZslygzWLZpAFkE72BJnUvRkfU+au8McvNRaYH50=
Date:   Sun, 11 Sep 2022 21:56:53 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fail_function-switch-to-memdup_user_nul-helper.patch removed from -mm tree
Message-Id: <20220912045654.2CF58C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fail_function: switch to memdup_user_nul() helper
has been removed from the -mm tree.  Its filename was
     fail_function-switch-to-memdup_user_nul-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



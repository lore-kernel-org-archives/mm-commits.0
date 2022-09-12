Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B319ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiILE6L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiILE5B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F6A2870D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91EC6B80B9F
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45604C433D7;
        Mon, 12 Sep 2022 04:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958615;
        bh=fTy/CZAammYJ9vYrP01cTUKstEYQry2cb5uIigrdUnA=;
        h=Date:To:From:Subject:From;
        b=wJ2/BnNoEj5JtzyRtZr5YEtXN8it5AfIIGrrh28odCx8Jk6xNTPFfisPX764X5Yix
         nKuc7MvUn1YF1YtzLFqhv3RYzz0+1blf3JFeIsLYMj5wLapfNumFQU4feGI8cYJAHs
         9ECfVG4M3MJjy6q1era0S9ln6dI+O1YQwa/J52Ww=
Date:   Sun, 11 Sep 2022 21:56:54 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch removed from -mm tree
Message-Id: <20220912045655.45604C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fail_function: refactor code of checking return value of register_kprobe()
has been removed from the -mm tree.  Its filename was
     fail_function-refctor-code-of-checking-return-value-of-register_kprobe.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: fail_function: refactor code of checking return value of register_kprobe()
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



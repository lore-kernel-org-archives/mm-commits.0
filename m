Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63A2ECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiILE6B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiILE5B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44E627DDF
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3719060CFA
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ADDC433D6;
        Mon, 12 Sep 2022 04:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958616;
        bh=qyfr1GiIk2L0TzB9pl8LtqyREMrQ5va87oFerPiHUqw=;
        h=Date:To:From:Subject:From;
        b=j4AEKJBMh9OznPBbUSPgB1w1/Lkw5Y1wWlUzrBehNFXFZ+tiDLz8BFDHtmjW6ny+L
         kmkVJAHbmuuHFAQkCSQK0OAX470oy1bIAnANeAZvneMgW1R38RYOa7KVEOEJkPX0eS
         ZUW3qqFHV+XI9EdIoW5XdOEI5Z6WLH+z2s02DL5I=
Date:   Sun, 11 Sep 2022 21:56:55 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fail_function-fix-wrong-use-of-fei_attr_remove.patch removed from -mm tree
Message-Id: <20220912045656.92ADDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fail_function: fix wrong use of fei_attr_remove()
has been removed from the -mm tree.  Its filename was
     fail_function-fix-wrong-use-of-fei_attr_remove.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



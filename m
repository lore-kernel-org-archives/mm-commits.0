Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C011C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C91160F38
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhGWWJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 18:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhGWWJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89FDC60F37;
        Fri, 23 Jul 2021 22:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080608;
        bh=dx1gV6KM0pdOuySOLjDluTLHL5+kDMKfQTL8YS6y57M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=skA9qDzL8pCQXfK7RBxPbcYEJfHTlcZ+nbryDskDWJE8StNo9BVoU041ZHMfighBZ
         bvIT+qHxokLRqydlI0yeYCDsR5ZtWjDbtiIROUeZvERRn9ZA0WuEjc7kmLXRE91Ru5
         16H89bqkvsT9vOLJFTtOSMWbv+4rjGju5BhzQ9hM=
Date:   Fri, 23 Jul 2021 15:50:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        o451686892@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 03/15] kfence: defer kfence_test_init to ensure
 that kunit debugfs is created
Message-ID: <20210723225008.moMYwrxvY%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Weizhao Ouyang <o451686892@gmail.com>
Subject: kfence: defer kfence_test_init to ensure that kunit debugfs is created

kfence_test_init and kunit_init both use the same level late_initcall,
which means if kfence_test_init linked ahead of kunit_init,
kfence_test_init will get a NULL debugfs_rootdir as parent dentry, then
kfence_test_init and kfence_debugfs_init both create a debugfs node named
"kfence" under debugfs_mount->mnt_root, and it will throw out "debugfs:
Directory 'kfence' with parent '/' already present!" with EEXIST.  So
kfence_test_init should be deferred.

Link: https://lkml.kernel.org/r/20210714113140.2949995-1-o451686892@gmail.com
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/kfence_test.c~kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created
+++ a/mm/kfence/kfence_test.c
@@ -852,7 +852,7 @@ static void kfence_test_exit(void)
 	tracepoint_synchronize_unregister();
 }
 
-late_initcall(kfence_test_init);
+late_initcall_sync(kfence_test_init);
 module_exit(kfence_test_exit);
 
 MODULE_LICENSE("GPL v2");
_

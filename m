Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78742C4320A
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5593B60FBF
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhG0TfK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhG0TfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AAEB60C51;
        Tue, 27 Jul 2021 19:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414506;
        bh=Jjk500yvmOpkJxg9v8T26GL9J9pp2P6XxkTXx0yMGj4=;
        h=Date:From:To:Subject:From;
        b=K6kN1intle3U7zyj5WqhZZSjR67UpI3bzwuTZAWD3hAVK5X76xjjOUz9piEdUSm0z
         xZuSnqF0C6NapO4wkOPIOKlTwFRvItBKqFIQdEyw04NFTjc06kZibemVYAqdC9XBMz
         UWcJtpyduXqjYGgXZFmJHGGiVopImeqRiBbzKLPk=
Date:   Tue, 27 Jul 2021 12:35:06 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, o451686892@gmail.com
Subject:  [merged]
 kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created.patch
 removed from -mm tree
Message-ID: <20210727193506.8RpMO190y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: defer kfence_test_init to ensure that kunit debugfs is created
has been removed from the -mm tree.  Its filename was
     kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from o451686892@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBB3C12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D6C5613CB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhGNWkq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhGNWkp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 18:40:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9978613C2;
        Wed, 14 Jul 2021 22:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626302272;
        bh=ij1P2uNm1F/md0DJ78CDLWea66AsipZMMRaZmoMm9l8=;
        h=Date:From:To:Subject:From;
        b=KvyrCg9/MeXZB5JgjeaSKSPAeRcMacIOEg5cCpwkal7/uj6XxgsBez1Hpc7v4QCLW
         LQOB5IkNjy9kqc9r3oi7ytYae0A6k83H7paIigZNYlp0HxiL7JrsO16UwPgpCTbFq6
         WpD1n0rzob3tEdLzzs+UXlR/jWCpdo2+2xKw+fLY=
Date:   Wed, 14 Jul 2021 15:37:52 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, o451686892@gmail.com
Subject:  +
 kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created.patch
 added to -mm tree
Message-ID: <20210714223752.8SuCBLrQt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: defer kfence_test_init to ensure that kunit debugfs is created
has been added to the -mm tree.  Its filename is
     kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexander Potapenko <glider@google.com
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

kfence-defer-kfence_test_init-to-ensure-that-kunit-debugfs-is-created.patch


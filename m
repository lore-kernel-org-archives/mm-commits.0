Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FFCC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbiDYWdF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiDYWc4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 18:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6E76593
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 15:29:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52A9E61551
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 22:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAE7C385A7;
        Mon, 25 Apr 2022 22:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650925765;
        bh=h91eRus3yPsgYXrIYd4Ub1CtiNiwPuDm5HoG/84li9k=;
        h=Date:To:From:Subject:From;
        b=riGvzmzSanBxQ2Tp7NVH7yihUobbCy74/Vv9vfZFFsugthEaQA3uIN/rFdD6W+ogB
         ObH2C5GLYh49P9uQ9cBiERwGiaqCM7E1oocQQbXQWb4NApUz0LBaxRj58fqIg1CtGG
         K6jsljdCwLKTlaCoF0iCAy6WZJYU8m+l5Cowxmuo=
Date:   Mon, 25 Apr 2022 15:29:25 -0700
To:     mm-commits@vger.kernel.org, zhongjubin@huawei.com,
        wangbing6@huawei.com, nixiaoming@huawei.com,
        huangshaobo6@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, chenzefeng2@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch added to -mm tree
Message-Id: <20220425222925.AAAE7C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix
has been added to the -mm tree.  Its filename is
     kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix

add __read_mostly, per Marco

Cc: Alexander Potapenko <glider@google.com>
Cc: chenzefeng <chenzefeng2@huawei.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: huangshaobo <huangshaobo6@huawei.com>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Marco Elver <elver@google.com>
Cc: Wangbing <wangbing6@huawei.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix
+++ a/mm/kfence/core.c
@@ -102,7 +102,7 @@ static bool kfence_deferrable __read_mos
 module_param_named(deferrable, kfence_deferrable, bool, 0444);
 
 /* If true, check all canary bytes on panic. */
-static bool kfence_check_on_panic;
+static bool kfence_check_on_panic __read_mostly;
 module_param_named(check_on_panic, kfence_check_on_panic, bool, 0444);
 
 /* The pool of pages used for guard pages and objects. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


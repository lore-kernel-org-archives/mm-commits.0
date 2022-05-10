Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F2EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 01:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiEJBJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 21:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiEJBJ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 21:09:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E4C2992D2
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 18:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 794B16159A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 01:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC72BC385C2;
        Tue, 10 May 2022 01:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652144724;
        bh=/FoQOmNyqySzVsP2Ej95QQHarWSw43L+a6rmNaYmFMs=;
        h=Date:To:From:Subject:From;
        b=hwLK60CkS8S4J6BE3NS4Ad+ZtApIb1SmU7UnKdBfDpTtwlT9hQ2099wzt+ZIVoouA
         T2ulJ31a+4/cP6WvW1R9ZloSaJHbN63nBbCUwvxt4l83fj30W+VxSc8WJyt8SI9FGb
         iu2jwcoHH5DggHy+XbuuICw3Kqusq/BlMISwX3Nw=
Date:   Mon, 09 May 2022 18:05:24 -0700
To:     mm-commits@vger.kernel.org, zhongjubin@huawei.com,
        wangbing6@huawei.com, nixiaoming@huawei.com,
        huangshaobo6@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, chenzefeng2@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch removed from -mm tree
Message-Id: <20220510010524.CC72BC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix
has been removed from the -mm tree.  Its filename was
     kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch

This patch was dropped because it was folded into kfence-enable-check-kfence-canary-on-panic-via-boot-param.patch

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

mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


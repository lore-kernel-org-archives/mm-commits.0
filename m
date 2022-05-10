Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9B6C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiEJEWI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiEJEUe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1D42AD773
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 892F06176C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE237C385A6;
        Tue, 10 May 2022 04:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156128;
        bh=vvxghYXCLrH4IKI3D5jZiwkL0RW7gnJNeLR/cgjhj6U=;
        h=Date:To:From:Subject:From;
        b=bsZm4t44h4rECxuOLsOPTr+lHXgJpZoAB8Wh8dHMzREeUYiGW5EWiWwwGGLjdyqZU
         piyhFc95Iwnrk4tcTEWjiMDbGZjDJKVoGnmZKofm83lcwDO0oTZUTOSmQdKDjarlnx
         /3amYxjIt7pkJPev/I0uW6je1txVEejjbBwmgcqQ=
Date:   Mon, 09 May 2022 21:15:27 -0700
To:     mm-commits@vger.kernel.org, zhongjubin@huawei.com,
        wangbing6@huawei.com, nixiaoming@huawei.com, glider@google.com,
        elver@google.com, dvyukov@google.com, chenzefeng2@huawei.com,
        huangshaobo6@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kfence-enable-check-kfence-canary-on-panic-via-boot-param.patch removed from -mm tree
Message-Id: <20220510041527.DE237C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kfence: enable check kfence canary on panic via boot param
has been removed from the -mm tree.  Its filename was
     kfence-enable-check-kfence-canary-on-panic-via-boot-param.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: huangshaobo <huangshaobo6@huawei.com>
Subject: kfence: enable check kfence canary on panic via boot param

Out-of-bounds accesses that aren't caught by a guard page will result in
corruption of canary memory.  In pathological cases, where an object has
certain alignment requirements, an out-of-bounds access might never be
caught by the guard page.  Such corruptions, however, are only detected on
kfree() normally.  If the bug causes the kernel to panic before kfree(),
KFENCE has no opportunity to report the issue.  Such corruptions may also
indicate failing memory or other faults.

To provide some more information in such cases, add the option to check
canary bytes on panic.  This might help narrow the search for the panic
cause; but, due to only having the allocation stack trace, such reports
are difficult to use to diagnose an issue alone.  In most cases, such
reports are inactionable, and is therefore an opt-in feature (disabled by
default).

[akpm@linux-foundation.org: add __read_mostly, per Marco]
Link: https://lkml.kernel.org/r/20220425022456.44300-1-huangshaobo6@huawei.com
Signed-off-by: huangshaobo <huangshaobo6@huawei.com>
Suggested-by: chenzefeng <chenzefeng2@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Wangbing <wangbing6@huawei.com>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/mm/kfence/core.c~kfence-enable-check-kfence-canary-on-panic-via-boot-param
+++ a/mm/kfence/core.c
@@ -21,6 +21,8 @@
 #include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/clock.h>
@@ -99,6 +101,10 @@ module_param_named(skip_covered_thresh,
 static bool kfence_deferrable __read_mostly = IS_ENABLED(CONFIG_KFENCE_DEFERRABLE);
 module_param_named(deferrable, kfence_deferrable, bool, 0444);
 
+/* If true, check all canary bytes on panic. */
+static bool kfence_check_on_panic __read_mostly;
+module_param_named(check_on_panic, kfence_check_on_panic, bool, 0444);
+
 /* The pool of pages used for guard pages and objects. */
 char *__kfence_pool __read_mostly;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
@@ -727,6 +733,31 @@ static int __init kfence_debugfs_init(vo
 
 late_initcall(kfence_debugfs_init);
 
+/* === Panic Notifier ====================================================== */
+
+static void kfence_check_all_canary(void)
+{
+	int i;
+
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		struct kfence_metadata *meta = &kfence_metadata[i];
+
+		if (meta->state == KFENCE_OBJECT_ALLOCATED)
+			for_each_canary(meta, check_canary_byte);
+	}
+}
+
+static int kfence_check_canary_callback(struct notifier_block *nb,
+					unsigned long reason, void *arg)
+{
+	kfence_check_all_canary();
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kfence_check_canary_notifier = {
+	.notifier_call = kfence_check_canary_callback,
+};
+
 /* === Allocation Gate Timer ================================================ */
 
 static struct delayed_work kfence_timer;
@@ -804,6 +835,9 @@ static void kfence_init_enable(void)
 	else
 		INIT_DELAYED_WORK(&kfence_timer, toggle_allocation_gate);
 
+	if (kfence_check_on_panic)
+		atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
+
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 
_

Patches currently in -mm which might be from huangshaobo6@huawei.com are



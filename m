Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CA7C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08D1206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027156;
	bh=sG2AcN7sXWTfN0k4pIFV5eCnsXi8zRyxpTM+liepA1Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uRGf8lG5ErefIfmNMUluQ/amLwCIrEXvpnZ+/pQ/pV0MhS7ArPTg84dkt9dJMtlw0
	 /sszHvYMLJpSwSIEPBFrJMuzlVHezqjYVNR5HhTCN/LcZsdSyJG3scacVkYRQ7gDmB
	 yCuzy/ytSBzOZSJr1mGlM9LAVn9lPBheYWHgJn28=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHJCjQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCjQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E18B2065D;
        Mon, 10 Aug 2020 02:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027155;
        bh=sG2AcN7sXWTfN0k4pIFV5eCnsXi8zRyxpTM+liepA1Y=;
        h=Date:From:To:Subject:From;
        b=xlmAeKRp7DrWb+7V81CUadvLOlvAdrDxrar/AlhW2FK5p4KZ7MvrzTqKGTAfywDCX
         x1W28GOnuJK2wf5YrF3pUrhd9WRpCvUUIEG5BmA9Q2/5AThRgU02SqYZpa+jNrW9sj
         wTCXGDADn7rQQ7/Rsg4FcISDr6VTj51asotanxhM=
Date:   Sun, 09 Aug 2020 19:39:15 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, glider@google.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-add-tests-for-call_rcu-stack-recording.patch removed from -mm tree
Message-ID: <20200810023915.zERsquVMq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add tests for call_rcu stack recording
has been removed from the -mm tree.  Its filename was
     kasan-add-tests-for-call_rcu-stack-recording.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: add tests for call_rcu stack recording

Test call_rcu() call stack recording and verify whether it correctly is
printed in KASAN report.

Link: http://lkml.kernel.org/r/20200601051045.1294-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/lib/test_kasan.c~kasan-add-tests-for-call_rcu-stack-recording
+++ a/lib/test_kasan.c
@@ -801,6 +801,35 @@ static noinline void __init vmalloc_oob(
 static void __init vmalloc_oob(void) {}
 #endif
 
+static struct kasan_rcu_info {
+	int i;
+	struct rcu_head rcu;
+} *global_rcu_ptr;
+
+static noinline void __init kasan_rcu_reclaim(struct rcu_head *rp)
+{
+	struct kasan_rcu_info *fp = container_of(rp,
+						struct kasan_rcu_info, rcu);
+
+	kfree(fp);
+	fp->i = 1;
+}
+
+static noinline void __init kasan_rcu_uaf(void)
+{
+	struct kasan_rcu_info *ptr;
+
+	pr_info("use-after-free in kasan_rcu_reclaim\n");
+	ptr = kmalloc(sizeof(struct kasan_rcu_info), GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	global_rcu_ptr = rcu_dereference_protected(ptr, NULL);
+	call_rcu(&global_rcu_ptr->rcu, kasan_rcu_reclaim);
+}
+
 static int __init kmalloc_tests_init(void)
 {
 	/*
@@ -848,6 +877,7 @@ static int __init kmalloc_tests_init(voi
 	kasan_bitops();
 	kmalloc_double_kzfree();
 	vmalloc_oob();
+	kasan_rcu_uaf();
 
 	kasan_restore_multi_shot(multishot);
 
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are



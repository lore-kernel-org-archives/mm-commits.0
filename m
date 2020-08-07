Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D22AC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4723722CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781485;
	bh=NEWTFKbeXMs6X35eaBwhoU6LJS6a/ZSjHevVS+cNwE4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GrJ7wLi+i/RH+XbprLXjjfhg2kDdgIU5C693vLufTeAqHc6lFkGTr19hOcQ1/X/en
	 OIpx62+v4M3kbXSpP16Lw0feWDkIk91dzYXQQf62GO/cTuOF7bro7l32GEtm4UpfHk
	 ZD7ySpx7f8qy9hcvrEyUmeGM46BhEdz8j/q2VwCM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGYp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGYo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B80F221E5;
        Fri,  7 Aug 2020 06:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781484;
        bh=NEWTFKbeXMs6X35eaBwhoU6LJS6a/ZSjHevVS+cNwE4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oS7eQESWW7FpnQKS2eZVw+VJfSnfLa9BtJGCfg+ppHqHjgZ7evddbyVWzLsepMNt6
         ngjCbzLazeCGO4fiOow0l6s4J5JQTc7XVtbFMNG8dsDwqwfqT4ble7eGqDr8CqPfAh
         7mQN7lTyHQGS2q0ZVp4BT1erts+ZIIYWjsoSEhOk=
Date:   Thu, 06 Aug 2020 23:24:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com,
        glider@google.com, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject:  [patch 132/163] kasan: add tests for call_rcu stack
 recording
Message-ID: <20200807062442.wgksHZUL3%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

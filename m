Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42834C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbjHKW7J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbjHKW6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66782268C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F00CB6738D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D60C433C8;
        Fri, 11 Aug 2023 22:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794733;
        bh=fK0bp/ZYV3dSx7m+vMmZaWBSeVo1Poifg+i+1uGDMhc=;
        h=Date:To:From:Subject:From;
        b=BDRYiVRwSenCce3SAMSxwIcAZn9UZd9GkKJkXXDZPCbfdjlzHUOs7x5tfmq4b4lJc
         FeEhwomujg5YptX7cUp8OYiwi21CwJQSlcKbAlZ43G61OYeq1M2a0s4McF9B/QfVz1
         jugU8VIdjHUtjFpjmD8dEqdiuoK+FwwTPGabAtAQ=
Date:   Fri, 11 Aug 2023 15:58:52 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-test-for-expanding-range-in-rcu-mode.patch removed from -mm tree
Message-Id: <20230811225853.52D60C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add test for expanding range in RCU mode
has been removed from the -mm tree.  Its filename was
     maple_tree-add-test-for-expanding-range-in-rcu-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: add test for expanding range in RCU mode
Date: Wed, 28 Jun 2023 15:36:55 +0800

Add test for expanding range in RCU mode. If we use the fast path of the
slot store to expand range in RCU mode, this test will fail.

Link: https://lkml.kernel.org/r/20230628073657.75314-3-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   75 +++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-add-test-for-expanding-range-in-rcu-mode
+++ a/tools/testing/radix-tree/maple.c
@@ -45,6 +45,13 @@ struct rcu_test_struct2 {
 	unsigned long last[RCU_RANGE_COUNT];
 };
 
+struct rcu_test_struct3 {
+	struct maple_tree *mt;
+	unsigned long index;
+	unsigned long last;
+	bool stop;
+};
+
 struct rcu_reader_struct {
 	unsigned int id;
 	int mod;
@@ -34954,6 +34961,70 @@ void run_check_rcu(struct maple_tree *mt
 	MT_BUG_ON(mt, !vals->seen_entry2);
 }
 
+static void *rcu_slot_store_reader(void *ptr)
+{
+	struct rcu_test_struct3 *test = ptr;
+	MA_STATE(mas, test->mt, test->index, test->index);
+
+	rcu_register_thread();
+
+	rcu_read_lock();
+	while (!test->stop) {
+		mas_walk(&mas);
+		/* The length of growth to both sides must be equal. */
+		RCU_MT_BUG_ON(test, (test->index - mas.index) !=
+				    (mas.last - test->last));
+	}
+	rcu_read_unlock();
+
+	rcu_unregister_thread();
+	return NULL;
+}
+
+static noinline void run_check_rcu_slot_store(struct maple_tree *mt)
+{
+	pthread_t readers[20];
+	int range_cnt = 200, i, limit = 10000;
+	unsigned long len = ULONG_MAX / range_cnt, start, end;
+	struct rcu_test_struct3 test = {.stop = false, .mt = mt};
+
+	start = range_cnt / 2 * len;
+	end = start + len - 1;
+	test.index = start;
+	test.last = end;
+
+	for (i = 0; i < range_cnt; i++) {
+		mtree_store_range(mt, i * len, i * len + len - 1,
+				  xa_mk_value(i * 100), GFP_KERNEL);
+	}
+
+	mt_set_in_rcu(mt);
+	MT_BUG_ON(mt, !mt_in_rcu(mt));
+
+	for (i = 0; i < ARRAY_SIZE(readers); i++) {
+		if (pthread_create(&readers[i], NULL, rcu_slot_store_reader,
+				   &test)) {
+			perror("creating reader thread");
+			exit(1);
+		}
+	}
+
+	usleep(5);
+
+	while (limit--) {
+		/* Step by step, expand the most middle range to both sides. */
+		mtree_store_range(mt, --start, ++end, xa_mk_value(100),
+				  GFP_KERNEL);
+	}
+
+	test.stop = true;
+
+	while (i--)
+		pthread_join(readers[i], NULL);
+
+	mt_validate(mt);
+}
+
 static noinline
 void run_check_rcu_slowread(struct maple_tree *mt, struct rcu_test_struct *vals)
 {
@@ -35206,6 +35277,10 @@ static noinline void __init check_rcu_th
 	run_check_rcu(mt, &vals);
 	mtree_destroy(mt);
 
+	/* Check expanding range in RCU mode */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	run_check_rcu_slot_store(mt);
+	mtree_destroy(mt);
 
 	/* Forward writer for rcu stress */
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are



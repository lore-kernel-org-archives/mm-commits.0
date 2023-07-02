Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF23EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 22:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjGBWdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 18:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjGBWdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 18:33:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C91AE6E
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 15:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 564A360C75
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 22:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD443C433C8;
        Sun,  2 Jul 2023 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688337213;
        bh=SEsEQkEGavyg8cjFJBwqcFXbstSiGs0vlJHQXlNf+/A=;
        h=Date:To:From:Subject:From;
        b=tebvhrHCwGkdl+TLaPA49OJW4I5pIxkRX33GPP1G6eGoce3W0MFqUTNOMUyH+lyLX
         3AUEOGtpTsf8VL0ShZglAsJsrxn2Fw2YWuFKCOcqPFf1k6Rqqs3De6Yh2v2D+iIeav
         lYDemo6p4vvSrZnPahFqprM9VTnmpbkuJ5kNiamg=
Date:   Sun, 02 Jul 2023 15:33:33 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-test-for-expanding-range-in-rcu-mode.patch added to mm-unstable branch
Message-Id: <20230702223333.AD443C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add test for expanding range in RCU mode
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-test-for-expanding-range-in-rcu-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-test-for-expanding-range-in-rcu-mode.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

maple_tree-add-test-for-mas_wr_modify-fast-path.patch
maple_tree-add-test-for-expanding-range-in-rcu-mode.patch
maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch
maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch


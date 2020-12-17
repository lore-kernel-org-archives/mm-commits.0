Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F82BC2BBCF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25ED423A51
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgLQXDP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 18:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731489AbgLQXDP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 18:03:15 -0500
Date:   Thu, 17 Dec 2020 15:02:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608246153;
        bh=hvnhB40ezg2ROzclfnxtN1gIhU4OJ+pmbaXFPKbtjkU=;
        h=From:To:Subject:From;
        b=UtJdGue9eN+JoHYeDmWXUWiKoL7AJf/w976N3Zy6b3YNjGz7tA9NTqllky8SvdwLa
         RUWl7MZER8cduVAOEvZzPOvht077eQjqT0rPBLPDlS0mYSWDkJgmlrkTCbfkz9gw9u
         +Wkijbk/OjEHCZohLiNXUsJ6CET7E9hbOjH24UaM=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitor@massaru.org,
        skhan@linuxfoundation.org, matti.vaittinen@fi.rohmeurope.com,
        davidgow@google.com, broonie@kernel.org, brendanhiggins@google.com,
        andriy.shevchenko@linux.intel.com
Subject:  [to-be-updated]
 lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch removed
 from -mm tree
Message-ID: <20201217230232.e1eXk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bits_kunit: follow new file name convention for KUnit tests
has been removed from the -mm tree.  Its filename was
     lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/bits_kunit: follow new file name convention for KUnit tests

Follow new file name convention for the KUnit tests.  Since we have
lib/*test*.c in a few variations, use 'kunit' suffix to distinguish usual
test cases with KUnit-based ones.

Link: https://lkml.kernel.org/r/20201112180732.75589-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: David Gow <davidgow@google.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile     |    2 
 lib/bits_kunit.c |   75 ++++
 lib/list-test.c  |  748 ---------------------------------------------
 lib/list_kunit.c |  748 +++++++++++++++++++++++++++++++++++++++++++++
 lib/test_bits.c  |   75 ----
 5 files changed, 824 insertions(+), 824 deletions(-)

--- /dev/null
+++ a/lib/bits_kunit.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Test cases for functions and macros in bits.h
+ */
+
+#include <kunit/test.h>
+#include <linux/bits.h>
+
+
+static void genmask_test(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, 1ul, GENMASK(0, 0));
+	KUNIT_EXPECT_EQ(test, 3ul, GENMASK(1, 0));
+	KUNIT_EXPECT_EQ(test, 6ul, GENMASK(2, 1));
+	KUNIT_EXPECT_EQ(test, 0xFFFFFFFFul, GENMASK(31, 0));
+
+#ifdef TEST_GENMASK_FAILURES
+	/* these should fail compilation */
+	GENMASK(0, 1);
+	GENMASK(0, 10);
+	GENMASK(9, 10);
+#endif
+
+
+}
+
+static void genmask_ull_test(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, 1ull, GENMASK_ULL(0, 0));
+	KUNIT_EXPECT_EQ(test, 3ull, GENMASK_ULL(1, 0));
+	KUNIT_EXPECT_EQ(test, 0x000000ffffe00000ull, GENMASK_ULL(39, 21));
+	KUNIT_EXPECT_EQ(test, 0xffffffffffffffffull, GENMASK_ULL(63, 0));
+
+#ifdef TEST_GENMASK_FAILURES
+	/* these should fail compilation */
+	GENMASK_ULL(0, 1);
+	GENMASK_ULL(0, 10);
+	GENMASK_ULL(9, 10);
+#endif
+}
+
+static void genmask_input_check_test(struct kunit *test)
+{
+	unsigned int x, y;
+	int z, w;
+
+	/* Unknown input */
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(x, 0));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(0, x));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(x, y));
+
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(z, 0));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(0, z));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(z, w));
+
+	/* Valid input */
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(1, 1));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(39, 21));
+}
+
+
+static struct kunit_case bits_test_cases[] = {
+	KUNIT_CASE(genmask_test),
+	KUNIT_CASE(genmask_ull_test),
+	KUNIT_CASE(genmask_input_check_test),
+	{}
+};
+
+static struct kunit_suite bits_test_suite = {
+	.name = "bits-test",
+	.test_cases = bits_test_cases,
+};
+kunit_test_suite(bits_test_suite);
+
+MODULE_LICENSE("GPL");
--- /dev/null
+++ a/lib/list_kunit.c
@@ -0,0 +1,748 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit test for the Kernel Linked-list structures.
+ *
+ * Copyright (C) 2019, Google LLC.
+ * Author: David Gow <davidgow@google.com>
+ */
+#include <kunit/test.h>
+
+#include <linux/list.h>
+
+struct list_test_struct {
+	int data;
+	struct list_head list;
+};
+
+static void list_test_list_init(struct kunit *test)
+{
+	/* Test the different ways of initialising a list. */
+	struct list_head list1 = LIST_HEAD_INIT(list1);
+	struct list_head list2;
+	LIST_HEAD(list3);
+	struct list_head *list4;
+	struct list_head *list5;
+
+	INIT_LIST_HEAD(&list2);
+
+	list4 = kzalloc(sizeof(*list4), GFP_KERNEL | __GFP_NOFAIL);
+	INIT_LIST_HEAD(list4);
+
+	list5 = kmalloc(sizeof(*list5), GFP_KERNEL | __GFP_NOFAIL);
+	memset(list5, 0xFF, sizeof(*list5));
+	INIT_LIST_HEAD(list5);
+
+	/* list_empty_careful() checks both next and prev. */
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list1));
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list3));
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(list4));
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(list5));
+
+	kfree(list4);
+	kfree(list5);
+}
+
+static void list_test_list_add(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add(&a, &list);
+	list_add(&b, &list);
+
+	/* should be [list] -> b -> a */
+	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
+	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
+	KUNIT_EXPECT_PTR_EQ(test, b.next, &a);
+}
+
+static void list_test_list_add_tail(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+
+	/* should be [list] -> a -> b */
+	KUNIT_EXPECT_PTR_EQ(test, list.next, &a);
+	KUNIT_EXPECT_PTR_EQ(test, a.prev, &list);
+	KUNIT_EXPECT_PTR_EQ(test, a.next, &b);
+}
+
+static void list_test_list_del(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+
+	/* before: [list] -> a -> b */
+	list_del(&a);
+
+	/* now: [list] -> b */
+	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
+	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
+}
+
+static void list_test_list_replace(struct kunit *test)
+{
+	struct list_head a_old, a_new, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a_old, &list);
+	list_add_tail(&b, &list);
+
+	/* before: [list] -> a_old -> b */
+	list_replace(&a_old, &a_new);
+
+	/* now: [list] -> a_new -> b */
+	KUNIT_EXPECT_PTR_EQ(test, list.next, &a_new);
+	KUNIT_EXPECT_PTR_EQ(test, b.prev, &a_new);
+}
+
+static void list_test_list_replace_init(struct kunit *test)
+{
+	struct list_head a_old, a_new, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a_old, &list);
+	list_add_tail(&b, &list);
+
+	/* before: [list] -> a_old -> b */
+	list_replace_init(&a_old, &a_new);
+
+	/* now: [list] -> a_new -> b */
+	KUNIT_EXPECT_PTR_EQ(test, list.next, &a_new);
+	KUNIT_EXPECT_PTR_EQ(test, b.prev, &a_new);
+
+	/* check a_old is empty (initialized) */
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&a_old));
+}
+
+static void list_test_list_swap(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+
+	/* before: [list] -> a -> b */
+	list_swap(&a, &b);
+
+	/* after: [list] -> b -> a */
+	KUNIT_EXPECT_PTR_EQ(test, &b, list.next);
+	KUNIT_EXPECT_PTR_EQ(test, &a, list.prev);
+
+	KUNIT_EXPECT_PTR_EQ(test, &a, b.next);
+	KUNIT_EXPECT_PTR_EQ(test, &list, b.prev);
+
+	KUNIT_EXPECT_PTR_EQ(test, &list, a.next);
+	KUNIT_EXPECT_PTR_EQ(test, &b, a.prev);
+}
+
+static void list_test_list_del_init(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+
+	/* before: [list] -> a -> b */
+	list_del_init(&a);
+	/* after: [list] -> b, a initialised */
+
+	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
+	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&a));
+}
+
+static void list_test_list_move(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+
+	list_add_tail(&a, &list1);
+	list_add_tail(&b, &list2);
+
+	/* before: [list1] -> a, [list2] -> b */
+	list_move(&a, &list2);
+	/* after: [list1] empty, [list2] -> a -> b */
+
+	KUNIT_EXPECT_TRUE(test, list_empty(&list1));
+
+	KUNIT_EXPECT_PTR_EQ(test, &a, list2.next);
+	KUNIT_EXPECT_PTR_EQ(test, &b, a.next);
+}
+
+static void list_test_list_move_tail(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+
+	list_add_tail(&a, &list1);
+	list_add_tail(&b, &list2);
+
+	/* before: [list1] -> a, [list2] -> b */
+	list_move_tail(&a, &list2);
+	/* after: [list1] empty, [list2] -> b -> a */
+
+	KUNIT_EXPECT_TRUE(test, list_empty(&list1));
+
+	KUNIT_EXPECT_PTR_EQ(test, &b, list2.next);
+	KUNIT_EXPECT_PTR_EQ(test, &a, b.next);
+}
+
+static void list_test_list_bulk_move_tail(struct kunit *test)
+{
+	struct list_head a, b, c, d, x, y;
+	struct list_head *list1_values[] = { &x, &b, &c, &y };
+	struct list_head *list2_values[] = { &a, &d };
+	struct list_head *ptr;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+	int i = 0;
+
+	list_add_tail(&x, &list1);
+	list_add_tail(&y, &list1);
+
+	list_add_tail(&a, &list2);
+	list_add_tail(&b, &list2);
+	list_add_tail(&c, &list2);
+	list_add_tail(&d, &list2);
+
+	/* before: [list1] -> x -> y, [list2] -> a -> b -> c -> d */
+	list_bulk_move_tail(&y, &b, &c);
+	/* after: [list1] -> x -> b -> c -> y, [list2] -> a -> d */
+
+	list_for_each(ptr, &list1) {
+		KUNIT_EXPECT_PTR_EQ(test, ptr, list1_values[i]);
+		i++;
+	}
+	KUNIT_EXPECT_EQ(test, i, 4);
+	i = 0;
+	list_for_each(ptr, &list2) {
+		KUNIT_EXPECT_PTR_EQ(test, ptr, list2_values[i]);
+		i++;
+	}
+	KUNIT_EXPECT_EQ(test, i, 2);
+}
+
+static void list_test_list_is_first(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+
+	KUNIT_EXPECT_TRUE(test, list_is_first(&a, &list));
+	KUNIT_EXPECT_FALSE(test, list_is_first(&b, &list));
+}
+
+static void list_test_list_is_last(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+
+	KUNIT_EXPECT_FALSE(test, list_is_last(&a, &list));
+	KUNIT_EXPECT_TRUE(test, list_is_last(&b, &list));
+}
+
+static void list_test_list_empty(struct kunit *test)
+{
+	struct list_head a;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+
+	list_add_tail(&a, &list1);
+
+	KUNIT_EXPECT_FALSE(test, list_empty(&list1));
+	KUNIT_EXPECT_TRUE(test, list_empty(&list2));
+}
+
+static void list_test_list_empty_careful(struct kunit *test)
+{
+	/* This test doesn't check correctness under concurrent access */
+	struct list_head a;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+
+	list_add_tail(&a, &list1);
+
+	KUNIT_EXPECT_FALSE(test, list_empty_careful(&list1));
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
+}
+
+static void list_test_list_rotate_left(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+
+	/* before: [list] -> a -> b */
+	list_rotate_left(&list);
+	/* after: [list] -> b -> a */
+
+	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
+	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
+	KUNIT_EXPECT_PTR_EQ(test, b.next, &a);
+}
+
+static void list_test_list_rotate_to_front(struct kunit *test)
+{
+	struct list_head a, b, c, d;
+	struct list_head *list_values[] = { &c, &d, &a, &b };
+	struct list_head *ptr;
+	LIST_HEAD(list);
+	int i = 0;
+
+	list_add_tail(&a, &list);
+	list_add_tail(&b, &list);
+	list_add_tail(&c, &list);
+	list_add_tail(&d, &list);
+
+	/* before: [list] -> a -> b -> c -> d */
+	list_rotate_to_front(&c, &list);
+	/* after: [list] -> c -> d -> a -> b */
+
+	list_for_each(ptr, &list) {
+		KUNIT_EXPECT_PTR_EQ(test, ptr, list_values[i]);
+		i++;
+	}
+	KUNIT_EXPECT_EQ(test, i, 4);
+}
+
+static void list_test_list_is_singular(struct kunit *test)
+{
+	struct list_head a, b;
+	LIST_HEAD(list);
+
+	/* [list] empty */
+	KUNIT_EXPECT_FALSE(test, list_is_singular(&list));
+
+	list_add_tail(&a, &list);
+
+	/* [list] -> a */
+	KUNIT_EXPECT_TRUE(test, list_is_singular(&list));
+
+	list_add_tail(&b, &list);
+
+	/* [list] -> a -> b */
+	KUNIT_EXPECT_FALSE(test, list_is_singular(&list));
+}
+
+static void list_test_list_cut_position(struct kunit *test)
+{
+	struct list_head entries[3], *cur;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+	int i = 0;
+
+	list_add_tail(&entries[0], &list1);
+	list_add_tail(&entries[1], &list1);
+	list_add_tail(&entries[2], &list1);
+
+	/* before: [list1] -> entries[0] -> entries[1] -> entries[2] */
+	list_cut_position(&list2, &list1, &entries[1]);
+	/* after: [list2] -> entries[0] -> entries[1], [list1] -> entries[2] */
+
+	list_for_each(cur, &list2) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 2);
+
+	list_for_each(cur, &list1) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+}
+
+static void list_test_list_cut_before(struct kunit *test)
+{
+	struct list_head entries[3], *cur;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+	int i = 0;
+
+	list_add_tail(&entries[0], &list1);
+	list_add_tail(&entries[1], &list1);
+	list_add_tail(&entries[2], &list1);
+
+	/* before: [list1] -> entries[0] -> entries[1] -> entries[2] */
+	list_cut_before(&list2, &list1, &entries[1]);
+	/* after: [list2] -> entries[0], [list1] -> entries[1] -> entries[2] */
+
+	list_for_each(cur, &list2) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 1);
+
+	list_for_each(cur, &list1) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+}
+
+static void list_test_list_splice(struct kunit *test)
+{
+	struct list_head entries[5], *cur;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+	int i = 0;
+
+	list_add_tail(&entries[0], &list1);
+	list_add_tail(&entries[1], &list1);
+	list_add_tail(&entries[2], &list2);
+	list_add_tail(&entries[3], &list2);
+	list_add_tail(&entries[4], &list1);
+
+	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
+	list_splice(&list2, &entries[1]);
+	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] uninit */
+
+	list_for_each(cur, &list1) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 5);
+}
+
+static void list_test_list_splice_tail(struct kunit *test)
+{
+	struct list_head entries[5], *cur;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+	int i = 0;
+
+	list_add_tail(&entries[0], &list1);
+	list_add_tail(&entries[1], &list1);
+	list_add_tail(&entries[2], &list2);
+	list_add_tail(&entries[3], &list2);
+	list_add_tail(&entries[4], &list1);
+
+	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
+	list_splice_tail(&list2, &entries[4]);
+	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] uninit */
+
+	list_for_each(cur, &list1) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 5);
+}
+
+static void list_test_list_splice_init(struct kunit *test)
+{
+	struct list_head entries[5], *cur;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+	int i = 0;
+
+	list_add_tail(&entries[0], &list1);
+	list_add_tail(&entries[1], &list1);
+	list_add_tail(&entries[2], &list2);
+	list_add_tail(&entries[3], &list2);
+	list_add_tail(&entries[4], &list1);
+
+	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
+	list_splice_init(&list2, &entries[1]);
+	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] empty */
+
+	list_for_each(cur, &list1) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 5);
+
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
+}
+
+static void list_test_list_splice_tail_init(struct kunit *test)
+{
+	struct list_head entries[5], *cur;
+	LIST_HEAD(list1);
+	LIST_HEAD(list2);
+	int i = 0;
+
+	list_add_tail(&entries[0], &list1);
+	list_add_tail(&entries[1], &list1);
+	list_add_tail(&entries[2], &list2);
+	list_add_tail(&entries[3], &list2);
+	list_add_tail(&entries[4], &list1);
+
+	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
+	list_splice_tail_init(&list2, &entries[4]);
+	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] empty */
+
+	list_for_each(cur, &list1) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 5);
+
+	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
+}
+
+static void list_test_list_entry(struct kunit *test)
+{
+	struct list_test_struct test_struct;
+
+	KUNIT_EXPECT_PTR_EQ(test, &test_struct, list_entry(&(test_struct.list),
+				struct list_test_struct, list));
+}
+
+static void list_test_list_first_entry(struct kunit *test)
+{
+	struct list_test_struct test_struct1, test_struct2;
+	LIST_HEAD(list);
+
+	list_add_tail(&test_struct1.list, &list);
+	list_add_tail(&test_struct2.list, &list);
+
+
+	KUNIT_EXPECT_PTR_EQ(test, &test_struct1, list_first_entry(&list,
+				struct list_test_struct, list));
+}
+
+static void list_test_list_last_entry(struct kunit *test)
+{
+	struct list_test_struct test_struct1, test_struct2;
+	LIST_HEAD(list);
+
+	list_add_tail(&test_struct1.list, &list);
+	list_add_tail(&test_struct2.list, &list);
+
+
+	KUNIT_EXPECT_PTR_EQ(test, &test_struct2, list_last_entry(&list,
+				struct list_test_struct, list));
+}
+
+static void list_test_list_first_entry_or_null(struct kunit *test)
+{
+	struct list_test_struct test_struct1, test_struct2;
+	LIST_HEAD(list);
+
+	KUNIT_EXPECT_FALSE(test, list_first_entry_or_null(&list,
+				struct list_test_struct, list));
+
+	list_add_tail(&test_struct1.list, &list);
+	list_add_tail(&test_struct2.list, &list);
+
+	KUNIT_EXPECT_PTR_EQ(test, &test_struct1,
+			list_first_entry_or_null(&list,
+				struct list_test_struct, list));
+}
+
+static void list_test_list_next_entry(struct kunit *test)
+{
+	struct list_test_struct test_struct1, test_struct2;
+	LIST_HEAD(list);
+
+	list_add_tail(&test_struct1.list, &list);
+	list_add_tail(&test_struct2.list, &list);
+
+
+	KUNIT_EXPECT_PTR_EQ(test, &test_struct2, list_next_entry(&test_struct1,
+				list));
+}
+
+static void list_test_list_prev_entry(struct kunit *test)
+{
+	struct list_test_struct test_struct1, test_struct2;
+	LIST_HEAD(list);
+
+	list_add_tail(&test_struct1.list, &list);
+	list_add_tail(&test_struct2.list, &list);
+
+
+	KUNIT_EXPECT_PTR_EQ(test, &test_struct1, list_prev_entry(&test_struct2,
+				list));
+}
+
+static void list_test_list_for_each(struct kunit *test)
+{
+	struct list_head entries[3], *cur;
+	LIST_HEAD(list);
+	int i = 0;
+
+	list_add_tail(&entries[0], &list);
+	list_add_tail(&entries[1], &list);
+	list_add_tail(&entries[2], &list);
+
+	list_for_each(cur, &list) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 3);
+}
+
+static void list_test_list_for_each_prev(struct kunit *test)
+{
+	struct list_head entries[3], *cur;
+	LIST_HEAD(list);
+	int i = 2;
+
+	list_add_tail(&entries[0], &list);
+	list_add_tail(&entries[1], &list);
+	list_add_tail(&entries[2], &list);
+
+	list_for_each_prev(cur, &list) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		i--;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, -1);
+}
+
+static void list_test_list_for_each_safe(struct kunit *test)
+{
+	struct list_head entries[3], *cur, *n;
+	LIST_HEAD(list);
+	int i = 0;
+
+
+	list_add_tail(&entries[0], &list);
+	list_add_tail(&entries[1], &list);
+	list_add_tail(&entries[2], &list);
+
+	list_for_each_safe(cur, n, &list) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		list_del(&entries[i]);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 3);
+	KUNIT_EXPECT_TRUE(test, list_empty(&list));
+}
+
+static void list_test_list_for_each_prev_safe(struct kunit *test)
+{
+	struct list_head entries[3], *cur, *n;
+	LIST_HEAD(list);
+	int i = 2;
+
+	list_add_tail(&entries[0], &list);
+	list_add_tail(&entries[1], &list);
+	list_add_tail(&entries[2], &list);
+
+	list_for_each_prev_safe(cur, n, &list) {
+		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
+		list_del(&entries[i]);
+		i--;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, -1);
+	KUNIT_EXPECT_TRUE(test, list_empty(&list));
+}
+
+static void list_test_list_for_each_entry(struct kunit *test)
+{
+	struct list_test_struct entries[5], *cur;
+	LIST_HEAD(list);
+	int i = 0;
+
+	for (i = 0; i < 5; ++i) {
+		entries[i].data = i;
+		list_add_tail(&entries[i].list, &list);
+	}
+
+	i = 0;
+
+	list_for_each_entry(cur, &list, list) {
+		KUNIT_EXPECT_EQ(test, cur->data, i);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 5);
+}
+
+static void list_test_list_for_each_entry_reverse(struct kunit *test)
+{
+	struct list_test_struct entries[5], *cur;
+	LIST_HEAD(list);
+	int i = 0;
+
+	for (i = 0; i < 5; ++i) {
+		entries[i].data = i;
+		list_add_tail(&entries[i].list, &list);
+	}
+
+	i = 4;
+
+	list_for_each_entry_reverse(cur, &list, list) {
+		KUNIT_EXPECT_EQ(test, cur->data, i);
+		i--;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, -1);
+}
+
+static struct kunit_case list_test_cases[] = {
+	KUNIT_CASE(list_test_list_init),
+	KUNIT_CASE(list_test_list_add),
+	KUNIT_CASE(list_test_list_add_tail),
+	KUNIT_CASE(list_test_list_del),
+	KUNIT_CASE(list_test_list_replace),
+	KUNIT_CASE(list_test_list_replace_init),
+	KUNIT_CASE(list_test_list_swap),
+	KUNIT_CASE(list_test_list_del_init),
+	KUNIT_CASE(list_test_list_move),
+	KUNIT_CASE(list_test_list_move_tail),
+	KUNIT_CASE(list_test_list_bulk_move_tail),
+	KUNIT_CASE(list_test_list_is_first),
+	KUNIT_CASE(list_test_list_is_last),
+	KUNIT_CASE(list_test_list_empty),
+	KUNIT_CASE(list_test_list_empty_careful),
+	KUNIT_CASE(list_test_list_rotate_left),
+	KUNIT_CASE(list_test_list_rotate_to_front),
+	KUNIT_CASE(list_test_list_is_singular),
+	KUNIT_CASE(list_test_list_cut_position),
+	KUNIT_CASE(list_test_list_cut_before),
+	KUNIT_CASE(list_test_list_splice),
+	KUNIT_CASE(list_test_list_splice_tail),
+	KUNIT_CASE(list_test_list_splice_init),
+	KUNIT_CASE(list_test_list_splice_tail_init),
+	KUNIT_CASE(list_test_list_entry),
+	KUNIT_CASE(list_test_list_first_entry),
+	KUNIT_CASE(list_test_list_last_entry),
+	KUNIT_CASE(list_test_list_first_entry_or_null),
+	KUNIT_CASE(list_test_list_next_entry),
+	KUNIT_CASE(list_test_list_prev_entry),
+	KUNIT_CASE(list_test_list_for_each),
+	KUNIT_CASE(list_test_list_for_each_prev),
+	KUNIT_CASE(list_test_list_for_each_safe),
+	KUNIT_CASE(list_test_list_for_each_prev_safe),
+	KUNIT_CASE(list_test_list_for_each_entry),
+	KUNIT_CASE(list_test_list_for_each_entry_reverse),
+	{},
+};
+
+static struct kunit_suite list_test_module = {
+	.name = "list-kunit-test",
+	.test_cases = list_test_cases,
+};
+
+kunit_test_suites(&list_test_module);
+
+MODULE_LICENSE("GPL v2");
--- a/lib/list-test.c
+++ /dev/null
@@ -1,748 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * KUnit test for the Kernel Linked-list structures.
- *
- * Copyright (C) 2019, Google LLC.
- * Author: David Gow <davidgow@google.com>
- */
-#include <kunit/test.h>
-
-#include <linux/list.h>
-
-struct list_test_struct {
-	int data;
-	struct list_head list;
-};
-
-static void list_test_list_init(struct kunit *test)
-{
-	/* Test the different ways of initialising a list. */
-	struct list_head list1 = LIST_HEAD_INIT(list1);
-	struct list_head list2;
-	LIST_HEAD(list3);
-	struct list_head *list4;
-	struct list_head *list5;
-
-	INIT_LIST_HEAD(&list2);
-
-	list4 = kzalloc(sizeof(*list4), GFP_KERNEL | __GFP_NOFAIL);
-	INIT_LIST_HEAD(list4);
-
-	list5 = kmalloc(sizeof(*list5), GFP_KERNEL | __GFP_NOFAIL);
-	memset(list5, 0xFF, sizeof(*list5));
-	INIT_LIST_HEAD(list5);
-
-	/* list_empty_careful() checks both next and prev. */
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list1));
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list3));
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(list4));
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(list5));
-
-	kfree(list4);
-	kfree(list5);
-}
-
-static void list_test_list_add(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add(&a, &list);
-	list_add(&b, &list);
-
-	/* should be [list] -> b -> a */
-	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
-	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
-	KUNIT_EXPECT_PTR_EQ(test, b.next, &a);
-}
-
-static void list_test_list_add_tail(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-
-	/* should be [list] -> a -> b */
-	KUNIT_EXPECT_PTR_EQ(test, list.next, &a);
-	KUNIT_EXPECT_PTR_EQ(test, a.prev, &list);
-	KUNIT_EXPECT_PTR_EQ(test, a.next, &b);
-}
-
-static void list_test_list_del(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-
-	/* before: [list] -> a -> b */
-	list_del(&a);
-
-	/* now: [list] -> b */
-	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
-	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
-}
-
-static void list_test_list_replace(struct kunit *test)
-{
-	struct list_head a_old, a_new, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a_old, &list);
-	list_add_tail(&b, &list);
-
-	/* before: [list] -> a_old -> b */
-	list_replace(&a_old, &a_new);
-
-	/* now: [list] -> a_new -> b */
-	KUNIT_EXPECT_PTR_EQ(test, list.next, &a_new);
-	KUNIT_EXPECT_PTR_EQ(test, b.prev, &a_new);
-}
-
-static void list_test_list_replace_init(struct kunit *test)
-{
-	struct list_head a_old, a_new, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a_old, &list);
-	list_add_tail(&b, &list);
-
-	/* before: [list] -> a_old -> b */
-	list_replace_init(&a_old, &a_new);
-
-	/* now: [list] -> a_new -> b */
-	KUNIT_EXPECT_PTR_EQ(test, list.next, &a_new);
-	KUNIT_EXPECT_PTR_EQ(test, b.prev, &a_new);
-
-	/* check a_old is empty (initialized) */
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&a_old));
-}
-
-static void list_test_list_swap(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-
-	/* before: [list] -> a -> b */
-	list_swap(&a, &b);
-
-	/* after: [list] -> b -> a */
-	KUNIT_EXPECT_PTR_EQ(test, &b, list.next);
-	KUNIT_EXPECT_PTR_EQ(test, &a, list.prev);
-
-	KUNIT_EXPECT_PTR_EQ(test, &a, b.next);
-	KUNIT_EXPECT_PTR_EQ(test, &list, b.prev);
-
-	KUNIT_EXPECT_PTR_EQ(test, &list, a.next);
-	KUNIT_EXPECT_PTR_EQ(test, &b, a.prev);
-}
-
-static void list_test_list_del_init(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-
-	/* before: [list] -> a -> b */
-	list_del_init(&a);
-	/* after: [list] -> b, a initialised */
-
-	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
-	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&a));
-}
-
-static void list_test_list_move(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-
-	list_add_tail(&a, &list1);
-	list_add_tail(&b, &list2);
-
-	/* before: [list1] -> a, [list2] -> b */
-	list_move(&a, &list2);
-	/* after: [list1] empty, [list2] -> a -> b */
-
-	KUNIT_EXPECT_TRUE(test, list_empty(&list1));
-
-	KUNIT_EXPECT_PTR_EQ(test, &a, list2.next);
-	KUNIT_EXPECT_PTR_EQ(test, &b, a.next);
-}
-
-static void list_test_list_move_tail(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-
-	list_add_tail(&a, &list1);
-	list_add_tail(&b, &list2);
-
-	/* before: [list1] -> a, [list2] -> b */
-	list_move_tail(&a, &list2);
-	/* after: [list1] empty, [list2] -> b -> a */
-
-	KUNIT_EXPECT_TRUE(test, list_empty(&list1));
-
-	KUNIT_EXPECT_PTR_EQ(test, &b, list2.next);
-	KUNIT_EXPECT_PTR_EQ(test, &a, b.next);
-}
-
-static void list_test_list_bulk_move_tail(struct kunit *test)
-{
-	struct list_head a, b, c, d, x, y;
-	struct list_head *list1_values[] = { &x, &b, &c, &y };
-	struct list_head *list2_values[] = { &a, &d };
-	struct list_head *ptr;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-	int i = 0;
-
-	list_add_tail(&x, &list1);
-	list_add_tail(&y, &list1);
-
-	list_add_tail(&a, &list2);
-	list_add_tail(&b, &list2);
-	list_add_tail(&c, &list2);
-	list_add_tail(&d, &list2);
-
-	/* before: [list1] -> x -> y, [list2] -> a -> b -> c -> d */
-	list_bulk_move_tail(&y, &b, &c);
-	/* after: [list1] -> x -> b -> c -> y, [list2] -> a -> d */
-
-	list_for_each(ptr, &list1) {
-		KUNIT_EXPECT_PTR_EQ(test, ptr, list1_values[i]);
-		i++;
-	}
-	KUNIT_EXPECT_EQ(test, i, 4);
-	i = 0;
-	list_for_each(ptr, &list2) {
-		KUNIT_EXPECT_PTR_EQ(test, ptr, list2_values[i]);
-		i++;
-	}
-	KUNIT_EXPECT_EQ(test, i, 2);
-}
-
-static void list_test_list_is_first(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-
-	KUNIT_EXPECT_TRUE(test, list_is_first(&a, &list));
-	KUNIT_EXPECT_FALSE(test, list_is_first(&b, &list));
-}
-
-static void list_test_list_is_last(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-
-	KUNIT_EXPECT_FALSE(test, list_is_last(&a, &list));
-	KUNIT_EXPECT_TRUE(test, list_is_last(&b, &list));
-}
-
-static void list_test_list_empty(struct kunit *test)
-{
-	struct list_head a;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-
-	list_add_tail(&a, &list1);
-
-	KUNIT_EXPECT_FALSE(test, list_empty(&list1));
-	KUNIT_EXPECT_TRUE(test, list_empty(&list2));
-}
-
-static void list_test_list_empty_careful(struct kunit *test)
-{
-	/* This test doesn't check correctness under concurrent access */
-	struct list_head a;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-
-	list_add_tail(&a, &list1);
-
-	KUNIT_EXPECT_FALSE(test, list_empty_careful(&list1));
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
-}
-
-static void list_test_list_rotate_left(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-
-	/* before: [list] -> a -> b */
-	list_rotate_left(&list);
-	/* after: [list] -> b -> a */
-
-	KUNIT_EXPECT_PTR_EQ(test, list.next, &b);
-	KUNIT_EXPECT_PTR_EQ(test, b.prev, &list);
-	KUNIT_EXPECT_PTR_EQ(test, b.next, &a);
-}
-
-static void list_test_list_rotate_to_front(struct kunit *test)
-{
-	struct list_head a, b, c, d;
-	struct list_head *list_values[] = { &c, &d, &a, &b };
-	struct list_head *ptr;
-	LIST_HEAD(list);
-	int i = 0;
-
-	list_add_tail(&a, &list);
-	list_add_tail(&b, &list);
-	list_add_tail(&c, &list);
-	list_add_tail(&d, &list);
-
-	/* before: [list] -> a -> b -> c -> d */
-	list_rotate_to_front(&c, &list);
-	/* after: [list] -> c -> d -> a -> b */
-
-	list_for_each(ptr, &list) {
-		KUNIT_EXPECT_PTR_EQ(test, ptr, list_values[i]);
-		i++;
-	}
-	KUNIT_EXPECT_EQ(test, i, 4);
-}
-
-static void list_test_list_is_singular(struct kunit *test)
-{
-	struct list_head a, b;
-	LIST_HEAD(list);
-
-	/* [list] empty */
-	KUNIT_EXPECT_FALSE(test, list_is_singular(&list));
-
-	list_add_tail(&a, &list);
-
-	/* [list] -> a */
-	KUNIT_EXPECT_TRUE(test, list_is_singular(&list));
-
-	list_add_tail(&b, &list);
-
-	/* [list] -> a -> b */
-	KUNIT_EXPECT_FALSE(test, list_is_singular(&list));
-}
-
-static void list_test_list_cut_position(struct kunit *test)
-{
-	struct list_head entries[3], *cur;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-	int i = 0;
-
-	list_add_tail(&entries[0], &list1);
-	list_add_tail(&entries[1], &list1);
-	list_add_tail(&entries[2], &list1);
-
-	/* before: [list1] -> entries[0] -> entries[1] -> entries[2] */
-	list_cut_position(&list2, &list1, &entries[1]);
-	/* after: [list2] -> entries[0] -> entries[1], [list1] -> entries[2] */
-
-	list_for_each(cur, &list2) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 2);
-
-	list_for_each(cur, &list1) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-}
-
-static void list_test_list_cut_before(struct kunit *test)
-{
-	struct list_head entries[3], *cur;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-	int i = 0;
-
-	list_add_tail(&entries[0], &list1);
-	list_add_tail(&entries[1], &list1);
-	list_add_tail(&entries[2], &list1);
-
-	/* before: [list1] -> entries[0] -> entries[1] -> entries[2] */
-	list_cut_before(&list2, &list1, &entries[1]);
-	/* after: [list2] -> entries[0], [list1] -> entries[1] -> entries[2] */
-
-	list_for_each(cur, &list2) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 1);
-
-	list_for_each(cur, &list1) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-}
-
-static void list_test_list_splice(struct kunit *test)
-{
-	struct list_head entries[5], *cur;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-	int i = 0;
-
-	list_add_tail(&entries[0], &list1);
-	list_add_tail(&entries[1], &list1);
-	list_add_tail(&entries[2], &list2);
-	list_add_tail(&entries[3], &list2);
-	list_add_tail(&entries[4], &list1);
-
-	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
-	list_splice(&list2, &entries[1]);
-	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] uninit */
-
-	list_for_each(cur, &list1) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 5);
-}
-
-static void list_test_list_splice_tail(struct kunit *test)
-{
-	struct list_head entries[5], *cur;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-	int i = 0;
-
-	list_add_tail(&entries[0], &list1);
-	list_add_tail(&entries[1], &list1);
-	list_add_tail(&entries[2], &list2);
-	list_add_tail(&entries[3], &list2);
-	list_add_tail(&entries[4], &list1);
-
-	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
-	list_splice_tail(&list2, &entries[4]);
-	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] uninit */
-
-	list_for_each(cur, &list1) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 5);
-}
-
-static void list_test_list_splice_init(struct kunit *test)
-{
-	struct list_head entries[5], *cur;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-	int i = 0;
-
-	list_add_tail(&entries[0], &list1);
-	list_add_tail(&entries[1], &list1);
-	list_add_tail(&entries[2], &list2);
-	list_add_tail(&entries[3], &list2);
-	list_add_tail(&entries[4], &list1);
-
-	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
-	list_splice_init(&list2, &entries[1]);
-	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] empty */
-
-	list_for_each(cur, &list1) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 5);
-
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
-}
-
-static void list_test_list_splice_tail_init(struct kunit *test)
-{
-	struct list_head entries[5], *cur;
-	LIST_HEAD(list1);
-	LIST_HEAD(list2);
-	int i = 0;
-
-	list_add_tail(&entries[0], &list1);
-	list_add_tail(&entries[1], &list1);
-	list_add_tail(&entries[2], &list2);
-	list_add_tail(&entries[3], &list2);
-	list_add_tail(&entries[4], &list1);
-
-	/* before: [list1]->e[0]->e[1]->e[4], [list2]->e[2]->e[3] */
-	list_splice_tail_init(&list2, &entries[4]);
-	/* after: [list1]->e[0]->e[1]->e[2]->e[3]->e[4], [list2] empty */
-
-	list_for_each(cur, &list1) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 5);
-
-	KUNIT_EXPECT_TRUE(test, list_empty_careful(&list2));
-}
-
-static void list_test_list_entry(struct kunit *test)
-{
-	struct list_test_struct test_struct;
-
-	KUNIT_EXPECT_PTR_EQ(test, &test_struct, list_entry(&(test_struct.list),
-				struct list_test_struct, list));
-}
-
-static void list_test_list_first_entry(struct kunit *test)
-{
-	struct list_test_struct test_struct1, test_struct2;
-	LIST_HEAD(list);
-
-	list_add_tail(&test_struct1.list, &list);
-	list_add_tail(&test_struct2.list, &list);
-
-
-	KUNIT_EXPECT_PTR_EQ(test, &test_struct1, list_first_entry(&list,
-				struct list_test_struct, list));
-}
-
-static void list_test_list_last_entry(struct kunit *test)
-{
-	struct list_test_struct test_struct1, test_struct2;
-	LIST_HEAD(list);
-
-	list_add_tail(&test_struct1.list, &list);
-	list_add_tail(&test_struct2.list, &list);
-
-
-	KUNIT_EXPECT_PTR_EQ(test, &test_struct2, list_last_entry(&list,
-				struct list_test_struct, list));
-}
-
-static void list_test_list_first_entry_or_null(struct kunit *test)
-{
-	struct list_test_struct test_struct1, test_struct2;
-	LIST_HEAD(list);
-
-	KUNIT_EXPECT_FALSE(test, list_first_entry_or_null(&list,
-				struct list_test_struct, list));
-
-	list_add_tail(&test_struct1.list, &list);
-	list_add_tail(&test_struct2.list, &list);
-
-	KUNIT_EXPECT_PTR_EQ(test, &test_struct1,
-			list_first_entry_or_null(&list,
-				struct list_test_struct, list));
-}
-
-static void list_test_list_next_entry(struct kunit *test)
-{
-	struct list_test_struct test_struct1, test_struct2;
-	LIST_HEAD(list);
-
-	list_add_tail(&test_struct1.list, &list);
-	list_add_tail(&test_struct2.list, &list);
-
-
-	KUNIT_EXPECT_PTR_EQ(test, &test_struct2, list_next_entry(&test_struct1,
-				list));
-}
-
-static void list_test_list_prev_entry(struct kunit *test)
-{
-	struct list_test_struct test_struct1, test_struct2;
-	LIST_HEAD(list);
-
-	list_add_tail(&test_struct1.list, &list);
-	list_add_tail(&test_struct2.list, &list);
-
-
-	KUNIT_EXPECT_PTR_EQ(test, &test_struct1, list_prev_entry(&test_struct2,
-				list));
-}
-
-static void list_test_list_for_each(struct kunit *test)
-{
-	struct list_head entries[3], *cur;
-	LIST_HEAD(list);
-	int i = 0;
-
-	list_add_tail(&entries[0], &list);
-	list_add_tail(&entries[1], &list);
-	list_add_tail(&entries[2], &list);
-
-	list_for_each(cur, &list) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 3);
-}
-
-static void list_test_list_for_each_prev(struct kunit *test)
-{
-	struct list_head entries[3], *cur;
-	LIST_HEAD(list);
-	int i = 2;
-
-	list_add_tail(&entries[0], &list);
-	list_add_tail(&entries[1], &list);
-	list_add_tail(&entries[2], &list);
-
-	list_for_each_prev(cur, &list) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		i--;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, -1);
-}
-
-static void list_test_list_for_each_safe(struct kunit *test)
-{
-	struct list_head entries[3], *cur, *n;
-	LIST_HEAD(list);
-	int i = 0;
-
-
-	list_add_tail(&entries[0], &list);
-	list_add_tail(&entries[1], &list);
-	list_add_tail(&entries[2], &list);
-
-	list_for_each_safe(cur, n, &list) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		list_del(&entries[i]);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 3);
-	KUNIT_EXPECT_TRUE(test, list_empty(&list));
-}
-
-static void list_test_list_for_each_prev_safe(struct kunit *test)
-{
-	struct list_head entries[3], *cur, *n;
-	LIST_HEAD(list);
-	int i = 2;
-
-	list_add_tail(&entries[0], &list);
-	list_add_tail(&entries[1], &list);
-	list_add_tail(&entries[2], &list);
-
-	list_for_each_prev_safe(cur, n, &list) {
-		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
-		list_del(&entries[i]);
-		i--;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, -1);
-	KUNIT_EXPECT_TRUE(test, list_empty(&list));
-}
-
-static void list_test_list_for_each_entry(struct kunit *test)
-{
-	struct list_test_struct entries[5], *cur;
-	LIST_HEAD(list);
-	int i = 0;
-
-	for (i = 0; i < 5; ++i) {
-		entries[i].data = i;
-		list_add_tail(&entries[i].list, &list);
-	}
-
-	i = 0;
-
-	list_for_each_entry(cur, &list, list) {
-		KUNIT_EXPECT_EQ(test, cur->data, i);
-		i++;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, 5);
-}
-
-static void list_test_list_for_each_entry_reverse(struct kunit *test)
-{
-	struct list_test_struct entries[5], *cur;
-	LIST_HEAD(list);
-	int i = 0;
-
-	for (i = 0; i < 5; ++i) {
-		entries[i].data = i;
-		list_add_tail(&entries[i].list, &list);
-	}
-
-	i = 4;
-
-	list_for_each_entry_reverse(cur, &list, list) {
-		KUNIT_EXPECT_EQ(test, cur->data, i);
-		i--;
-	}
-
-	KUNIT_EXPECT_EQ(test, i, -1);
-}
-
-static struct kunit_case list_test_cases[] = {
-	KUNIT_CASE(list_test_list_init),
-	KUNIT_CASE(list_test_list_add),
-	KUNIT_CASE(list_test_list_add_tail),
-	KUNIT_CASE(list_test_list_del),
-	KUNIT_CASE(list_test_list_replace),
-	KUNIT_CASE(list_test_list_replace_init),
-	KUNIT_CASE(list_test_list_swap),
-	KUNIT_CASE(list_test_list_del_init),
-	KUNIT_CASE(list_test_list_move),
-	KUNIT_CASE(list_test_list_move_tail),
-	KUNIT_CASE(list_test_list_bulk_move_tail),
-	KUNIT_CASE(list_test_list_is_first),
-	KUNIT_CASE(list_test_list_is_last),
-	KUNIT_CASE(list_test_list_empty),
-	KUNIT_CASE(list_test_list_empty_careful),
-	KUNIT_CASE(list_test_list_rotate_left),
-	KUNIT_CASE(list_test_list_rotate_to_front),
-	KUNIT_CASE(list_test_list_is_singular),
-	KUNIT_CASE(list_test_list_cut_position),
-	KUNIT_CASE(list_test_list_cut_before),
-	KUNIT_CASE(list_test_list_splice),
-	KUNIT_CASE(list_test_list_splice_tail),
-	KUNIT_CASE(list_test_list_splice_init),
-	KUNIT_CASE(list_test_list_splice_tail_init),
-	KUNIT_CASE(list_test_list_entry),
-	KUNIT_CASE(list_test_list_first_entry),
-	KUNIT_CASE(list_test_list_last_entry),
-	KUNIT_CASE(list_test_list_first_entry_or_null),
-	KUNIT_CASE(list_test_list_next_entry),
-	KUNIT_CASE(list_test_list_prev_entry),
-	KUNIT_CASE(list_test_list_for_each),
-	KUNIT_CASE(list_test_list_for_each_prev),
-	KUNIT_CASE(list_test_list_for_each_safe),
-	KUNIT_CASE(list_test_list_for_each_prev_safe),
-	KUNIT_CASE(list_test_list_for_each_entry),
-	KUNIT_CASE(list_test_list_for_each_entry_reverse),
-	{},
-};
-
-static struct kunit_suite list_test_module = {
-	.name = "list-kunit-test",
-	.test_cases = list_test_cases,
-};
-
-kunit_test_suites(&list_test_module);
-
-MODULE_LICENSE("GPL v2");
--- a/lib/Makefile~lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests
+++ a/lib/Makefile
@@ -350,6 +350,6 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
+obj-$(CONFIG_BITS_TEST) += bits_kunit.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += linear_ranges_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
-obj-$(CONFIG_BITS_TEST) += test_bits.o
--- a/lib/test_bits.c
+++ /dev/null
@@ -1,75 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Test cases for functions and macros in bits.h
- */
-
-#include <kunit/test.h>
-#include <linux/bits.h>
-
-
-static void genmask_test(struct kunit *test)
-{
-	KUNIT_EXPECT_EQ(test, 1ul, GENMASK(0, 0));
-	KUNIT_EXPECT_EQ(test, 3ul, GENMASK(1, 0));
-	KUNIT_EXPECT_EQ(test, 6ul, GENMASK(2, 1));
-	KUNIT_EXPECT_EQ(test, 0xFFFFFFFFul, GENMASK(31, 0));
-
-#ifdef TEST_GENMASK_FAILURES
-	/* these should fail compilation */
-	GENMASK(0, 1);
-	GENMASK(0, 10);
-	GENMASK(9, 10);
-#endif
-
-
-}
-
-static void genmask_ull_test(struct kunit *test)
-{
-	KUNIT_EXPECT_EQ(test, 1ull, GENMASK_ULL(0, 0));
-	KUNIT_EXPECT_EQ(test, 3ull, GENMASK_ULL(1, 0));
-	KUNIT_EXPECT_EQ(test, 0x000000ffffe00000ull, GENMASK_ULL(39, 21));
-	KUNIT_EXPECT_EQ(test, 0xffffffffffffffffull, GENMASK_ULL(63, 0));
-
-#ifdef TEST_GENMASK_FAILURES
-	/* these should fail compilation */
-	GENMASK_ULL(0, 1);
-	GENMASK_ULL(0, 10);
-	GENMASK_ULL(9, 10);
-#endif
-}
-
-static void genmask_input_check_test(struct kunit *test)
-{
-	unsigned int x, y;
-	int z, w;
-
-	/* Unknown input */
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(x, 0));
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(0, x));
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(x, y));
-
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(z, 0));
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(0, z));
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(z, w));
-
-	/* Valid input */
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(1, 1));
-	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(39, 21));
-}
-
-
-static struct kunit_case bits_test_cases[] = {
-	KUNIT_CASE(genmask_test),
-	KUNIT_CASE(genmask_ull_test),
-	KUNIT_CASE(genmask_input_check_test),
-	{}
-};
-
-static struct kunit_suite bits_test_suite = {
-	.name = "bits-test",
-	.test_cases = bits_test_cases,
-};
-kunit_test_suite(bits_test_suite);
-
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch


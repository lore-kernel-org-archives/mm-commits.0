Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D2B1A0712
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 21:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766092099; cv=none; b=mayrIFuFbzWO0/rQfN7XIyls3g8lGjoxooi3DIY3S2dCazjZ3HH672mfbtbno+D6fbvKNaF/pjIDS8SKDHvKdvSQcYMeuBfdBLcR7peRi9kkBOheQ438JtzvahfLcMkbFKEtGAnDYlKiWznbcWgvVote6yVb9RYmV2wNIIZP5mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766092099; c=relaxed/simple;
	bh=wf7yW29QTrdeGZjR7exXJE+gqsuO7FZhOwWsp57/h5c=;
	h=Date:To:From:Subject:Message-Id; b=ee51FJkqmcQD/R4XxMU6aLoLsTyMyZBI2Kz+jo7FLCMDZWEmhLsDlClV+9p5t7Fiagp4BvVNClA/Ii4QT5HkgNU2F3URpSiZ/BWhsG8xOhUfVVL3xSKPNHmighbhAq3fnj/PHrtQuLTkc2EClp89zvPWYCR8sreojJf6qy9aAN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fx+aaTHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fx+aaTHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EDAC4CEFB;
	Thu, 18 Dec 2025 21:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766092099;
	bh=wf7yW29QTrdeGZjR7exXJE+gqsuO7FZhOwWsp57/h5c=;
	h=Date:To:From:Subject:From;
	b=Fx+aaTHpoVoDwdeSfMPF/dxRNzNlFsBkLwRX0Dhd7EPkW5QvJ9CI6KIxSxv3IyDvw
	 u6DUajOh910aEAOXPsx3uhIurp5Mkjyw/tr+SDtNhbAvKO/OZccefqmuZqOHgqvXrj
	 jxyjongANUUaFkGD7PLS1RINtfnsE/KgAhQPN7rk=
Date: Thu, 18 Dec 2025 13:08:18 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,skhawaja@google.com,rppt@kernel.org,rientjes@google.com,pratyush@kernel.org,pmladek@suse.com,kees@kernel.org,graf@amazon.com,dmatlack@google.com,davidgow@google.com,corbet@lwn.net,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-add-kunit-test-for-private-list-primitives.patch added to mm-nonmm-unstable branch
Message-Id: <20251218210818.E4EDAC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: add kunit test for private list primitives
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-add-kunit-test-for-private-list-primitives.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-add-kunit-test-for-private-list-primitives.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: list: add kunit test for private list primitives
Date: Thu, 18 Dec 2025 10:57:49 -0500

Add a KUnit test suite for the new private list primitives.

The test defines a struct with a __private list_head and exercises every
macro defined in <linux/list_private.h>.

This ensures that the macros correctly handle the ACCESS_PRIVATE()
abstraction and compile without warnings when acting on private members,
verifying that qualifiers are stripped and offsets are calculated
correctly.

Link: https://lkml.kernel.org/r/20251218155752.3045808-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: David Gow <davidgow@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug             |   14 +++++
 lib/tests/Makefile            |    1 
 lib/tests/list-private-test.c |   76 ++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)

--- a/lib/Kconfig.debug~list-add-kunit-test-for-private-list-primitives
+++ a/lib/Kconfig.debug
@@ -2796,6 +2796,20 @@ config LIST_KUNIT_TEST
 
 	  If unsure, say N.
 
+config LIST_PRIVATE_KUNIT_TEST
+	tristate "KUnit Test for Kernel Private Linked-list structures" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the KUnit test for the private linked-list primitives
+	  defined in include/linux/list_private.h.
+
+	  These primitives allow manipulation of list_head members that are
+	  marked as private and require special accessors (ACCESS_PRIVATE)
+	  to strip qualifiers or handle encapsulation.
+
+	  If unsure, say N.
+
 config HASHTABLE_KUNIT_TEST
 	tristate "KUnit Test for Kernel Hashtable structures" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/tests/list-private-test.c a/lib/tests/list-private-test.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/list-private-test.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit compilation/smoke test for Private list primitives.
+ *
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/list_private.h>
+#include <kunit/test.h>
+
+/*
+ * This forces compiler to warn if you access it directly, because list
+ * primitives expect (struct list_head *), not (volatile struct list_head *).
+ */
+#undef __private
+#define __private volatile
+
+/* Redefine ACCESS_PRIVATE for this test. */
+#undef ACCESS_PRIVATE
+#define ACCESS_PRIVATE(p, member) \
+	(*((struct list_head *)((unsigned long)&((p)->member))))
+
+struct list_test_struct {
+	int data;
+	struct list_head __private list;
+};
+
+static void list_private_compile_test(struct kunit *test)
+{
+	struct list_test_struct entry;
+	struct list_test_struct *pos, *n;
+	LIST_HEAD(head);
+
+	INIT_LIST_HEAD(&ACCESS_PRIVATE(&entry, list));
+	list_add(&ACCESS_PRIVATE(&entry, list), &head);
+	pos = &entry;
+
+	pos = list_private_entry(&ACCESS_PRIVATE(&entry, list), struct list_test_struct, list);
+	pos = list_private_first_entry(&head, struct list_test_struct, list);
+	pos = list_private_last_entry(&head, struct list_test_struct, list);
+	pos = list_private_next_entry(pos, list);
+	pos = list_private_prev_entry(pos, list);
+	pos = list_private_next_entry_circular(pos, &head, list);
+	pos = list_private_prev_entry_circular(pos, &head, list);
+
+	if (list_private_entry_is_head(pos, &head, list))
+		return;
+
+	list_private_for_each_entry(pos, &head, list) { }
+	list_private_for_each_entry_reverse(pos, &head, list) { }
+	list_private_for_each_entry_continue(pos, &head, list) { }
+	list_private_for_each_entry_continue_reverse(pos, &head, list) { }
+	list_private_for_each_entry_from(pos, &head, list) { }
+	list_private_for_each_entry_from_reverse(pos, &head, list) { }
+
+	list_private_for_each_entry_safe(pos, n, &head, list)
+		list_private_safe_reset_next(pos, n, list);
+	list_private_for_each_entry_safe_continue(pos, n, &head, list) { }
+	list_private_for_each_entry_safe_from(pos, n, &head, list) { }
+	list_private_for_each_entry_safe_reverse(pos, n, &head, list) { }
+}
+
+static struct kunit_case list_private_test_cases[] = {
+	KUNIT_CASE(list_private_compile_test),
+	{},
+};
+
+static struct kunit_suite list_private_test_module = {
+	.name = "list-private-kunit-test",
+	.test_cases = list_private_test_cases,
+};
+
+kunit_test_suite(list_private_test_module);
+
+MODULE_DESCRIPTION("KUnit compilation test for private list primitives");
+MODULE_LICENSE("GPL");
--- a/lib/tests/Makefile~list-add-kunit-test-for-private-list-primitives
+++ a/lib/tests/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_TEST_IOV_ITER) += kunit_iov
 obj-$(CONFIG_IS_SIGNED_TYPE_KUNIT_TEST) += is_signed_type_kunit.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
+obj-$(CONFIG_LIST_PRIVATE_KUNIT_TEST) += list-private-test.o
 obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

list-add-primitives-for-private-list-manipulations.patch
list-add-kunit-test-for-private-list-primitives.patch
liveupdate-luo_file-use-private-list.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch


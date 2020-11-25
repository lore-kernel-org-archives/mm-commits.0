Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CAFC56201
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC20221F8
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ducPP6sP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgKYWSl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:18:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbgKYWSk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 17:18:40 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE1F21D40;
        Wed, 25 Nov 2020 22:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606342707;
        bh=F2fHqEqknkKC91kwS4eJkjwj06xYV7XyoYbht9NWzmQ=;
        h=Date:From:To:Subject:From;
        b=ducPP6sPyO8mooVl2c11nmh2aLmPV9ZamkkD4RluTQ23z30WXRjbtfJym0123LAPJ
         T0LTeiz4MpbpHuR+VUUIGdXjp0DONpUmPGz5LhWg7AVTojwm4djPz/hrH6GZ/M9AwM
         ohGiVvMz/DnPJT/Fk+HdcCKLXQiGi7ImG8/0bvc0=
Date:   Wed, 25 Nov 2020 14:18:25 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, cai@lca.pw, christian.koenig@amd.com,
        cl@linux.com, daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        david@fromorbit.com, iamjoonsoo.kim@lge.com, jgg@mellanox.com,
        jgg@nvidia.com, longman@redhat.com,
        maarten.lankhorst@linux.intel.com, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org, penberg@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com, tglx@linutronix.de,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        will@kernel.org, willy@infradead.org
Subject:  + locking-selftests-add-testcases-for-fs_reclaim.patch
 added to -mm tree
Message-ID: <20201125221825.Z1e_5EEx_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: locking/selftests: add testcases for fs_reclaim
has been added to the -mm tree.  Its filename is
     locking-selftests-add-testcases-for-fs_reclaim.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/locking-selftests-add-testcas=
es-for-fs_reclaim.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/locking-selftests-add-testcas=
es-for-fs_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: locking/selftests: add testcases for fs_reclaim

Since I butchered this I figured better to make sure we have testcases for
this now.  Since we only have a locking context for __GFP_FS that's the
only thing we're testing right now.

Link: https://lkml.kernel.org/r/20201125162532.1299794-4-daniel.vetter@ffwl=
l.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Hellstr=C3=B6m (Intel) <thomas_os@shipmail.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/locking-selftest.c |   47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- a/lib/locking-selftest.c~locking-selftests-add-testcases-for-fs_reclaim
+++ a/lib/locking-selftest.c
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/ww_mutex.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/delay.h>
 #include <linux/lockdep.h>
 #include <linux/spinlock.h>
@@ -2357,6 +2358,50 @@ static void queued_read_lock_tests(void)
 	pr_cont("\n");
 }
=20
+static void fs_reclaim_correct_nesting(void)
+{
+	fs_reclaim_acquire(GFP_KERNEL);
+	might_alloc(GFP_NOFS);
+	fs_reclaim_release(GFP_KERNEL);
+}
+
+static void fs_reclaim_wrong_nesting(void)
+{
+	fs_reclaim_acquire(GFP_KERNEL);
+	might_alloc(GFP_KERNEL);
+	fs_reclaim_release(GFP_KERNEL);
+}
+
+static void fs_reclaim_protected_nesting(void)
+{
+	unsigned int flags;
+
+	fs_reclaim_acquire(GFP_KERNEL);
+	flags =3D memalloc_nofs_save();
+	might_alloc(GFP_KERNEL);
+	memalloc_nofs_restore(flags);
+	fs_reclaim_release(GFP_KERNEL);
+}
+
+static void fs_reclaim_tests(void)
+{
+	printk("  --------------------\n");
+	printk("  | fs_reclaim tests |\n");
+	printk("  --------------------\n");
+
+	print_testname("correct nesting");
+	dotest(fs_reclaim_correct_nesting, SUCCESS, 0);
+	pr_cont("\n");
+
+	print_testname("wrong nesting");
+	dotest(fs_reclaim_wrong_nesting, FAILURE, 0);
+	pr_cont("\n");
+
+	print_testname("protected nesting");
+	dotest(fs_reclaim_protected_nesting, SUCCESS, 0);
+	pr_cont("\n");
+}
+
 void locking_selftest(void)
 {
 	/*
@@ -2478,6 +2523,8 @@ void locking_selftest(void)
 	if (IS_ENABLED(CONFIG_QUEUED_RWLOCKS))
 		queued_read_lock_tests();
=20
+	fs_reclaim_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("----------------------------------------------------------------=
-\n");
 		debug_locks =3D 0;
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch
mm-extract-might_alloc-debug-check.patch
locking-selftests-add-testcases-for-fs_reclaim.patch


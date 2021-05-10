Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AE6C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19A2611F1
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhEJBiZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 21:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhEJBiZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 21:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F15F6613DE;
        Mon, 10 May 2021 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620610641;
        bh=cBhz9fXvKQyfa1HS9X81GYXQoiKAZs8loarAGNab5Lk=;
        h=Date:From:To:Subject:From;
        b=s82hNvbxBGVdZG97iy2Hqt+8xsTd4DBS/MhYldreoel44X6zaG8Tv/7luPu4pB76E
         K8Oge4zwcE2tOXkYBJ5uEXLg8ei0CW9a7FLhj9ANJwkaMbjyrp+wy90PK4g1qZUUoV
         IR0awVdxsrB8ZahhKXvgjPXyz4Y2BBFWADirKt6Q=
Date:   Sun, 09 May 2021 18:37:20 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, corbet@lwn.net,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        linux@rasmusvillemoes.dk, mathieu.desnoyers@efficios.com,
        mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        paul.gortmaker@windriver.com, paulmck@kernel.org,
        rdunlap@infradead.org, rostedt@goodmis.org, yury.norov@gmail.com
Subject:  +
 rcu-tree_plugin-dont-handle-the-case-of-all-cpu-range.patch added to -mm
 tree
Message-ID: <20210510013720.DiCIfcnJy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcu/tree_plugin: don't handle the case of 'all' CPU range
has been added to the -mm tree.  Its filename is
     rcu-tree_plugin-dont-handle-the-case-of-all-cpu-range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rcu-tree_plugin-dont-handle-the-case-of-all-cpu-range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rcu-tree_plugin-dont-handle-the-case-of-all-cpu-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: rcu/tree_plugin: don't handle the case of 'all' CPU range

The 'all' semantics is now supported by the bitmap_parselist() so we can
drop supporting it as a special case in RCU code.  Since 'all' is properly
supported in core bitmap code, drop legacy comment in RCU for it.

This patch does not add any functional changes for existing users.

Link: https://lkml.kernel.org/r/20210421031326.72816-3-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree_plugin.h |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/rcu/tree_plugin.h~rcu-tree_plugin-dont-handle-the-case-of-all-cpu-range
+++ a/kernel/rcu/tree_plugin.h
@@ -1535,13 +1535,10 @@ static void rcu_cleanup_after_idle(void)
 static int __init rcu_nocb_setup(char *str)
 {
 	alloc_bootmem_cpumask_var(&rcu_nocb_mask);
-	if (!strcasecmp(str, "all"))		/* legacy: use "0-N" instead */
+	if (cpulist_parse(str, rcu_nocb_mask)) {
+		pr_warn("rcu_nocbs= bad CPU range, all CPUs set\n");
 		cpumask_setall(rcu_nocb_mask);
-	else
-		if (cpulist_parse(str, rcu_nocb_mask)) {
-			pr_warn("rcu_nocbs= bad CPU range, all CPUs set\n");
-			cpumask_setall(rcu_nocb_mask);
-		}
+	}
 	return 1;
 }
 __setup("rcu_nocbs=", rcu_nocb_setup);
_

Patches currently in -mm which might be from yury.norov@gmail.com are

bitmap_parse-support-all-semantics.patch
rcu-tree_plugin-dont-handle-the-case-of-all-cpu-range.patch


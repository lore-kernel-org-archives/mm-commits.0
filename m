Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E64C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C09611F1
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhEJBiW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 21:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhEJBiW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 21:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F949613DB;
        Mon, 10 May 2021 01:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620610638;
        bh=y8etkLxN9O9LosLJ7wuM6XLbIdR94D1NDhHSNuiJvTg=;
        h=Date:From:To:Subject:From;
        b=YlNQezX9jfTz0apuiigzNMhjR1osHu0mEcqpBA4uwqY2Bw0cDm0XfXtaT4uedlNCr
         5DNBKm3vrmWSICZpe6JPMOObVWozirzvqS33rLnpnCCAXh+jR50dtSYADg/xQT7vhl
         vr+D7UzEL98jvEFayHRpAXICwHwhjnJ233GQF8jE=
Date:   Sun, 09 May 2021 18:37:17 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, corbet@lwn.net,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        linux@rasmusvillemoes.dk, mathieu.desnoyers@efficios.com,
        mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        paul.gortmaker@windriver.com, paulmck@kernel.org,
        rdunlap@infradead.org, rostedt@goodmis.org, yury.norov@gmail.com
Subject:  + bitmap_parse-support-all-semantics.patch added to -mm
 tree
Message-ID: <20210510013717.chKOjQxD9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap_parse: support 'all' semantics
has been added to the -mm tree.  Its filename is
     bitmap_parse-support-all-semantics.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitmap_parse-support-all-semantics.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitmap_parse-support-all-semantics.patch

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
Subject: bitmap_parse: support 'all' semantics

RCU code supports an 'all' group as a special case when parsing rcu_nocbs
parameter.  This patch moves the 'all' support to the core bitmap_parse
code, so that all bitmap users can enjoy this extension.

Moving 'all' parsing to a bitmap_parse level, also allows users to pass
patterns together with 'all' in regular group:pattern format

Link: https://lkml.kernel.org/r/20210421031326.72816-2-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.rst |    5 +++++
 lib/bitmap.c                                    |    9 +++++++++
 lib/test_bitmap.c                               |    7 +++++++
 3 files changed, 21 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.rst~bitmap_parse-support-all-semantics
+++ a/Documentation/admin-guide/kernel-parameters.rst
@@ -76,6 +76,11 @@ to change, such as less cores in the CPU
 will also change.  Use the same on a small 4 core system, and "16-N" becomes
 "16-3" and now the same boot input will be flagged as invalid (start > end).
 
+The special case-tolerant group name "all" has a meaning of selecting all CPUs,
+such that "isolcpus=all" is the equivalent of "isolcpus=0-N".
+
+The semantics of "N" and "all" is supported on a level of bitmaps and holds for
+all users of bitmap_parse().
 
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
--- a/lib/bitmap.c~bitmap_parse-support-all-semantics
+++ a/lib/bitmap.c
@@ -581,6 +581,14 @@ static const char *bitmap_parse_region(c
 {
 	unsigned int lastbit = r->nbits - 1;
 
+	if (!strncasecmp(str, "all", 3)) {
+		r->start = 0;
+		r->end = lastbit;
+		str += 3;
+
+		goto check_pattern;
+	}
+
 	str = bitmap_getnum(str, &r->start, lastbit);
 	if (IS_ERR(str))
 		return str;
@@ -595,6 +603,7 @@ static const char *bitmap_parse_region(c
 	if (IS_ERR(str))
 		return str;
 
+check_pattern:
 	if (end_of_region(*str))
 		goto no_pattern;
 
--- a/lib/test_bitmap.c~bitmap_parse-support-all-semantics
+++ a/lib/test_bitmap.c
@@ -366,6 +366,13 @@ static const struct test_bitmap_parselis
 	{0, "0-31:1/3,1-31:1/3,2-31:1/3",	&exp1[8 * step], 32, 0},
 	{0, "1-10:8/12,8-31:24/29,0-31:0/3",	&exp1[9 * step], 32, 0},
 
+	{0,	  "all",		&exp1[8 * step], 32, 0},
+	{0,	  "0, 1, all,  ",	&exp1[8 * step], 32, 0},
+	{0,	  "all:1/2",		&exp1[4 * step], 32, 0},
+	{0,	  "ALL:1/2",		&exp1[4 * step], 32, 0},
+	{-EINVAL, "al", NULL, 8, 0},
+	{-EINVAL, "alll", NULL, 8, 0},
+
 	{-EINVAL, "-1",	NULL, 8, 0},
 	{-EINVAL, "-0",	NULL, 8, 0},
 	{-EINVAL, "10-1", NULL, 8, 0},
_

Patches currently in -mm which might be from yury.norov@gmail.com are

bitmap_parse-support-all-semantics.patch
rcu-tree_plugin-dont-handle-the-case-of-all-cpu-range.patch


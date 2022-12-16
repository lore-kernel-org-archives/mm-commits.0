Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A512BC3DA6E
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiLPX7r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiLPX7n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E9F7262C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EED0B81E29
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06C1C433D2;
        Fri, 16 Dec 2022 23:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235174;
        bh=CD6U+LtTc02zjJE0nq0WrT4I5ZbeDE4h9NDaokmwp4Q=;
        h=Date:To:From:Subject:From;
        b=VrT8IbJ/2EtBy3KV8tRrQKAj8aDEPcSdaFp6edhSwLwaWQmq2ZpIJbXTakzafRzbT
         9DOD0LkiueW3clk0wHVmMzNu5poY/HntjEoQLCcOiUTos0wGA0O6yoJCCHNt4MedNG
         RGSrfOddSGXok5xu5lZyhP/+V25DBC3PjJ9fw5kg=
Date:   Fri, 16 Dec 2022 15:59:34 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch added to mm-unstable branch
Message-Id: <20221216235934.C06C1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: add a parameter called skip_anon for avoiding anonymous pages reclamation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: add a parameter called skip_anon for avoiding anonymous pages reclamation
Date: Mon, 5 Dec 2022 23:08:22 +0000

In some cases, for example if users have confidence at anonymous pages
management or the swap device is too slow, users would want to avoid
DAMON_RECLAIM swapping the anonymous pages out.  For such case, add yet
another DAMON_RECLAIM parameter, namely 'skip_anon'.  When it is set as
'Y', DAMON_RECLAIM will avoid reclaiming anonymous pages using a DAMOS
filter.

Link: https://lkml.kernel.org/r/20221205230830.144349-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation
+++ a/mm/damon/reclaim.c
@@ -99,6 +99,15 @@ static unsigned long monitor_region_end
 module_param(monitor_region_end, ulong, 0600);
 
 /*
+ * Skip anonymous pages reclamation.
+ *
+ * If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+ * pages.  By default, ``N``.
+ */
+static bool skip_anon __read_mostly;
+module_param(skip_anon, bool, 0600);
+
+/*
  * PID of the DAMON thread
  *
  * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
@@ -142,6 +151,7 @@ static struct damos *damon_reclaim_new_s
 static int damon_reclaim_apply_parameters(void)
 {
 	struct damos *scheme;
+	struct damos_filter *filter;
 	int err = 0;
 
 	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
@@ -152,6 +162,15 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		return -ENOMEM;
+	if (skip_anon) {
+		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+		if (!filter) {
+			/* Will be freed by next 'damon_set_schemes()' below */
+			damon_destroy_scheme(scheme);
+			return -ENOMEM;
+		}
+		damos_add_filter(scheme, filter);
+	}
 	damon_set_schemes(ctx, &scheme, 1);
 
 	return damon_set_region_biggest_system_ram_default(target,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch


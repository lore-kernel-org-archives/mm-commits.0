Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DE3C3DA71
	for <mm-commits@archiver.kernel.org>; Sat, 17 Dec 2022 00:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiLQAAT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 19:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiLPX7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E84273B31
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22845B81E29
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE638C433F1;
        Fri, 16 Dec 2022 23:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235188;
        bh=FCdXHmNEfkCaHjXD+eo+4aga99x9H3jxS/vxmWKpmAg=;
        h=Date:To:From:Subject:From;
        b=h0QSOy4ftWpctNrLQ4F4bPuh2LWHO4kYOomwA8BdNKloZesXZT+laI0hVcaRwdNO7
         +B2ya2Tidk50PNlVeraClStqR8cWBdcSJQEgHEeZr9ABauu++jY2fJ6zid7p1xyTPU
         4WEtkJSeBjMdWmyx0JOPNQqDRKHQMzYQ8oyybfdM=
Date:   Fri, 16 Dec 2022 15:59:48 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch added to mm-unstable branch
Message-Id: <20221216235948.CE638C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document DAMOS filters of sysfs
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document DAMOS filters of sysfs
Date: Mon, 5 Dec 2022 23:08:29 +0000

Document about the newly added files for DAMOS filters on the DAMON usage
document.

Link: https://lkml.kernel.org/r/20221205230830.144349-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   48 ++++++++++++++++-
 1 file changed, 46 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -87,6 +87,8 @@ comma (","). ::
     │ │ │ │ │ │ │ quotas/ms,bytes,reset_interval_ms
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ watermarks/metric,interval_us,high,mid,low
+    │ │ │ │ │ │ │ filters/nr_filters
+    │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
     │ │ │ │ │ │ │ stats/nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
     │ │ │ │ │ │ │ tried_regions/
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age
@@ -151,6 +153,8 @@ number (``N``) to the file creates the n
 moment, only one context per kdamond is supported, so only ``0`` or ``1`` can
 be written to the file.
 
+.. _sysfs_contexts:
+
 contexts/<N>/
 -------------
 
@@ -268,8 +272,8 @@ schemes/<N>/
 ------------
 
 In each scheme directory, five directories (``access_pattern``, ``quotas``,
-``watermarks``, ``stats``, and ``tried_regions``) and one file (``action``)
-exist.
+``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and one file
+(``action``) exist.
 
 The ``action`` file is for setting and getting what action you want to apply to
 memory regions having specific access pattern of the interest.  The keywords
@@ -347,6 +351,46 @@ as below.
 
 The ``interval`` should written in microseconds unit.
 
+schemes/<N>/filters/
+--------------------
+
+Users could know something more than the kernel for specific types of memory.
+In the case, users could do their own management for the memory and hence
+doesn't want DAMOS bothers that.  Users could limit DAMOS by setting the access
+pattern of the scheme and/or the monitoring regions for the purpose, but that
+can be inefficient in some cases.  In such cases, users could set non-access
+pattern driven filters using files in this directory.
+
+In the beginning, this directory has only one file, ``nr_filters``.  Writing a
+number (``N``) to the file creates the number of child directories named ``0``
+to ``N-1``.  Each directory represents each filter.  The filters are evaluated
+in the numeric order.
+
+Each filter directory contains three files, namely ``type``, ``matcing``, and
+``memcg_path``.  You can write one of two special keywords, ``anon`` for
+anonymous pages, or ``memcg`` for specific memory cgroup filtering.  In case of
+the memory cgroup filtering, you can specify the memory cgroup of the interest
+by writing the path of the memory cgroup from the cgroups mount point to
+``memcg_path`` file.  You can write ``Y`` or ``N`` to ``matching`` file to
+filter out pages that does or does not match to the type, respectively.  Then,
+the scheme's action will not be applied to the pages that specified to be
+filtered out.
+
+For example, below restricts a DAMOS action to be applied to only non-anonymous
+pages of all memory cgroups except ``/having_care_already``.::
+
+    # echo 2 > nr_filters
+    # # filter out anonymous pages
+    echo anon > 0/type
+    echo Y > 0/matching
+    # # further filter out all cgroups except one at '/having_care_already'
+    echo memcg > 1/type
+    echo /having_care_already > 1/memcg_path
+    echo N > 1/matching
+
+Note that filters could be ignored depend on the running DAMON operations set
+`implementation <sysfs_contexts>`.
+
 .. _sysfs_schemes_stats:
 
 schemes/<N>/stats/
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


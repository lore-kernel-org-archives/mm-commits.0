Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229E4C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBCGfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjBCGfW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E260EF9C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B5AD61D9D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A18C433EF;
        Fri,  3 Feb 2023 06:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406118;
        bh=L5KpBlB9RmzDci67Jx79KI6ezmF8FYrDY3uj2Zx+4nI=;
        h=Date:To:From:Subject:From;
        b=0wj9jLV5Xqk//+qJPRPaBFDF/XbOadYNeTLB/hqF2Ui0LMTUBOxKy7gwpM+RH0Uld
         S1ghTBYgvmMscKr9vj9xlRFe9cNSZDpj82qU9mz6l7dy2y2d3lffqKQxqKGm6rnh+m
         bD5PDMlSJ/gK8kNc4bnYw2Z2S9bFCwRezNcHdKhc=
Date:   Thu, 02 Feb 2023 22:35:17 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-index-mention-damos-on-the-intro.patch removed from -mm tree
Message-Id: <20230203063518.71A18C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/index: mention DAMOS on the intro
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-index-mention-damos-on-the-intro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/index: mention DAMOS on the intro
Date: Tue, 10 Jan 2023 19:03:55 +0000

What DAMON aims to do is not only access monitoring but efficient and
effective access-aware system operations.  And DAMon-based Operation
Schemes (DAMOS) is the important feature of DAMON for the goal.  Make the
intro of DAMON documentation to emphasize the goal and mention DAMOS.

Link: https://lkml.kernel.org/r/20230110190400.119388-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-mention-damos-on-the-intro
+++ a/Documentation/mm/damon/index.rst
@@ -4,8 +4,9 @@
 DAMON: Data Access MONitor
 ==========================
 
-DAMON is a data access monitoring framework subsystem for the Linux kernel.
-The core mechanisms of DAMON (refer to :doc:`design` for the detail) make it
+DAMON is a Linux kernel subsystem that provides a framework for data access
+monitoring and the monitoring results based system operations.  The core
+monitoring mechanisms of DAMON (refer to :doc:`design` for the detail) make it
 
  - *accurate* (the monitoring output is useful enough for DRAM level memory
    management; It might not appropriate for CPU Cache levels, though),
@@ -14,12 +15,16 @@ The core mechanisms of DAMON (refer to :
  - *scalable* (the upper-bound of the overhead is in constant range regardless
    of the size of target workloads).
 
-Using this framework, therefore, the kernel's memory management mechanisms can
-make advanced decisions.  Experimental memory management optimization works
-that incurring high data accesses monitoring overhead could implemented again.
-In user space, meanwhile, users who have some special workloads can write
-personalized applications for better understanding and optimizations of their
-workloads and systems.
+Using this framework, therefore, the kernel can operate system in an
+access-aware fashion.  Because the features are also exposed to the user space,
+users who have special information about their workloads can write personalized
+applications for better understanding and optimizations of their workloads and
+systems.
+
+For easier development of such systems, DAMON provides a feature called DAMOS
+(DAMon-based Operation Schemes) in addition to the monitoring.  Using the
+feature, DAMON users in both kernel and user spaces can do access-aware system
+operations with no code but simple configurations.
 
 .. toctree::
    :maxdepth: 2
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch


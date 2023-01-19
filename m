Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8BEC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjASBUt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjASBTc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0091B69226
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F5E361B0E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E32C433D2;
        Thu, 19 Jan 2023 01:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090985;
        bh=nwVVve4Dkhl4CEEpo9eQtluLkBkV1eY0khUR1UkAnWE=;
        h=Date:To:From:Subject:From;
        b=RW0UfdE1A5U+ynxrV7KHllot296IqIA5ZZoOscDj7k7xX9MQ6dqXb1WxBnjDrx8Gz
         nsIBNKjov42EAqcOjXK3AFjaOraLSfnVfXGznv55TVkcJbpc/q87w3fc1b87HxeYyR
         en3lXQEX74cbvKmckCIYgPq+TdIS8eFi/PNR2h80=
Date:   Wed, 18 Jan 2023 17:16:24 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch removed from -mm tree
Message-Id: <20230119011624.E9E32C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/numaperf: increase depth of subsections
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/numaperf: increase depth of subsections
Date: Tue, 3 Jan 2023 18:07:54 +0000

Each section of numaperf.rst has zero depth, and therefore be exposed to
the index of admin-guide/mm.  Especially 'See Also' section on the index
makes the document weird.  Hide the sections from the index by giving the
document a title and increasing the depth of each section.

[sj@kernel.org: change title to fix duplicate label warning]
  Link: https://lkml.kernel.org/r/20230106194927.152663-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230103180754.129637-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/numaperf.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/numaperf.rst~docs-admin-guide-mm-numaperf-increase-depth-of-subsections
+++ a/Documentation/admin-guide/mm/numaperf.rst
@@ -1,6 +1,9 @@
 .. _numaperf:
 
-=============
+=======================
+NUMA Memory Performance
+=======================
+
 NUMA Locality
 =============
 
@@ -61,7 +64,6 @@ that are CPUs and hence suitable for gen
 IO initiators such as GPUs and NICs.  Unlike access class 0, only
 nodes containing CPUs are considered.
 
-================
 NUMA Performance
 ================
 
@@ -96,7 +98,6 @@ for the platform.
 Access class 1 takes the same form but only includes values for CPU to
 memory activity.
 
-==========
 NUMA Cache
 ==========
 
@@ -170,7 +171,6 @@ The "size" is the number of bytes provid
 The "write_policy" will be 0 for write-back, and non-zero for
 write-through caching.
 
-========
 See Also
 ========
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch


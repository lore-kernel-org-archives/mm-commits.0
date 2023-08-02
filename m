Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167CBC001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjHBVwB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjHBVv5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:51:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6002FE7D
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E874761B24
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E71C433C8;
        Wed,  2 Aug 2023 21:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691013115;
        bh=3i9bMQWNhx95cOxlmTuXa243d3DHHRR5aUe/AiRsKV4=;
        h=Date:To:From:Subject:From;
        b=mWi4H+7xz9LXB6pVa5Gkpr9Z0gUlPA9KlMsY6Cns/AFLThTn3/acFdXBkdFqmZ1Gb
         0eWZVeBR4HGdGhTi9+0Hx+1/ClY9SvofePWF+/6GuxgB6dpc5cMJ63zGHrO4qo0nbd
         318EJ9Bcvqf7TKHWQPkVYwR3oe3CjHltt+ouY2hA=
Date:   Wed, 02 Aug 2023 14:51:54 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-update-for-address-range-damos-filter.patch added to mm-unstable branch
Message-Id: <20230802215155.48E71C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/ABI/damon: update for address range DAMOS filter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-update-for-address-range-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-address-range-damos-filter.patch

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
Subject: Docs/ABI/damon: update for address range DAMOS filter
Date: Wed, 2 Aug 2023 21:43:05 +0000

Update DAMON ABI document for address ranges type DAMOS filter files.

Link: https://lkml.kernel.org/r/20230802214312.110532-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   20 ++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-address-range-damos-filter
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -271,8 +271,9 @@ What:		/sys/kernel/mm/damon/admin/kdamon
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
-		the memory of the interest.  'anon' for anonymous pages, or
-		'memcg' for specific memory cgroup can be written and read.
+		the memory of the interest.  'anon' for anonymous pages,
+		'memcg' for specific memory cgroup, or 'addr' for address range
+		(an open-ended interval) can be written and read.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
 Date:		Dec 2022
@@ -281,6 +282,21 @@ Description:	If 'memcg' is written to th
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_start
+Date:		Jul 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'addr' is written to the 'type' file, writing to or reading
+		from this file sets or gets the start address of the address
+		range for the filter.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_end
+Date:		Jul 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'addr' is written to the 'type' file, writing to or reading
+		from this file sets or gets the end address of the address
+		range for the filter.
+
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/matching
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch
mm-damon-core-introduce-address-range-type-damos-filter.patch
mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch
mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch
selftests-damon-sysfs-test-address-range-damos-filter.patch
docs-mm-damon-design-update-for-address-range-filters.patch
docs-abi-damon-update-for-address-range-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch
mm-damon-core-implement-target-type-damos-filter.patch
mm-damon-sysfs-schemes-support-target-damos-filter.patch
selftests-damon-sysfs-test-damon_target-filter.patch
docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch
docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch


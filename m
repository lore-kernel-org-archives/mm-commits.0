Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE799C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiB1TtV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiB1TtD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:49:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2BAEF7BD
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:47:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1619D615B8
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68847C340F1;
        Mon, 28 Feb 2022 19:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646077664;
        bh=yJKCZwjTk9wtcqZotJdUbJbFFw/NHYv0j5a1D9kFQm0=;
        h=Date:To:From:Subject:From;
        b=UCsK9F4GmYVOYrideZj+6qWCAFkuK65ypD/L1FSxeCWzcXwVWCqrd79oAJ1urEzdF
         hibwBG1kbT8ZvQz9zel6/XMCaDLOdo+7KG9SJ2tx8Vp6Bh0l1rXBUS7zjJ1D1rRrKX
         Rz+cPYHeGsZXNgnw4cG8BMg4BNW0Es4jhgslhmjI=
Date:   Mon, 28 Feb 2022 11:47:43 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        skhan@linuxfoundation.org, rientjes@google.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-number-of-each-enum-type-values.patch added to -mm tree
Message-Id: <20220228194744.68847C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: add number of each enum type values
has been added to the -mm tree.  Its filename is
     mm-damon-core-add-number-of-each-enum-type-values.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-add-number-of-each-enum-type-values.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-add-number-of-each-enum-type-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add number of each enum type values

This commit declares the number of legal values for each DAMON enum types
to make traversals of such DAMON enum types easy and safe.

Link: https://lkml.kernel.org/r/20220228081314.5770-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-add-number-of-each-enum-type-values
+++ a/include/linux/damon.h
@@ -87,6 +87,7 @@ struct damon_target {
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_STAT:		Do nothing but count the stat.
+ * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  */
 enum damos_action {
 	DAMOS_WILLNEED,
@@ -95,6 +96,7 @@ enum damos_action {
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
+	NR_DAMOS_ACTIONS,
 };
 
 /**
@@ -157,10 +159,12 @@ struct damos_quota {
  *
  * @DAMOS_WMARK_NONE:		Ignore the watermarks of the given scheme.
  * @DAMOS_WMARK_FREE_MEM_RATE:	Free memory rate of the system in [0,1000].
+ * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
  */
 enum damos_wmark_metric {
 	DAMOS_WMARK_NONE,
 	DAMOS_WMARK_FREE_MEM_RATE,
+	NR_DAMOS_WMARK_METRICS,
 };
 
 /**
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch
docs-vm-damon-call-low-level-monitoring-primitives-the-operations.patch
docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch
docs-damon-update-outdated-term-regions-update-interval.patch
mm-damon-core-allow-non-exclusive-damon-start-stop.patch
mm-damon-core-add-number-of-each-enum-type-values.patch
mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface.patch
mm-damon-sysfs-link-damon-for-virtual-address-spaces-monitoring.patch
mm-damon-sysfs-support-the-physical-address-space-monitoring.patch
mm-damon-sysfs-support-damon-based-operation-schemes.patch
mm-damon-sysfs-support-damos-quotas.patch
mm-damon-sysfs-support-schemes-prioritization.patch
mm-damon-sysfs-support-damos-watermarks.patch
mm-damon-sysfs-support-damos-stats.patch
selftests-damon-add-a-test-for-damon-sysfs-interface.patch
docs-admin-guide-mm-damon-usage-document-damon-sysfs-interface.patch
docs-abi-testing-add-damon-sysfs-interface-abi-document.patch


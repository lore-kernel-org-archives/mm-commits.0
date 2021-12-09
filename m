Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF3DC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhLIUgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhLIUgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:36:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87958C061746
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 12:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EF1DB82645
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F5FC004DD;
        Thu,  9 Dec 2021 20:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081949;
        bh=OV88nL5GLBWpZ4Z/IqoJ1GBa4aW6dS5/s72zLYYP+h0=;
        h=Date:From:To:Subject:From;
        b=xzhP89VUt7GWbut4+2xZUr6GGJAZQQtDaKvrNIdz15qrqtzSYlMJBNyzb4rKtUJqG
         AmU0M39cLFtS9li3C7tMBlLLTzjzBMVOrBrrzRqOekQF/kFGsDYllgfZtQvvvlTWwj
         /YS+XD/1JPoIMQM7rhSn7DZmH+k4JflWATza/rD8=
Date:   Thu, 09 Dec 2021 12:32:28 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
 added to -mm tree
Message-ID: <20211209203228.uWw8AbsBE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: mention tracepoint at the beginning
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch

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
Subject: Docs/admin-guide/mm/damon/usage: mention tracepoint at the beginning

To get detailed monitoring results from the user space, users need to use
the damon_aggregated tracepoint.  This commit adds a brief mention of it
at the beginning of the usage document.

Link: https://lkml.kernel.org/r/20211209131806.19317-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -21,7 +21,10 @@ DAMON provides below three interfaces fo
   you can write and use your personalized DAMON debugfs wrapper programs that
   reads/writes the debugfs files instead of you.  The `DAMON user space tool
   <https://github.com/awslabs/damo>`_ is one example of such programs.  It
-  supports both virtual and physical address spaces monitoring.
+  supports both virtual and physical address spaces monitoring.  Note that this
+  interface provides only simple :ref:`statistics <damos_stats>` for the
+  monitoring results.  For detailed monitoring results, DAMON provides a
+  :ref:`tracepoint <tracepoint>`.
 - *Kernel Space Programming Interface.*
   :doc:`This </vm/damon/api>` is for kernel space programmers.  Using this,
   users can utilize every feature of DAMON most flexibly and efficiently by
@@ -215,6 +218,8 @@ If the value is higher than ``<high mark
 scheme is deactivated.  If the value is lower than ``<mid mark>``, the scheme
 is activated.
 
+.. _damos_stats:
+
 Statistics
 ~~~~~~~~~~
 
@@ -268,6 +273,8 @@ the monitoring is turned on.  If you wri
 an error code such as ``-EBUSY`` will be returned.
 
 
+.. _tracepoint:
+
 Tracepoint for Monitoring Results
 =================================
 
_

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063ECC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhLIUgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbhLIUgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:36:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73B4C061746
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 12:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F14ACE25F1
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23826C004DD;
        Thu,  9 Dec 2021 20:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081951;
        bh=G8PoFTjclPXXeIhaHial3v1TKQ2xfVUEB4EsMopS9ic=;
        h=Date:From:To:Subject:From;
        b=jI6AzDiaLZl8NhT6ZP9WqfEUM7HHwY3xtvvVKyxE67jhTl25JD0qwBc21uk+IxKXj
         JPrAJrLFp9u+YCM9TJYj9h1GlWOHXE6RbYZIgTCFM63scqqokus3gNEx60SRipaZ+L
         VFiXhkd6tq9GgPJjWysLEZ7PJBWK9nC2+DounCuI=
Date:   Thu, 09 Dec 2021 12:32:30 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 =?US-ASCII?Q?docs-admin-guide-mm-damon-usage-update-for-kdamond=5Fpid-and?=
 =?US-ASCII?Q?-mkrm=5Fcontexts.patch?= added to -mm tree
Message-ID: <20211209203230.WkKl_jitY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for kdamond_pid and (mk|rm)_contexts
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for kdamond_pid and (mk|rm)_contexts

The DAMON debugfs usage document is missing descriptions for
'kdamond_pid', 'mk_contexts', and 'rm_contexts' debugfs files.  This
commit adds those.

Link: https://lkml.kernel.org/r/20211209131806.19317-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   52 ++++++++++++++++-
 1 file changed, 49 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -38,9 +38,9 @@ DAMON provides below three interfaces fo
 debugfs Interface
 =================
 
-DAMON exports five files, ``attrs``, ``target_ids``, ``init_regions``,
-``schemes`` and ``monitor_on`` under its debugfs directory,
-``<debugfs>/damon/``.
+DAMON exports eight files, ``attrs``, ``target_ids``, ``init_regions``,
+``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts`` and
+``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
 
 
 Attributes
@@ -273,6 +273,52 @@ the monitoring is turned on.  If you wri
 an error code such as ``-EBUSY`` will be returned.
 
 
+Monitoring Thread PID
+---------------------
+
+DAMON does requested monitoring with a kernel thread called ``kdamond``.  You
+can get the pid of the thread by reading the ``kdamond_pid`` file.  When the
+monitoring is turned off, reading the file returns ``none``. ::
+
+    # cd <debugfs>/damon
+    # cat monitor_on
+    off
+    # cat kdamond_pid
+    none
+    # echo on > monitor_on
+    # cat kdamond_pid
+    18594
+
+
+Using Multiple Monitoring Threads
+---------------------------------
+
+One ``kdamond`` thread is created for each monitoring context.  You can create
+and remove monitoring contexts for multiple ``kdamond`` required use case using
+the ``mk_contexts`` and ``rm_contexts`` files.
+
+Writing the name of the new context to the ``mk_contexts`` file creates a
+directory of the name on the DAMON debugfs directory.  The directory will have
+DAMON debugfs files for the context. ::
+
+    # cd <debugfs>/damon
+    # ls foo
+    # ls: cannot access 'foo': No such file or directory
+    # echo foo > mk_contexts
+    # ls foo
+    # attrs  init_regions  kdamond_pid  schemes  target_ids
+
+If the context is not needed anymore, you can remove it and the corresponding
+directory by putting the name of the context to the ``rm_contexts`` file. ::
+
+    # echo foo > rm_contexts
+    # ls foo
+    # ls: cannot access 'foo': No such file or directory
+
+Note that ``mk_contexts``, ``rm_contexts``, and ``monitor_on`` files are in the
+root directory only.
+
+
 .. _tracepoint:
 
 Tracepoint for Monitoring Results
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


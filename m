Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C91C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbiATV2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377898AbiATV2q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BE4C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 040CEB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97210C340E0;
        Thu, 20 Jan 2022 21:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714122;
        bh=jrq4H+3b8weu/gJaGvwfq582IyPpFw00N/fvx/a6zZI=;
        h=Date:From:To:Subject:From;
        b=pG6BDnV4c4t0x2T1m7QQENrXpoW7xtxOHlqFYxn9MyEqxy09XSVO1rOBJFBDVD53G
         ol/C7COdv+nswIu9rLMVBbNhO01NsJezTkJ8lvOqlx0UiQuull213IwDbA9Scb7g0K
         mMZbv8l9fR7rlnLY5kyDkrZ57OFOu7uBn2CAECDQ=
Date:   Thu, 20 Jan 2022 13:28:42 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?docs-admin-guide-mm-damon-usage-update-for-kdamond=5Fpid-and?=
 =?US-ASCII?Q?-mkrm=5Fcontexts.patch?= removed from -mm tree
Message-ID: <20220120212842.ev8W7pI5p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for kdamond_pid and (mk|rm)_contexts
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



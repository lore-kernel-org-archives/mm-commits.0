Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7178EC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiANWKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiANWKP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428ABC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6194CE19A9
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89C9C36AE5;
        Fri, 14 Jan 2022 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198212;
        bh=bqJOBv3bz137w2s4IpkvD2KdNttFcPuPeJVeiFVERwY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W3uv4CXTxJtVns/FsnMteprPuEzzvGEAHMq3KB3nSD3NoOGYKqvgpnRUvbxh0rBng
         UdBdw800XiP7VxqNKy/jSs/gNfQDT6iM9UdLXEoz3ByIw6bYwXfWE4+4cyAFX0P/gq
         HpvPTD/d3Uo73JfD2mQuhxRgKn2Pw9VO1LEh2Kiw=
Date:   Fri, 14 Jan 2022 14:10:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 133/146] Docs/admin-guide/mm/damon/usage: update
 for kdamond_pid and (mk|rm)_contexts
Message-ID: <20220114221011.W00hsuTTA%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

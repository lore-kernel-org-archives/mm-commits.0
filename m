Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9578C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F606128E
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhKEUtb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhKEUta (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:49:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 458F26126A;
        Fri,  5 Nov 2021 20:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145210;
        bh=RcTA1AudXgXH9EMTrgmQoWw5+SCP6irYLWzXAWwE4GY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XiK25w98qyvz3HgDp69ZqPvFamWBI8AN+BXPwGvvfxPdE145ikuPJFuV84tlqj8aw
         JWYeBWXLq1powsv2ZWjjGnxD83JhvA2T1amKPW6mG+yQDPdq4qS9OiqUYuGFRMXhz/
         1THNiUrzR2iQe/vRccK0c4KFXLLBR9/TnZqvb/Tg=
Date:   Fri, 05 Nov 2021 13:46:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, brendanhiggins@google.com,
        corbet@lwn.net, david@redhat.com, dwmw@amazon.com,
        elver@google.com, foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, linux-mm@kvack.org, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 232/262] Docs/admin-guide/mm/damon: document
 'init_regions' feature
Message-ID: <20211105204649.5UJA8W9k3%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon: document 'init_regions' feature

This commit adds description of the 'init_regions' feature in the DAMON
usage document.

Link: https://lkml.kernel.org/r/20211012205711.29216-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   41 ++++++++++++++++-
 1 file changed, 39 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-document-init_regions-feature
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -34,8 +34,9 @@ the reason, this document describes only
 debugfs Interface
 =================
 
-DAMON exports four files, ``attrs``, ``target_ids``, ``schemes`` and
-``monitor_on`` under its debugfs directory, ``<debugfs>/damon/``.
+DAMON exports five files, ``attrs``, ``target_ids``, ``init_regions``,
+``schemes`` and ``monitor_on`` under its debugfs directory,
+``<debugfs>/damon/``.
 
 
 Attributes
@@ -74,6 +75,42 @@ check it again::
 Note that setting the target ids doesn't start the monitoring.
 
 
+Initial Monitoring Target Regions
+---------------------------------
+
+In case of the debugfs based monitoring, DAMON automatically sets and updates
+the monitoring target regions so that entire memory mappings of target
+processes can be covered.  However, users can want to limit the monitoring
+region to specific address ranges, such as the heap, the stack, or specific
+file-mapped area.  Or, some users can know the initial access pattern of their
+workloads and therefore want to set optimal initial regions for the 'adaptive
+regions adjustment'.
+
+In such cases, users can explicitly set the initial monitoring target regions
+as they want, by writing proper values to the ``init_regions`` file.  Each line
+of the input should represent one region in below form.::
+
+    <target id> <start address> <end address>
+
+The ``target id`` should already in ``target_ids`` file, and the regions should
+be passed in address order.  For example, below commands will set a couple of
+address ranges, ``1-100`` and ``100-200`` as the initial monitoring target
+region of process 42, and another couple of address ranges, ``20-40`` and
+``50-100`` as that of process 4242.::
+
+    # cd <debugfs>/damon
+    # echo "42   1       100
+            42   100     200
+            4242 20      40
+            4242 50      100" > init_regions
+
+Note that this sets the initial monitoring target regions only.  In case of
+virtual memory monitoring, DAMON will automatically updates the boundary of the
+regions after one ``regions update interval``.  Therefore, users should set the
+``regions update interval`` large enough in this case, if they don't want the
+update.
+
+
 Schemes
 -------
 
_

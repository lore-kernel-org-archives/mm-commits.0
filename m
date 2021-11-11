Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8A0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62FF6135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhKKCwL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCwJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88D8661108;
        Thu, 11 Nov 2021 02:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598961;
        bh=Emrv3Ggm2AtuTfeABLh7TEeZk+fEHYX3FWVIbFd9zO8=;
        h=Date:From:To:Subject:From;
        b=Hlt8giI449KuWl5PAim2O8bFPradv18GiV/TdrDQeSaqyvyiHkXb/M2f/6SE8rjnv
         CLllEzssczqYS3jlUY9JPF+dly8YgRqL3kXeYK9GfoAqtWJYk8U2H5DB/Ku5tI6Ml+
         hLtJEE3DJGbNEk+02Rozkc0x44DPaRdWpHWIwwZ4=
Date:   Wed, 10 Nov 2021 18:49:20 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-document-init_regions-feature.patch removed from
 -mm tree
Message-ID: <20211111024920.pbLZsIVma%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon: document 'init_regions' feature
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-document-init_regions-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are



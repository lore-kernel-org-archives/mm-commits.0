Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914EDC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74BEA61152
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJMWyZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 18:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhJMWyX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 18:54:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F160F6101E;
        Wed, 13 Oct 2021 22:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634165539;
        bh=o9wuuo1/XsLtXcEEcAAWhX7uD/ybU2f7tHa8xV6XZBA=;
        h=Date:From:To:Subject:From;
        b=I2j6JXzxWDGTnEk2kXMKz1Nocmw9DYWYhrVStm2lPTk0UcjhtUkh2QpBQzpZiV0ie
         dVA4ZtRx7Jl7kZQw1VmAmfUMoID53KsT5Z+qH4lh0OoJw5+DL7ql0iB8Q72FKeHFA+
         aMVkhXUiuHdHon/BUA+RJhArLE21/W3Z8N544PF4=
Date:   Wed, 13 Oct 2021 15:52:18 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  +
 docs-admin-guide-mm-damon-document-init_regions-feature.patch added to -mm
 tree
Message-ID: <20211013225218.Qu1_I0lGK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon: document 'init_regions' feature
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-document-init_regions-feature.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-document-init_regions-feature.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-document-init_regions-feature.patch

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

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch


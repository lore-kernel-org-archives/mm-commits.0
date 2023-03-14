Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C28C05027
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 20:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCNUxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 16:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNUxT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 16:53:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B2A1A660
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 13:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDF07614A5
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 20:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D912C433D2;
        Tue, 14 Mar 2023 20:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678827197;
        bh=Z0lcU7+pLCRyfCJNoe+Qk1sd+VbjVG0AtXnhTlidzXM=;
        h=Date:To:From:Subject:From;
        b=IpsFrEPK/NLUFg9Iqt4KNQ/gt3ApO1hRBpmCwK5CqynzmMPdw1muORTUCD+T1F5jx
         069DTz7AqMK+00xgsOKmQpaZu56HfwJPOYM8K5GHJiAtWJMP2eNBkbTyMkHKdvqqsf
         EgIAeo59Ks81ptxyfbQMMYOHVJrCwpZexssm0gxE=
Date:   Tue, 14 Mar 2023 13:53:16 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, mhocko@suse.com,
        hannes@cmpxchg.org, david@redhat.com, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-extend-ksm-doc.patch added to mm-unstable branch
Message-Id: <20230314205317.3D912C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/mm: extend ksm doc
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-extend-ksm-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-extend-ksm-doc.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: docs/mm: extend ksm doc
Date: Tue, 14 Mar 2023 13:45:57 -0700

This adds a description of the new prctl interface for KSM and also adds a
general section on security concerns.

Link: https://lkml.kernel.org/r/20230314204557.3863923-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/mm/ksm.rst~docs-mm-extend-ksm-doc
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -20,13 +20,15 @@ content which can be replaced by a singl
 is automatically copied if a process later wants to update its
 content). The amount of pages that KSM daemon scans in a single pass
 and the time between the passes are configured using :ref:`sysfs
-intraface <ksm_sysfs>`
+interface <ksm_sysfs>`
 
 KSM only merges anonymous (private) pages, never pagecache (file) pages.
 KSM's merged pages were originally locked into kernel memory, but can now
 be swapped out just like other user pages (but sharing is broken when they
 are swapped back in: ksmd must rediscover their identity and merge again).
 
+.. _ksm_madvise:
+
 Controlling KSM with madvise
 ============================
 
@@ -68,6 +70,43 @@ Applications should be considerate in th
 restricting its use to areas likely to benefit.  KSM's scans may use a lot
 of processing power: some installations will disable KSM for that reason.
 
+Controlling KSM with prctl
+============================
+
+KSM can be enabled for a process or a cgroup, by using the prctl(2) system
+call::
+
+	int prctl(PR_SET_MEMORY_MERGE, 1)
+
+The app may call
+
+::
+
+	int prctl(PR_SET_MEMORY_MERGE, 0)
+
+to cancel that advice and restore unshared pages: whereupon KSM
+unmerges whatever is merged for that process.  Note: this unmerging call
+may suddenly require more memory than is available - possibly failing
+with EAGAIN, but more probably arousing the Out-Of-Memory killer.
+
+The restrictions mentioned in :ref:`Controlling KSM with madvise <ksm_madvise>`'
+also apply here. Also consider the security implications of using KSM.
+
+KSM security concerns
+=======================
+
+KSM has the possibility of memory side channel attacks. When individual
+VMA's have KSM enabled, the security aspect needs to be considered.
+
+An individual workload doesn't know what else is running on
+the machine, so it needs to be highly conservative about what it can
+give up for system-wide merging.
+
+However, if the system is dedicated to running multiple jobs within the
+same security domain, there is a usecase where multiple instances of the
+same job are running inside a safe shared security domain and using the
+same sensitive data.
+
 .. _ksm_sysfs:
 
 KSM daemon sysfs interface
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-add-tracepoints-to-ksm.patch
mm-add-new-api-to-enable-ksm-per-process.patch
mm-add-new-ksm-process-and-sysfs-knobs.patch
selftests-mm-add-new-selftests-for-ksm.patch
docs-mm-extend-ksm-doc.patch


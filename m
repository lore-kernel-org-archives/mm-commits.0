Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F60C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353229AbiA2VlX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:41:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47978 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353214AbiA2VlU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:41:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EABCB82812
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1CFC340E5;
        Sat, 29 Jan 2022 21:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492478;
        bh=i931nSJLzi5MhRxxg/21FURRXgt4mDNd0VRjTte9vxI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=O+INIFp7qwRTC+J3bvVOdeKfeuNDJ4GeMUhWPhp5TjUurfaYSVtsTRMkXqU22PwhT
         vsbtFLkLjxCFTWSxZmmzim9vh2hA1CJ48Rd3Gh+h1SxdB6XRaDGVROtrfdTNd5NZqv
         gbsIky6D+88dRxcgkFn4vP5a5XZWqzEVR8xeBqG4=
Date:   Sat, 29 Jan 2022 13:41:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        lkp@intel.com, mm-commits@vger.kernel.org, surenb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 09/12] psi: fix "no previous prototype" warnings
 when CONFIG_CGROUPS=n
Message-ID: <20220129214117.ce7iVzoIA%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>
Subject: psi: fix "no previous prototype" warnings when CONFIG_CGROUPS=n

When CONFIG_CGROUPS is disabled psi code generates the following warnings:

kernel/sched/psi.c:1112:21: warning: no previous prototype for 'psi_trigger_create' [-Wmissing-prototypes]
    1112 | struct psi_trigger *psi_trigger_create(struct psi_group *group,
         |                     ^~~~~~~~~~~~~~~~~~
kernel/sched/psi.c:1182:6: warning: no previous prototype for 'psi_trigger_destroy' [-Wmissing-prototypes]
    1182 | void psi_trigger_destroy(struct psi_trigger *t)
         |      ^~~~~~~~~~~~~~~~~~~
kernel/sched/psi.c:1249:10: warning: no previous prototype for 'psi_trigger_poll' [-Wmissing-prototypes]
    1249 | __poll_t psi_trigger_poll(void **trigger_ptr,
         |          ^~~~~~~~~~~~~~~~

Change declarations of these functions in the header to provide the
prototypes even when they are unused.

Link: https://lkml.kernel.org/r/20220119223940.787748-2-surenb@google.com
Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/psi.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/include/linux/psi.h~psi-fix-no-previous-prototype-warnings-when-config_cgroups=n
+++ a/include/linux/psi.h
@@ -25,18 +25,17 @@ void psi_memstall_enter(unsigned long *f
 void psi_memstall_leave(unsigned long *flags);
 
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
-
-#ifdef CONFIG_CGROUPS
-int psi_cgroup_alloc(struct cgroup *cgrp);
-void psi_cgroup_free(struct cgroup *cgrp);
-void cgroup_move_task(struct task_struct *p, struct css_set *to);
-
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
 void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
+
+#ifdef CONFIG_CGROUPS
+int psi_cgroup_alloc(struct cgroup *cgrp);
+void psi_cgroup_free(struct cgroup *cgrp);
+void cgroup_move_task(struct task_struct *p, struct css_set *to);
 #endif
 
 #else /* CONFIG_PSI */
_

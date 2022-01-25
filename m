Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EC2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 07:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443775AbiAYHWA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 02:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443777AbiAYHQz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 02:16:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C108C068091
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:26:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC8B960B21
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B19C340E8;
        Tue, 25 Jan 2022 06:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091964;
        bh=W+8z+CThzHp8tdIzYRt5OHGk9P/cHJNALuroZD25SVY=;
        h=Date:From:To:Subject:From;
        b=2osfbRKAZnjfHgsupmY5VKBBIhiz5ci06hAEM74SRbysr8o0d5fcuMcDlRzERzL5/
         T5bZTmofzlvT9HBMbouZn2jXzYAmjfQOC5L5eWh6TmCqFttgRcqS4/zZ13ohvhP61A
         F1PbIQFgQrRHn907zhTgNj8ETqs/k+P7coNP3iMg=
Date:   Mon, 24 Jan 2022 22:26:03 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, lkp@intel.com, mm-commits@vger.kernel.org,
        surenb@google.com
Subject:  +
 psi-fix-no-previous-prototype-warnings-when-config_cgroups=n.patch added to
 -mm tree
Message-ID: <20220125062603.PlWJtnK1Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: psi: fix "no previous prototype" warnings when CONFIG_CGROUPS=n
has been added to the -mm tree.  Its filename is
     psi-fix-no-previous-prototype-warnings-when-config_cgroups=n.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/psi-fix-no-previous-prototype-warnings-when-config_cgroups%3Dn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/psi-fix-no-previous-prototype-warnings-when-config_cgroups%3Dn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from surenb@google.com are

psi-fix-no-previous-prototype-warnings-when-config_cgroups=n.patch
psi-fix-defined-but-not-used-warnings-when-config_proc_fs=n.patch


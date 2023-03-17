Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED75C6FD1D
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 23:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCQXcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 19:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCQXcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 19:32:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7FB59E6F
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 16:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A2FEB826EE
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 23:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AFEC433D2;
        Fri, 17 Mar 2023 23:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679095923;
        bh=I8YYDTw3IPGHfYK9bdzvScHfbVFbWRxz+CR1Jyqgxkw=;
        h=Date:To:From:Subject:From;
        b=N8tp53thPEzWfI5xQw6X3X2Z7qaHxQ+0NVc8Ci0HK4VH58wKyv8a7jQ5bl7OdmuxY
         LUXJcuRMkwDkxaDpgd5zPx1fz7igAScpWIJ1yJMB6p5N3YPF8LMcVNT5CPthjIie7b
         D6FIl9mhSqwJD54UjmaraK8/pRzzClifpWOjPfQ4=
Date:   Fri, 17 Mar 2023 16:32:02 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch added to mm-unstable branch
Message-Id: <20230317233203.B4AFEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix
Date: Fri Mar 17 04:30:24 PM PDT 2023

memcontrol.c needs sched/isolation.h

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202303180617.7E3aIlHf-lkp@intel.com/
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memcontrol.c~memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix
+++ a/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
+#include <linux/sched/isolation.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch


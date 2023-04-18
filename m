Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28726C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjDRXPV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjDRXPV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:15:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E25270E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:15:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97CAE62CF4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF65CC433EF;
        Tue, 18 Apr 2023 23:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859719;
        bh=x+Yj7eYTRZbtWu0chsw6VYn09GpMK0w2kF0T9lc01UQ=;
        h=Date:To:From:Subject:From;
        b=uff5Tl1ShyKQQnTUP+aDYQ2ZOgJZQZLdjazwauJuFCqL/XxU/a9icHyWJGytCDXi/
         TiAn+GymX7PukF6KrjpLIlKxj/KUR0idjbaG2w8D0tAB3pqDrI5B4ohGEuV/vnpXit
         4VaHRzWeuBqbSBymwF2fW4z8JAmeQPSJjVppHVo0=
Date:   Tue, 18 Apr 2023 16:15:18 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch removed from -mm tree
Message-Id: <20230418231518.EF65CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix
has been removed from the -mm tree.  Its filename was
     memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch

This patch was dropped because it was folded into memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus.patch

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

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

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

memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch


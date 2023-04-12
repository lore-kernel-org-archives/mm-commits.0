Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE89C77B6E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 19:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDLTnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 15:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDLTnZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 15:43:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091EF1738
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 12:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845AF63004
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 19:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD50C433EF;
        Wed, 12 Apr 2023 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681328602;
        bh=dAITyb6w3FOWBbFswhgnGuV5e1a/qE5oN3AS0bYk3MQ=;
        h=Date:To:From:Subject:From;
        b=rYXCiUZpWFj3YPFNWIHafUdt2JuHE0NTi1tfVL8IeqR9AIh3N5A++eoqx734FU9sg
         /xTWkDKCq1R1T6uoZRVakzlQlVM1e0ZKxmW0NBcwbesKwCNHmY3eHSTwEUuEPas/05
         kfT7Plj3CQRsIxdurkx5dUA76MB09WdHIZzYHPlY=
Date:   Wed, 12 Apr 2023 12:43:22 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        pmladek@suse.com, kbingham@kernel.org, john.ogness@linutronix.de,
        jan.kiszka@siemens.com, development@efficientek.com,
        antonio.borneo@foss.st.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230412194322.CBD50C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix
Date: Wed Apr 12 12:20:00 PM PDT 2023

add SPDX-License-Identifier

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Antonio Borneo <antonio.borneo@foss.st.com>
Cc: Glenn Washburn <development@efficientek.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/gdb/linux/proc.py~scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix
+++ a/scripts/gdb/linux/proc.py
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 #
 # gdb helper commands and functions for Linux kernel debugging
 #
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch


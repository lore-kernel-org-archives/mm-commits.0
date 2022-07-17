Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB76FC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 00:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiGQAkx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 20:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQAkw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 20:40:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D12013D38
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 17:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C468B8015A
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 00:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A17C34115;
        Sun, 17 Jul 2022 00:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658018448;
        bh=kJXmn1rIifMo7yX8D0sOBUK4pcwTl794roOpbikpguc=;
        h=Date:To:From:Subject:From;
        b=k68OAXHD+hgJIZQrkyUSOJRT9gq/uRIc8ZdK534iQ347sUt48AXslQEWk2PDVO4Dv
         SvJFCq2d9yA9RuijB0y/I92zNRKyg3W0UQZexZ4rV9gDySa2Sw9hOiwhQqGMn/LP0P
         zxO9lHlaEddD3Q3cD1N+mhQEE06pOzYtllUSjCJY=
Date:   Sat, 16 Jul 2022 17:40:48 -0700
To:     mm-commits@vger.kernel.org, Conor.Dooley@microchip.com,
        ben.dooks@sifive.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-hung_task-fix-address-space-of-proc_dohung_task_timeout_secs.patch added to mm-nonmm-unstable branch
Message-Id: <20220717004048.D9A17C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task: fix address space of proc_dohung_task_timeout_secs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-hung_task-fix-address-space-of-proc_dohung_task_timeout_secs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-hung_task-fix-address-space-of-proc_dohung_task_timeout_secs.patch

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
From: Ben Dooks <ben.dooks@sifive.com>
Subject: kernel/hung_task: fix address space of proc_dohung_task_timeout_secs
Date: Thu, 14 Jul 2022 08:47:44 +0100

The proc_dohung_task_timeout_secs() function is incorrectly marked
as having a __user buffer as argument 3. However this is not the
case and it is casing multiple sparse warnings. Fix the following
warnings by removing __user from the argument:

kernel/hung_task.c:237:52: warning: incorrect type in argument 3 (different address spaces)
kernel/hung_task.c:237:52:    expected void *
kernel/hung_task.c:237:52:    got void [noderef] __user *buffer
kernel/hung_task.c:287:35: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
kernel/hung_task.c:287:35:    expected int ( [usertype] *proc_handler )( ... )
kernel/hung_task.c:287:35:    got int ( * )( ... )
kernel/hung_task.c:295:35: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
kernel/hung_task.c:295:35:    expected int ( [usertype] *proc_handler )( ... )
kernel/hung_task.c:295:35:    got int ( * )( ... )

Link: https://lkml.kernel.org/r/20220714074744.189017-1-ben.dooks@sifive.com
Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Cc: <Conor.Dooley@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/hung_task.c~kernel-hung_task-fix-address-space-of-proc_dohung_task_timeout_secs
+++ a/kernel/hung_task.c
@@ -229,7 +229,7 @@ static long hung_timeout_jiffies(unsigne
  * Process updating of timeout sysctl
  */
 static int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
-				  void __user *buffer,
+				  void *buffer,
 				  size_t *lenp, loff_t *ppos)
 {
 	int ret;
_

Patches currently in -mm which might be from ben.dooks@sifive.com are

kernel-hung_task-fix-address-space-of-proc_dohung_task_timeout_secs.patch


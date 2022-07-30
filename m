Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BFBC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiG3BNR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbiG3BNP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F8310579
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0637861B74
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56345C433C1;
        Sat, 30 Jul 2022 01:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143593;
        bh=8kc+gZ2f25OxF7rt4tSSWQPgG5ULNKLDKEbxCBb6/Go=;
        h=Date:To:From:Subject:From;
        b=UXz1pam4jDdQh7vcIjiTQn2gHQOL8eSVekgpTB4GWdqGb9pE8YKNNLRbC74pVPijT
         rWiRKmqEY4ok0gAPuidZnsgvYOpBYaZUo4Q8mBJqDvpV7HDiwI9tZvVGWs+eHjWaxp
         Pt2Q/yRatoR+NlyuG8yO6SdGxvHsdKlhA3fqyU0w=
Date:   Fri, 29 Jul 2022 18:13:12 -0700
To:     mm-commits@vger.kernel.org, Conor.Dooley@microchip.com,
        ben.dooks@sifive.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-hung_task-fix-address-space-of-proc_dohung_task_timeout_secs.patch removed from -mm tree
Message-Id: <20220730011313.56345C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/hung_task: fix address space of proc_dohung_task_timeout_secs
has been removed from the -mm tree.  Its filename was
     kernel-hung_task-fix-address-space-of-proc_dohung_task_timeout_secs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



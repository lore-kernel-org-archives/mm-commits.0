Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81924C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C2B120767
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598401706;
	bh=Q0DyZHaByD5oiczGyyDfMgBZPkXr3wa3djMMqFDptSs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u4YGQTo4RHR2metZ9zTZz8dS7PQ5XXhKvkn+9VeVKOuFlWK3ZqqUeRSmpkc2TBo9J
	 CZaeM1/P+7x7t7CaHnPCJ7hrE8MWa+/OZWhStsQrBhwtHby50DqxiRt4ZcSmpkcktc
	 Y1sLBFA7hcuGAmxLBFAW6I6+5QNyI+8Xz+OjJpRQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHZA2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHZA2Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:28:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E0AD2075E;
        Wed, 26 Aug 2020 00:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598401704;
        bh=Q0DyZHaByD5oiczGyyDfMgBZPkXr3wa3djMMqFDptSs=;
        h=Date:From:To:Subject:From;
        b=UMVdoMtlYeBlHx/AsBO6/bd1ABp+zE/7WMlLVrLpi9NiZoMP5i4yOkI5SIcJwNvW/
         jygzvyyfmi6Ana8rnHoG/y9lpfeblbgJ0j21tZgObInU6OHcqF9MkJzYsJ4RsXT4kX
         7qd9zMga/3sWIz0jkwM9y5qAwop2DlVN/T3ElPqg=
Date:   Tue, 25 Aug 2020 17:28:24 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, tklauser@distanz.ch,
        viro@zeniv.linux.org.uk
Subject:  +
 fork-adjust-sysctl_max_threads-definition-to-match-prototype.patch added to
 -mm tree
Message-ID: <20200826002824.sf9ShHYgI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork: adjust sysctl_max_threads definition to match prototype
has been added to the -mm tree.  Its filename is
     fork-adjust-sysctl_max_threads-definition-to-match-prototype.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fork-adjust-sysctl_max_threads-definition-to-match-prototype.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fork-adjust-sysctl_max_threads-definition-to-match-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: fork: adjust sysctl_max_threads definition to match prototype

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer.  Adjust the
definition of sysctl_max_threads to match its prototype in linux/sysctl.h
which fixes the following sparse error/warning:

kernel/fork.c:3050:47: warning: incorrect type in argument 3 (different address spaces)
kernel/fork.c:3050:47:    expected void *
kernel/fork.c:3050:47:    got void [noderef] __user *buffer
kernel/fork.c:3036:5: error: symbol 'sysctl_max_threads' redeclared with different type (incompatible argument 3 (different address spaces)):
kernel/fork.c:3036:5:    int extern [addressable] [signed] [toplevel] sysctl_max_threads( ... )
kernel/fork.c: note: in included file (through include/linux/key.h, include/linux/cred.h, include/linux/sched/signal.h, include/linux/sched/cputime.h):
./include/linux/sysctl.h:242:5: note: previously declared as:
./include/linux/sysctl.h:242:5:    int extern [addressable] [signed] [toplevel] sysctl_max_threads( ... )

Link: https://lkml.kernel.org/r/20200825093647.24263-1-tklauser@distanz.ch
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~fork-adjust-sysctl_max_threads-definition-to-match-prototype
+++ a/kernel/fork.c
@@ -3014,7 +3014,7 @@ int unshare_files(struct files_struct **
 }
 
 int sysctl_max_threads(struct ctl_table *table, int write,
-		       void __user *buffer, size_t *lenp, loff_t *ppos)
+		       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
 	int ret;
_

Patches currently in -mm which might be from tklauser@distanz.ch are

ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch
fork-adjust-sysctl_max_threads-definition-to-match-prototype.patch


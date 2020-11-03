Return-Path: <SRS0=UcEf=EJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395D0C388F7
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AB622280
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604427442;
	bh=P9BLBtUCpqROAIlC6P9N5+x+B3veIK+kri28br0EYOY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=THlsbpwXooe+ebk5/PiCEPeN9qEaxLsKzeBhQZr+aeFTjbYrp+Zew1B4lOFdaVlgZ
	 mjZthSCu878NPqeuTvdPncqv0P8CIx0nnDzkwEvTm5Y0926o8Yo8IpzpiNbDlLmScy
	 M6Iz7nSruLi0IPg4oQi9hVFWSQdURFW8LnOwpR1k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgKCSRW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:17:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgKCSRW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 13:17:22 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83489207BB;
        Tue,  3 Nov 2020 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427441;
        bh=P9BLBtUCpqROAIlC6P9N5+x+B3veIK+kri28br0EYOY=;
        h=Date:From:To:Subject:From;
        b=gn5VhWdykeWRbWwsEf9BtG+Inw1jRQnogszPHD+p7BOqTlIjLLdqJqn3Sf3lmZdxX
         5kyzSte4bM3lzszcwuyQvvz8vBYOgp8dEsOzSaKAk0DfCJZ4dLg9ZcS5uoRoSDlXun
         wD/EeLhOal8gxoLKIBSvNfZLuxVkC0KDE+uD2agg=
Date:   Tue, 03 Nov 2020 10:17:21 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, rdna@fb.com,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 kernel-hung_taskc-make-type-annotations-consistent.patch removed from -mm
 tree
Message-ID: <20201103181721.88DSiBMqa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task.c: make type annotations consistent
has been removed from the -mm tree.  Its filename was
     kernel-hung_taskc-make-type-annotations-consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: kernel/hung_task.c: make type annotations consistent

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
removed various __user annotations from function signatures as part of its
refactoring.

It also removed the __user annotation for proc_dohung_task_timeout_secs()
at its declaration in ./sched/sysctl.h, but not at its definition in
./kernel/hung_task.c.

Hence, sparse complains:

  kernel/hung_task.c:271:5: error: \
  symbol 'proc_dohung_task_timeout_secs' redeclared with different type \
  (incompatible argument 3 (different address spaces))

Adjust the annotation at the definition fitting to that refactoring to make
sparse happy again, which also resolves this warning from sparse:

  kernel/hung_task.c:277:52: warning: incorrect type in argument 3 \
    (different address spaces)
  kernel/hung_task.c:277:52:    expected void *
  kernel/hung_task.c:277:52:    got void [noderef] __user *buffer

No functional change. No change in object code.

Link: https://lkml.kernel.org/r/20201028130541.20320-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/hung_task.c~kernel-hung_taskc-make-type-annotations-consistent
+++ a/kernel/hung_task.c
@@ -225,8 +225,7 @@ static long hung_timeout_jiffies(unsigne
  * Process updating of timeout sysctl
  */
 int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos)
+				  void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
 
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mm-vmscan-drop-unneeded-assignment-in-kswapd.patch


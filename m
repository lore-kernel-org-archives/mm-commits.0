Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F742C388F7
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1BCA2417B
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603921070;
	bh=zTlNKYSjXmraCtR0tVKDivndta8iZmKepp66TpaokMA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SUmoSNWW9I2Cw/0+E0HsIQN5saf8pbY3iXaCYMEiikyFrJcmF+iFozD+e2iZWV2qu
	 gcEVq584eBCImWWXdElUSTlaC9U6k7laoV+GiyReAWZSXrhXpzkeeac1CxpZTt3mkl
	 U7zdf+2qsJI2X33jm8X+Zhsk3smj4RDPl20hltVs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgJ1Vhi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgJ1VhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:37:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E14D02475D;
        Wed, 28 Oct 2020 21:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603919852;
        bh=zTlNKYSjXmraCtR0tVKDivndta8iZmKepp66TpaokMA=;
        h=Date:From:To:Subject:From;
        b=1+ykOQbNW3P3z7e2Ug+NHdp+ju9UC/wfhaA9e5ho50mnlR5jlziqg92vH+GQZxiv5
         LENsgozKpbxRkk8499+gCEj1pFYpr+R0JF/xVF4H6spoXMZ3AHNQglewVYZdUr1Rr0
         lkVpxKhOUWdRRJHqjS4pTXMqepSKDFIm0XQ2j6t4=
Date:   Wed, 28 Oct 2020 14:17:31 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, rdna@fb.com,
        viro@zeniv.linux.org.uk
Subject:  +
 kernel-hung_taskc-make-type-annotations-consistent.patch added to -mm tree
Message-ID: <20201028211731.uj0HSYqSM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task.c: make type annotations consistent
has been added to the -mm tree.  Its filename is
     kernel-hung_taskc-make-type-annotations-consistent.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-hung_taskc-make-type-annotations-consistent.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-hung_taskc-make-type-annotations-consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-hung_taskc-make-type-annotations-consistent.patch
mm-vmscan-drop-unneeded-assignment-in-kswapd.patch


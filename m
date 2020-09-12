Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F521C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 630D321D7E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927852;
	bh=xvbIfDj8tAfCaJA8ma6Jqi8KENLQDzKyW3v6EJf+k18=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=W2USbTsSMGzpQf/0xRpQbsNP1NVEloiL1DZ0u1CyJWGS1gmXSZrL5AN+fpwyv5yt8
	 1bB3dvAwcgX4JzPBr0kHmePc7Kp3BVHexyf98D+uCBXr6g9+Zl52oUjCABo5GsxFE2
	 nxi0WxZ9YH/cDt4JKRcOp96QpegGlhVYypTmYnFI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgILQYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgILQXx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:23:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 855582083E;
        Sat, 12 Sep 2020 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927832;
        bh=xvbIfDj8tAfCaJA8ma6Jqi8KENLQDzKyW3v6EJf+k18=;
        h=Date:From:To:Subject:From;
        b=QPFFFxjDoDRxEYhyBuAbCKdPRNnK7FFceytV5AWpMWUfp9b0RqIxAWUp5OMrEtSDh
         z6luIV8rV4c88G4BJpVSenopZoNN5zkhub0zP5TsGOZ7vxQbMkSozovdq0qCLTOsFo
         phd+CxCkezMeRvXxicQUuSuBF76Ak7BQIG91STxQ=
Date:   Sat, 12 Sep 2020 09:23:52 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, tklauser@distanz.ch,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 fork-adjust-sysctl_max_threads-definition-to-match-prototype.patch removed
 from -mm tree
Message-ID: <20200912162352.65dolWiK3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork: adjust sysctl_max_threads definition to match prototype
has been removed from the -mm tree.  Its filename was
     fork-adjust-sysctl_max_threads-definition-to-match-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



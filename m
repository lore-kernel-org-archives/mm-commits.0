Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FDFC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46072078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266304;
	bh=k1kPNonMcHrnICHhZoU5ZUeLnsj4BrVCNmmZOl3QiCk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YTe1ikuJjdMNwUy+BflndAkZ5oAyAmdn1MEkDLUrfZY68TdaNSNTRXtQqPGpDO1oo
	 orYzn8L6r2gH/0CFPkSvD8ZiONlCxhXq4OGmqCtodV+VYi1VyP0vK27FddoGdh7yrs
	 CARus2IT4Jdmfiu3AMQp80KvfesxEQQtOrFsOwwo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHLVFE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgHLVFE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763A920774;
        Wed, 12 Aug 2020 21:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266302;
        bh=k1kPNonMcHrnICHhZoU5ZUeLnsj4BrVCNmmZOl3QiCk=;
        h=Date:From:To:Subject:From;
        b=WYvuJHybBel7f+FGHZh3KCT3mRgFo9OgUFbPLGjO9elfVS0ljAG5cmVCSPHkYQEzC
         +AVvMJPpxI305V99EIMcgxppwRVbd8gEVsXbQj/3D0tTJDObtMhaJh/81hyve9zlam
         X334VUUPlzX1oFKvezfD9slT71ZbDKTbKClBg4qg=
Date:   Wed, 12 Aug 2020 14:05:02 -0700
From:   akpm@linux-foundation.org
To:     deller@gmx.de, laurent@vivier.eu, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4.patch removed from
 -mm tree
Message-ID: <20200812210502.n6SXaK2zi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/signalfd.c: fix inconsistent return codes for signalfd4
has been removed from the -mm tree.  Its filename was
     fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: fs/signalfd.c: fix inconsistent return codes for signalfd4

The kernel signalfd4() syscall returns different error codes when called
either in compat or native mode.  This behaviour makes correct emulation
in qemu and testing programs like LTP more complicated.

Fix the code to always return -in both modes- EFAULT for unaccessible user
memory, and EINVAL when called with an invalid signal mask.

Link: http://lkml.kernel.org/r/20200530100707.GA10159@ls3530.fritz.box
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/signalfd.c~fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4
+++ a/fs/signalfd.c
@@ -314,9 +314,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 {
 	sigset_t mask;
 
-	if (sizemask != sizeof(sigset_t) ||
-	    copy_from_user(&mask, user_mask, sizeof(mask)))
+	if (sizemask != sizeof(sigset_t))
 		return -EINVAL;
+	if (copy_from_user(&mask, user_mask, sizeof(mask)))
+		return -EFAULT;
 	return do_signalfd4(ufd, &mask, flags);
 }
 
@@ -325,9 +326,10 @@ SYSCALL_DEFINE3(signalfd, int, ufd, sigs
 {
 	sigset_t mask;
 
-	if (sizemask != sizeof(sigset_t) ||
-	    copy_from_user(&mask, user_mask, sizeof(mask)))
+	if (sizemask != sizeof(sigset_t))
 		return -EINVAL;
+	if (copy_from_user(&mask, user_mask, sizeof(mask)))
+		return -EFAULT;
 	return do_signalfd4(ufd, &mask, 0);
 }
 
_

Patches currently in -mm which might be from deller@gmx.de are



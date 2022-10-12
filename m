Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086E1C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 01:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJLBvl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLBvl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 21:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06419A3445
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 18:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 976936133B
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 01:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD541C433C1;
        Wed, 12 Oct 2022 01:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665539499;
        bh=eMajYQelzuNQiGtayYvjeoR8hFo2jcX5MAi/H+PrlPo=;
        h=Date:To:From:Subject:From;
        b=nV6IRteeIlfYuTmgd0CdIrqiD78nY/IAiTlGddpSbSujL+ceSvpz9ldM9deNW0N2y
         GlfdUXVgsKtskP2j+F9H6ehoaFAFeTa5eW2i8fS8MYSSyG5mhPe0mguH3xJ4PDJW7W
         Jo9vDUynQE5QQ6nUpoUbZN9SdDSAw7Opnfa7nEpI=
Date:   Tue, 11 Oct 2022 18:51:37 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, tglx@linutronix.de,
        luto@kernel.org, liam.howlett@oracle.com, fenghua.yu@intel.com,
        ebiederm@xmission.com, brauner@kernel.org, bigeasy@linutronix.de,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-remove-duplicate-included-header-files.patch removed from -mm tree
Message-Id: <20221012015138.DD541C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fork: remove duplicate included header files
has been removed from the -mm tree.  Its filename was
     fork-remove-duplicate-included-header-files.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xu Panda <xu.panda@zte.com.cn>
Subject: fork: remove duplicate included header files
Date: Mon, 12 Sep 2022 07:15:57 +0000

linux/sched/mm.h is included more than once.

Link: https://lkml.kernel.org/r/20220912071556.16811-1-xu.panda@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/fork.c~fork-remove-duplicate-included-header-files
+++ a/kernel/fork.c
@@ -97,7 +97,6 @@
 #include <linux/scs.h>
 #include <linux/io_uring.h>
 #include <linux/bpf.h>
-#include <linux/sched/mm.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are



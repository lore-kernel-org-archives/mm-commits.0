Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E88C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 05:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2851E20732
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 05:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbhAZFRh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbhAZB2K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 20:28:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7351F23109;
        Tue, 26 Jan 2021 01:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611624450;
        bh=hQYb+AfRG4Gb6CILMMYW6l6zWAtVSTVdWPizaupk6wQ=;
        h=Date:From:To:Subject:From;
        b=O/7YWNgeCsCqcEs6hEM/9HViPkwe+RdRdwYTPsV6UgAbCpJdtyQk5FW1UchVzJhFK
         gwUPY2ZszgagKALhvfaxfodeZb3PkSbJq7FINbTVHhdfYAHWDkyGhJALlVOb1WPA7/
         kRiXoQ/cGY2gE+v28/N+KOMp1aq7hZeMbjKkjIjY=
Date:   Mon, 25 Jan 2021 17:27:28 -0800
From:   akpm@linux-foundation.org
To:     areber@redhat.com, christian.brauner@ubuntu.com, hulkci@huawei.com,
        liao.pingfang@zte.com.cn, linux@rasmusvillemoes.dk,
        mchristi@redhat.com, mm-commits@vger.kernel.org,
        Nicolas.Viennot@twosigma.com, tglx@linutronix.de,
        thomascedeno@google.com, viresh.kumar@linaro.org,
        viro@zeniv.linux.org.uk, zou_wei@huawei.com
Subject:  [failures]
 kernel-sysc-remove-unused-including-linux-versionh.patch removed from -mm
 tree
Message-ID: <20210126012728.eFbVmEib5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: Remove unused including <linux/version.h>
has been removed from the -mm tree.  Its filename was
     kernel-sysc-remove-unused-including-linux-versionh.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Zou Wei <zou_wei@huawei.com>
Subject: kernel/sys.c: Remove unused including <linux/version.h>

Fix the following versioncheck warning:

kernel/sys.c:42:1: unused including <linux/version.h>

Link: https://lkml.kernel.org/r/1611578869-43453-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Reber <areber@redhat.com>
Cc: Thomas Cedeno <thomascedeno@google.com>
Cc: Nicolas Viennot <Nicolas.Viennot@twosigma.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Liao Pingfang <liao.pingfang@zte.com.cn>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/sys.c~kernel-sysc-remove-unused-including-linux-versionh
+++ a/kernel/sys.c
@@ -40,7 +40,6 @@
 #include <linux/mount.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
-#include <linux/version.h>
 #include <linux/ctype.h>
 #include <linux/syscall_user_dispatch.h>
 
_

Patches currently in -mm which might be from zou_wei@huawei.com are



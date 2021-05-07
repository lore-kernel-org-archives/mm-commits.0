Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10441C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF890613C5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhEGBDf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhEGBDe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F8F610F7;
        Fri,  7 May 2021 01:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349354;
        bh=DMUfVf60/DN14XEkg/+hKFncyay4tqpfYikv9VMtpI8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eS2RmEsAMpb4NhOAft8hyS9P/aZw+UDe20mAwBKFFbEgqV013+PkphWrQcFQlbgiC
         WHDmmHoTgrG4zRct+TeHjZr0B9FtTPggWWTRqQz32CSGK0hVZvEZynVN13AYSvmv9J
         dk0++01dZAp6cS/JfNE6ChhAiDvpaIqjeoVRzhuA=
Date:   Thu, 06 May 2021 18:02:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wanjiabing@vivo.com
Subject:  [patch 11/91] linux/profile.h: remove unnecessary
 declaration
Message-ID: <20210507010233.hAkGHZSW_%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>
Subject: linux/profile.h: remove unnecessary declaration

Declaring struct pt_regs is unnecessary.  On the one hand, there is no
function using it; on the other hand, struct pt_regs has been declared in
linux/kernel.h.  Remove them.

Link: https://lkml.kernel.org/r/20210401104834.1009157-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/profile.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/profile.h~linux-profileh-remove-unnecessary-declaration
+++ a/include/linux/profile.h
@@ -15,7 +15,6 @@
 #define KVM_PROFILING	4
 
 struct proc_dir_entry;
-struct pt_regs;
 struct notifier_block;
 
 #if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
@@ -84,8 +83,6 @@ int task_handoff_unregister(struct notif
 int profile_event_register(enum profile_type, struct notifier_block * n);
 int profile_event_unregister(enum profile_type, struct notifier_block * n);
 
-struct pt_regs;
-
 #else
 
 #define prof_on 0
_

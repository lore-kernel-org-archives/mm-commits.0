Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3D3C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F60A61424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHWxG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWxG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F6E60233;
        Sat,  8 May 2021 22:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514324;
        bh=78BtNOrmKNE4FMJXLkSKLFjV6SoLyo/ZtLbsegj1lWY=;
        h=Date:From:To:Subject:From;
        b=1T4qR8m5GccDAQLSPJ0qTMeGK7+oqcsJHJeMKXDYWKvYhJPaYTuk7AeT/Ek8JObRn
         CmZCbwZP4EypbGag3yM3Gqf/Doh2wmGp5xEYHMWB+ansEhaEIKPno6mqkrF/9i7/A1
         1UOwsE+btMKY18j0k8HioKl9rn/Ye22zJn0jdtKE=
Date:   Sat, 08 May 2021 15:52:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wanjiabing@vivo.com
Subject:  [merged]
 linux-profileh-remove-unnecessary-declaration.patch removed from -mm tree
Message-ID: <20210508225204.pfGMBkwhl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/profile.h: remove unnecessary declaration
has been removed from the -mm tree.  Its filename was
     linux-profileh-remove-unnecessary-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from wanjiabing@vivo.com are



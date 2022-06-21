Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C4EC43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 21:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355067AbiFUVWS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 17:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355619AbiFUVV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 17:21:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E11531392
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 14:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1DA1B817F3
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 21:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00164C3411C;
        Tue, 21 Jun 2022 21:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655845740;
        bh=rL2lP1uRblCGev9+mR3oTERX8CN7JKUxVQmpje5A6Pw=;
        h=Date:To:From:Subject:From;
        b=NMIX8R3SU+LFjsewFj69AeJJ2mN6HHCSC4ZXzxKbGlaml4XYTq1FjWIqc6l34MhRK
         ZUv/MxraK1d47nBsBL7tol+tpmpWLNBnJSmaiHgnnCc8MoJuZ18AsEKpgkSJYLpqjt
         slZF4jmQ5AtSfaGjiboP6AzLDMdc3XgQABd1T6Wo=
Date:   Tue, 21 Jun 2022 14:08:51 -0700
To:     mm-commits@vger.kernel.org, yhs@fb.com, songliubraving@fb.com,
        mhiramat@kernel.org, kpsingh@kernel.org, kafai@fb.com,
        john.fastabend@gmail.com, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-error-inject-traverse-list-with-mutex.patch added to mm-nonmm-unstable branch
Message-Id: <20220621210859.00164C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/error-inject: Traverse list with mutex
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-error-inject-traverse-list-with-mutex.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-error-inject-traverse-list-with-mutex.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/error-inject: Traverse list with mutex
Date: Mon, 20 Jun 2022 18:02:44 +0800

Traversing list without mutex in get_injectable_error_type will
race with the following code:
    list_del_init(&ent->list)
    kfree(ent)
in module_unload_ei_list. So fix that.

Link: https://lkml.kernel.org/r/20220620100244.82896-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/error-inject.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/lib/error-inject.c~lib-error-inject-traverse-list-with-mutex
+++ a/lib/error-inject.c
@@ -40,12 +40,18 @@ bool within_error_injection_list(unsigne
 int get_injectable_error_type(unsigned long addr)
 {
 	struct ei_entry *ent;
+	int ei_type = EI_ETYPE_NONE;
 
+	mutex_lock(&ei_mutex);
 	list_for_each_entry(ent, &error_injection_list, list) {
-		if (addr >= ent->start_addr && addr < ent->end_addr)
-			return ent->etype;
+		if (addr >= ent->start_addr && addr < ent->end_addr) {
+			ei_type = ent->etype;
+			break;
+		}
 	}
-	return EI_ETYPE_NONE;
+	mutex_unlock(&ei_mutex);
+
+	return ei_type;
 }
 
 /*
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
lib-lru_cache-fix-error-free-handing-in-lc_create.patch
net-lib-once-remove-net_get_random_once_wait-macro.patch
lib-error-inject-traverse-list-with-mutex.patch


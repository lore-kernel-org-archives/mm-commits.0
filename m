Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E992BCCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiGRAc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiGRAc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9A313CFC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C38B80EE8
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06728C3411E;
        Mon, 18 Jul 2022 00:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104344;
        bh=Wii0KFMNpUCkjA+EQ2Aji/pfR6/DYsundfFr6yNKeA4=;
        h=Date:To:From:Subject:From;
        b=FXRtJh7DdtG6BpbSWJQPIe5zy0gTUcrpdDY50ailqaIdsazTis3t5bnfjWhxOe9F4
         8jGlQTTwhRi1NRGGhvBpozgICArYebobcvUPbWcu0Cg2TPzIe7VPWQ6WsqLrBO0p4/
         9/S7fX4SkYemg4HL9/NNXHJDM/v+sNQIhJINDouk=
Date:   Sun, 17 Jul 2022 17:32:23 -0700
To:     mm-commits@vger.kernel.org, yhs@fb.com, songliubraving@fb.com,
        mhiramat@kernel.org, kpsingh@kernel.org, kafai@fb.com,
        john.fastabend@gmail.com, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-error-inject-traverse-list-with-mutex.patch removed from -mm tree
Message-Id: <20220718003224.06728C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/error-inject: traverse list with mutex
has been removed from the -mm tree.  Its filename was
     lib-error-inject-traverse-list-with-mutex.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/error-inject: traverse list with mutex
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


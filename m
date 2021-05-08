Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C268FC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95DD660E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHW4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhEHW4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70E76610FA;
        Sat,  8 May 2021 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514509;
        bh=zVk1A6dtR37PNw2kRb1e3iUO36lZIfIS+Avs/qoOWeA=;
        h=Date:From:To:Subject:From;
        b=S0YS2aifJEThWbKuCtomSWMgcxm0SplXYPpeZZPHTykjRCDnpeg45jL9cxaXOTJe2
         kpMOl8Lz+fqRfJQVGJKE3iVy39S19RI8ZerJN3ALWdT70rp7aSAlS+8bQouyn1d+KZ
         wnjRIOor/ROTFJLlcox6y+s9J7BGJ4u0rpCDJoDw=
Date:   Sat, 08 May 2021 15:55:09 -0700
From:   akpm@linux-foundation.org
To:     caoxiaofeng@yulong.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged] kernel-sys-fix-typo-issue.patch removed from -mm
 tree
Message-ID: <20210508225509.SAo1MYsD9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: fix typo
has been removed from the -mm tree.  Its filename was
     kernel-sys-fix-typo-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaofeng Cao <caoxiaofeng@yulong.com>
Subject: kernel/sys.c: fix typo

change 'infite'     to 'infinite'
change 'concurent'  to 'concurrent'
change 'memvers'    to 'members'
change 'decendants' to 'descendants'
change 'argumets'   to 'arguments'

Link: https://lkml.kernel.org/r/20210316112904.10661-1-cxfcosmos@gmail.com
Signed-off-by: Xiaofeng Cao <caoxiaofeng@yulong.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/sys.c~kernel-sys-fix-typo-issue
+++ a/kernel/sys.c
@@ -1590,7 +1590,7 @@ int do_prlimit(struct task_struct *tsk,
 
 	/*
 	 * RLIMIT_CPU handling. Arm the posix CPU timer if the limit is not
-	 * infite. In case of RLIM_INFINITY the posix CPU timer code
+	 * infinite. In case of RLIM_INFINITY the posix CPU timer code
 	 * ignores the rlimit.
 	 */
 	 if (!retval && new_rlim && resource == RLIMIT_CPU &&
@@ -2029,7 +2029,7 @@ static int prctl_set_mm_map(int opt, con
 	}
 
 	/*
-	 * arg_lock protects concurent updates but we still need mmap_lock for
+	 * arg_lock protects concurrent updates but we still need mmap_lock for
 	 * read to exclude races with sys_brk.
 	 */
 	mmap_read_lock(mm);
@@ -2041,7 +2041,7 @@ static int prctl_set_mm_map(int opt, con
 	 * output in procfs mostly, except
 	 *
 	 *  - @start_brk/@brk which are used in do_brk_flags but kernel lookups
-	 *    for VMAs when updating these memvers so anything wrong written
+	 *    for VMAs when updating these members so anything wrong written
 	 *    here cause kernel to swear at userspace program but won't lead
 	 *    to any problem in kernel itself
 	 */
@@ -2143,7 +2143,7 @@ static int prctl_set_mm(int opt, unsigne
 	error = -EINVAL;
 
 	/*
-	 * arg_lock protects concurent updates of arg boundaries, we need
+	 * arg_lock protects concurrent updates of arg boundaries, we need
 	 * mmap_lock for a) concurrent sys_brk, b) finding VMA for addr
 	 * validation.
 	 */
@@ -2210,7 +2210,7 @@ static int prctl_set_mm(int opt, unsigne
 	 * If command line arguments and environment
 	 * are placed somewhere else on stack, we can
 	 * set them up here, ARG_START/END to setup
-	 * command line argumets and ENV_START/END
+	 * command line arguments and ENV_START/END
 	 * for environment.
 	 */
 	case PR_SET_MM_START_STACK:
@@ -2258,8 +2258,8 @@ static int prctl_get_tid_address(struct
 static int propagate_has_child_subreaper(struct task_struct *p, void *data)
 {
 	/*
-	 * If task has has_child_subreaper - all its decendants
-	 * already have these flag too and new decendants will
+	 * If task has has_child_subreaper - all its descendants
+	 * already have these flag too and new descendants will
 	 * inherit it on fork, skip them.
 	 *
 	 * If we've found child_reaper - skip descendants in
_

Patches currently in -mm which might be from caoxiaofeng@yulong.com are



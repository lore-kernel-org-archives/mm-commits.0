Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD362C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E962054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196214;
	bh=xSB+rzXnd94oZ8eeo/rboL8ZhBXOt2WMoAAW8dAoNvE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tkxXU+j9p1hzcDaeqEDGu3QfAJrfOnxcDllQmu3flAFouzz5VlD5UBNUCVH9jtdN0
	 ioPQSjXISBDLegAvIVwqJ9RjoIpDWD1wS2ji0sklzTMs0T7hy6fy3IA4L9nyrgrvWc
	 aIAZ7sUt5iy2uLRNriOWqWgfFGWo6DkPU+8ke4N0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBgy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLBgy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70B6E20658;
        Wed, 12 Aug 2020 01:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196213;
        bh=xSB+rzXnd94oZ8eeo/rboL8ZhBXOt2WMoAAW8dAoNvE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A3hLD+xUwWXOHM2tMWuY9JkwaP1F7DNn9/CPv0dDp726AMD6uofHQVqK+1MJxZuDh
         IOjO97Samx2+FCLi7RireiZ9MrObaUSu+ou7GqGNdiklnzI8EIikkM6ZUYvtdTdeI2
         n7sO4pFKJmO4k4Kw7BZVtEa6mtq1DrGOYZzkehsc=
Date:   Tue, 11 Aug 2020 18:36:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, huyue2@yulong.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 125/165] panic: make print_oops_end_marker()
 static
Message-ID: <20200812013653.9kSGSVf1y%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>
Subject: panic: make print_oops_end_marker() static

Since print_oops_end_marker() is not used externally, also remove it in
kernel.h at the same time.

Link: http://lkml.kernel.org/r/20200724011516.12756-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 -
 kernel/panic.c         |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/kernel.h~panic-make-print_oops_end_marker-static
+++ a/include/linux/kernel.h
@@ -321,7 +321,6 @@ void panic(const char *fmt, ...) __noret
 void nmi_panic(struct pt_regs *regs, const char *msg);
 extern void oops_enter(void);
 extern void oops_exit(void);
-void print_oops_end_marker(void);
 extern bool oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
--- a/kernel/panic.c~panic-make-print_oops_end_marker-static
+++ a/kernel/panic.c
@@ -551,7 +551,7 @@ static int init_oops_id(void)
 }
 late_initcall(init_oops_id);
 
-void print_oops_end_marker(void)
+static void print_oops_end_marker(void)
 {
 	init_oops_id();
 	pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
_

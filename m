Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8824FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5344D2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266340;
	bh=t3ZTyz9YD/PsdvbWtV61G57YrS+KFlxXJG4mQDxQr+Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xlcco64J+c9u2CnLKXeizbZm2QarwZFt8U3JwFluKulpJf/6FgaIV4Z2S8dvvSyfJ
	 shJuYF6ppP3Zz234coNZIQi5s9stOBhzyuP98w0tSmrBWf0eD/Qn7Y0N8ACnzC8ves
	 7f0beX77OPh7TlDsVVtnr57dmBYOA9U2ng57LTH4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLVFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787522078B;
        Wed, 12 Aug 2020 21:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266339;
        bh=t3ZTyz9YD/PsdvbWtV61G57YrS+KFlxXJG4mQDxQr+Q=;
        h=Date:From:To:Subject:From;
        b=gUKxfIOJS61QD8UQNalj5T2h1fwejgoQ/AlYC/QO1lFw6DFVV8IAzCRVYiwTloRmN
         X4/7ju3Ht0cUbb3vGe5IjSZSaMT/Eirph6h7/ahG2LJmd1muebq4bQJ6vTjkmQqKGc
         GQoLwL5vAJsLDYt9UO17dk1XvrKkPwsL72/JgYqY=
Date:   Wed, 12 Aug 2020 14:05:39 -0700
From:   akpm@linux-foundation.org
To:     huyue2@yulong.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  [merged] panic-make-print_oops_end_marker-static.patch
 removed from -mm tree
Message-ID: <20200812210539.umK9NEMDJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: make print_oops_end_marker() static
has been removed from the -mm tree.  Its filename was
     panic-make-print_oops_end_marker-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from huyue2@yulong.com are



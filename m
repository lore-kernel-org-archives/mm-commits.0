Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145ACC433EA
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35E3207DF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595556777;
	bh=VG2NLy3ZXsT0wYJ2GTP4VJneN3PWE0OVEuIWNrroqZk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IXoboaM4mMIf/p4IwCLX+V6dyBsuUI/cLTzLT86+wk/p36oKt07zccAvc4iWvTI9T
	 CgPtr9QRGjkPIH2e4MjUmx1fksfIFxgXbw9HRZSP2JEQN39g5xuJEsXx3CHu8KGqR3
	 G5U2fn4QJ7vluY8UtYMwYtkwfeRek9rzuWuUwIY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgGXCM5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 22:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgGXCM5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 22:12:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A96C72065E;
        Fri, 24 Jul 2020 02:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595556776;
        bh=VG2NLy3ZXsT0wYJ2GTP4VJneN3PWE0OVEuIWNrroqZk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lzj0DVhhr+WVfZwKrQH3r6O9eupX3q7XWIIWSZYZ6GQxLqSRU6Lt/3VJCZEcgbCgw
         YGrkpNqSFCXrD03OFHlUlovZvRXEJ/Csh93gaPN1or6W1DjtSF9zrQdCxQNvEHNaIM
         Bza1VRWcAMunz5bXFRmTc3KPRdS8VhY/wEwxQfrs=
Date:   Thu, 23 Jul 2020 19:12:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     huyue2@yulong.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  + panic-make-print_oops_end_marker-static.patch added to
 -mm tree
Message-ID: <20200724021256.jbUdnd9Yc%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: make print_oops_end_marker() static
has been added to the -mm tree.  Its filename is
     panic-make-print_oops_end_marker-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/panic-make-print_oops_end_marker-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/panic-make-print_oops_end_marker-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 extern int oops_may_print(void);
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

panic-make-print_oops_end_marker-static.patch


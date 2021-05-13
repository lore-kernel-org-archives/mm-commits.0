Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC55C43460
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D6F1613DE
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhEMSvP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 14:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhEMSvO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 14:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B619C613DF;
        Thu, 13 May 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620931803;
        bh=8gIOzdg/3SooFZeLtAX6CmmQdoZYGX633ri2aQ6wwl0=;
        h=Date:From:To:Subject:From;
        b=XGa9Ao4bkHb2XfkOhRHyuwIS4vXw6ieb0Y3Oco7w/CY3BkaJukqKvv0nxi0Xf/RdM
         zpDkGrk5aH9RHISfjeu9mUPKymBVL+Q8Yw7487kGEZsKzyxhGw5t1CJ4RbtOZy3qWO
         9kS0LMpyycw9jkKIRBaocRaXdZl2B0AgJOsR4RqY=
Date:   Thu, 13 May 2021 11:50:03 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, glider@google.com, lkp@intel.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  + printk-introduce-dump_stack_lvl-fix.patch added to -mm
 tree
Message-ID: <20210513185003.d7yQOM97c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "printk: introduce dump_stack_lvl()"
has been added to the -mm tree.  Its filename is
     printk-introduce-dump_stack_lvl-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/printk-introduce-dump_stack_lvl-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/printk-introduce-dump_stack_lvl-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: fix for "printk: introduce dump_stack_lvl()"

Add missing dump_stack_lvl() stub if CONFIG_PRINTK=n.

Link: https://lkml.kernel.org/r/YJ0KAM0hQev1AmWe@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/printk.h~printk-introduce-dump_stack_lvl-fix
+++ a/include/linux/printk.h
@@ -270,6 +270,10 @@ static inline void show_regs_print_info(
 {
 }
 
+static inline void dump_stack_lvl(const char *log_lvl)
+{
+}
+
 static inline void dump_stack(void)
 {
 }
_

Patches currently in -mm which might be from elver@google.com are

printk-introduce-dump_stack_lvl-fix.patch


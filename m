Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6834CC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiLOXBV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLOXBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:01:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB39B7F4
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:01:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EBD361E4E
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08FDC43396;
        Thu, 15 Dec 2022 23:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145265;
        bh=5mjDH0RM240QXd+F1im/kFPupDa7kUYG3vHtUsQm4fw=;
        h=Date:To:From:Subject:From;
        b=1p866MfBXwx0mHxoQz7Aw5rKf6SD7EvwXeIrBfhITD8um5IXYzF87FjsILWra/CCw
         ZHF2Di1rTXNPh5SKrChGaOQQL1kF1bW1K1d0WxwKgBExoi28P8+If+8wml3Y1FkaAN
         8VuYMwGfJ5lgruTZZmprLRb0hpeicCrgvmcIEwrg=
Date:   Thu, 15 Dec 2022 15:01:05 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        revest@chromium.org, peterz@infradead.org, mark.rutland@arm.com,
        kpsingh@kernel.org, keescook@chromium.org, jpoimboe@redhat.com,
        hch@infradead.org, gregkh@linuxfoundation.org, corbet@lwn.net,
        clm@meta.com, bp@alien8.de, alexei.starovoitov@gmail.com,
        mhiramat@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + error-injection-remove-ei_etype_none.patch added to mm-nonmm-unstable branch
Message-Id: <20221215230105.A08FDC43396@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: error-injection: remove EI_ETYPE_NONE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     error-injection-remove-ei_etype_none.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/error-injection-remove-ei_etype_none.patch

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
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: error-injection: remove EI_ETYPE_NONE
Date: Mon, 12 Dec 2022 11:46:44 +0900

Patch series "error-injection: Clarify the requirements of error
injectable functions".

Patches for clarifying the requirement of error injectable functions and
to remove the confusing EI_ETYPE_NONE.


This patch (of 2):

Since the EI_ETYPE_NONE is confusing type, replace it with appropriate
errno.  The EI_ETYPE_NONE has been introduced for a dummy (error) value,
but it can mislead people that they can use ALLOW_ERROR_INJECTION(func,
NONE).  So remove it from the EI_ETYPE and use appropriate errno instead.

Link: https://lkml.kernel.org/r/167081319306.387937.10079195394503045678.stgit@devnote3
Link: https://lkml.kernel.org/r/167081320421.387937.4259807348852421112.stgit@devnote3
Fixes: 663faf9f7bee ("error-injection: Add injectable error types")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Florent Revest <revest@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/error-injection.h |    1 -
 include/linux/error-injection.h       |    2 +-
 lib/error-inject.c                    |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/asm-generic/error-injection.h~error-injection-remove-ei_etype_none
+++ a/include/asm-generic/error-injection.h
@@ -4,7 +4,6 @@
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 enum {
-	EI_ETYPE_NONE,		/* Dummy value for undefined case */
 	EI_ETYPE_NULL,		/* Return NULL if failure */
 	EI_ETYPE_ERRNO,		/* Return -ERRNO if failure */
 	EI_ETYPE_ERRNO_NULL,	/* Return -ERRNO or NULL if failure */
--- a/include/linux/error-injection.h~error-injection-remove-ei_etype_none
+++ a/include/linux/error-injection.h
@@ -19,7 +19,7 @@ static inline bool within_error_injectio
 
 static inline int get_injectable_error_type(unsigned long addr)
 {
-	return EI_ETYPE_NONE;
+	return -EOPNOTSUPP;
 }
 
 #endif
--- a/lib/error-inject.c~error-injection-remove-ei_etype_none
+++ a/lib/error-inject.c
@@ -40,7 +40,7 @@ bool within_error_injection_list(unsigne
 int get_injectable_error_type(unsigned long addr)
 {
 	struct ei_entry *ent;
-	int ei_type = EI_ETYPE_NONE;
+	int ei_type = -EINVAL;
 
 	mutex_lock(&ei_mutex);
 	list_for_each_entry(ent, &error_injection_list, list) {
_

Patches currently in -mm which might be from mhiramat@kernel.org are

error-injection-remove-ei_etype_none.patch
docs-fault-injection-add-requirements-of-error-injectable-functions.patch


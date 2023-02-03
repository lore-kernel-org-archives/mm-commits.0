Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEEBC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjBCGut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCGus (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393EE4C1E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C989861DB3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A73DC433EF;
        Fri,  3 Feb 2023 06:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407046;
        bh=kerUGFkNGuamSBbQVzjTVQzaG7hsK0ooRkJljIHHyH4=;
        h=Date:To:From:Subject:From;
        b=xZE3duQA1+/3mLvS02tjkD9fIEGzir7xwz7bl4r4uh/RwJfD2qtW5XMqVTBHm+3b+
         h3Aij2FDOrPyf0tKhpgZAtd4+Gi3BfZ1ITXf0ZR1e7+OEk8VjbvO8XpAhBcKc+ntOG
         zd6mKveRGb7spS1hR0PlC9D4T2dDAFt3fwH95NbY=
Date:   Thu, 02 Feb 2023 22:50:45 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        revest@chromium.org, peterz@infradead.org, mark.rutland@arm.com,
        kpsingh@kernel.org, keescook@chromium.org, jpoimboe@redhat.com,
        hch@infradead.org, gregkh@linuxfoundation.org, corbet@lwn.net,
        clm@meta.com, bp@alien8.de, alexei.starovoitov@gmail.com,
        mhiramat@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] error-injection-remove-ei_etype_none.patch removed from -mm tree
Message-Id: <20230203065046.2A73DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: error-injection: remove EI_ETYPE_NONE
has been removed from the -mm tree.  Its filename was
     error-injection-remove-ei_etype_none.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: include/linux/error-injection.h needs errno.h]
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
@@ -3,6 +3,7 @@
 #define _LINUX_ERROR_INJECTION_H
 
 #include <linux/compiler.h>
+#include <linux/errno.h>
 #include <asm-generic/error-injection.h>
 
 #ifdef CONFIG_FUNCTION_ERROR_INJECTION
@@ -19,7 +20,7 @@ static inline bool within_error_injectio
 
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



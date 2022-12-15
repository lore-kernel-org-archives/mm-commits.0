Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9488C10F1E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLOXBV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLOXBM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:01:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6663E0BE
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAA0261F92
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F9BC433F1;
        Thu, 15 Dec 2022 23:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145268;
        bh=yvtCHDac7AZIHut0Cw2q631d3IoB9ZtORSm8rHsYdl0=;
        h=Date:To:From:Subject:From;
        b=MyvLD8XuN8Mbn4hg3W8k2p0mGgiL4Ng9Nvbe+sKzLwBsadtHcbVih8R03B6lbKC9J
         N8WiDklDQuEl17qJo6Yc6dAw+0rbrMgvnUJUtSpAqzGfsi2BqTm+2zWT1eqEhOz3sP
         Ha5SfUs5IxJ6HTPiM4gCWqGitq04S9bNc1gQC/jM=
Date:   Thu, 15 Dec 2022 15:01:07 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        revest@chromium.org, peterz@infradead.org, mark.rutland@arm.com,
        kpsingh@kernel.org, keescook@chromium.org, jpoimboe@redhat.com,
        hch@infradead.org, gregkh@linuxfoundation.org, corbet@lwn.net,
        clm@meta.com, bp@alien8.de, alexei.starovoitov@gmail.com,
        mhiramat@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-fault-injection-add-requirements-of-error-injectable-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20221215230108.28F9BC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: fault-injection: add requirements of error injectable functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-fault-injection-add-requirements-of-error-injectable-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-fault-injection-add-requirements-of-error-injectable-functions.patch

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
Subject: docs: fault-injection: add requirements of error injectable functions
Date: Mon, 12 Dec 2022 11:46:54 +0900

Add a section about the requirements of the error injectable functions and
the type of errors.

Since this section must be read before using ALLOW_ERROR_INJECTION()
macro, that section is referred from the comment of the macro too.

Link: https://lkml.kernel.org/r/167081321427.387937.15475445689482551048.stgit@devnote3
Link: https://lore.kernel.org/all/20221211115218.2e6e289bb85f8cf53c11aa97@kernel.org/T/#u
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

 Documentation/fault-injection/fault-injection.rst |   65 ++++++++++++
 include/asm-generic/error-injection.h             |    6 -
 2 files changed, 69 insertions(+), 2 deletions(-)

--- a/Documentation/fault-injection/fault-injection.rst~docs-fault-injection-add-requirements-of-error-injectable-functions
+++ a/Documentation/fault-injection/fault-injection.rst
@@ -231,6 +231,71 @@ proc entries
 	This feature is intended for systematic testing of faults in a single
 	system call. See an example below.
 
+
+Error Injectable Functions
+--------------------------
+
+This part is for the kenrel developers considering to add a function to
+ALLOW_ERROR_INJECTION() macro.
+
+Requirements for the Error Injectable Functions
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Since the function-level error injection forcibly changes the code path
+and returns an error even if the input and conditions are proper, this can
+cause unexpected kernel crash if you allow error injection on the function
+which is NOT error injectable. Thus, you (and reviewers) must ensure;
+
+- The function returns an error code if it fails, and the callers must check
+  it correctly (need to recover from it).
+
+- The function does not execute any code which can change any state before
+  the first error return. The state includes global or local, or input
+  variable. For example, clear output address storage (e.g. `*ret = NULL`),
+  increments/decrements counter, set a flag, preempt/irq disable or get
+  a lock (if those are recovered before returning error, that will be OK.)
+
+The first requirement is important, and it will result in that the release
+(free objects) functions are usually harder to inject errors than allocate
+functions. If errors of such release functions are not correctly handled
+it will cause a memory leak easily (the caller will confuse that the object
+has been released or corrupted.)
+
+The second one is for the caller which expects the function should always
+does something. Thus if the function error injection skips whole of the
+function, the expectation is betrayed and causes an unexpected error.
+
+Type of the Error Injectable Functions
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Each error injectable functions will have the error type specified by the
+ALLOW_ERROR_INJECTION() macro. You have to choose it carefully if you add
+a new error injectable function. If the wrong error type is chosen, the
+kernel may crash because it may not be able to handle the error.
+There are 4 types of errors defined in include/asm-generic/error-injection.h
+
+EI_ETYPE_NULL
+  This function will return `NULL` if it fails. e.g. return an allocateed
+  object address.
+
+EI_ETYPE_ERRNO
+  This function will return an `-errno` error code if it fails. e.g. return
+  -EINVAL if the input is wrong. This will include the functions which will
+  return an address which encodes `-errno` by ERR_PTR() macro.
+
+EI_ETYPE_ERRNO_NULL
+  This function will return an `-errno` or `NULL` if it fails. If the caller
+  of this function checks the return value with IS_ERR_OR_NULL() macro, this
+  type will be appropriate.
+
+EI_ETYPE_TRUE
+  This function will return `true` (non-zero positive value) if it fails.
+
+If you specifies a wrong type, for example, EI_TYPE_ERRNO for the function
+which returns an allocated object, it may cause a problem because the returned
+value is not an object address and the caller can not access to the address.
+
+
 How to add new fault injection capability
 -----------------------------------------
 
--- a/include/asm-generic/error-injection.h~docs-fault-injection-add-requirements-of-error-injectable-functions
+++ a/include/asm-generic/error-injection.h
@@ -19,8 +19,10 @@ struct pt_regs;
 
 #ifdef CONFIG_FUNCTION_ERROR_INJECTION
 /*
- * Whitelist generating macro. Specify functions which can be
- * error-injectable using this macro.
+ * Whitelist generating macro. Specify functions which can be error-injectable
+ * using this macro. If you unsure what is required for the error-injectable
+ * functions, please read Documentation/fault-injection/fault-injection.rst
+ * 'Error Injectable Functions' section.
  */
 #define ALLOW_ERROR_INJECTION(fname, _etype)				\
 static struct error_injection_entry __used				\
_

Patches currently in -mm which might be from mhiramat@kernel.org are

error-injection-remove-ei_etype_none.patch
docs-fault-injection-add-requirements-of-error-injectable-functions.patch


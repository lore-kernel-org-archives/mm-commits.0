Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC629C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 23:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77C423B44
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 23:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgLHX6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgLHX6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Dec 2020 18:58:52 -0500
Date:   Tue, 08 Dec 2020 15:58:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607471891;
        bh=eCPvH2rLtvftu0ECvVYcAcDETfJ0POx64+eofH2ImFU=;
        h=From:To:Subject:From;
        b=PqDsDuTWIph4zzr/Rd+2guAXYfTWA2EQ50Q1epdn0p70htpr+JwhRIjHUWAAbHP0F
         N/bkV5eWcjJj27gmvJK2zzdONh9j2AJlkpAROL5AFqdmUbNSSEbd7FAD3EqDXPnOVV
         6cRTMB3xn6xTI/jD7xdOZ6XPBlirx974zh+MsPE0=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, serge@hallyn.com,
        john.johansen@canonical.com, jmorris@namei.org,
        andriy.shevchenko@linux.intel.com
Subject:  + apparmor-remove-duplicate-macro-list_entry_is_head.patch
 added to -mm tree
Message-ID: <20201208235810.oTyQw%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: apparmor: remove duplicate macro list_entry_is_head()
has been added to the -mm tree.  Its filename is
     apparmor-remove-duplicate-macro-list_entry_is_head.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/apparmor-remove-duplicate-macro-list_entry_is_head.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/apparmor-remove-duplicate-macro-list_entry_is_head.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: apparmor: remove duplicate macro list_entry_is_head()

Strangely I hadn't had noticed the existence of the list_entry_is_head()
in apparmor code when added the same one in the list.h.  Luckily it's
fully identical and didn't break builds.  In any case we don't need a
duplicate anymore, thus remove it from apparmor code.

Link: https://lkml.kernel.org/r/20201208100639.88182-1-andriy.shevchenko@linux.intel.com
Fixes: e130816164e244 ("include/linux/list.h: add a macro to test if entry is pointing to the head")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E . Hallyn " <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/apparmor/apparmorfs.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/security/apparmor/apparmorfs.c~apparmor-remove-duplicate-macro-list_entry_is_head
+++ a/security/apparmor/apparmorfs.c
@@ -2046,9 +2046,6 @@ fail2:
 	return error;
 }
 
-
-#define list_entry_is_head(pos, head, member) (&pos->member == (head))
-
 /**
  * __next_ns - find the next namespace to list
  * @root: root namespace to stop search at (NOT NULL)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch


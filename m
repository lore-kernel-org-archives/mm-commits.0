Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365A8E7D0BC
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjIVBeo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjIVBej (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:34:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C135EF4;
        Thu, 21 Sep 2023 18:34:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A3C433C7;
        Fri, 22 Sep 2023 01:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346473;
        bh=RoOqiADMW93lOJZw5qLeWTM8S1+LP6nBtl7kmLV67kE=;
        h=Date:To:From:Subject:From;
        b=hgk9mldgYWF/3Qc9yLBC0weVwLwBBnnqz8HF9iDvETmJwldOAILErlH1llQV1u1M6
         BQzrnt27n+a7eNyhUAc3l3HgojdaA3B7fzOSK7lYT1x//yHthMk3Ylc+HlyaLMtWQE
         S6pOudMA9hJMIsCbe/l/ncSzm2LOHg+g2nv6wTKs=
Date:   Thu, 21 Sep 2023 18:34:32 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, stable@vger.kernel.org,
        ryan.roberts@arm.com, peterx@redhat.com, mhocko@suse.com,
        kpsingh@kernel.org, keescook@chromium.org, joey.gouly@arm.com,
        izbyshev@ispras.ru, gthelen@google.com, david@redhat.com,
        catalin.marinas@arm.com, broonie@kernel.org, ayush.jain3@amd.com,
        anshuman.khandual@arm.com, revest@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch added to mm-unstable branch
Message-Id: <20230922013433.5D1A3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make PR_MDWE_REFUSE_EXEC_GAIN an unsigned long
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch

This patch will later appear in the mm-unstable branch at
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
From: Florent Revest <revest@chromium.org>
Subject: mm: make PR_MDWE_REFUSE_EXEC_GAIN an unsigned long
Date: Mon, 28 Aug 2023 17:08:56 +0200

Defining a prctl flag as an int is a footgun because on a 64 bit machine
and with a variadic implementation of prctl (like in musl and glibc), when
used directly as a prctl argument, it can get casted to long with garbage
upper bits which would result in unexpected behaviors.

This patch changes the constant to an unsigned long to eliminate that
possibilities.  This does not break UAPI.

Link: https://lkml.kernel.org/r/20230828150858.393570-5-revest@chromium.org
Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
Signed-off-by: Florent Revest <revest@chromium.org>
Suggested-by: Alexey Izbyshev <izbyshev@ispras.ru>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/prctl.h       |    2 +-
 tools/include/uapi/linux/prctl.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/prctl.h~mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long
+++ a/include/uapi/linux/prctl.h
@@ -283,7 +283,7 @@ struct prctl_mm_map {
 
 /* Memory deny write / execute */
 #define PR_SET_MDWE			65
-# define PR_MDWE_REFUSE_EXEC_GAIN	1
+# define PR_MDWE_REFUSE_EXEC_GAIN	(1UL << 0)
 
 #define PR_GET_MDWE			66
 
--- a/tools/include/uapi/linux/prctl.h~mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long
+++ a/tools/include/uapi/linux/prctl.h
@@ -283,7 +283,7 @@ struct prctl_mm_map {
 
 /* Memory deny write / execute */
 #define PR_SET_MDWE			65
-# define PR_MDWE_REFUSE_EXEC_GAIN	1
+# define PR_MDWE_REFUSE_EXEC_GAIN	(1UL << 0)
 
 #define PR_GET_MDWE			66
 
_

Patches currently in -mm which might be from revest@chromium.org are

kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test.patch
kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch
kselftest-vm-check-errnos-in-mdwe_test.patch
mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch
mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch
kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch


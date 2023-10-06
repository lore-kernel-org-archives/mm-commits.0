Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5004EE94133
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbjJFVsB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbjJFVrq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7156E10E;
        Fri,  6 Oct 2023 14:47:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0A6C433C8;
        Fri,  6 Oct 2023 21:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628865;
        bh=ux3gL0mi7ZOJBcaEmLh4fGqG4Z4Ip+jU1XdzxEsrX6E=;
        h=Date:To:From:Subject:From;
        b=Yr1cYFMY311akwsn2CElPpDsshqr+kpX+5/gxzf3LdRouHGvXc1rwOirGGk1xjv8N
         eCtmLYWx+j9XmWZugimIWtyZ6zrNIPVKC36Ypy1ppeCTKVvvsMc9/kAbUqFBBdGAw8
         KyUVJQYDl5musFi8op8CCmf6HqIdXWBxSQqp05R4=
Date:   Fri, 06 Oct 2023 14:47:42 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, stable@vger.kernel.org,
        ryan.roberts@arm.com, peterx@redhat.com, mhocko@suse.com,
        kpsingh@kernel.org, keescook@chromium.org, joey.gouly@arm.com,
        izbyshev@ispras.ru, gthelen@google.com, david@redhat.com,
        catalin.marinas@arm.com, broonie@kernel.org, ayush.jain3@amd.com,
        anshuman.khandual@arm.com, revest@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch removed from -mm tree
Message-Id: <20231006214744.AE0A6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make PR_MDWE_REFUSE_EXEC_GAIN an unsigned long
has been removed from the -mm tree.  Its filename was
     mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

I think that a stable backport would be "nice to have": to reduce the
chances that users build binaries that could end up with garbage bits in
their MDWE prctl arguments.  We are not aware of anyone having yet
encountered this corner case with MDWE prctls but a backport would reduce
the likelihood it happens, since this sort of issues has happened with
other prctls.  But If this is perceived as a backporting burden, I suppose
we could also live without a stable backport.

Link: https://lkml.kernel.org/r/20230828150858.393570-5-revest@chromium.org
Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
Signed-off-by: Florent Revest <revest@chromium.org>
Suggested-by: Alexey Izbyshev <izbyshev@ispras.ru>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
Cc: <stable@vger.kernel.org>
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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887E5C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 21:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiLPVch (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 16:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLPVcf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 16:32:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5957061D7B
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 13:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D9B62222
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 21:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C438C433EF;
        Fri, 16 Dec 2022 21:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671226352;
        bh=IxHucLhTK9iIKlC/eVr65F1igaHOgINp2FRh+q/QLQg=;
        h=Date:To:From:Subject:From;
        b=Vq2nsGfgs+e90qZ60Krl9FIn9i4sTYUv4oMSP3sljuGvs9mLV5Dg5envrCS8q31Rl
         DPXQFLNFKlLv88d+e/YrJCa/F1qYhdU6MK+6tm2s9KKBiS4hDONAiSwfhjxYD1wSxM
         jchf7kCRoGy59EyT4aiOAxYWoikQf1TnP91yk1qA=
Date:   Fri, 16 Dec 2022 13:32:31 -0800
To:     mm-commits@vger.kernel.org, jeffxu@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch added to mm-unstable branch
Message-Id: <20221216213232.3C438C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix
Date: Fri Dec 16 01:31:26 PM PST 2022

remove unneeded register_pid_ns_ctl_table_vm() stub, per Jeff

Cc: Jeff Xu <jeffxu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_sysctl.h |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/pid_sysctl.h~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix
+++ a/kernel/pid_sysctl.h
@@ -54,7 +54,6 @@ static inline void register_pid_ns_sysct
 #else
 static inline void initialize_memfd_noexec_scope(struct pid_namespace *ns) {}
 static inline void set_memfd_noexec_scope(struct pid_namespace *ns) {}
-static inline void register_pid_ns_ctl_table_vm(void) {}
 static inline void register_pid_ns_sysctl_table_vm(void) {}
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
error-injection-remove-ei_etype_none-fix.patch


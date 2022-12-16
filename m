Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5071C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 03:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLPDE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 22:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLPDE4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 22:04:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2137650D73
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 19:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B388D61FE1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 03:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FDFC433EF;
        Fri, 16 Dec 2022 03:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671159895;
        bh=epZ99mC+/Euu5QdXRkHDroxTapp+0J5tl/DiDLAEHDM=;
        h=Date:To:From:Subject:From;
        b=ZtqLLz69/L5AdPaA8om7W4sR+jcGlsIpsnvFWYHXMnMSXRZsuaMfBKO9sv4Atz7YK
         +bvXznJFiA7VGaNmYHDCuF4Ymvt/HvGWjAXmLIll/3kb/OwCrIyGLRyNsq207AQxgt
         kjLSN+BG62YYc3679dpJTGXTCPEM1OK5nV+RH+js=
Date:   Thu, 15 Dec 2022 19:04:54 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        jeffxu@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch added to mm-unstable branch
Message-Id: <20221216030455.16FDFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch

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
Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix
Date: Thu Dec 15 06:58:24 PM PST 2022

add stub functions to fix build

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Xu <jeffxu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_sysctl.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/pid_sysctl.h~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix
+++ a/kernel/pid_sysctl.h
@@ -52,8 +52,10 @@ static inline void register_pid_ns_sysct
 	register_sysctl_paths(vm_path, pid_ns_ctl_table_vm);
 }
 #else
+static inline void initialize_memfd_noexec_scope(struct pid_namespace *ns) {}
 static inline void set_memfd_noexec_scope(struct pid_namespace *ns) {}
 static inline void register_pid_ns_ctl_table_vm(void) {}
+static inline void register_pid_ns_sysctl_table_vm(void) {}
 #endif
 
 #endif /* LINUX_PID_SYSCTL_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
error-injection-remove-ei_etype_none-fix.patch


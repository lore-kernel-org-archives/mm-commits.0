Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DF2C3DA7A
	for <mm-commits@archiver.kernel.org>; Tue, 20 Dec 2022 22:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiLTWIV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Dec 2022 17:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiLTWIU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2022 17:08:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5395CB54
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2022 14:08:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E098B81A21
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2022 22:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC003C433D2;
        Tue, 20 Dec 2022 22:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671574096;
        bh=Fk2QY4V+RFIOrTXnjfYCW5+JYkveL/1siiRt8rqbrvw=;
        h=Date:To:From:Subject:From;
        b=09G1oJcAOVyNe2zpHzzASU9hTqxm0u7XW5mcsG9/R7DtGP7hb/dymUAqbRcn6JDOL
         R1sAu+7AMfUk2UX/SHe8USEBQoSbg9r/qXoxd6sjbydzCnm5MUKaIZZWV021kHrc0Z
         tvySdzAutyKVSD6jekDOkKwcoWQXa1mtSSCZnkbs=
Date:   Tue, 20 Dec 2022 14:08:15 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, jeffxu@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch added to mm-unstable branch
Message-Id: <20221220220816.BC003C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch

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
Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
Date: Tue Dec 20 02:06:58 PM PST 2022

fix CONFIG_SYSCTL=n warning

Reported-by: kernel test robot <lkp@intel.com>
Cc: Jeff Xu <jeffxu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd.c~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
+++ a/mm/memfd.c
@@ -271,7 +271,6 @@ SYSCALL_DEFINE2(memfd_create,
 		unsigned int, flags)
 {
 	char comm[TASK_COMM_LEN];
-	struct pid_namespace *ns;
 	unsigned int *file_seals;
 	struct file *file;
 	int fd, error;
@@ -295,6 +294,7 @@ SYSCALL_DEFINE2(memfd_create,
 	if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
 #ifdef CONFIG_SYSCTL
 		int sysctl = MEMFD_NOEXEC_SCOPE_EXEC;
+		struct pid_namespace *ns;
 
 		ns = task_active_pid_ns(current);
 		if (ns)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
error-injection-remove-ei_etype_none-fix.patch


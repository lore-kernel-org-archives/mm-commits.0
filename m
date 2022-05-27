Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09A8C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349744AbiE0Qji (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349694AbiE0Qjg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:39:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3823BAEE10
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C32B825AF
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD2AC385A9;
        Fri, 27 May 2022 16:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669572;
        bh=yu7Fo+GWP8AG746ERJ5ZPDD8lvprJIdU2C/rMyqIfgU=;
        h=Date:To:From:Subject:From;
        b=Q9pGLfx02nFT6FC5Mho2Sck6Sy3+W+A7qN57XNMNO+acJuW5YEC+pMaC4R98eS6Xs
         IcZCDslMpvPns7OyytCzK/pOeWBuTr3LRWGYxR6hBRubTtLIGMEuqoy5nfOhHx9f8Z
         q5cZqGoGSqAum4fDLf+ZlplSk1Gr6y2BOI8BblTI=
Date:   Fri, 27 May 2022 09:39:31 -0700
To:     mm-commits@vger.kernel.org, naveen.n.rao@linux.vnet.ibm.com,
        mpe@ellerman.id.au, ebiederm@xmission.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch removed from -mm tree
Message-Id: <20220527163932.7AD2AC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix
has been removed from the -mm tree.  Its filename was
     kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix
Date: Thu May 19 10:19:00 AM PDT 2022

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/kexec.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix
+++ a/arch/s390/include/asm/kexec.h
@@ -9,6 +9,8 @@
 #ifndef _S390_KEXEC_H
 #define _S390_KEXEC_H
 
+#include <linux/module.h>
+
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/setup.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-shmemc-suppress-shift-warning.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


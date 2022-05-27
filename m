Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEE4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 15:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiE0PwZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 11:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353712AbiE0PwZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 11:52:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA1013C1E1
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 08:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD3E61D6A
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 15:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2DEC385A9;
        Fri, 27 May 2022 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653666740;
        bh=bpgQF6uU/2WE/hFI8YKjfCQVcLucB6uQoLr3bd7+1Bg=;
        h=Date:To:From:Subject:From;
        b=VBBlx390iaZf+vNmljCu5Kt/eP2SRoiiaO83EXjhTDcz7v6CO0nTJrNFI815BQYM1
         dedRDhtjU7baeSinUrLxjcmI59hmc7M4iP3N2IE9YoZt5bKFkupFAb0Cej2K+xlCnb
         JyLuQ/hq2J7/G5Qr+0G6d/zmMov0lNz71mE5E0Ck=
Date:   Fri, 27 May 2022 08:52:19 -0700
To:     mm-commits@vger.kernel.org, naveen.n.rao@linux.vnet.ibm.com,
        mpe@ellerman.id.au, ebiederm@xmission.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch removed from -mm tree
Message-Id: <20220527155220.5F2DEC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix
has been removed from the -mm tree.  Its filename was
     kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch

This patch was dropped because it was folded into kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations.patch

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

kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations.patch
mm-page_table_check-fix-accessing-unmapped-ptep-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-shmemc-suppress-shift-warning.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


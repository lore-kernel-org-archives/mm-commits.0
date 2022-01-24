Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED90C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386761AbiAYDo7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3413951AbiAYAl3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:41:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03410C05430C
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 14:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5AFACE13B6
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85AEC340E4;
        Mon, 24 Jan 2022 22:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643063324;
        bh=xU7hh9fO1L0YKbS/YwewcK54F3WOtJaolV9ytbRO5E0=;
        h=Date:From:To:Subject:From;
        b=lByo4CI53jwVlk6TiCkkqXrRsai4sVNj1W5zr3ILiRZnVrfNoVzBu/8L/Sh090fKI
         w6j2WyLfa/wQVIQ50p+WXEowFO1E3nWmJ71UhSy96C8unA1lgsxKt7znB70CHPWcQH
         /1PHCViZDjUvjQQv/l3oX4emgCN35H7BxPCkwGPc=
Date:   Mon, 24 Jan 2022 14:28:43 -0800
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, hch@infradead.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tony.luck@intel.com
Subject:  +
 ia64-make-ia64_mca_recovery-bool-instead-of-tristate.patch added to -mm
 tree
Message-ID: <20220124222843.H489ykWjC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: make IA64_MCA_RECOVERY bool instead of tristate
has been added to the -mm tree.  Its filename is
     ia64-make-ia64_mca_recovery-bool-instead-of-tristate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-make-ia64_mca_recovery-bool-instead-of-tristate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-make-ia64_mca_recovery-bool-instead-of-tristate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: make IA64_MCA_RECOVERY bool instead of tristate

In linux-next, IA64_MCA_RECOVERY uses the (new) function make_task_dead(),
which is not exported for use by modules.  Instead of exporting it for one
user, convert IA64_MCA_RECOVERY to be a bool Kconfig symbol.

In a config file from "kernel test robot <lkp@intel.com>" for a different
problem, this linker error was exposed when CONFIG_IA64_MCA_RECOVERY=m.

Fixes this build error:

ERROR: modpost: "make_task_dead" [arch/ia64/kernel/mca_recovery.ko] undefined!

Link: https://lkml.kernel.org/r/20220124213129.29306-1-rdunlap@infradead.org
Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/Kconfig~ia64-make-ia64_mca_recovery-bool-instead-of-tristate
+++ a/arch/ia64/Kconfig
@@ -318,7 +318,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config IA64_PALINFO
 	tristate "/proc/pal support"
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ia64-make-ia64_mca_recovery-bool-instead-of-tristate.patch
sysctl-documentation-fix-table-format-warning.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEC1C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 22:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbjK2WZi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 17:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbjK2WZh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 17:25:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D0F171B
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 14:24:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49B0C433C9;
        Wed, 29 Nov 2023 22:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701296686;
        bh=6l0LFh+tT1gTERFfDeTg2oTmx1lgFX0zvl2oIwSj5Ow=;
        h=Date:To:From:Subject:From;
        b=pPYaSL0s0V+MTMKdZ0QMT0l1On6svHWqE9lmRn2s15I9kTK6YDz397U+7XIzZLqaD
         sJ3x2ZELkJf3YvIn+pRKYar7ZJc+tb1Jq+yVGBKbXM3FkuKLTIstxfiMnDUg2hk8Qb
         /5X70TmNtqj1++DK3uLW52aADaAa6wNX5uyf2ir0=
Date:   Wed, 29 Nov 2023 14:24:46 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, bhe@redhat.com,
        agordeev@linux.ibm.com, ignat@cloudflare.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump.patch added to mm-hotfixes-unstable branch
Message-Id: <20231129222446.C49B0C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: drop dependency on ARCH_SUPPORTS_KEXEC from CRASH_DUMP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ignat Korchagin <ignat@cloudflare.com>
Subject: kexec: drop dependency on ARCH_SUPPORTS_KEXEC from CRASH_DUMP
Date: Wed, 29 Nov 2023 22:04:09 +0000

In commit f8ff23429c62 ("kernel/Kconfig.kexec: drop select of KEXEC for
CRASH_DUMP") we tried to fix a config regression, where CONFIG_CRASH_DUMP
required CONFIG_KEXEC.

However, it was not enough at least for arm64 platforms.  While further
testing the patch with our arm64 config I noticed that CONFIG_CRASH_DUMP
is unavailable in menuconfig.  This is because CONFIG_CRASH_DUMP still
depends on the new CONFIG_ARCH_SUPPORTS_KEXEC introduced in commit
91506f7e5d21 ("arm64/kexec: refactor for kernel/Kconfig.kexec") and on
arm64 CONFIG_ARCH_SUPPORTS_KEXEC requires CONFIG_PM_SLEEP_SMP=y, which in
turn requires either CONFIG_SUSPEND=y or CONFIG_HIBERNATION=y neither of
which are set in our config.

Given that we already established that CONFIG_KEXEC (which is a switch for
kexec system call itself) is not required for CONFIG_CRASH_DUMP drop
CONFIG_ARCH_SUPPORTS_KEXEC dependency as well.  The arm64 kernel builds
just fine with CONFIG_CRASH_DUMP=y and with both CONFIG_KEXEC=n and
CONFIG_KEXEC_FILE=n after f8ff23429c62 ("kernel/Kconfig.kexec: drop select
of KEXEC for CRASH_DUMP") and this patch are applied given that the
necessary shared bits are included via CONFIG_KEXEC_CORE dependency.

Link: https://lkml.kernel.org/r/20231129220409.55006-1-ignat@cloudflare.com
Fixes: 91506f7e5d21 ("arm64/kexec: refactor for kernel/Kconfig.kexec")
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Cc: <stable@vger.kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/Kconfig.kexec~kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump
+++ a/kernel/Kconfig.kexec
@@ -94,7 +94,6 @@ config KEXEC_JUMP
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on ARCH_SUPPORTS_CRASH_DUMP
-	depends on ARCH_SUPPORTS_KEXEC
 	select CRASH_CORE
 	select KEXEC_CORE
 	help
_

Patches currently in -mm which might be from ignat@cloudflare.com are

kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump.patch


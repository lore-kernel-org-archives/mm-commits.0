Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF593C04FE0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjHLWF6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjHLWFq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E971919AA
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB7A61046
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1026C433C8;
        Sat, 12 Aug 2023 22:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877939;
        bh=NGVY4ONls/UVaaiDQ/+GcCzNNQ15qEKNCCpGthsYG5c=;
        h=Date:To:From:Subject:From;
        b=H8CXy/6rrysQrWvUjt43Iybbe2Lk8dV5ghfdyi2iQxp2v1HvaSu851l7sCltQP7D5
         t1EExxNC7WnPDEXt2AAagBemR9cox/ftTPEkDdZaxWfxpwR4JRyOuU1ttR3ps2mFjs
         Ept5khhta1068XSJ/ggVFqXo/39RKOngUHkkvtzs=
Date:   Sat, 12 Aug 2023 15:05:39 -0700
To:     mm-commits@vger.kernel.org, agordeev@linux.ibm.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] remove-arch_default_kexec-from-kconfigkexec.patch removed from -mm tree
Message-Id: <20230812220539.D1026C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: remove ARCH_DEFAULT_KEXEC from Kconfig.kexec
has been removed from the -mm tree.  Its filename was
     remove-arch_default_kexec-from-kconfigkexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: remove ARCH_DEFAULT_KEXEC from Kconfig.kexec
Date: Wed, 2 Aug 2023 12:17:50 -0400

This patch is a minor cleanup to the series "refactor Kconfig to
consolidate KEXEC and CRASH options".

In that series, a new option ARCH_DEFAULT_KEXEC was introduced in order to
obtain the equivalent behavior of s390 original Kconfig settings for
KEXEC.  As it turns out, this new option did not fully provide the
equivalent behavior, rather a "select KEXEC" did.

As such, the ARCH_DEFAULT_KEXEC is not needed anymore, so remove it.

Link: https://lkml.kernel.org/r/20230802161750.2215-1-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig    |    3 ---
 kernel/Kconfig.kexec |    1 -
 2 files changed, 4 deletions(-)

--- a/arch/s390/Kconfig~remove-arch_default_kexec-from-kconfigkexec
+++ a/arch/s390/Kconfig
@@ -245,9 +245,6 @@ config PGTABLE_LEVELS
 
 source "kernel/livepatch/Kconfig"
 
-config ARCH_DEFAULT_KEXEC
-	def_bool y
-
 config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
--- a/kernel/Kconfig.kexec~remove-arch_default_kexec-from-kconfigkexec
+++ a/kernel/Kconfig.kexec
@@ -17,7 +17,6 @@ config HAVE_IMA_KEXEC
 
 config KEXEC
 	bool "Enable kexec system call"
-	default ARCH_DEFAULT_KEXEC
 	depends on ARCH_SUPPORTS_KEXEC
 	select KEXEC_CORE
 	help
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch


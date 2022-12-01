Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD84C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiLAAGf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiLAAEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E029074D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44BA96176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C797C433D7;
        Thu,  1 Dec 2022 00:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852920;
        bh=Vz7Sp+l6Igf5lJrXPMaHibLXnyz9UgOv7l3t+9BIW7Y=;
        h=Date:To:From:Subject:From;
        b=HaTy18GxWHHxU6K7KEqWGdd9mUkeD/URCZKPDhN/4XZ/NSzkI8gls2Ip8GxSGk3pI
         sIPF19E4eX1Bt857PT07m6ei5heGxTZ68DCrtkT6B3apO9c0E3BGPJm9M0084v2bRH
         pkJMKrWXjUIdJdGMUfm1S/KZh/ZJLqI20wrBhUYs=
Date:   Wed, 30 Nov 2022 16:01:59 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        masahiroy@kernel.org, arnd@arndb.de, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-make-config-secretmem-visible-with-expert.patch removed from -mm tree
Message-Id: <20221201000200.8C797C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: Kconfig: make config SECRETMEM visible with EXPERT
has been removed from the -mm tree.  Its filename was
     mm-kconfig-make-config-secretmem-visible-with-expert.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mm: Kconfig: make config SECRETMEM visible with EXPERT
Date: Wed, 16 Nov 2022 14:19:22 +0100

Commit 6a108a14fa35 ("kconfig: rename CONFIG_EMBEDDED to CONFIG_EXPERT")
introduces CONFIG_EXPERT to carry the previous intent of CONFIG_EMBEDDED
and just gives that intent a much better name.  That has been clearly a
good and long overdue renaming, and it is clearly an improvement to the
kernel build configuration that has shown to help managing the kernel
build configuration in the last decade.

However, rather than bravely and radically just deleting CONFIG_EMBEDDED,
this commit gives CONFIG_EMBEDDED a new intended semantics, but keeps it
open for future contributors to implement that intended semantics:

    A new CONFIG_EMBEDDED option is added that automatically selects
    CONFIG_EXPERT when enabled and can be used in the future to isolate
    options that should only be considered for embedded systems (RISC
    architectures, SLOB, etc).

Since then, this CONFIG_EMBEDDED implicitly had two purposes:

  - It can make even more options visible beyond what CONFIG_EXPERT makes
    visible. In other words, it may introduce another level of enabling the
    visibility of configuration options: always visible, visible with
    CONFIG_EXPERT and visible with CONFIG_EMBEDDED.

  - Set certain default values of some configurations differently,
    following the assumption that configuring a kernel build for an
    embedded system generally starts with a different set of default values
    compared to kernel builds for all other kind of systems.

Considering the second purpose, note that already probably arguing that a
kernel build for an embedded system would choose some values differently
is already tricky: the set of embedded systems with Linux kernels is
already quite diverse.  Many embedded system have powerful CPUs and it
would not be clear that all embedded systems just optimize towards one
specific aspect, e.g., a smaller kernel image size.  So, it is unclear if
starting with "one set of default configuration" that is induced by
CONFIG_EMBEDDED is a good offer for developers configuring their kernels.

Also, the differences of needed user-space features in an embedded system
compared to a non-embedded system are probably difficult or even
impossible to name in some generic way.

So it is not surprising that in the last decade hardly anyone has
contributed changes to make something default differently in case of
CONFIG_EMBEDDED=y.

Currently, in v6.0-rc4, SECRETMEM is the only config switched off if
CONFIG_EMBEDDED=y.

As long as that is actually the only option that currently is selected or
deselected, it is better to just make SECRETMEM configurable at build time
by experts using menuconfig instead.

Make SECRETMEM configurable when EXPERT is set and otherwise default to
yes.  Further, SECRETMEM needs ARCH_HAS_SET_DIRECT_MAP.

This allows us to remove CONFIG_EMBEDDED in the close future.

Link: https://lkml.kernel.org/r/20221116131922.25533-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-make-config-secretmem-visible-with-expert
+++ a/mm/Kconfig
@@ -1074,7 +1074,13 @@ config IO_MAPPING
 	bool
 
 config SECRETMEM
-	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
+	default y
+	bool "Enable memfd_secret() system call" if EXPERT
+	depends on ARCH_HAS_SET_DIRECT_MAP
+	help
+	  Enable the memfd_secret() system call with the ability to create
+	  memory areas visible only in the context of the owning process and
+	  not mapped to other processes and other kernel page tables.
 
 config ANON_VMA_NAME
 	bool "Anonymous VMA name support"
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D140C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiKPWE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiKPWEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:04:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFD866C89
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D03CB81ED9
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FABC433D6;
        Wed, 16 Nov 2022 22:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668636285;
        bh=d10l7gtFpphj5GvJ/A6xMImv83Gx+oOLBXYQ5mU13r0=;
        h=Date:To:From:Subject:From;
        b=BuhGTf0ZyGjU+WqxtV3ec4MWN5M9lm2uTTxK5WYpnky/QgpUh94ifmVC6sJSpvVhb
         QqRRcrOwdINZWViXgZcks7bRUN5xRA4vPqioU9JxvOyTzVD5/5WCsnIFT3Znf/vVcP
         KEnDQByaKl4rfkem8OALL1t3Rkljhj5wcRm5b2Y8=
Date:   Wed, 16 Nov 2022 14:04:44 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        masahiroy@kernel.org, arnd@arndb.de, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-make-config-secretmem-visible-with-expert.patch added to mm-unstable branch
Message-Id: <20221116220445.29FABC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Kconfig: make config SECRETMEM visible with EXPERT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kconfig-make-config-secretmem-visible-with-expert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-make-config-secretmem-visible-with-expert.patch

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
@@ -1091,7 +1091,13 @@ config IO_MAPPING
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

mm-kconfig-make-config-secretmem-visible-with-expert.patch


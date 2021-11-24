Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24AFC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344094AbhKXVj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344406AbhKXVjY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:39:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E5860555;
        Wed, 24 Nov 2021 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637789774;
        bh=OQSub4eOanL/mde5aEd4WVVb1eHV+P4v7XTFhqyjuiQ=;
        h=Date:From:To:Subject:From;
        b=uUU96nEr5L0BT5EmNlpSOCzgyYtp0C3CSyQ2F1vPnPwSXAeg1Q68ZIKO9LsS1geNM
         bkmqhqVSu5FF+2rgWxqsNq0fOouMyWCoS0YCNER/Dz1HHwvHh7SoDuglucdzXildTk
         j540pLSNdgqFWWqY3a3bDHTCBaouIfSqx5nqryd8=
Date:   Wed, 24 Nov 2021 13:36:13 -0800
From:   akpm@linux-foundation.org
To:     agruenba@redhat.com, catalin.marinas@arm.com, dsterba@suse.com,
        josef@toxicpanda.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org
Subject:  +
 arm64-add-support-for-sub-page-faults-user-probing.patch added to -mm tree
Message-ID: <20211124213613.gapJk5t8S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: add support for sub-page faults user probing
has been added to the -mm tree.  Its filename is
     arm64-add-support-for-sub-page-faults-user-probing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-add-support-for-sub-page-faults-user-probing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-add-support-for-sub-page-faults-user-probing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm64: add support for sub-page faults user probing

With MTE, even if the pte allows an access, a mismatched tag somewhere
within a page can still cause a fault.  Select ARCH_HAS_SUBPAGE_FAULTS if
MTE is enabled and implement probe_user_writeable().

Link: https://lkml.kernel.org/r/20211124192024.2408218-3-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    1 
 arch/arm64/include/asm/uaccess.h |   33 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/arch/arm64/include/asm/uaccess.h~arm64-add-support-for-sub-page-faults-user-probing
+++ a/arch/arm64/include/asm/uaccess.h
@@ -445,4 +445,37 @@ static inline int __copy_from_user_flush
 }
 #endif
 
+#ifdef CONFIG_ARCH_HAS_SUBPAGE_FAULTS
+static inline size_t __mte_probe_user_range(const char __user *uaddr,
+					    size_t size)
+{
+	const char __user *end = uaddr + size;
+	int err = 0;
+	char val;
+
+	uaddr = PTR_ALIGN_DOWN(uaddr, MTE_GRANULE_SIZE);
+	while (uaddr < end) {
+		/*
+		 * A read is sufficient for MTE, the caller should have probed
+		 * for the pte write permission.
+		 */
+		__raw_get_user(val, uaddr, err);
+		if (err)
+			return end - uaddr;
+		uaddr += MTE_GRANULE_SIZE;
+	}
+	(void)val;
+
+	return 0;
+}
+
+static inline size_t probe_user_writable(const void __user *uaddr,
+					 size_t size)
+{
+	if (!system_supports_mte())
+		return 0;
+	return __mte_probe_user_range(uaddr, size);
+}
+#endif /* CONFIG_ARCH_HAS_SUBPAGE_FAULTS */
+
 #endif /* __ASM_UACCESS_H */
--- a/arch/arm64/Kconfig~arm64-add-support-for-sub-page-faults-user-probing
+++ a/arch/arm64/Kconfig
@@ -1777,6 +1777,7 @@ config ARM64_MTE
 	depends on AS_HAS_LSE_ATOMICS
 	# Required for tag checking in the uaccess routines
 	depends on ARM64_PAN
+	select ARCH_HAS_SUBPAGE_FAULTS
 	select ARCH_USES_HIGH_VMA_FLAGS
 	help
 	  Memory Tagging (part of the ARMv8.5 Extensions) provides
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults.patch
arm64-add-support-for-sub-page-faults-user-probing.patch
btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B641C6369E
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 00:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A9B206E3
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 00:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgLCAh1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 19:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCAh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 19:37:27 -0500
Date:   Wed, 02 Dec 2020 16:36:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606955806;
        bh=WSelHXEzdHstOCGzDlQN8F3WSf7e2dwsPLytpU9OyiA=;
        h=From:To:Subject:From;
        b=HZf11Q4cKPh2U/M54zG6+Jar2OpEuXa5V84b0k+DLXQ+r4OJXvkXnQoQseKMWgryp
         4canTYokV+578de8MtD+dsbquV4gcrB8lt4dfNy+u69bGkw5t6xNk+vIGAOnBj2ZD9
         y+mUtSEW4OeYHXLCQcj3G00ThSonfpEJTOr8cUdw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  +
 init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch added to
 -mm tree
Message-ID: <20201203003645.tCsJnol50%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: don't assume scripts/lld-version.sh is executable
has been added to the -mm tree.  Its filename is
     init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init/Kconfig: don't assume scripts/lld-version.sh is executable

Kbuild should not assume that scripts have the x bit set.  This is because
downloading and applying patch-X.Y.gz is a supported way of updating the
kernel source, and patch(1) loses the x bit.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~init-kconfig-dont-assume-scripts-lld-versionsh-is-executable
+++ a/init/Kconfig
@@ -49,7 +49,7 @@ config CLANG_VERSION
 
 config LLD_VERSION
 	int
-	default $(shell,$(srctree)/scripts/lld-version.sh $(LD))
+	default $(shell,/bin/sh $(srctree)/scripts/lld-version.sh $(LD))
 
 config CC_CAN_LINK
 	bool
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch


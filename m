Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8484CEB64DD
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 02:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbjGFCzU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jul 2023 22:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjGFCzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2023 22:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740019B6;
        Wed,  5 Jul 2023 19:55:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E72C861458;
        Thu,  6 Jul 2023 02:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496AEC433C7;
        Thu,  6 Jul 2023 02:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688612115;
        bh=I3oQLGb7DDE3492bE5KuNY+wEpuZQhoPBEz7o4Q/umw=;
        h=Date:To:From:Subject:From;
        b=vzFobDJAcL47psaq8p66IX0SxmbCdn6yHgOSRBelNPTSeVzJh7ZZGs/FgCrDSamGQ
         Bf6kJsJagISjU8bKzGlHWWcX6MbofqOBhvh8xCwwb3SG6yWesvFF9/6dPGYMMJcLiQ
         8LBtRCgl4R+U52niaDIJbzy8RSwbxa6iN6Q2iatE=
Date:   Wed, 05 Jul 2023 19:55:14 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        jirislaby@kernel.org, jacobly.alt@gmail.com,
        holger@applied-asynchrony.com, david@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-disable-config_per_vma_lock-until-its-fixed.patch added to mm-hotfixes-unstable branch
Message-Id: <20230706025515.496AEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable CONFIG_PER_VMA_LOCK until its fixed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-disable-config_per_vma_lock-until-its-fixed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-disable-config_per_vma_lock-until-its-fixed.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: disable CONFIG_PER_VMA_LOCK until its fixed
Date: Wed, 5 Jul 2023 18:14:00 -0700

A memory corruption was reported in [1] with bisection pointing to the
patch [2] enabling per-VMA locks for x86.  Disable per-VMA locks config to
prevent this issue until the fix is confirmed.  This is expected to be a
temporary measure.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=217624
[2] https://lore.kernel.org/all/20230227173632.3292573-30-surenb@google.com

Link: https://lkml.kernel.org/r/20230706011400.2949242-3-surenb@google.com
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel.org/
Reported-by: Jacob Young <jacobly.alt@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217624
Fixes: 0bff0aaea03e ("x86/mm: try VMA lock-based page fault handling first")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Holger Hoffstätte <holger@applied-asynchrony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/Kconfig~mm-disable-config_per_vma_lock-until-its-fixed
+++ a/mm/Kconfig
@@ -1224,8 +1224,9 @@ config ARCH_SUPPORTS_PER_VMA_LOCK
        def_bool n
 
 config PER_VMA_LOCK
-	def_bool y
+	bool "Enable per-vma locking during page fault handling."
 	depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
+	depends on BROKEN
 	help
 	  Allow per-vma locking during page fault handling.
 
_

Patches currently in -mm which might be from surenb@google.com are

fork-lock-vmas-of-the-parent-process-when-forking.patch
mm-disable-config_per_vma_lock-until-its-fixed.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch


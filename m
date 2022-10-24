Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D701FA373F
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiJYAFc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJYAFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:05:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F40815FE2
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33870B816AD
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1FBC433D6;
        Mon, 24 Oct 2022 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650121;
        bh=7TObxtO5ha1dVMyA8looaIpsB982Ld10MImlFWbW7FM=;
        h=Date:To:From:Subject:From;
        b=0dsqO6fCVbobh7CLfKOxOjDB9L2KgGMNdMNE6Ac9r1jxDpoZNFNU0RPpfKomjMzr3
         tpZ93VBqnKjTAHONnMlDz2dIQPPpjzOoyQPcnOBtljkQOlgNcqDAWkKAYDh15+iBaq
         VzzFIs8NUxVdZAf6ahp7N9XwmINu+24a8VJPInGc=
Date:   Mon, 24 Oct 2022 15:22:01 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-purgatory-disable-kmsan-instrumentation.patch added to mm-hotfixes-unstable branch
Message-Id: <20221024222201.CC1FBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/purgatory: disable KMSAN instrumentation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-purgatory-disable-kmsan-instrumentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-purgatory-disable-kmsan-instrumentation.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: x86/purgatory: disable KMSAN instrumentation
Date: Mon, 24 Oct 2022 23:21:41 +0200

The stand-alone purgatory.ro does not contain the KMSAN runtime, therefore
it can't be built with KMSAN compiler instrumentation.

Link: https://lkml.kernel.org/r/20221024212144.2852069-2-glider@google.com
Link: https://github.com/google/kmsan/issues/89
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/purgatory/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/purgatory/Makefile~x86-purgatory-disable-kmsan-instrumentation
+++ a/arch/x86/purgatory/Makefile
@@ -26,6 +26,7 @@ GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
 UBSAN_SANITIZE	:= n
 KCSAN_SANITIZE	:= n
+KMSAN_SANITIZE	:= n
 KCOV_INSTRUMENT := n
 
 # These are adjustments to the compiler flags used for objects that
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-export-kmsan_copy_page_meta.patch
x86-purgatory-disable-kmsan-instrumentation.patch
kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch
x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch
x86-fortify-kmsan-fix-kmsan-fortify-builds.patch


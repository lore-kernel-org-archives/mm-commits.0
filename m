Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB40C7EE29
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 00:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbjFGAqx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 20:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbjFGAqr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 20:46:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE8519A1
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 17:46:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 302F663915
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 00:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F2DC433D2;
        Wed,  7 Jun 2023 00:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686098804;
        bh=J9mTUJSpDNSc/qhmegkXCMPZlLxqi1stcPdMaC1RwUg=;
        h=Date:To:From:Subject:From;
        b=w2Mill9+CAbGUZnsC7F2BzSi4dxUH7ya+jBtTgNIj1cFCGJHW6jWTIGp4ZwJ2UJWo
         2i3azPWu99unCHZAHkqmwalwY1+kvi7D1Ym1eRiyCD1BCQTFVjC2CKMHYbnZ546KcS
         XpWEzaMylqtqoJ9AsBxvMqIC0Ju+smvrce0ARJjQ=
Date:   Tue, 06 Jun 2023 17:46:43 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-entry-for-debug-objects.patch added to mm-hotfixes-unstable branch
Message-Id: <20230607004644.80F2DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for debug objects
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-entry-for-debug-objects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-entry-for-debug-objects.patch

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
From: Thomas Gleixner <tglx@linutronix.de>
Subject: MAINTAINERS: add entry for debug objects
Date: Wed, 07 Jun 2023 01:14:05 +0200

This is overdue and an oversight.

Add myself to this file deespite the fact that I'm trying to reduce the
number of entries in this file which have my name attached, but in the
hope that patches wont get picked up elsewhere completely unreviewed and
unnoticed.

Link: https://lkml.kernel.org/r/87v8g0ji9u.ffs@tglx
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-debug-objects
+++ a/MAINTAINERS
@@ -5727,6 +5727,14 @@ F:	include/linux/tfrc.h
 F:	include/uapi/linux/dccp.h
 F:	net/dccp/
 
+DEBUGOBJECTS:
+M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/debugobjects
+F:	lib/debugobjects.c
+F:	include/linux/debugobjects.h
+
 DECSTATION PLATFORM SUPPORT
 M:	"Maciej W. Rozycki" <macro@orcam.me.uk>
 L:	linux-mips@vger.kernel.org
_

Patches currently in -mm which might be from tglx@linutronix.de are

maintainers-add-entry-for-debug-objects.patch
mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch
mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch
mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch
mm-vmalloc-check-free-space-in-vmap_block-lockless.patch
mm-vmalloc-add-missing-read-write_once-annotations.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch


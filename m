Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5D8C38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 22:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjARWNU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjARWNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 17:13:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9B96600A
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 14:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A144661A7E
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 22:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B31C433EF;
        Wed, 18 Jan 2023 22:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674079981;
        bh=BKBbvyUmOuWyxFHFwH2NSfA4RcI1souurVDExGqg/Iw=;
        h=Date:To:From:Subject:From;
        b=0vclDlSXHnzmSgkHCYP19S0bE23guLaGTzKZleubGJFTATIlS5Fxn8qEPu9SSEd9i
         OpXkJkdVMf1A0l+d2soB77+QEMsJ5QsPAvCPFhOlvqHSy0p+WoKjYOh8V7Fj2AXNM0
         p2s8g6GIUTp+yu8kmamo1OYd9nZQ2qRNPTZfaAiY=
Date:   Wed, 18 Jan 2023 14:13:00 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, scweaver@redhat.com,
        jforbes@redhat.com, dzickus@redhat.com, herton@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-allow-users-to-provide-additional-cflags-ldflags.patch added to mm-unstable branch
Message-Id: <20230118221301.02B31C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/mm: allow users to provide additional cflags/ldflags
has been added to the -mm mm-unstable branch.  Its filename is
     tools-vm-allow-users-to-provide-additional-cflags-ldflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-vm-allow-users-to-provide-additional-cflags-ldflags.patch

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
From: "Herton R. Krzesinski" <herton@redhat.com>
Subject: tools/mm: allow users to provide additional cflags/ldflags
Date: Mon, 16 Jan 2023 19:49:21 -0300

Right now there is no way to provide additional cflags/ldflags when
building tools/vm binaries.  And using eg.  make CFLAGS=<options> will
override the CFLAGS being set in the Makefile, making the build fail since
it requires the include of the ../lib dir (for libapi).

This change then allows you to specify:
CFLAGS=<options> LDFLAGS=<options> make V=1 -C tools/vm

And the options will be correctly appended as can be seen from the
make output.

Link: https://lkml.kernel.org/r/20230116224921.4106324-1-herton@redhat.com
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Justin Forbes <jforbes@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Scott Weaver <scweaver@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/mm/Makefile~tools-vm-allow-users-to-provide-additional-cflags-ldflags
+++ a/tools/mm/Makefile
@@ -8,8 +8,8 @@ TARGETS=page-types slabinfo page_owner_s
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
 
-CFLAGS = -Wall -Wextra -I../lib/
-LDFLAGS = $(LIBS)
+CFLAGS += -Wall -Wextra -I../lib/
+LDFLAGS += $(LIBS)
 
 all: $(TARGETS)
 
_

Patches currently in -mm which might be from herton@redhat.com are

tools-vm-allow-users-to-provide-additional-cflags-ldflags.patch


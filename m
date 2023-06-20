Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A9FEB64D7
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jun 2023 18:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjFTSEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jun 2023 14:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjFTSDp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2023 14:03:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AEBF1
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 11:03:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 895C86135A
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 18:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B6C433C0;
        Tue, 20 Jun 2023 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687284222;
        bh=9kgfNbWXUyI49sG484kYKkJRuOO7or01nrJF6wFsNO8=;
        h=Date:To:From:Subject:From;
        b=NVj187qTG/vrzUzvNyMRr3pB36LRTnNcqlUy/8KnJfzysHyhKuhPz1xzLE12xmRIH
         ggROCpvmh3AfII+EgzW9R++r4GaodnUCFyjU/Hmwzx/HRD1C6H1sx9Gkws5zqI7+Z7
         /HfppHukMnU6tSjVnoo+zDxmOSbGqEXIFx+MtifU=
Date:   Tue, 20 Jun 2023 11:03:42 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tarasmadan@google.com, ryabinin.a.a@gmail.com, nogikh@google.com,
        glider@google.com, dvyukov@google.com, corbet@lwn.net,
        catalin.marinas@arm.com, andreyknvl@gmail.com, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-doc-note-kasanfault=panic_on_write-behaviour-for-async-modes.patch added to mm-unstable branch
Message-Id: <20230620180342.D53B6C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, doc: note kasan.fault=panic_on_write behaviour for async modes
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-doc-note-kasanfault=panic_on_write-behaviour-for-async-modes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-doc-note-kasanfault=panic_on_write-behaviour-for-async-modes.patch

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
From: Marco Elver <elver@google.com>
Subject: kasan, doc: note kasan.fault=panic_on_write behaviour for async modes
Date: Tue, 20 Jun 2023 19:17:35 +0200

Note the behaviour of kasan.fault=panic_on_write for async modes, since
all asynchronous faults will result in panic (even if they are reads).

Link: https://lkml.kernel.org/r/ZJHfL6vavKUZ3Yd8@elver.google.com
Fixes: 452c03fdbed0 ("kasan: add support for kasan.fault=panic_on_write")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-doc-note-kasanfault=panic_on_write-behaviour-for-async-modes
+++ a/Documentation/dev-tools/kasan.rst
@@ -110,7 +110,9 @@ parameter can be used to control panic a
 - ``kasan.fault=report``, ``=panic``, or ``=panic_on_write`` controls whether
   to only print a KASAN report, panic the kernel, or panic the kernel on
   invalid writes only (default: ``report``). The panic happens even if
-  ``kasan_multi_shot`` is enabled.
+  ``kasan_multi_shot`` is enabled. Note that when using asynchronous mode of
+  Hardware Tag-Based KASAN, ``kasan.fault=panic_on_write`` always panics on
+  asynchronously checked accesses (including reads).
 
 Software and Hardware Tag-Based KASAN modes (see the section about various
 modes below) support altering stack trace collection behavior:
_

Patches currently in -mm which might be from elver@google.com are

kasan-doc-note-kasanfault=panic_on_write-behaviour-for-async-modes.patch


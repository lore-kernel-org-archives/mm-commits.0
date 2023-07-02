Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FDCEB64DD
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 18:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjGBSBm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 14:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjGBSBj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 14:01:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9386391
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 11:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2666D60C77
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 18:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DC2C433C8;
        Sun,  2 Jul 2023 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688320897;
        bh=vcimAUkloecdP2IrbyIZurPXx7rm4XKGj2jUljmXM3A=;
        h=Date:To:From:Subject:From;
        b=r4OI+TDn36tNzwPGuSzTjVz/mp32whvR6lORFv9Tdc2zSu3sny6MB7kYIDfQG9d50
         oq18sPb6JvuoShFzArGcHy5SP3BNR8bsYEADCHXUEeK0wKozvblOidcCxfP/ZM0OxV
         w9DMWOKzmooYROU5kNaoBNMYFgL9bdnGsAeC8dZY=
Date:   Sun, 02 Jul 2023 11:01:36 -0700
To:     mm-commits@vger.kernel.org, bjorn@kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch added to mm-nonmm-unstable branch
Message-Id: <20230702180137.79DC2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: skip proc-empty-vm on anything but amd64 and i386
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: skip proc-empty-vm on anything but amd64 and i386
Date: Fri, 30 Jun 2023 21:34:34 +0300

This test is arch specific, requires "munmap everything" primitive.

Link: https://lkml.kernel.org/r/20230630183434.17434-2-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -1,3 +1,4 @@
+#if defined __amd64__ || defined __i386__
 /*
  * Copyright (c) 2022 Alexey Dobriyan <adobriyan@gmail.com>
  *
@@ -402,3 +403,9 @@ int main(void)
 
 	return rv;
 }
+#else
+int main(void)
+{
+	return 4;
+}
+#endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-support-proc-empty-vm-test-on-i386.patch
proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch


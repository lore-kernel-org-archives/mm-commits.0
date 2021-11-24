Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DF0C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhKXAXn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231515AbhKXAXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:23:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B145C60240;
        Wed, 24 Nov 2021 00:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637713229;
        bh=OROcPh6jP4xopgnCzzg9QrGVWQF7o1lmXEwLxkq87Fo=;
        h=Date:From:To:Subject:From;
        b=FoxeOSgCmFhicDjMGJWyxVmHlQiwRjijc2MUwYIbraxS5LOd/WzR5RZU6BdEvbEKP
         p5SgzSno13UtsIdYeikYtluctQGZUNi0fbKt3NfbUw2mDAmuOrlqgJfXAYFUia01dy
         XjQnnyWvPyVQvABlD9xpX6Z7lnnhQIOeTxyUbOq0=
Date:   Tue, 23 Nov 2021 16:20:29 -0800
From:   akpm@linux-foundation.org
To:     ccross@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, surenb@google.com
Subject:  +
 mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch added
 to -mm tree
Message-ID: <20211124002029.xqAm4tts2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: proc.rst: /proc/PID/maps: fix malformed table
has been added to the -mm tree.  Its filename is
     mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: docs: proc.rst: /proc/PID/maps: fix malformed table

Fix malformed table describing "pathname" values for mappings not
associated with a file.

Link: https://lkml.kernel.org/r/20211123185928.2513763-1-surenb@google.com
Fixes: 2df148be9486 ("mm: add a field to store names for private anonymous memory")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Colin Cross <ccross@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/proc.rst~mm-add-a-field-to-store-names-for-private-anonymous-memory-fix
+++ a/Documentation/filesystems/proc.rst
@@ -426,14 +426,14 @@ with the memory region, as the case woul
 The "pathname" shows the name associated file for this mapping.  If the mapping
 is not associated with a file:
 
- =======                    ====================================
+ =============              ====================================
  [heap]                     the heap of the program
  [stack]                    the stack of the main process
  [vdso]                     the "virtual dynamic shared object",
                             the kernel system call handler
-[anon:<name>]               an anonymous mapping that has been
+ [anon:<name>]              an anonymous mapping that has been
                             named by userspace
- =======                    ====================================
+ =============              ====================================
 
  or if empty, the mapping is anonymous.
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-anonymous-vma-name-refcounting.patch


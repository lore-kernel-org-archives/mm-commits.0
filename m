Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03E9C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC4E61151
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhJMW4j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 18:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhJMW4i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 18:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D4F761163;
        Wed, 13 Oct 2021 22:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634165674;
        bh=bPFOxrXjNAgXdhcSgd1+yhkGEuUeB1JkQAu2XXE/ZmY=;
        h=Date:From:To:Subject:From;
        b=z793Z23VfygAMTl3vC//KuuSW2HEt1xIwgSjnz/FGlOMzBX0uOG69e3m1I4z7yLDM
         0yHZfH398haCWQMzl8OCao+wtLj/IF4Tg7loWZBbu/t5mt5dt7IsCi7xHNn9tPx4hC
         3ntySjphi5Q8dPM7seT3FJW0DtaRLTOJKxsN5Mbs=
Date:   Wed, 13 Oct 2021 15:54:34 -0700
From:   akpm@linux-foundation.org
To:     liu.song11@zte.com.cn, mm-commits@vger.kernel.org
Subject:  +
 mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey.patch added to
 -mm tree
Message-ID: <20211013225434.lxh0C73Bh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: avoid repeated assignment in do_mprotect_pkey()
has been added to the -mm tree.  Its filename is
     mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Song <liu.song11@zte.com.cn>
Subject: mm/mprotect.c: avoid repeated assignment in do_mprotect_pkey()

After adjustment, the repeated assignment of "prev" is avoided, and the
readability of the code is improved.

Link: https://lkml.kernel.org/r/20211012152444.4127-1-fishland@aliyun.com
Signed-off-by: Liu Song <liu.song11@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey
+++ a/mm/mprotect.c
@@ -563,7 +563,7 @@ static int do_mprotect_pkey(unsigned lon
 	error = -ENOMEM;
 	if (!vma)
 		goto out;
-	prev = vma->vm_prev;
+
 	if (unlikely(grows & PROT_GROWSDOWN)) {
 		if (vma->vm_start >= end)
 			goto out;
@@ -581,8 +581,11 @@ static int do_mprotect_pkey(unsigned lon
 				goto out;
 		}
 	}
+
 	if (start > vma->vm_start)
 		prev = vma;
+	else
+		prev = vma->vm_prev;
 
 	for (nstart = start ; ; ) {
 		unsigned long mask_off_old_flags;
_

Patches currently in -mm which might be from liu.song11@zte.com.cn are

mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey.patch


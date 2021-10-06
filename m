Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31024C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 00:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E35661130
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 00:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhJFAUb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 20:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhJFAUb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 20:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB1C6611C0;
        Wed,  6 Oct 2021 00:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633479520;
        bh=7eGFXYwFc7VCJLITFhL1Zdi6rFXwXi2BZM6LopULWgg=;
        h=Date:From:To:Subject:From;
        b=Af/2VJA6xheLxPUTlJAv2k1lo2cCHmt8AHN2HufG48+2zvlhvHDzWajvcVO4PM0wt
         vcKx4YmQnTcQESCjpQEx7cIAC8FMY+al7W3aJAV182KCA8OuRU0YnjyjtD/QBiKfF2
         LDRiecIxDxb9GaAJnDyV3/oXlletT1W5cNPMjG0g=
Date:   Tue, 05 Oct 2021 17:18:39 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org,
        rf@opensource.cirrus.com
Subject:  + lib-uninline-simple_strntoull-as-well.patch added to
 -mm tree
Message-ID: <20211006001839.S8UrOINNB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: uninline simple_strntoull() as well
has been added to the -mm tree.  Its filename is
     lib-uninline-simple_strntoull-as-well.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-uninline-simple_strntoull-as-well.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-uninline-simple_strntoull-as-well.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib: uninline simple_strntoull() as well

Codegen become bloated again after simple_strntoull() introduction

	add/remove: 0/0 grow/shrink: 0/4 up/down: 0/-224 (-224)
	Function                                     old     new   delta
	simple_strtoul                                 5       2      -3
	simple_strtol                                 23      20      -3
	simple_strtoull                              119      15    -104
	simple_strtoll                               155      41    -114

Link: https://lkml.kernel.org/r/YVmlB9yY4lvbNKYt@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/vsprintf.c~lib-uninline-simple_strntoull-as-well
+++ a/lib/vsprintf.c
@@ -53,8 +53,7 @@
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
 
-static unsigned long long simple_strntoull(const char *startp, size_t max_chars,
-					   char **endp, unsigned int base)
+static noinline unsigned long long simple_strntoull(const char *startp, size_t max_chars, char **endp, unsigned int base)
 {
 	const char *cp;
 	unsigned long long result = 0ULL;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-uninline-simple_strntoull-as-well.patch


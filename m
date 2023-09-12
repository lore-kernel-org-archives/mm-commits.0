Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C68EE3F06
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 17:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbjILRhc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjILRhc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 13:37:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8349910E9
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 10:37:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A03C433C9;
        Tue, 12 Sep 2023 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694540248;
        bh=g5GcYyKfcBHHdUGGEYnQUMYqmiu/lA0XrIHZCZRn1GE=;
        h=Date:To:From:Subject:From;
        b=1nxdIoMev2lUDZnVIE/iA5aX0F1kcdc9hfPnlyF77yN25KWAL5OrCdV2VCaKzKoi8
         Kqv4e46z276qn4ICOmHWIqdTK8HFjHg4LKEiDPajrX6yEwOwhsxyikTnd2LJtbh3QD
         0tXS10dNXt7RMK/s6m8WhGnghoxxLRis+QO/+42s=
Date:   Tue, 12 Sep 2023 10:37:27 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + argv_split-fix-kernel-doc-warnings.patch added to mm-hotfixes-unstable branch
Message-Id: <20230912173728.20A03C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: argv_split: fix kernel-doc warnings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     argv_split-fix-kernel-doc-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/argv_split-fix-kernel-doc-warnings.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: argv_split: fix kernel-doc warnings
Date: Mon, 11 Sep 2023 23:08:38 -0700

Use proper kernel-doc notation to prevent build warnings:

lib/argv_split.c:36: warning: Function parameter or member 'argv' not described in 'argv_free'
lib/argv_split.c:61: warning: No description found for return value of 'argv_split'

Link: https://lkml.kernel.org/r/20230912060838.3794-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/argv_split.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/argv_split.c~argv_split-fix-kernel-doc-warnings
+++ a/lib/argv_split.c
@@ -28,7 +28,7 @@ static int count_argc(const char *str)
 
 /**
  * argv_free - free an argv
- * @argv - the argument vector to be freed
+ * @argv: the argument vector to be freed
  *
  * Frees an argv and the strings it points to.
  */
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(argv_free);
  * @str: the string to be split
  * @argcp: returned argument count
  *
- * Returns an array of pointers to strings which are split out from
+ * Returns: an array of pointers to strings which are split out from
  * @str.  This is performed by strictly splitting on white-space; no
  * quote processing is performed.  Multiple whitespace characters are
  * considered to be a single argument separator.  The returned array
_

Patches currently in -mm which might be from rdunlap@infradead.org are

scatterlist-add-missing-function-params-to-kernel-doc.patch
argv_split-fix-kernel-doc-warnings.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4F1C77B7C
	for <mm-commits@archiver.kernel.org>; Thu, 11 May 2023 04:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjEKEex (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 May 2023 00:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjEKEew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2023 00:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD964C30
        for <mm-commits@vger.kernel.org>; Wed, 10 May 2023 21:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42C2A60DEB
        for <mm-commits@vger.kernel.org>; Thu, 11 May 2023 04:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AE6C433EF;
        Thu, 11 May 2023 04:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683779689;
        bh=JmUkn0ZxUgn+WrnZBJGtDeDKdQp1ffKFW3Uiisv1GvM=;
        h=Date:To:From:Subject:From;
        b=hs/9boNDFWYZXt0NSSlxqZ9hDlUNYoQJp5zI3AdidrLk3fOOXwi+JraHW4fc6sg3p
         8tPL+qyjiAEkGK4SR4YSdRJMOzt8w+gAfQjzNS1mjuHdUmAe9qCby1DuaKeCVUstLs
         F6NQFn9wy1GcB2bXp3cw9kzfA8qD01faFniDmML0=
Date:   Wed, 10 May 2023 21:34:49 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        lstoakes@gmail.com, liushixin2@huawei.com, david@redhat.com,
        bhe@redhat.com, azeemshaikh38@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-replace-all-non-returning-strlcpy-with-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20230511043449.99AE6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: replace all non-returning strlcpy with strscpy
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     procfs-replace-all-non-returning-strlcpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-replace-all-non-returning-strlcpy-with-strscpy.patch

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
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Subject: procfs: replace all non-returning strlcpy with strscpy
Date: Wed, 10 May 2023 21:24:57 +0000

strlcpy() reads the entire source buffer first.  This read may exceed the
destination size limit.  This is both inefficient and can lead to linear
read overflows if a source string is not NUL-terminated [1].  In an effort
to remove strlcpy() completely [2], replace strlcpy() here with strscpy().
No return values were used, so direct replacement is safe.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Link: https://lkml.kernel.org/r/20230510212457.3491385-1-azeemshaikh38@gmail.com
Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/kcore.c~procfs-replace-all-non-returning-strlcpy-with-strscpy
+++ a/fs/proc/kcore.c
@@ -419,7 +419,7 @@ static ssize_t read_kcore_iter(struct ki
 		char *notes;
 		size_t i = 0;
 
-		strlcpy(prpsinfo.pr_psargs, saved_command_line,
+		strscpy(prpsinfo.pr_psargs, saved_command_line,
 			sizeof(prpsinfo.pr_psargs));
 
 		notes = kzalloc(notes_len, GFP_KERNEL);
_

Patches currently in -mm which might be from azeemshaikh38@gmail.com are

procfs-replace-all-non-returning-strlcpy-with-strscpy.patch


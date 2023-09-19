Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBE5CE79AD
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbjISUWm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjISUWQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:22:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44357BD
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 13:22:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CEFC433C9;
        Tue, 19 Sep 2023 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154930;
        bh=xB4Xpn8LzqG6aFzYgMTMpM+EpHJ464qaYY/CiCvppOA=;
        h=Date:To:From:Subject:From;
        b=rZjj3PVEpDfAmIMmY6AOmuIyvTRN+XBThoYHh+qJG5LWd7MrgXwzuFo3U0s0mlPIr
         LfKsnliJw5OLlAeeKyf4qarsdLkuxBDxJdJqutBXWAzVj5rkIjSPSMh8sOvmLrKN0Q
         f6S121SSsNoKFp/HVpMKwRzCNc9EFO55QGmgrZoE=
Date:   Tue, 19 Sep 2023 13:22:10 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] argv_split-fix-kernel-doc-warnings.patch removed from -mm tree
Message-Id: <20230919202210.D0CEFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: argv_split: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     argv_split-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



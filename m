Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819DBECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 21:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiISVUO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 17:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiISVUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 17:20:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A919EB7E1
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 14:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18D54CE1275
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 21:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72322C433D6;
        Mon, 19 Sep 2022 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663622408;
        bh=co/t1hPnUyls5hOP5q2bkV4229u9XkZZk2V+tEGnieY=;
        h=Date:To:From:Subject:From;
        b=1Z088D98bjRe2kTZmnFo3aMKow+MKE5djDbKFWJPdZIiRsjYVfxl6sdQFdNANzGiG
         HlX6aoaM6wzc3EoytMkHYOOVJE85YUNrgezTtSCLkcHdmxZW0nLNdtwzOxs9UDeLW1
         P5RTCFmubPats7ivxOgR/I87M4UDO/GJFEOdbo+g=
Date:   Mon, 19 Sep 2022 14:19:59 -0700
To:     mm-commits@vger.kernel.org, nicolas@fjasle.eu,
        masahiroy@kernel.org, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + usr-remove-unnecessary-1-values-from-int-file.patch added to mm-nonmm-unstable branch
Message-Id: <20220919212007.72322C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: usr/gen_init_cpio.c: remove unnecessary -1 values from int file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     usr-remove-unnecessary-1-values-from-int-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/usr-remove-unnecessary-1-values-from-int-file.patch

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
From: Li zeming <zeming@nfschina.com>
Subject: usr/gen_init_cpio.c: remove unnecessary -1 values from int file
Date: Mon, 19 Sep 2022 09:44:06 +0800

The file variable is assigned first, it does not need to be initialized.

Link: https://lkml.kernel.org/r/20220919014406.3242-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Li zeming <zeming@nfschina.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/usr/gen_init_cpio.c~usr-remove-unnecessary-1-values-from-int-file
+++ a/usr/gen_init_cpio.c
@@ -326,7 +326,7 @@ static int cpio_mkfile(const char *name,
 	char s[256];
 	struct stat buf;
 	unsigned long size;
-	int file = -1;
+	int file;
 	int retval;
 	int rc = -1;
 	int namesize;
_

Patches currently in -mm which might be from zeming@nfschina.com are

mm-remove-unnecessary-0-values-from-err.patch
usr-remove-unnecessary-1-values-from-int-file.patch


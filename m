Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18C8C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiJCVaZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiJCV3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732CA57BD5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1FE2CE0E82
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093B2C433D7;
        Mon,  3 Oct 2022 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832163;
        bh=RpJ778xpfrPYteBAum3G+nmTYYQhpGdoCv9yP8ME5yI=;
        h=Date:To:From:Subject:From;
        b=NDVYhrwWeQ4PKn5vJv0hS4mUBW1sOYIJ4JFnQvFGPV3yQkoDmwuefHtr3ZKBRS5Ae
         6fYsmaEjyJil3x5qi8AUrrI+3k2Mohn4bI5/FuUH+nBxCJfztR8JDVv98pz8p2rQsa
         vwwKBYKubRkuILxyjqTpKuHoO9yIYoYHGvZTuaEA=
Date:   Mon, 03 Oct 2022 14:22:42 -0700
To:     mm-commits@vger.kernel.org, nicolas@fjasle.eu,
        masahiroy@kernel.org, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] usr-remove-unnecessary-1-values-from-int-file.patch removed from -mm tree
Message-Id: <20221003212243.093B2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: usr/gen_init_cpio.c: remove unnecessary -1 values from int file
has been removed from the -mm tree.  Its filename was
     usr-remove-unnecessary-1-values-from-int-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 usr/gen_init_cpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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



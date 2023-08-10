Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F432C04E69
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbjHJQuc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbjHJQub (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ABA2683
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB0663184
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 16:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96170C433C7;
        Thu, 10 Aug 2023 16:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691686229;
        bh=0npDXGA6F3dGDh/GM9EpInGv7L3R917/N92ABiyQBvo=;
        h=Date:To:From:Subject:From;
        b=g7hQp9gQGlWWEab4tqOJGBMLkan8Rlsaz3lFwNk9Ce6yj+8Q25K6pMTbtWrhITVW2
         ruoZgCX0Wb2J4fpsq4/pMLZbXYovr2FdF2rw/ONajgFOSusZXo8cUn1NQn4nTX/9mV
         IYhd7fSzgma8TvfqxCAIypKSGfx67EQ7e5Il0MTs=
Date:   Thu, 10 Aug 2023 09:50:28 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + adfs-delete-unused-union-adfs_dirtail-definition.patch added to mm-nonmm-unstable branch
Message-Id: <20230810165029.96170C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: adfs: delete unused "union adfs_dirtail" definition
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     adfs-delete-unused-union-adfs_dirtail-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/adfs-delete-unused-union-adfs_dirtail-definition.patch

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
Subject: adfs: delete unused "union adfs_dirtail" definition
Date: Wed, 9 Aug 2023 19:35:49 +0300

union adfs_dirtail::new stands in the way if Linux++ project:
"new" can't be used as member's name because it is a keyword in C++.

Link: https://lkml.kernel.org/r/43b0a4c8-a7cf-4ab1-98f7-0f65c096f9e8@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_f.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/adfs/dir_f.h~adfs-delete-unused-union-adfs_dirtail-definition
+++ a/fs/adfs/dir_f.h
@@ -58,9 +58,4 @@ struct adfs_newdirtail {
 	__u8 dircheckbyte;
 } __attribute__((packed));
 
-union adfs_dirtail {
-	struct adfs_olddirtail old;
-	struct adfs_newdirtail new;
-};
-
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-support-proc-empty-vm-test-on-i386.patch
proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch
adfs-delete-unused-union-adfs_dirtail-definition.patch


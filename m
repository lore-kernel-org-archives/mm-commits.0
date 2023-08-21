Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEC0EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjHUUrQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjHUUrP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D29818F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B792B64AFC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181C4C433C7;
        Mon, 21 Aug 2023 20:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650827;
        bh=adGchP0GfzTtldEOLvY06CyktiAtKLpiIRHMzOziQow=;
        h=Date:To:From:Subject:From;
        b=kPBKU30Igwuc8/4JgLD4NOXC7iNWsZAa1Xn1TzwRSunNruczSmXHr0wriebxxSkcc
         iqx9Q58wrwf2zseniNWV6NLyE8Q+RXT8DBSWrvB7PwdZ/qE7wx55u5ga+jTG4OtDv/
         2L+JFaZZsIYPMgD8Tnsy63m0LMK/9vijSlcQ5pJA=
Date:   Mon, 21 Aug 2023 13:47:06 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] adfs-delete-unused-union-adfs_dirtail-definition.patch removed from -mm tree
Message-Id: <20230821204707.181C4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: adfs: delete unused "union adfs_dirtail" definition
has been removed from the -mm tree.  Its filename was
     adfs-delete-unused-union-adfs_dirtail-definition.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

char-shrink-character-devices-devlist-array.patch


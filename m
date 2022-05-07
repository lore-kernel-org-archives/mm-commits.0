Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6694EC433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 21:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348322AbiEGViC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 17:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbiEGViB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 17:38:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4591F639
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 14:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 820D660F2C
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 21:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B32C385A6;
        Sat,  7 May 2022 21:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651959252;
        bh=De8mBkXSUQ6oyYwYq83d+OiIy8mBXP2JcIfjYi2Q17c=;
        h=Date:To:From:Subject:From;
        b=gxEnYqAUFBh3/K6E+vDds/0SSbb/oBYtcqx9g3Ja+xbxDRxQnK5FWEbZZXvcvDzz/
         eUokVdLRb1Fev6cQevaLeWATQPaDSiWmxC9RhtcEqJaFr4QSyHBq8uTIgb9vLV7iD5
         F0E6jTTips60uDtTIQSM2AzVDLp20Elw//hrni+U=
Date:   Sat, 07 May 2022 14:34:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, linkinjeon@kernel.org,
        kari.argillander@stargateuniverse.net,
        almaz.alexandrovich@paragon-software.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ntfs3-validate-boot-sectors_per_clusters.patch added to mm-nonmm-unstable branch
Message-Id: <20220507213412.C6B32C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs3: validate BOOT sectors_per_clusters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ntfs3-validate-boot-sectors_per_clusters.patch

This patch should soon appear in the mm-nonmm-unstable branch at
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
Subject: fs/ntfs3: validate BOOT sectors_per_clusters

When the NTFS BOOT sectors_per_clusters field is > 0x80, it represents a
shift value.  Make sure that the shift value is not too large before using
it (NTFS max cluster size is 2MB).  Return -EVINVAL if it too large.

This prevents negative shift values and shift values that are larger than
the field size.

Prevents this UBSAN error:

 UBSAN: shift-out-of-bounds in ../fs/ntfs3/super.c:673:16
 shift exponent -192 is negative

Link: https://lkml.kernel.org/r/20220502175342.20296-1-rdunlap@infradead.org
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+1631f09646bc214d2e76@syzkaller.appspotmail.com
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kari Argillander <kari.argillander@stargateuniverse.net>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/super.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/super.c~fs-ntfs3-validate-boot-sectors_per_clusters
+++ a/fs/ntfs3/super.c
@@ -668,9 +668,11 @@ static u32 format_size_gb(const u64 byte
 
 static u32 true_sectors_per_clst(const struct NTFS_BOOT *boot)
 {
-	return boot->sectors_per_clusters <= 0x80
-		       ? boot->sectors_per_clusters
-		       : (1u << (0 - boot->sectors_per_clusters));
+	if (boot->sectors_per_clusters <= 0x80)
+		return boot->sectors_per_clusters;
+	if (boot->sectors_per_clusters >= 0xf4) /* limit shift to 2MB max */
+		return 1U << (0 - boot->sectors_per_clusters);
+	return -EINVAL;
 }
 
 /*
@@ -713,6 +715,8 @@ static int ntfs_init_from_boot(struct su
 
 	/* cluster size: 512, 1K, 2K, 4K, ... 2M */
 	sct_per_clst = true_sectors_per_clst(boot);
+	if ((int)sct_per_clst < 0)
+		goto out;
 	if (!is_power_of_2(sct_per_clst))
 		goto out;
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ntfs3-validate-boot-sectors_per_clusters.patch


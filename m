Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420D5C43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238167AbiKOWce (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbiKOWcJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C0BE9F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08CA0B81B88
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64C9C433C1;
        Tue, 15 Nov 2022 22:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551525;
        bh=/jAhW8IPZOhcHpRhIR+0/kyP3gbRhLEAcbSaFD/43R8=;
        h=Date:To:From:Subject:From;
        b=hRNZLVlOOMLmTF5gYmLbjqsAoMr4GiTdubRvgbrQYP/GOo3AF6z7h62BLEnRPs7P6
         RkpKxkz/jrlcGLF2HsPDW327t/LrtXfEFcc7ZxlSzpUFht3hLJmyGMR62U4M76Zd+s
         FHStPFk5SPSrgybWWYBX9ZX9zSJnlJZmYr9t811o=
Date:   Tue, 15 Nov 2022 14:32:05 -0800
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, pmladek@suse.com,
        paulus@samba.org, niejianglei2021@163.com, mpe@ellerman.id.au,
        linux@armlinux.org.uk, lchen@ambarella.com, ebiederm@xmission.com,
        chenlifu@huawei.com, bhe@redhat.com, benh@kernel.crashing.org,
        ye.xingchen@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-remove-the-unneeded-result-variable.patch removed from -mm tree
Message-Id: <20221115223205.A64C9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: remove the unneeded result variable
has been removed from the -mm tree.  Its filename was
     kexec-remove-the-unneeded-result-variable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ye xingchen <ye.xingchen@zte.com.cn>
Subject: kexec: remove the unneeded result variable
Date: Thu, 29 Sep 2022 12:29:34 +0800

Return the value kimage_add_entry() directly instead of storing it in
another redundant variable.

Link: https://lkml.kernel.org/r/20220929042936.22012-3-bhe@redhat.com
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Lifu <chenlifu@huawei.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jianglei Nie <niejianglei2021@163.com>
Cc: Li Chen <lchen@ambarella.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/kernel/kexec_core.c~kexec-remove-the-unneeded-result-variable
+++ a/kernel/kexec_core.c
@@ -561,23 +561,17 @@ static int kimage_add_entry(struct kimag
 static int kimage_set_destination(struct kimage *image,
 				   unsigned long destination)
 {
-	int result;
-
 	destination &= PAGE_MASK;
-	result = kimage_add_entry(image, destination | IND_DESTINATION);
 
-	return result;
+	return kimage_add_entry(image, destination | IND_DESTINATION);
 }
 
 
 static int kimage_add_page(struct kimage *image, unsigned long page)
 {
-	int result;
-
 	page &= PAGE_MASK;
-	result = kimage_add_entry(image, page | IND_SOURCE);
 
-	return result;
+	return kimage_add_entry(image, page | IND_SOURCE);
 }
 
 
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are



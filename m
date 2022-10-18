Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1841AC43217
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJRAwT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiJRAv6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:51:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3492782752
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51904B81BEB
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0578CC433D6;
        Tue, 18 Oct 2022 00:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666054314;
        bh=d5n7JVeBo/NP7SAlV8nG3a0uV1Jq+A0qxbdqzVjjZkU=;
        h=Date:To:From:Subject:From;
        b=uar0+PTb4FPNrzAoTzsYZ9eSSGELhIkIN2EdukxxJPJxuZa6sIH9n686HxRvR/r9+
         qICxXP0kjXRHtQTe0nsdoQcIgSp3F5jTT3E8yC/TiwUWL3lXeziNjqNXafuqq+hoHm
         wMswJTF5Z1/I6s3gHCdHv30e+6mBy+3mSKHmx4V4=
Date:   Mon, 17 Oct 2022 17:51:53 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, pmladek@suse.com,
        paulus@samba.org, niejianglei2021@163.com, mpe@ellerman.id.au,
        linux@armlinux.org.uk, lchen@ambarella.com, ebiederm@xmission.com,
        chenlifu@huawei.com, bhe@redhat.com, benh@kernel.crashing.org,
        ye.xingchen@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-remove-the-unneeded-result-variable.patch added to mm-nonmm-unstable branch
Message-Id: <20221018005154.0578CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove the unneeded result variable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-remove-the-unneeded-result-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-remove-the-unneeded-result-variable.patch

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

kexec-remove-the-unneeded-result-variable.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31C5C04FE0
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjG0UII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjG0UHy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701D930D4;
        Thu, 27 Jul 2023 13:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E6A061EF0;
        Thu, 27 Jul 2023 20:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A841BC433C8;
        Thu, 27 Jul 2023 20:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488469;
        bh=r2g+Zhpbm7baeSAIFrYwn3uee5TpfLItuw0hzWx1b/M=;
        h=Date:To:From:Subject:From;
        b=GSZZKbAc2vQVQ2+xHMqhZthwudn4MaS3bgZT9JLed9txJ1sAaRGyfAKs8pa9r32Vd
         i+RXPV7dGyd55GjANrP/2m3/16vIhUmkKP1WJ1buJzG+MkkH/wiV7LkW6NNBU/kiru
         /dTf/3Td88s03IvbHjxiz9t5eWPGIO1xk2W0K7UI=
Date:   Thu, 27 Jul 2023 13:07:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vgoyal@redhat.com,
        stable@vger.kernel.org, dyoung@redhat.com, bhe@redhat.com,
        adobriyan@gmail.com, dan.carpenter@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-vmcore-fix-signedness-bug-in-read_from_oldmem.patch removed from -mm tree
Message-Id: <20230727200749.A841BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/vmcore: fix signedness bug in read_from_oldmem()
has been removed from the -mm tree.  Its filename was
     proc-vmcore-fix-signedness-bug-in-read_from_oldmem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: proc/vmcore: fix signedness bug in read_from_oldmem()
Date: Tue, 25 Jul 2023 20:03:16 +0300

The bug is the error handling:

	if (tmp < nr_bytes) {

"tmp" can hold negative error codes but because "nr_bytes" is type size_t
the negative error codes are treated as very high positive values
(success).  Fix this by changing "nr_bytes" to type ssize_t.  The
"nr_bytes" variable is used to store values between 1 and PAGE_SIZE and
they can fit in ssize_t without any issue.

Link: https://lkml.kernel.org/r/b55f7eed-1c65-4adc-95d1-6c7c65a54a6e@moroto.mountain
Fixes: 5d8de293c224 ("vmcore: convert copy_oldmem_page() to take an iov_iter")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/vmcore.c~proc-vmcore-fix-signedness-bug-in-read_from_oldmem
+++ a/fs/proc/vmcore.c
@@ -132,7 +132,7 @@ ssize_t read_from_oldmem(struct iov_iter
 			 u64 *ppos, bool encrypted)
 {
 	unsigned long pfn, offset;
-	size_t nr_bytes;
+	ssize_t nr_bytes;
 	ssize_t read = 0, tmp;
 	int idx;
 
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are



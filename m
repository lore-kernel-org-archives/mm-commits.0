Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B33C001DC
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jul 2023 19:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjGZTAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jul 2023 15:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjGZTAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2023 15:00:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8031E7;
        Wed, 26 Jul 2023 12:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4654261C77;
        Wed, 26 Jul 2023 19:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9222AC433C8;
        Wed, 26 Jul 2023 19:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690398038;
        bh=YHR/M/KvFbPNyaO+qOZVSHuewaYjTebzhe0YHQAn5LE=;
        h=Date:To:From:Subject:From;
        b=fau+zAihLffO7GMl7KSZFdXx1ZX8abC54aHO/II47fR8TIfvnCkAHkHBcut0NMwfp
         5cp+KZpcD+8OBj6vQe61pUUPkNkCPjgkRurMDycfm83ZR/eudLxoHRaBsSzoZzD7HA
         S1ZI4IUvGeZtZccEG26JEKx5gNaMbZFWBeddT0Qk=
Date:   Wed, 26 Jul 2023 12:00:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vgoyal@redhat.com,
        stable@vger.kernel.org, dyoung@redhat.com, bhe@redhat.com,
        adobriyan@gmail.com, dan.carpenter@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-vmcore-fix-signedness-bug-in-read_from_oldmem.patch added to mm-hotfixes-unstable branch
Message-Id: <20230726190038.9222AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/vmcore: fix signedness bug in read_from_oldmem()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-vmcore-fix-signedness-bug-in-read_from_oldmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-vmcore-fix-signedness-bug-in-read_from_oldmem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

proc-vmcore-fix-signedness-bug-in-read_from_oldmem.patch


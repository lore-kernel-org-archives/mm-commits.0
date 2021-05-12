Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7765BC433B4
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4944D61288
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhELWjv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 18:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244494AbhELVjt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 17:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F31C7613BD;
        Wed, 12 May 2021 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620855515;
        bh=xUS0aizBteCAqR6YW5eauSOgr09CuVGIz+i5ft+xQcQ=;
        h=Date:From:To:Subject:From;
        b=kIjxs9bUOYOWXnnhGd2HmuJdszaKGWafDrJMOLLTNU+sDSNF92TEXW437Wh5hfKuM
         U+p4yaLoaA8gATJ6NaM1UzeJs5PIq4cA5NvniKQzZKhf7iq1I82xdt5CyhPSTVHFzz
         mnYGEubODMca2o6q0G6Q0CXrF8Le1X81xuPGaVL8=
Date:   Wed, 12 May 2021 14:38:34 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, cascardo@canonical.com,
        christian.brauner@ubuntu.com, ddiss@suse.de, deller@gmx.de,
        lstoakes@gmail.com, marcelo.cerri@canonical.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, walken@google.com
Subject:  + proc-avoid-mixing-integer-types-in-mem_rw.patch added
 to -mm tree
Message-ID: <20210512213834.wb0N76pyo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: Avoid mixing integer types in mem_rw()
has been added to the -mm tree.  Its filename is
     proc-avoid-mixing-integer-types-in-mem_rw.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-avoid-mixing-integer-types-in-mem_rw.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-avoid-mixing-integer-types-in-mem_rw.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: proc: Avoid mixing integer types in mem_rw()

Use size_t when capping the count argument received by mem_rw(). Since
count is size_t, using min_t(int, ...) can lead to a negative value
that will later be passed to access_remote_vm(), which can cause
unexpected behavior.

Since we are capping the value to at maximum PAGE_SIZE, the conversion
from size_t to int when passing it to access_remote_vm() as "len"
shouldn't be a problem.

Link: https://lkml.kernel.org/r/20210512125215.3348316-1-marcelo.cerri@canonical.com
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Souza Cascardo <cascardo@canonical.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~proc-avoid-mixing-integer-types-in-mem_rw
+++ a/fs/proc/base.c
@@ -854,7 +854,7 @@ static ssize_t mem_rw(struct file *file,
 	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
 
 	while (count > 0) {
-		int this_len = min_t(int, count, PAGE_SIZE);
+		size_t this_len = min_t(size_t, count, PAGE_SIZE);
 
 		if (write && copy_from_user(page, buf, this_len)) {
 			copied = -EFAULT;
_

Patches currently in -mm which might be from marcelo.cerri@canonical.com are

proc-avoid-mixing-integer-types-in-mem_rw.patch


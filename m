Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB2BC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 844E061C9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhGFTYX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhGFTYX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A580561C9A;
        Tue,  6 Jul 2021 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599304;
        bh=mU4T1TSPYfuou2Z4i/VXv+i9hHvelsbOVvrZJ32s4O0=;
        h=Date:From:To:Subject:From;
        b=UHl5xK/o7hYp2CmtNUgRu2duKdpLUy6QpvghCyXzddcB9RR6gJSnL+wkKdwE4u1X9
         j38lrpxajWOTCNMKnRy/pbyQNBNYiNIllsc5qhz8xzOEzNebhPG2Mj0pspAUAAC5tQ
         6vfHGYWW+pZKEcTyocdCWr6X8rHUJ7phJddlHK0s=
Date:   Tue, 06 Jul 2021 12:21:43 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, cascardo@canonical.com,
        christian.brauner@ubuntu.com, ddiss@suse.de, deller@gmx.de,
        lstoakes@gmail.com, marcelo.cerri@canonical.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, walken@google.com
Subject:  [merged] proc-avoid-mixing-integer-types-in-mem_rw.patch
 removed from -mm tree
Message-ID: <20210706192143.4Dc95YUCp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: Avoid mixing integer types in mem_rw()
has been removed from the -mm tree.  Its filename was
     proc-avoid-mixing-integer-types-in-mem_rw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



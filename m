Return-Path: <SRS0=nxWc=B6=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C76AC433DF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 21:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D304D2078D
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 21:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597957891;
	bh=o7vpdCJCnazJNH91ipcJd3ZAxGgZFEsXF3igb+Fnx8E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QwODcYq2l5j/wLT9iVvjNepiBtXY3Hiw0qOyXMIqigmMxoSttIe0pa6t+Ct5ZGOpM
	 HPv0pEOZAt4/oAW3O2Rd7v29LjD5XC+evebapwp4aZysKJRiKmkoWXHoFQcCvRnB/Z
	 3/IlS7mw3g91lf9Sz2IpC3r5abI5YwBHLfpxegO0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgHTVLb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 17:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgHTVLa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 17:11:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D012075E;
        Thu, 20 Aug 2020 21:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597957890;
        bh=o7vpdCJCnazJNH91ipcJd3ZAxGgZFEsXF3igb+Fnx8E=;
        h=Date:From:To:Subject:From;
        b=iNCHxJWlzxNgeExIor9dbVb5NPPnYokEnwWrBAjYBU7l5uJQOK9yxgWimGc7GtD0g
         SgVJ8eA+SsAfl/cZpxybBXQIfdYuSYc5x1iiHsP/R1nbmtH3v+vcGiw69yLjBdD33s
         GJanhCstrHGnM4y6u5hVnlKw/36Q8nSjIuooC5qE=
Date:   Thu, 20 Aug 2020 14:11:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, raven@themaw.net, willy@infradead.org
Subject:  + harden-autofs-ioctl-table.patch added to -mm tree
Message-ID: <20200820211129.RA9T3OzC6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: harden ioctl table
has been added to the -mm tree.  Its filename is
     harden-autofs-ioctl-table.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/harden-autofs-ioctl-table.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/harden-autofs-ioctl-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: autofs: harden ioctl table

The table of ioctl functions should be marked const in order to put them
in read-only memory, and we should use array_index_nospec() to avoid
speculation disclosing the contents of kernel memory to userspace.

Link: https://lkml.kernel.org/r/20200818122203.GO17456@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/dev-ioctl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/autofs/dev-ioctl.c~harden-autofs-ioctl-table
+++ a/fs/autofs/dev-ioctl.c
@@ -8,6 +8,7 @@
 #include <linux/compat.h>
 #include <linux/syscalls.h>
 #include <linux/magic.h>
+#include <linux/nospec.h>
 
 #include "autofs_i.h"
 
@@ -563,7 +564,7 @@ out:
 
 static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
 {
-	static ioctl_fn _ioctls[] = {
+	static const ioctl_fn _ioctls[] = {
 		autofs_dev_ioctl_version,
 		autofs_dev_ioctl_protover,
 		autofs_dev_ioctl_protosubver,
@@ -581,7 +582,10 @@ static ioctl_fn lookup_dev_ioctl(unsigne
 	};
 	unsigned int idx = cmd_idx(cmd);
 
-	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx];
+	if (idx >= ARRAY_SIZE(_ioctls))
+		return NULL;
+	idx = array_index_nospec(idx, ARRAY_SIZE(_ioctls));
+	return _ioctls[idx];
 }
 
 /* ioctl dispatcher */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
harden-autofs-ioctl-table.patch


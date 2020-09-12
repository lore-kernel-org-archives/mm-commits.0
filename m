Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B22C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 421E821655
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927847;
	bh=n+LGTKqz8CyWkQpUY9B5wNT9T8lKEh0BF9qAYRu9YJ4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ahyp1kwd9y/Fu2oQTzOdZUINsUPKbSb5SWVqPKv9v0Xethm/Natzx3q9z7Ftn5JCm
	 DwIypCS9uSDOswKlpJgpxWdpLxlsbMyFubCYXf71GyT2Ws35EKNo8WeRlBCM4wXJVb
	 P9QvKeLqX9a0qf66V8Nb3HguHfnr6BFpbJZ9BALs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgILQYE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgILQXu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:23:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8891721D6C;
        Sat, 12 Sep 2020 16:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927829;
        bh=n+LGTKqz8CyWkQpUY9B5wNT9T8lKEh0BF9qAYRu9YJ4=;
        h=Date:From:To:Subject:From;
        b=RQAyfUQOtDZlXnQZF0z+LfI/zV0uK7eBPJjZn+y4XWz5Y42/NIcain58LwUWkPZDA
         PVxgMbUUuhGEW+RzuJ2njN7ygiC5pwqBke1Yaz+bgspT3yXB1oAPd9o4FHQQMnYzNy
         QC1R0tmOWz4XdZQFksNooKfWw+AF94rVbbP/4nw4=
Date:   Sat, 12 Sep 2020 09:23:49 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, tklauser@distanz.ch,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch
 removed from -mm tree
Message-ID: <20200912162349.mr_UYJcu-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: adjust proc_ipc_sem_dointvec definition to match prototype
has been removed from the -mm tree.  Its filename was
     ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: ipc: adjust proc_ipc_sem_dointvec definition to match prototype

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer.  Adjust the
signature of proc_ipc_sem_dointvec to match ctl_table.proc_handler which
fixes the following sparse error/warning:

ipc/ipc_sysctl.c:94:47: warning: incorrect type in argument 3 (different address spaces)
ipc/ipc_sysctl.c:94:47:    expected void *buffer
ipc/ipc_sysctl.c:94:47:    got void [noderef] __user *buffer
ipc/ipc_sysctl.c:194:35: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
ipc/ipc_sysctl.c:194:35:    expected int ( [usertype] *proc_handler )( ... )
ipc/ipc_sysctl.c:194:35:    got int ( * )( ... )

Link: https://lkml.kernel.org/r/20200825105846.5193-1-tklauser@distanz.ch
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/ipc_sysctl.c~ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype
+++ a/ipc/ipc_sysctl.c
@@ -85,7 +85,7 @@ static int proc_ipc_auto_msgmni(struct c
 }
 
 static int proc_ipc_sem_dointvec(struct ctl_table *table, int write,
-	void __user *buffer, size_t *lenp, loff_t *ppos)
+	void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret, semmni;
 	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
_

Patches currently in -mm which might be from tklauser@distanz.ch are



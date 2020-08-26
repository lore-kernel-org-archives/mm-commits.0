Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31558C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4282075E
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598401313;
	bh=ijea7F6YeRft+xNmgJTZ81kknhje228Ouq4h4gK14fY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rTS5tmcpNmeXSfw5jqOGkesb0xf6/DoRT9RkewJZs6qWqYegES/nbHmxSp1ioAxRK
	 Eu2xEevVG5EVXzdlUTfGb0gJh49NL3gIl38tsSGIUbaXBJimm8vx7lQDdpJ+/vRJ9v
	 3oWE1mCf9Kf8NQWECDwYwcMgL/E18g6uWnVU3Oxs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHZAVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgHZAVw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:21:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9866720738;
        Wed, 26 Aug 2020 00:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598401311;
        bh=ijea7F6YeRft+xNmgJTZ81kknhje228Ouq4h4gK14fY=;
        h=Date:From:To:Subject:From;
        b=Niei5NObdTl9l5JXa+cqHTTsJnOp1+B+jnyovQkpcjK0MTnZjUw6fm0JfTeTdRn7z
         vO1lIs2sUXFtjQojSvd6W93m7RigHuDJH2afH6Vbz4oUy/5fJamHL0VuwcLK6RLcAg
         yodAl81oIvefGDbo55U/wfIoc+5woHaY4M9/Ymm8=
Date:   Tue, 25 Aug 2020 17:21:51 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, tklauser@distanz.ch,
        viro@zeniv.linux.org.uk
Subject:  +
 ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch added
 to -mm tree
Message-ID: <20200826002151.0ZAjEpBHK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: adjust proc_ipc_sem_dointvec definition to match prototype
has been added to the -mm tree.  Its filename is
     ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-adjust-proc_ipc_sem_dointvec-definition-to-match-prototype.patch


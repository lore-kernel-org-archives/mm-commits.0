Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FA3C2D0A8
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA89C208FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262547;
	bh=f4EWx0Zx5oQOoDoii54mhkMDCz4hMvSrWBjD7+aGxSc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xj5ZG+B6/oPwSxfZB4qZ9T71itK7ZHUZeohJMEC4TKPvs02zwKAXcmLVcfMaIjAmR
	 1Py0tiJEsRG8TMnnspcmqqKpl6RGHHjh1c7OugpKHRGpcloIdFHfi4137WtENGoyuc
	 7Eta8PGh85jFFyD/UaKTQHOfYJcNPZMUh6jMBgNE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgIDXfr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXfr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8406E2084D;
        Fri,  4 Sep 2020 23:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262546;
        bh=f4EWx0Zx5oQOoDoii54mhkMDCz4hMvSrWBjD7+aGxSc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s5mrOifqZb3W4r26SaEUaPIRy1zsWVi7gH9latbMHE+BPGKKf7G7T9Gdi0m4woAtm
         ollZC4yXUfRl32rOXPs7vTOtotWjMnTjbO6IcOfkgWU7iNONN3c53s1cOgny1mjpwh
         v4cDC7AD40YB/YYMI7y/7vq2mjIwzSYwRQ5H5eDw=
Date:   Fri, 04 Sep 2020 16:35:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tklauser@distanz.ch,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 08/19] ipc: adjust proc_ipc_sem_dointvec
 definition to match prototype
Message-ID: <20200904233546._jA3OBwc_%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0C8C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E7B6023F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhGFTPX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231808AbhGFTPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B28460C3D;
        Tue,  6 Jul 2021 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598764;
        bh=mlqPJmwmddvVhu5TEOgwbq3/Mbv3wpX0whlymWI5hvM=;
        h=Date:From:To:Subject:From;
        b=wNoC7Qei+CB0xNFcDRljYyzq7uW3DqQYhnNsJBKx37fPpvnnwxo/HqeIjhpK9p18y
         UPkNbfYTs+84Wh3q+1U2kDS+Vo1vOpGrIr9xkXivuFptJ2Y/1rV4MuPDEpT5QaEyFS
         kFD112kfB+pLAz5zpB9hHCstI4CL4TBm7zTcAEYE=
Date:   Tue, 06 Jul 2021 12:12:44 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 net-ipv5-tcp-use-vma_lookup-in-tcp_zerocopy_receive.patch removed from -mm
 tree
Message-ID: <20210706191244.V9azl24vI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net/ipv5/tcp: use vma_lookup() in tcp_zerocopy_receive()
has been removed from the -mm tree.  Its filename was
     net-ipv5-tcp-use-vma_lookup-in-tcp_zerocopy_receive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: net/ipv5/tcp: use vma_lookup() in tcp_zerocopy_receive()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-13-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c~net-ipv5-tcp-use-vma_lookup-in-tcp_zerocopy_receive
+++ a/net/ipv4/tcp.c
@@ -2095,8 +2095,8 @@ static int tcp_zerocopy_receive(struct s
 
 	mmap_read_lock(current->mm);
 
-	vma = find_vma(current->mm, address);
-	if (!vma || vma->vm_start > address || vma->vm_ops != &tcp_vm_ops) {
+	vma = vma_lookup(current->mm, address);
+	if (!vma || vma->vm_ops != &tcp_vm_ops) {
 		mmap_read_unlock(current->mm);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are



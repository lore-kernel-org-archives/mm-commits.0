Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA5AC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46B2E61D08
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2Clw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231753AbhF2Clv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A780D619AB;
        Tue, 29 Jun 2021 02:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934364;
        bh=taf3Ryxes2Ab2FPkEgzZ8fvSN19xp/HTgTOV97ALI4E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J7N1XHsiJtTOSNhMl/9amf6WvopC8qgPjeL3KPDSL7KNZ7JMdIJMMgOadxBQyyXHf
         10gg//96sAPKmli8AQlvfoCEaU5oh/w3x1pc3/tXrEf4iflhfWn21QIpQ8baPbsQ2n
         hRarluNJgZRoVcug6xxI2bljDrZvLCTxGJYiL9m4=
Date:   Mon, 28 Jun 2021 19:39:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davem@davemloft.net, david@redhat.com,
        dbueso@suse.de, geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 116/192] net/ipv5/tcp: use vma_lookup() in
 tcp_zerocopy_receive()
Message-ID: <20210629023923.Pi_mCDAdS%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

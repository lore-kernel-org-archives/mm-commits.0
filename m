Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1223C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C80BB6115A
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhJRWR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWR6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:17:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FACE6113D;
        Mon, 18 Oct 2021 22:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595346;
        bh=l3XYSctveQCuBNkQuKRXWwx2EV1pKzu5RQE/jIJqSrQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XdBVC3eUF8KVhBqyH5pjVYdtjZ++h4a+nSzEUy5QTFmVxWYVgEsqJ2NNnLk502pLf
         Vf+e/afEKfgLpsCggYzWsx+OpabSJW0jglEmTJO24H+Y0qmMnTGuDKet6DQexjHmE0
         KZaZMX5jShBzKNk48CUEathixz+7l0/E445hIw5c=
Date:   Mon, 18 Oct 2021 15:15:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        geert+renesas@glider.be, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peng.fan@nxp.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 08/19] memblock: check memory total_size
Message-ID: <20211018221545.8GMak4XZn%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>
Subject: memblock: check memory total_size

mem=[X][G|M] is broken on ARM64 platform, there are cases that even
type.cnt is 1, but total_size is not 0 because regions are merged into 1. 
So only check 'cnt' is not enough, total_size should be used, othersize
bootargs 'mem=[X][G|B]' not work anymore.

Link: https://lkml.kernel.org/r/20210930024437.32598-1-peng.fan@oss.nxp.com
Fixes: e888fa7bb882 ("memblock: Check memory add/cap ordering")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~memblock-check-memory-total_size
+++ a/mm/memblock.c
@@ -1692,7 +1692,7 @@ void __init memblock_cap_memory_range(ph
 	if (!size)
 		return;
 
-	if (memblock.memory.cnt <= 1) {
+	if (!memblock_memory->total_size) {
 		pr_warn("%s: No memory registered yet\n", __func__);
 		return;
 	}
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BA2C4320A
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FA2660F42
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhGWWKE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 18:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhGWWKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 18:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5431F60F36;
        Fri, 23 Jul 2021 22:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080636;
        bh=/idCux6VI78ahDoXdpY+rIR9aMJz9Fhuw6pl2eaC+L8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uJNxTbRkj323LELxcYzloqNHbYt5Hy8ec1qSls+3kzfpm/equfEFjIUVhws/NzVOC
         QENHzmG9SGUGIqHtqDXfiWcCfDz388JvhDcapmFLkk+k1o4vuGK7z8ZV6Gi+O5S9Ot
         yPOFvPRdAphyxg44NgIHFr5Ry+56KxS0xCqx21cA=
Date:   Fri, 23 Jul 2021 15:50:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 12/15] mm/secretmem: wire up ->set_page_dirty
Message-ID: <20210723225035.OchgDJMop%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/secretmem: wire up ->set_page_dirty

Make secretmem up to date with the changes done in commit 0af573780b0b
("mm: require ->set_page_dirty to be explicitly wired up") so that
unconditional call to this method won't cause crashes.

Link: https://lkml.kernel.org/r/20210716063933.31633-1-rppt@kernel.org
Fixes: 0af573780b0b ("mm: require ->set_page_dirty to be explicitly wired up")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/secretmem.c~mm-secretmem-wire-up-set_page_dirty
+++ a/mm/secretmem.c
@@ -152,6 +152,7 @@ static void secretmem_freepage(struct pa
 }
 
 const struct address_space_operations secretmem_aops = {
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 	.freepage	= secretmem_freepage,
 	.migratepage	= secretmem_migratepage,
 	.isolate_page	= secretmem_isolate_page,
_

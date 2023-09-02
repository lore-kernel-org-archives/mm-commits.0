Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A423C83F33
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjIBWR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjIBWR6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:17:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529BDCE0
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBBD861030
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38303C433C7;
        Sat,  2 Sep 2023 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693693074;
        bh=fzE+Jvgyo3YkSwouV+nIrfL3s7s7LKPgy9a4zgjQfAM=;
        h=Date:To:From:Subject:From;
        b=0Qd/LKNx3FcLvtAJMnV3u01C0QRRrAM6/OnxFjfwqTMBK6zqNPS4zW1ZdJz9dCyBs
         huJVsk8mVFQzp/OQNzgh1aSt85uOqDWhVP4OdAiEc1INNRG8VzCftK9LK7vyJKrEvj
         ZoGzauyZzHBSZyd1sRp1cpBHxdr0VkbV3hlG4Nz4=
Date:   Sat, 02 Sep 2023 15:17:53 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, baruch@tkos.co.il,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rmap-remove-anon_vma_link-nommu-stub.patch removed from -mm tree
Message-Id: <20230902221754.38303C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rmap: remove anon_vma_link() nommu stub
has been removed from the -mm tree.  Its filename was
     rmap-remove-anon_vma_link-nommu-stub.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baruch Siach <baruch@tkos.co.il>
Subject: rmap: remove anon_vma_link() nommu stub
Date: Thu, 24 Aug 2023 14:38:08 +0300

anon_vma_link() is unused since commit 5beb49305251 ("mm: change anon_vma
linking to fix multi-process server scalability issue").

Link: https://lkml.kernel.org/r/cdce9b00c9ab15f6d02eddf40dcad537d3e9676f.1692877089.git.baruch@tkos.co.il
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/rmap.h~rmap-remove-anon_vma_link-nommu-stub
+++ a/include/linux/rmap.h
@@ -479,7 +479,6 @@ struct anon_vma *folio_lock_anon_vma_rea
 
 #define anon_vma_init()		do {} while (0)
 #define anon_vma_prepare(vma)	(0)
-#define anon_vma_link(vma)	do {} while (0)
 
 static inline int folio_referenced(struct folio *folio, int is_locked,
 				  struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from baruch@tkos.co.il are

maintainers-add-rmaph-to-mm-entry.patch


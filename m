Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA829C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236961AbjHKXDI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbjHKXB2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039DB3C28
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E24D6492A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E540DC433C8;
        Fri, 11 Aug 2023 23:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794846;
        bh=geQJcTGcDDjr3S1KtyXA7F8yczc+zqmQ1VNz/5M2rI0=;
        h=Date:To:From:Subject:From;
        b=xeooXlx4MQ5fh/PUBNNBlNnf8mBwaLny9G8Iyd6Sc09ucNV/JAgPYo6N78kq+Kvnk
         Ywm8ujp4ReH3DBot4hdJJxx7yQ7n3szTgOnJQb1qjPBLVF0V3NhfSGxXUt4g1F6QJi
         pZAxatfx9fCKJbeCXFRskIjvGuRdS/5htzBiadF0=
Date:   Fri, 11 Aug 2023 16:00:45 -0700
To:     mm-commits@vger.kernel.org, quic_charante@quicinc.com,
        mhocko@suse.com, david@redhat.com, xueshi.hu@smartx.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-clear_page_idle.patch removed from -mm tree
Message-Id: <20230811230045.E540DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove clear_page_idle()
has been removed from the -mm tree.  Its filename was
     mm-remove-clear_page_idle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xueshi Hu <xueshi.hu@smartx.com>
Subject: mm: remove clear_page_idle()
Date: Wed, 12 Jul 2023 21:49:59 +0800

All callers have now been converted to call folio_clear_idle().

Link: https://lkml.kernel.org/r/20230712134959.145373-1-xueshi.hu@smartx.com
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/page_idle.h~mm-remove-clear_page_idle
+++ a/include/linux/page_idle.h
@@ -144,9 +144,4 @@ static inline void set_page_idle(struct
 {
 	folio_set_idle(page_folio(page));
 }
-
-static inline void clear_page_idle(struct page *page)
-{
-	folio_clear_idle(page_folio(page));
-}
 #endif /* _LINUX_MM_PAGE_IDLE_H */
_

Patches currently in -mm which might be from xueshi.hu@smartx.com are



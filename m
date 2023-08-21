Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0D3EE49B0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjHUUj0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjHUUjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79BB132
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C804764A1B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234A3C433C8;
        Mon, 21 Aug 2023 20:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650340;
        bh=1OvVcoVEg3UUNC/aarbWuDANMWI4wBayK2VnJLeVeG8=;
        h=Date:To:From:Subject:From;
        b=aZmE5PqIKgDDc5E0B08yISrdNtuZtjzxfianlhheMN8oWnYjepwFr9R5nqTXTMqrU
         gNg5EED/DkooswtkwpBYuMyvc6FexKJgWJPfP0N/+LLHA+AgnKMIAFCGwbQ3aJg/Q5
         mdTXrOJXax6vb0IQ5Qv9rgg2jaZFJv6g0tQVRD9M=
Date:   Mon, 21 Aug 2023 13:38:59 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        akpm@linux-foudation.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch removed from -mm tree
Message-Id: <20230821203900.234A3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: add common function to get client data from page_ext
has been removed from the -mm tree.  Its filename was
     mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: add common function to get client data from page_ext
Date: Tue, 18 Jul 2023 22:58:10 +0800

Patch series "add page_ext_data to get client data in page_ext".

Current clients get data from page_ext by adding offset which is auto
generated in page_ext core and exposes the data layout design inside
page_ext core.  This series adds a page_ext_data() to hide this from
clients.  

Benefits include:

1. Future clients can call page_ext_data directly instead of defining
   a new function like get_page_owner to get the data.

2. There is no change to clients if the layout of page_ext data changes.


This patch (of 3):

Add common page_ext_data function to get client data.  This could hide
offset which is auto generated in page_ext core and expose the desgin of
page_ext data layout.

Link: https://lkml.kernel.org/r/20230718145812.1991717-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230718145812.1991717-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/page_ext.h~mm-page_ext-add-common-function-to-get-client-data-from-page_ext
+++ a/include/linux/page_ext.h
@@ -82,6 +82,12 @@ static inline void page_ext_init(void)
 extern struct page_ext *page_ext_get(struct page *page);
 extern void page_ext_put(struct page_ext *page_ext);
 
+static inline void *page_ext_data(struct page_ext *page_ext,
+				  struct page_ext_operations *ops)
+{
+	return (void *)(page_ext) + ops->offset;
+}
+
 static inline struct page_ext *page_ext_next(struct page_ext *curr)
 {
 	void *next = curr;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are



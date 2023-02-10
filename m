Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2628FC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjBJAwo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjBJAwb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43E76E887
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E33061C11
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEDBC4339B;
        Fri, 10 Feb 2023 00:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990347;
        bh=QL9h9KznrlnUahfRyzJOOY8+gpqLEGRtHlskyPHxwLc=;
        h=Date:To:From:Subject:From;
        b=YJG8z/Gk5U7P6BmGZHUY4UURO0SwtXDmQzDxlMTRVbPvrOtNL16Eh10mX5rwN2+uR
         LEccQrCMohvYcR4jj+CR5VA+NX333LMS1fcbzCElGBjeDNDyTFXSFhkUxSDuKScxiI
         KxJ0dtqhPAinc4wu4LOiTLBjT/os7oWmdCyXOxuQ=
Date:   Thu, 09 Feb 2023 16:52:27 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch removed from -mm tree
Message-Id: <20230210005227.9EEDBC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix handle of invalidated state in mas_wr_store_setup()
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix handle of invalidated state in mas_wr_store_setup()
Date: Fri, 20 Jan 2023 11:26:06 -0500

If an invalidated maple state is encountered during write, reset the maple
state to MAS_START.  This will result in a re-walk of the tree to the
correct location for the write.

Link: https://lore.kernel.org/all/20230107020126.1627-1-sj@kernel.org/
Link: https://lkml.kernel.org/r/20230120162650.984577-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/maple_tree.c~maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup
+++ a/lib/maple_tree.c
@@ -5609,6 +5609,9 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (unlikely(mas_is_paused(wr_mas->mas)))
+		mas_reset(wr_mas->mas);
+
 	if (!mas_is_start(wr_mas->mas)) {
 		if (mas_is_none(wr_mas->mas)) {
 			mas_reset(wr_mas->mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are



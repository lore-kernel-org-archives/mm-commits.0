Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDD6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383754AbiEMTZi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383891AbiEMTY2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:24:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97C330554
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F8E9B8310B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19189C34113;
        Fri, 13 May 2022 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469752;
        bh=AZ+QYp2Y13e4q3kyXpLjVDQ+G0JijSEUr6o830cuepk=;
        h=Date:To:From:Subject:From;
        b=CDmHZOSFU3NuaKtMf9tmNqY/jCxMsFbIbqHy716JISf9GIo+rC7SDdWeB5/MyG1N/
         TtoFJOag+hooBHLk8HPrNKVRAS5bwxLgbSzo9NBGPYESyG4nuyAX9IMT1tVBrH51Pc
         SaEtNd8lskDLnqkkhz4MprYGb7vKI8z5tTosmjxE=
Date:   Fri, 13 May 2022 12:22:31 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-disable-hwpoison-filter-during-removing.patch removed from -mm tree
Message-Id: <20220513192232.19189C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: disable hwpoison filter during removing
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-disable-hwpoison-filter-during-removing.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/hwpoison: disable hwpoison filter during removing

hwpoison filter is enabled by hwpoison-inject module, after removing this
module, hwpoison filter still works.  What is worse, user can not find the
debugfs entries to know this.

Disable the hwpoison filter during removing hwpoison-inject module.

Link: https://lkml.kernel.org/r/20220509105641.491313-5-pizhenwei@bytedance.com
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hwpoison-inject.c~mm-hwpoison-disable-hwpoison-filter-during-removing
+++ a/mm/hwpoison-inject.c
@@ -65,6 +65,7 @@ DEFINE_DEBUGFS_ATTRIBUTE(unpoison_fops,
 
 static void pfn_inject_exit(void)
 {
+	hwpoison_filter_enable = 0;
 	debugfs_remove_recursive(hwpoison_dir);
 }
 
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are



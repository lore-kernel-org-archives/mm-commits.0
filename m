Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FECC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 21:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKHVX6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 16:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiKHVXx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 16:23:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320546458
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9934B81AFD
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBAFC433C1;
        Tue,  8 Nov 2022 21:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667942630;
        bh=TIGUEAbG+sQLqRhl2DWuakS5fnytIIvz7mvXKDnJC1M=;
        h=Date:To:From:Subject:From;
        b=rhDDTyD+mV7o10qH5my7sztlPl5U6cPo/pV7r+lcZ9U5UfMjWkBgXThrdtKVYy8kM
         z/tdoqDViePndDiAkJ6hkXiPYlqmA9WekjBWNHZ9s3qPSn/JBAYn3s9KNrlwR+ysly
         EPDNlQedFlnxnNy9kDTyogGPeQgkeX83C74RplZI=
Date:   Tue, 08 Nov 2022 13:23:49 -0800
To:     mm-commits@vger.kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner-ignore-page_owner_sort-binary.patch added to mm-unstable branch
Message-Id: <20221108212350.8DBAFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner: ignore page_owner_sort binary
has been added to the -mm mm-unstable branch.  Its filename is
     tools-vm-page_owner-ignore-page_owner_sort-binary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-vm-page_owner-ignore-page_owner_sort-binary.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Rong Tao <rongtao@cestc.cn>
Subject: tools/vm/page_owner: ignore page_owner_sort binary
Date: Tue, 8 Nov 2022 19:53:48 +0800

page_owner_sort was introduced since commit 48c96a368579 ("mm/page_owner:
keep track of page owners"), and we should ignore it.

Link: https://lkml.kernel.org/r/tencent_F6CAC0ABE16839E2B2419BD07316DA65BB06@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/vm/.gitignore~tools-vm-page_owner-ignore-page_owner_sort-binary
+++ a/tools/vm/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 slabinfo
 page-types
+page_owner_sort
_

Patches currently in -mm which might be from rongtao@cestc.cn are

tools-vm-page_owner-ignore-page_owner_sort-binary.patch


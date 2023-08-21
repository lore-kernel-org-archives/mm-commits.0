Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6A3EE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjHUUoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjHUUn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9260719A3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74A5464B09
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68B2C433C8;
        Mon, 21 Aug 2023 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650522;
        bh=yFGj+DwzpBmeS9cKYINVNeqWQ3VV6K+SizbudBU0XTM=;
        h=Date:To:From:Subject:From;
        b=uS1uq06jyKGr0VoFDuWJ/IGHcEXr+BBsWqJzet9/9eTsrpQxj48AC0X5fNaGjItQJ
         bgeCrYMHMIYMNc8aA0aJOmm4p5hU/QjD3IaCnwP/Whj3F1jo3lsgIClft70KwLUrVl
         kHYdltPKFQasBR6alZC31S/ZuRSAprPzJGUFZmYk=
Date:   Mon, 21 Aug 2023 13:42:02 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, adobriyan@gmail.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmthp-fix-noden-meminfo-output-alignment.patch removed from -mm tree
Message-Id: <20230821204202.C68B2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm,thp: fix nodeN/meminfo output alignment
has been removed from the -mm tree.  Its filename was
     mmthp-fix-noden-meminfo-output-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp: fix nodeN/meminfo output alignment
Date: Mon, 14 Aug 2023 13:01:12 -0700 (PDT)

Add one more space to FileHugePages and FilePmdMapped, so the output is
aligned with other rows in /sys/devices/system/node/nodeN/meminfo.

Link: https://lkml.kernel.org/r/be861b50-a790-e041-bcb0-2a987dcfd1a@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/node.c~mmthp-fix-noden-meminfo-output-alignment
+++ a/drivers/base/node.c
@@ -446,8 +446,8 @@ static ssize_t node_read_meminfo(struct
 			     "Node %d AnonHugePages:  %8lu kB\n"
 			     "Node %d ShmemHugePages: %8lu kB\n"
 			     "Node %d ShmemPmdMapped: %8lu kB\n"
-			     "Node %d FileHugePages: %8lu kB\n"
-			     "Node %d FilePmdMapped: %8lu kB\n"
+			     "Node %d FileHugePages:  %8lu kB\n"
+			     "Node %d FilePmdMapped:  %8lu kB\n"
 #endif
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     "Node %d Unaccepted:     %8lu kB\n"
_

Patches currently in -mm which might be from hughd@google.com are

tmpfsxattr-gfp_kernel_account-for-simple-xattrs.patch


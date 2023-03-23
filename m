Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49857C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 21:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjCWV3f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjCWV3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 17:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D032F79A
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 14:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9575B628D7
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 21:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4CDC433EF;
        Thu, 23 Mar 2023 21:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679606970;
        bh=034V1LRsLP7L519S7hc/K28fXyIfOB/5FyP2SPstPQo=;
        h=Date:To:From:Subject:From;
        b=QsFsbez7V8QUIvzbohHDIAvcKNZmZlW63nQy6W19rVS5eRJjHL8gh/Dn00SWZGPCB
         azFbDgx/SCfEAA96xnGaga1/oihBb9UzyELWMfhh78swb9tCXMf1CDc+A8bU6Zj/gO
         +gd848RUHe7xYKpyYaL//t3z/g4q5JR74lLTxQMs=
Date:   Thu, 23 Mar 2023 14:29:29 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-prevent-out-of-bounds-array-speculation-when-closing-a-file-descriptor.patch removed from -mm tree
Message-Id: <20230323212929.EE4CDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: prevent out-of-bounds array speculation when closing a file descriptor
has been removed from the -mm tree.  Its filename was
     fs-prevent-out-of-bounds-array-speculation-when-closing-a-file-descriptor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: fs: prevent out-of-bounds array speculation when closing a file descriptor
Date: Mon, 6 Mar 2023 13:54:50 -0500

Google-Bug-Id: 114199369

Link: https://lkml.kernel.org/r/20230306185450.1028235-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/file.c~fs-prevent-out-of-bounds-array-speculation-when-closing-a-file-descriptor
+++ a/fs/file.c
@@ -642,6 +642,7 @@ static struct file *pick_file(struct fil
 	if (fd >= fdt->max_fds)
 		return NULL;
 
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (file) {
 		rcu_assign_pointer(fdt->fd[fd], NULL);
_

Patches currently in -mm which might be from tytso@mit.edu are



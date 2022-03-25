Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733F3C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357507AbiCYBh0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357520AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892503A1BA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CE1AB8226E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0040C340EC;
        Fri, 25 Mar 2022 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172050;
        bh=TH5LVjlR/sDW4tCcFq0R0pQZJhQHT7/fo8c1Nd3WRKA=;
        h=Date:To:From:Subject:From;
        b=VQEoLbFyk2F9L6EyZ+YBcXG/y8cQZp5/0RYpN+xFE80Bil3LJ7+MKqnGfvw4bJYBy
         29l6gMVv4rU9uJ5ZQvd+iAfVN0/1Hz2XFzBc+GqaafcHqZt/nT0JWPW256OArJzJJP
         o3Ub/IgU/vTAe4jSlBn9sn4S9Uaxry9OrYQ/FCfc=
Date:   Thu, 24 Mar 2022 18:34:09 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-kdump-add-scp-example-to-write-out-the-dump-file.patch removed from -mm tree
Message-Id: <20220325013409.F0040C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: kdump: add scp example to write out the dump file
has been removed from the -mm tree.  Its filename was
     docs-kdump-add-scp-example-to-write-out-the-dump-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: docs: kdump: add scp example to write out the dump file

Except cp and makedumpfile, add scp example to write out the dump file.

Link: https://lkml.kernel.org/r/1644324666-15947-3-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/kdump/kdump.rst~docs-kdump-add-scp-example-to-write-out-the-dump-file
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -533,6 +533,10 @@ the following command::
 
    cp /proc/vmcore <dump-file>
 
+or use scp to write out the dump file between hosts on a network, e.g::
+
+   scp /proc/vmcore remote_username@remote_ip:<dump-file>
+
 You can also use makedumpfile utility to write out the dump file
 with specified options to filter out unwanted contents, e.g::
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850C7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbiCWXI3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbiCWXI0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CA690CEF
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74B0CB8214F
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E70C36AE5;
        Wed, 23 Mar 2022 23:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076809;
        bh=lzYOwM/qQ0uf4J6pgfonmxKUY4nonSgq8rrQjbyWLD8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=unpRlu5l97M2637wmCldsdDu39wVyRC03ZRK36C0JMR55EQSleOfu8GWd/lxSiiMe
         VNg6oYD8hoSGGlwxkPdAAcVAVSUt75qV7a39XgTZWg9+QOYGi+zasCdrD0/IzIlujV
         IjQtfNHg4FA3wyJtWW3+uyZPKEAWyWKqAJYjzm8w=
Date:   Wed, 23 Mar 2022 16:06:48 -0700
To:     ryabinin.a.a@gmail.com, lixuefeng@loongson.cn, elver@google.com,
        corbet@lwn.net, bhe@redhat.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 30/41] docs: kdump: add scp example to write out the dump file
Message-Id: <20220323230649.29E70C36AE5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

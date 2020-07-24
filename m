Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F540C433F1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23AD32067D
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564154;
	bh=5uv/3frivuikopVb6EWH8EFMRlKpWGluePcFeWUzSog=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zbXW1mKpZGg+m2hnaNXjaqLsnD2odt7kSm918+kRjhZnkUZnCDdodv22F+bWa92Vp
	 cBvQcYDNXfinQ4v/2tOFyE0MPFVgi3LN3jvcStGGuXEn0fRXMgD34dW6Qv322uiaos
	 J0RfpBJcZabCU9F2Dg8Z7VE6QH83lXNU3DnfvRoE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgGXEPx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXEPx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 038F62064C;
        Fri, 24 Jul 2020 04:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564153;
        bh=5uv/3frivuikopVb6EWH8EFMRlKpWGluePcFeWUzSog=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JiF5BAocVirW9TP0U8FAyeT9SVZQjgUDGXgnrXLrXXa/bkNrzhC13obocOQkHsJBI
         G6/9CCeZnVe648XY9zTC9oE0ItQHVbsxUgRKoiPeghe8V3v6dh/hHMS6qFwW5jAyCn
         PzLXxSeoI/wMkM0H9dM9rr/p0kkMwo4aPVIqkFTo=
Date:   Thu, 23 Jul 2020 21:15:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jan.kiszka@siemens.com,
        kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sgarzare@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 15/15] scripts/gdb: fix lx-symbols 'gdb.error'
 while loading modules
Message-ID: <20200724041552.hdbc354nL%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Subject: scripts/gdb: fix lx-symbols 'gdb.error' while loading modules

Commit ed66f991bb19 ("module: Refactor section attr into bin
attribute") removed the 'name' field from 'struct module_sect_attr'
triggering the following error when invoking lx-symbols:

  (gdb) lx-symbols
  loading vmlinux
  scanning for modules in linux/build
  loading @0xffffffffc014f000: linux/build/drivers/net/tun.ko
  Python Exception <class 'gdb.error'> There is no member named name.:
  Error occurred in Python: There is no member named name.

This patch fixes the issue taking the module name from the 'struct
attribute'.

Link: http://lkml.kernel.org/r/20200722102239.313231-1-sgarzare@redhat.com
Fixes: ed66f991bb19 ("module: Refactor section attr into bin attribute")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules
+++ a/scripts/gdb/linux/symbols.py
@@ -96,7 +96,7 @@ lx-symbols command."""
             return ""
         attrs = sect_attrs['attrs']
         section_name_to_address = {
-            attrs[n]['name'].string(): attrs[n]['address']
+            attrs[n]['battr']['attr']['name'].string(): attrs[n]['address']
             for n in range(int(sect_attrs['nsections']))}
         args = []
         for section_name in [".data", ".data..read_mostly", ".rodata", ".bss",
_

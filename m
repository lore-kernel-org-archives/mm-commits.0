Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940D6C433F2
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 677F02074B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633930;
	bh=/2kkXII9jCdw9aPDtIf+47PcSQc80SDGWSDncT/gRQ0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xXe4WMlF3643AxyxA+KPYy7KZH4L/tXUMGmYLQd8nd/B/bTXqzTBl2CZOHNlSZCDv
	 v+4GL3vxyAf24B74P0eDCnePMbpQiUorg5o6Q6FtjyjWE61ed5Z4sgGZgbW1wOAe/U
	 rSfgnkhdOpjc6OM0o+SwQruKfoaRtr/QopfyvLww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGXXiu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgGXXiu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C07020737;
        Fri, 24 Jul 2020 23:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633929;
        bh=/2kkXII9jCdw9aPDtIf+47PcSQc80SDGWSDncT/gRQ0=;
        h=Date:From:To:Subject:From;
        b=xyrsRr/DM6JUt7TOL4NrqN9+k+ZToYQCEGynhj92NV++K5z/ZT1F9eXkXhDgPz/Dw
         9HLrYCOhzkScz3pXTFW3ex5QeKGhTin60JgVG3ouJx+agm/xdKiKnZetfmbAREBSRQ
         oOoyrSZaxzIHClpb6W09Xq8sNmiYQCfa6htffk4w=
Date:   Fri, 24 Jul 2020 16:38:49 -0700
From:   akpm@linux-foundation.org
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, sgarzare@redhat.com
Subject:  [merged]
 scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules.patch removed
 from -mm tree
Message-ID: <20200724233849.jP9TIWRUz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-symbols 'gdb.error' while loading modules
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sgarzare@redhat.com are



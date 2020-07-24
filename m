Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A48C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43D2920792
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595550367;
	bh=mmmUgtJIqCuum9i+Rl2RLr7LpDvzjaD/WYlag2iXbuI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ELm6MxvDoLBimr9yzV+7hBmBfNJavQLpqhWigF2GGQId1tjO5G+egOfBlNyhQWkBA
	 aGxKR4ilg4NdzhgUGmlZFuqxBnkBWASCvYESibCj5y8bm/mHFupeBxc4uE/MzAZXds
	 PURaVIjgKyJh9mkBioMBY7Mzljw/IAA1WdVzHlXU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgGXA0G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 20:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgGXA0G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 20:26:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6A0206E3;
        Fri, 24 Jul 2020 00:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595550366;
        bh=mmmUgtJIqCuum9i+Rl2RLr7LpDvzjaD/WYlag2iXbuI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MOSrPFl6cgF3UxH9/ZRk0aSlg2rylpQvQ1lTG5kGAk0Srq2cgvAJ9afgE2w0unQ19
         rq9ZesCOftu/2qutRmUuXFBCJ4HiDfdC2yHTs2Mq9Gj2KV9L4opEbJHVBg4aLoIGKv
         z8yHST7jfPQXZaIp+sNLotFNet393KLsVSiyX6z0=
Date:   Thu, 23 Jul 2020 17:26:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, sgarzare@redhat.com
Subject:  +
 scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules.patch added to
 -mm tree
Message-ID: <20200724002605.8zaXJjauX%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-symbols 'gdb.error' while loading modules
has been added to the -mm tree.  Its filename is
     scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-fix-lx-symbols-gdberror-while-loading-modules.patch


Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CDCC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D876520738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598297894;
	bh=uuGCJUbrhQyPwOecoKiCd5mvnTXx6joqH3Am8tZQxK4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xcKKUC6pHN0T97wN36X+Qq7yPMAKyc6dYDenJg9sLmKGdxJMG6J24mNCMwLwHpgmv
	 SMDFqKkaodBal7ZBoXM/8dIPmKZetzntYu6D5tYGmou0FZ+UKNu6gqT48GTn16VqJo
	 JiEHGd0O9TsWnb7ImLAWTuUS84KcNPH7/jIJ6jps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgHXTiO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXTiO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 15:38:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A87206BE;
        Mon, 24 Aug 2020 19:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598297893;
        bh=uuGCJUbrhQyPwOecoKiCd5mvnTXx6joqH3Am8tZQxK4=;
        h=Date:From:To:Subject:From;
        b=mpbQQ5n5DCsRq7DEayPWxDIzYvc8fuWVN9v4nwp0TEMkofXl2BGfS/m2jzHtc0qb7
         OlsIsVtU668mmP4ylQXGtJ+GS8+dvZ0I4jGMTbWmI81ZINTH7X5WjoevXscCMqRrbD
         VUat9C7Lf75TG7Ddl5OkOfXKyBnK8zN8nWFQVGb8=
Date:   Mon, 24 Aug 2020 12:38:12 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, corbet@lwn.net, David.Laight@aculab.com,
        dyoung@redhat.com, gregkh@linuxfoundation.org,
        jan.kiszka@siemens.com, john.ogness@linutronix.de,
        kbingham@kernel.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, vgoyal@redhat.com
Subject:  + scripts-gdb-add-utilsread_ulong.patch added to -mm tree
Message-ID: <20200824193812.v5kwt_t5h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add utils.read_ulong()
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-utilsread_ulong.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-utilsread_ulong.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-utilsread_ulong.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Ogness <john.ogness@linutronix.de>
Subject: scripts/gdb: add utils.read_ulong()

Patch series "update gdb scripts for lockless printk ringbuffer".

When we brought in the new lockless printk ringbuffer, we overlooked the
gdb scripts.  Here are a set of patches to implement gdb support for the
new ringbuffer.


This patch (of 2):

Add a function for reading unsigned long values, which vary in size
depending on the architecture.

Link: https://lkml.kernel.org/r/20200814212525.6118-1-john.ogness@linutronix.de
Link: https://lkml.kernel.org/r/20200814212525.6118-2-john.ogness@linutronix.de
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Petr Mladek <pmladek@suse.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/gdb/linux/utils.py~scripts-gdb-add-utilsread_ulong
+++ a/scripts/gdb/linux/utils.py
@@ -123,6 +123,13 @@ def read_u64(buffer, offset):
         return read_u32(buffer, offset + 4) + (read_u32(buffer, offset) << 32)
 
 
+def read_ulong(buffer, offset):
+    if get_long_type().sizeof == 8:
+        return read_u64(buffer, offset)
+    else:
+        return read_u32(buffer, offset)
+
+
 target_arch = None
 
 
_

Patches currently in -mm which might be from john.ogness@linutronix.de are

scripts-gdb-add-utilsread_ulong.patch
scripts-gdb-update-for-lockless-printk-ringbuffer.patch


Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96580C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 740BE208C7
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599159830;
	bh=sorhmCxeKVvVzP8KZxda32d7Kr3idOmB6MiR3JjNLoI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aUAnmlj8eWQIK1lovcDfitph+RutTbIYaoOr0adNlux+hfUJBeB5gSBu5jIa5GH8p
	 m8xgom+3l2MGaTRaBvQOrgNtaEfaZFX0kqiTed8stT/uU1vexQOOwlb7dy854QKnBf
	 J8mkihw4LRpBogV4TyxvaM689ikbykcj13SI5bQw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgICTDu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgICTDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:03:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6A5720658;
        Thu,  3 Sep 2020 19:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599159828;
        bh=sorhmCxeKVvVzP8KZxda32d7Kr3idOmB6MiR3JjNLoI=;
        h=Date:From:To:Subject:From;
        b=uF602OyVfBRhI3Aj3UL3FmlwJoYTaM6FjDvJG+bZA6MdPS1S5hSEBB45WXH4HYjs9
         1OHl0mzUIAbjxuxGKesb2AxO5vwWehoZOedZzu+DxU4CKFDEBJsjpZgmi9mQD0i4Gv
         Kr1PN+7rRUZTRMVllLnJJH9+KUdodkb2is4ddBtM=
Date:   Thu, 03 Sep 2020 12:03:47 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, corbet@lwn.net, David.Laight@aculab.com,
        dyoung@redhat.com, gregkh@linuxfoundation.org,
        jan.kiszka@siemens.com, john.ogness@linutronix.de,
        kbingham@kernel.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, vgoyal@redhat.com
Subject:  [merged] scripts-gdb-add-utilsread_ulong.patch removed
 from -mm tree
Message-ID: <20200903190347.8SbFN4Nci%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add utils.read_ulong()
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-utilsread_ulong.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



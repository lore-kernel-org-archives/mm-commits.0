Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA97EC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 23:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbhLHXkl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhLHXkl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 18:40:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A99AC061746
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 15:37:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A45E3CE2261
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 23:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C32C00446;
        Wed,  8 Dec 2021 23:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639006624;
        bh=LA8sSxeKumEBVL1tkYP40Fi2+DeuJam8/sVSUcwd0ag=;
        h=Date:From:To:Subject:From;
        b=r9LfwcMgQE9wPKbzU1wAc53xPC1yLswPYBj0e49GUjR/zv8O6FpRDx5CkCYmN4vBU
         AYdbVxpr/4OFmVucvkD5lgDgnkEWDFwONgMVrFaknNwb7FPIoH0sH9KRhjDMxQmMO7
         /LyHUJw13sRYUJS/xXXI55sL6iNZws96tT006kFo=
Date:   Wed, 08 Dec 2021 15:37:04 -0800
From:   akpm@linux-foundation.org
To:     ahalaney@redhat.com, bhe@redhat.com, mm-commits@vger.kernel.org,
        prudo@redhat.com
Subject:  +
 kernel-crash_core-suppress-unknown-crashkernel-parameter-warning.patch
 added to -mm tree
Message-ID: <20211208233704.vuGWURxuf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/crash_core: suppress unknown crashkernel parameter warning
has been added to the -mm tree.  Its filename is
     kernel-crash_core-suppress-unknown-crashkernel-parameter-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-crash_core-suppress-unknown-crashkernel-parameter-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-crash_core-suppress-unknown-crashkernel-parameter-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philipp Rudo <prudo@redhat.com>
Subject: kernel/crash_core: suppress unknown crashkernel parameter warning

When booting with crashkernel= on the kernel command line a warning
similar to

[    0.038294] Kernel command line: ro console=ttyS0 crashkernel=256M
[    0.038353] Unknown kernel command line parameters "crashkernel=256M", will be passed to user space.

is printed.  This comes from crashkernel= being parsed independent from
the kernel parameter handling mechanism.  So the code in init/main.c
doesn't know that crashkernel= is a valid kernel parameter and prints this
incorrect warning.  Suppress the warning by adding a dummy early_param
handler for crashkernel=.

Link: https://lkml.kernel.org/r/20211208133443.6867-1-prudo@redhat.com
Fixes: 86d1919a4fb0 ("init: print out unknown kernel parameters")
Signed-off-by: Philipp Rudo <prudo@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/crash_core.c~kernel-crash_core-suppress-unknown-crashkernel-parameter-warning
+++ a/kernel/crash_core.c
@@ -6,6 +6,7 @@
 
 #include <linux/buildid.h>
 #include <linux/crash_core.h>
+#include <linux/init.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
 
@@ -295,6 +296,16 @@ int __init parse_crashkernel_low(char *c
 				"crashkernel=", suffix_tbl[SUFFIX_LOW]);
 }
 
+/*
+ * Add a dummy early_param handler to mark crashkernel= as a known command line
+ * parameter and suppress incorrect warnings in init/main.c.
+ */
+static int __init parse_crashkernel_dummy(char *arg)
+{
+	return 0;
+}
+early_param("crashkernel", parse_crashkernel_dummy);
+
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len)
 {
_

Patches currently in -mm which might be from prudo@redhat.com are

kernel-crash_core-suppress-unknown-crashkernel-parameter-warning.patch


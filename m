Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD323C4332F
	for <mm-commits@archiver.kernel.org>; Sun, 26 Dec 2021 22:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhLZWUB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 17:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhLZWUA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 17:20:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1297C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 14:20:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61E6160E2D
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 22:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64EAC36AE8;
        Sun, 26 Dec 2021 22:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557199;
        bh=v6es2EwK+t5T6rHqTjG/iiQ1uHhfO8SbFzBs7cD13wc=;
        h=Date:From:To:Subject:From;
        b=aysSshibdMOdbmz6oBranmbvgXecl1UkQ5cHl45u3nBVPh4pAJa2dUPhqzG2W00JO
         ZMVW+YHsF4klwZQtgIq0ZbiJrmhc6KPrdCiZc3sbXpqJ2o5bvy9CBvRsiyMhcDisua
         ilA5GKLCNtsGYF5N8u5XdpUiG4W3NmbLzp8U4Fww=
Date:   Sun, 26 Dec 2021 14:19:59 -0800
From:   akpm@linux-foundation.org
To:     ahalaney@redhat.com, bhe@redhat.com, mm-commits@vger.kernel.org,
        prudo@redhat.com
Subject:  [merged]
 kernel-crash_core-suppress-unknown-crashkernel-parameter-warning.patch
 removed from -mm tree
Message-ID: <20211226221959.ox--oFMtM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/crash_core: suppress unknown crashkernel parameter warning
has been removed from the -mm tree.  Its filename was
     kernel-crash_core-suppress-unknown-crashkernel-parameter-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



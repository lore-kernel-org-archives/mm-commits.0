Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8E8C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 25 Dec 2021 05:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhLYFMm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Dec 2021 00:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLYFMm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Dec 2021 00:12:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A673C061401
        for <mm-commits@vger.kernel.org>; Fri, 24 Dec 2021 21:12:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03392B8072F
        for <mm-commits@vger.kernel.org>; Sat, 25 Dec 2021 05:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A9DC36AE5;
        Sat, 25 Dec 2021 05:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409159;
        bh=DWeIuh07cHVZm8NJyw4rNMyS8/atCEUdEw3jcDbjF88=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=efX1t84J+mapk1BAjbQMpw5Wy8c7SdDF5lQkCDyiezcAjJbK+TrB4Ar8eNC740l4R
         aBA7+Aagu6DcS+mNTr9HwnCVfKW1fHSXRRr5GVWq+B2u2TZi6ymgt6oINfxsmgCSzt
         HP2ulGfKeaH3JZEPizPNbYLpJ7F/ZektArsGF/9k=
Date:   Fri, 24 Dec 2021 21:12:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ahalaney@redhat.com, akpm@linux-foundation.org, bhe@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, prudo@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 3/9] kernel/crash_core: suppress unknown
 crashkernel parameter warning
Message-ID: <20211225051239.TPFjGNEo6%akpm@linux-foundation.org>
In-Reply-To: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

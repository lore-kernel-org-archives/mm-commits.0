Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF044C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345969AbjKXTby (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345941AbjKXTby (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:31:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738D41FE6
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:32:00 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06432C433C7;
        Fri, 24 Nov 2023 19:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700854320;
        bh=LSsYWoRPH1W6asHTO5KxgVBMBeHfXU4ukC35KVwdFBU=;
        h=Date:To:From:Subject:From;
        b=XTCpHq99O3Z/GqRIsEmQpzhpdpdcErGg0W4vBqEmfL823AmGuTcYTiKb8iKP/nHL3
         oogFJBQoyId/j9q7M4tYV8PNQllM0QLMMAoddaV2enw6DIC1nA4R/clUdAcqr5kfng
         ITq+Otwk/2SVXvqH1I59B/fipNtxjEd/HAjZInyc=
Date:   Fri, 24 Nov 2023 11:31:59 -0800
To:     mm-commits@vger.kernel.org, takahiro.akashi@linaro.org,
        ebiederm@xmission.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-add-walk_system_ram_res_rev.patch added to mm-nonmm-unstable branch
Message-Id: <20231124193200.06432C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: resource: add walk_system_ram_res_rev()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-add-walk_system_ram_res_rev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-add-walk_system_ram_res_rev.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: resource: add walk_system_ram_res_rev()
Date: Wed, 15 Nov 2023 21:00:27 +0800

This function, being a variant of walk_system_ram_res() introduced in
commit 8c86e70acead ("resource: provide new functions to walk through
resources"), walks through a list of all the resources of System RAM in
reversed order, i.e., from higher to lower.

It will be used in kexec_file code to load kernel, initrd etc when
preparing kexec reboot.

Link: https://lkml.kernel.org/r/ZVTA6z/06cLnWKUz@MiWiFi-R3L-srv
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    3 ++
 kernel/resource.c      |   57 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/include/linux/ioport.h~resource-add-walk_system_ram_res_rev
+++ a/include/linux/ioport.h
@@ -331,6 +331,9 @@ extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
 		    int (*func)(struct resource *, void *));
 extern int
+walk_system_ram_res_rev(u64 start, u64 end, void *arg,
+			int (*func)(struct resource *, void *));
+extern int
 walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
 		    void *arg, int (*func)(struct resource *, void *));
 
--- a/kernel/resource.c~resource-add-walk_system_ram_res_rev
+++ a/kernel/resource.c
@@ -27,6 +27,8 @@
 #include <linux/mount.h>
 #include <linux/resource_ext.h>
 #include <uapi/linux/magic.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
 #include <asm/io.h>
 
 
@@ -430,6 +432,61 @@ int walk_system_ram_res(u64 start, u64 e
 }
 
 /*
+ * This function, being a variant of walk_system_ram_res(), calls the @func
+ * callback against all memory ranges of type System RAM which are marked as
+ * IORESOURCE_SYSTEM_RAM and IORESOUCE_BUSY in reversed order, i.e., from
+ * higher to lower.
+ */
+int walk_system_ram_res_rev(u64 start, u64 end, void *arg,
+				int (*func)(struct resource *, void *))
+{
+	struct resource res, *rams;
+	int rams_size = 16, i;
+	unsigned long flags;
+	int ret = -1;
+
+	/* create a list */
+	rams = kvcalloc(rams_size, sizeof(struct resource), GFP_KERNEL);
+	if (!rams)
+		return ret;
+
+	flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
+	i = 0;
+	while ((start < end) &&
+		(!find_next_iomem_res(start, end, flags, IORES_DESC_NONE, &res))) {
+		if (i >= rams_size) {
+			/* re-alloc */
+			struct resource *rams_new;
+
+			rams_new = kvrealloc(rams, rams_size * sizeof(struct resource),
+					     (rams_size + 16) * sizeof(struct resource),
+					     GFP_KERNEL);
+			if (!rams_new)
+				goto out;
+
+			rams = rams_new;
+			rams_size += 16;
+		}
+
+		rams[i].start = res.start;
+		rams[i++].end = res.end;
+
+		start = res.end + 1;
+	}
+
+	/* go reverse */
+	for (i--; i >= 0; i--) {
+		ret = (*func)(&rams[i], arg);
+		if (ret)
+			break;
+	}
+
+out:
+	kvfree(rams);
+	return ret;
+}
+
+/*
  * This function calls the @func callback against all memory ranges, which
  * are ranges marked as IORESOURCE_MEM and IORESOUCE_BUSY.
  */
_

Patches currently in -mm which might be from bhe@redhat.com are

resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1662AC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C36F023432
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgLPRLR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgLPRLP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:15 -0500
Date:   Wed, 16 Dec 2020 09:10:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138634;
        bh=FPWFAbH6Z54SaoJaLaisTXAJV9MmNj3vwoMlo2YMJJs=;
        h=From:To:Subject:From;
        b=INSh8/b+3heUkUvlO9JCxATF8SQ+rGcS3tpZC/6gLaKrIbImCxv5vs9aPpjsCIRlq
         Y+apMP7Ubf5t+UTy/eXfNoHH7YoCthD4BYhQWm31EaTnb1fL76xoHpicUDS/PbbS/k
         7So2IT6XfwavTaR222OjTQZ5YxS9Je7T03zpTv6s=
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, christian.brauner@ubuntu.com, dyoung@redhat.com,
        ebiederm@xmission.com, egorenar@linux.ibm.com,
        keescook@chromium.org, ktkhai@virtuozzo.com, lijiang@redhat.com,
        mm-commits@vger.kernel.org, vgoyal@redhat.com
Subject:  [merged]
 kdump-append-uts_namespacename-offset-to-vmcoreinfo.patch removed from -mm
 tree
Message-ID: <20201216171034.r5vXrhMGj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: append uts_namespace.name offset to VMCOREINFO
has been removed from the -mm tree.  Its filename was
     kdump-append-uts_namespacename-offset-to-vmcoreinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: kdump: append uts_namespace.name offset to VMCOREINFO

The offset of the field 'init_uts_ns.name' has changed since commit
9a56493f6942 ("uts: Use generic ns_common::count").

Make the offset of the field 'uts_namespace.name' available in VMCOREINFO
because tools like 'crash-utility' and 'makedumpfile' must be able to read
it from crash dumps.

Link: https://lore.kernel.org/r/159644978167.604812.1773586504374412107.stgit@localhost.localdomain
Link: https://lkml.kernel.org/r/20200930102328.396488-1-egorenar@linux.ibm.com
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Acked-by: lijiang <lijiang@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    6 ++++++
 kernel/crash_core.c                            |    1 +
 2 files changed, 7 insertions(+)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~kdump-append-uts_namespacename-offset-to-vmcoreinfo
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -39,6 +39,12 @@ call.
 User-space tools can get the kernel name, host name, kernel release
 number, kernel version, architecture name and OS type from it.
 
+(uts_namespace, name)
+---------------------
+
+Offset of the name's member. Crash Utility and Makedumpfile get
+the start address of the init_uts_ns.name from this.
+
 node_online_map
 ---------------
 
--- a/kernel/crash_core.c~kdump-append-uts_namespacename-offset-to-vmcoreinfo
+++ a/kernel/crash_core.c
@@ -447,6 +447,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_PAGESIZE(PAGE_SIZE);
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
+	VMCOREINFO_OFFSET(uts_namespace, name);
 	VMCOREINFO_SYMBOL(node_online_map);
 #ifdef CONFIG_MMU
 	VMCOREINFO_SYMBOL_ARRAY(swapper_pg_dir);
_

Patches currently in -mm which might be from egorenar@linux.ibm.com are



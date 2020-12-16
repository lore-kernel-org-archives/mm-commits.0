Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64840C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3443723339
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgLPEpr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgLPEpr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:47 -0500
Date:   Tue, 15 Dec 2020 20:45:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093932;
        bh=bSvKPyN2vI3JncAbr+6DrpmWfX86F/Omg+MsufQmK3A=;
        h=From:To:Subject:In-Reply-To:From;
        b=wAhXlCjzbB4bT5Vu5AJMkbJxrEh9SsFnBa6rRqjwFX5N+mjGpVp0aJvEybg8wrrLL
         hk+uRfDJSVssxHhQjLkYHsLB3e+5GTSGOh06drkFfHJA0xvlIBqGSJIjkTn3i/qZoT
         mxYEBQnwpZmcjZiN/7R5BvuIvr7HO9ojiUKPCoX8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com,
        christian.brauner@ubuntu.com, dyoung@redhat.com,
        ebiederm@xmission.com, egorenar@linux.ibm.com,
        keescook@chromium.org, ktkhai@virtuozzo.com, lijiang@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject:  [patch 59/95] kdump: append uts_namespace.name offset to
 VMCOREINFO
Message-ID: <20201216044531.5QxvZ9WtI%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

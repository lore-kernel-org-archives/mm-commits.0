Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B073C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377907AbiATV3m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377916AbiATV3c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD8EC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3424AB81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD778C340E0;
        Thu, 20 Jan 2022 21:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714170;
        bh=B8cImmT43H1ZNz/4bNZXSCq7I5i7Uc9ANzYoyXNaNw0=;
        h=Date:From:To:Subject:From;
        b=LFuLCXiWGin3+EbDHEDRvKBLUNKq+Q7Uf87dKPl+FeV/KmZVn/65rhqZPIHr0DGGj
         JjDZHcyxcjfckBBoYBSPi9C540W+6MUGt6Ls9GiPhwN+U7t2OpA6F7u1ROXByH4XnY
         ajFApRXMiUH3CpoW/cPYycjkC+Xj9uenGTITrx8M=
Date:   Thu, 20 Jan 2022 13:29:29 -0800
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, dhowells@redhat.com,
        hch@infradead.org, hdegoede@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 proc-make-the-proc_create-stubs-static-inlines.patch removed from -mm tree
Message-ID: <20220120212929.Gjh4U4LKM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make the proc_create[_data]() stubs static inlines
has been removed from the -mm tree.  Its filename was
     proc-make-the-proc_create-stubs-static-inlines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hans de Goede <hdegoede@redhat.com>
Subject: proc: make the proc_create[_data]() stubs static inlines

Change the proc_create[_data]() stubs which are used when CONFIG_PROC_FS
is not set from #defines to a static inline stubs.

Thix should fix clang -Werror builds failing due to errors like this:

drivers/platform/x86/thinkpad_acpi.c:918:30: error: unused variable
 'dispatch_proc_ops' [-Werror,-Wunused-const-variable]

Fixing this in include/linux/proc_fs.h should ensure that the same issue
is also fixed in any other drivers hitting the same -Werror issue.

Link: https://lkml.kernel.org/r/20211116131112.508304-1-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proc_fs.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/proc_fs.h~proc-make-the-proc_create-stubs-static-inlines
+++ a/include/linux/proc_fs.h
@@ -178,8 +178,14 @@ static inline struct proc_dir_entry *pro
 #define proc_create_seq(name, mode, parent, ops) ({NULL;})
 #define proc_create_single(name, mode, parent, show) ({NULL;})
 #define proc_create_single_data(name, mode, parent, show, data) ({NULL;})
-#define proc_create(name, mode, parent, proc_ops) ({NULL;})
-#define proc_create_data(name, mode, parent, proc_ops, data) ({NULL;})
+
+static inline struct proc_dir_entry *proc_create(
+	const char *, umode_t, struct proc_dir_entry *, const struct proc_ops *)
+{ return NULL; }
+
+static inline struct proc_dir_entry *proc_create_data(
+	const char *, umode_t, struct proc_dir_entry *, const struct proc_ops *, void *)
+{ return NULL; }
 
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
_

Patches currently in -mm which might be from hdegoede@redhat.com are



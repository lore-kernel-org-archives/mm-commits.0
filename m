Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D37DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 19 Nov 2021 01:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2969061AA2
	for <mm-commits@archiver.kernel.org>; Fri, 19 Nov 2021 01:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhKSBHY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 20:07:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230133AbhKSBHY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 20:07:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF9B961279;
        Fri, 19 Nov 2021 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637283863;
        bh=WiT53ndH/ccBQBNCpWyDA46vL8l9acqEux2ileRUUNU=;
        h=Date:From:To:Subject:From;
        b=Hs6hUbKfRnMvJ9ehrJYNV3zXacsLbm020VU/yp5iM074vcD+dfXQlQWTU1wbw0SgA
         wos+vnr9q58RktTZ+I6MvxN/QNZzHT0/h3Wfq9oIRYftl/+amixb9L+ucWxzMAVrZz
         YR3eBPeirpkn5zeZpcFj5vGOaEDAySIuFAL+0HPY=
Date:   Thu, 18 Nov 2021 17:04:22 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, christian@brauner.io,
        dhowells@redhat.com, hch@infradead.org, hdegoede@redhat.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        viro@zeniv.linux.org.uk
Subject:  +
 proc-make-the-proc_create-stubs-static-inlines-fix.patch added to -mm tree
Message-ID: <20211119010422.ZzUvO1GaL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-make-the-proc_create-stubs-static-inlines-fix
has been added to the -mm tree.  Its filename is
     proc-make-the-proc_create-stubs-static-inlines-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-make-the-proc_create-stubs-static-inlines-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-make-the-proc_create-stubs-static-inlines-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-make-the-proc_create-stubs-static-inlines-fix

fix CONFIG_PROC_FS=n

Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian@brauner.io>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proc_fs.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/proc_fs.h~proc-make-the-proc_create-stubs-static-inlines-fix
+++ a/include/linux/proc_fs.h
@@ -179,12 +179,14 @@ static inline struct proc_dir_entry *pro
 #define proc_create_single(name, mode, parent, show) ({NULL;})
 #define proc_create_single_data(name, mode, parent, show, data) ({NULL;})
 
-static inline struct proc_dir_entry *proc_create(
-	const char *, umode_t, struct proc_dir_entry *, const struct proc_ops *)
+static inline struct proc_dir_entry *
+proc_create(const char *name, umode_t mode, struct proc_dir_entry *parent,
+	    const struct proc_ops *proc_ops)
 { return NULL; }
 
-static inline struct proc_dir_entry *proc_create_data(
-	const char *, umode_t, struct proc_dir_entry *, const struct proc_ops *, void *)
+static inline struct proc_dir_entry *
+proc_create_data(const char *name, umode_t mode, struct proc_dir_entry *parent,
+		 const struct proc_ops *proc_ops, void *data)
 { return NULL; }
 
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF21C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377912AbiATV3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377943AbiATV3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92500C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 458DDB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC349C340E0;
        Thu, 20 Jan 2022 21:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714173;
        bh=8qiGaoFmGG+4MjIdGdrd3yxrdwlnw1VvJhqR7mEbDjs=;
        h=Date:From:To:Subject:From;
        b=bxPcon4uZlr2AdyMIn3hzdLBsg1yfkkfSsIxsDseGiVRUfMYNLPtCitNVXuVx3eEj
         4bS9MaLeV8IdFmJjCALScduiDIw4AYLGDfxFPiiVAMa8NMW63auGrkhqucqpAGYhLc
         E4YoBXypXQ0j9exKGQy3N1rNdjs8jYyUeehXhKcw=
Date:   Thu, 20 Jan 2022 13:29:32 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, christian@brauner.io,
        dhowells@redhat.com, hch@infradead.org, hdegoede@redhat.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 proc-make-the-proc_create-stubs-static-inlines-fix.patch removed from -mm
 tree
Message-ID: <20220120212932.-5AfZ9dSM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-make-the-proc_create-stubs-static-inlines-fix
has been removed from the -mm tree.  Its filename was
     proc-make-the-proc_create-stubs-static-inlines-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5839CC11F6A
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 468B561CD4
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhGHBKv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhGHBKt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9119861CCF;
        Thu,  8 Jul 2021 01:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706488;
        bh=UwC1xKQ66RJjSS8Lm5HR4sog8UZ4rbFsKgiRsF29CTE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wzbeP+o1fiFEWSsU1NTumoplIXCQixQblfscc/FjNZezbwPeTzGThJIGq5rMkgQ3b
         BPWvQvAFV6k5E4/iNEarroCm8+ee98xxUFxs5Dtj1NgCxrMGmGdOccMKVpKUzanmrR
         I7jWi0OhTBiSMID3tBE7I26O8yf+p7o91dvJrRL0=
Date:   Wed, 07 Jul 2021 18:08:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        elena.reshetova@intel.com, guro@fb.com, hagen@jauu.net,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        jejb@linux.ibm.com, kirill@shutemov.name, linux-mm@kvack.org,
        lkp@intel.com, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, tycho@tycho.ws,
        viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org
Subject:  [patch 12/54] PM: hibernate: disable when there are
 active secretmem users
Message-ID: <20210708010807.hHILhs811%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: PM: hibernate: disable when there are active secretmem users

It is unsafe to allow saving of secretmem areas to the hibernation
snapshot as they would be visible after the resume and this essentially
will defeat the purpose of secret memory mappings.

Prevent hibernation whenever there are active secret memory users.

Link: https://lkml.kernel.org/r/20210518072034.31572-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |    6 ++++++
 kernel/power/hibernate.c  |    5 ++++-
 mm/secretmem.c            |   15 +++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

--- a/include/linux/secretmem.h~pm-hibernate-disable-when-there-are-active-secretmem-users
+++ a/include/linux/secretmem.h
@@ -30,6 +30,7 @@ static inline bool page_is_secretmem(str
 }
 
 bool vma_is_secretmem(struct vm_area_struct *vma);
+bool secretmem_active(void);
 
 #else
 
@@ -42,6 +43,11 @@ static inline bool page_is_secretmem(str
 {
 	return false;
 }
+
+static inline bool secretmem_active(void)
+{
+	return false;
+}
 
 #endif /* CONFIG_SECRETMEM */
 
--- a/kernel/power/hibernate.c~pm-hibernate-disable-when-there-are-active-secretmem-users
+++ a/kernel/power/hibernate.c
@@ -31,6 +31,7 @@
 #include <linux/genhd.h>
 #include <linux/ktime.h>
 #include <linux/security.h>
+#include <linux/secretmem.h>
 #include <trace/events/power.h>
 
 #include "power.h"
@@ -81,7 +82,9 @@ void hibernate_release(void)
 
 bool hibernation_available(void)
 {
-	return nohibernate == 0 && !security_locked_down(LOCKDOWN_HIBERNATION);
+	return nohibernate == 0 &&
+		!security_locked_down(LOCKDOWN_HIBERNATION) &&
+		!secretmem_active();
 }
 
 /**
--- a/mm/secretmem.c~pm-hibernate-disable-when-there-are-active-secretmem-users
+++ a/mm/secretmem.c
@@ -40,6 +40,13 @@ module_param_named(enable, secretmem_ena
 MODULE_PARM_DESC(secretmem_enable,
 		 "Enable secretmem and memfd_secret(2) system call");
 
+static atomic_t secretmem_users;
+
+bool secretmem_active(void)
+{
+	return !!atomic_read(&secretmem_users);
+}
+
 static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
@@ -94,6 +101,12 @@ static const struct vm_operations_struct
 	.fault = secretmem_fault,
 };
 
+static int secretmem_release(struct inode *inode, struct file *file)
+{
+	atomic_dec(&secretmem_users);
+	return 0;
+}
+
 static int secretmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	unsigned long len = vma->vm_end - vma->vm_start;
@@ -116,6 +129,7 @@ bool vma_is_secretmem(struct vm_area_str
 }
 
 static const struct file_operations secretmem_fops = {
+	.release	= secretmem_release,
 	.mmap		= secretmem_mmap,
 };
 
@@ -202,6 +216,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
 	file->f_flags |= O_LARGEFILE;
 
 	fd_install(fd, file);
+	atomic_inc(&secretmem_users);
 	return fd;
 
 err_put_fd:
_

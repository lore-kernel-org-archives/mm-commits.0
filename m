From: akpm@linux-foundation.org
Subject: [to-be-updated] s390-query-dynamic-debug_pagealloc-setting.patch
 removed from -mm tree
Date: Wed, 27 Jan 2016 11:50:37 -0800
Message-ID: <56a91f8d.bH+27ZC/gkbOG01+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966816AbcA0Tui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:50:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     s390-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Return-Path: <borntraeger@de.ibm.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00 autolearn=ham
	version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id u0RABO2m001215
	for <akpm@localhost>; Wed, 27 Jan 2016 02:11:25 -0800
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Wed, 27 Jan 2016 02:11:25 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id 1B7C4EC4
	for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 10:09:46 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 75DBD10C
	for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 10:09:45 +0000 (UTC)
Received: by mail-wm0-f43.google.com with SMTP id n5so20114579wmn.1
        for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 02:09:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-original-authentication-results:x-gm-message-state:from:to:cc
         :subject:date:message-id:in-reply-to:references:delivered-to;
        bh=4w6mcO7lyGVhSdRzNUlEIAerJ+xftklYF1bAjjgAJpg=;
        b=BpeXn3b83NHdufNkpginK1alNodaIX92V4K4yWPViJYxrLXKIr/b2GDmu57GQSkS5S
         wthWq75NGR+blJ93YKuNJWg4FguITz1Q/rD7h8n/P1gd9FM6dpWSCpNZ9HaXsKmCdrVd
         9pLgMVMmPGkZLk3Ct5AyQwD3ZVYc9eqYEU/YR6uTT2XE6M53MEW7YOEXWESjydZyTaKL
         jzgCBwnXHADtqG1gaO+kbPe4UQPbHCn/XALe7MfMdsTUx+9rdOafUrmszMXOg+U2vMdE
         5xLFqy/bdOuRv10dYxst64/QfcLK/FFSgKUSztffoiPidQH26Rd088YIh/qv7+YiJRSf
         M71A==
X-Original-Authentication-Results: mx.google.com;       spf=pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.112 as permitted sender) smtp.mailfrom=borntraeger@de.ibm.com
X-Gm-Message-State: AG10YOTtOktcJcub00BuNMKjn0Ptj9mkUD5Fz66jrk7MVs65N7YK4xVi9AJDyJlAMQnXEhEkA6brDV6zn8OpLlVWRnmZ1jt+adgOERgHIDb9ZWoEtEeOsCGvnNAaw7GI6ExsMBIoE4uQ13tclkeCis4NjPKYITN+7/ZQ8p9b3o8lpnqzWIpEd2G1wDrfveyRL6hWHA==
X-Received: by 10.28.175.209 with SMTP id y200mr28019284wme.70.1453889384329;
        Wed, 27 Jan 2016 02:09:44 -0800 (PST)
X-Received: by 10.28.175.209 with SMTP id y200mr28019193wme.70.1453889383334;
        Wed, 27 Jan 2016 02:09:43 -0800 (PST)
Received: from e06smtp16.uk.ibm.com (e06smtp16.uk.ibm.com. [195.75.94.112])
        by mx.google.com with ESMTPS id a11si11251052wmi.4.2016.01.27.02.09.43
        for <akpm@linux-foundation.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 27 Jan 2016 02:09:43 -0800 (PST)
Received-SPF: pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.112 as permitted sender) client-ip=195.75.94.112;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.112 as permitted sender) smtp.mailfrom=borntraeger@de.ibm.com
Received: from localhost
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <akpm@linux-foundation.org> from <borntraeger@de.ibm.com>;
	Wed, 27 Jan 2016 10:09:42 -0000
Received: from d06dlp02.portsmouth.uk.ibm.com (9.149.20.14)
	by e06smtp16.uk.ibm.com (192.168.101.146) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
	Wed, 27 Jan 2016 10:09:40 -0000
X-IBM-Helo: d06dlp02.portsmouth.uk.ibm.com
X-IBM-MailFrom: borntraeger@de.ibm.com
X-IBM-RcptTo: akpm@linux-foundation.org
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1F1102190066
	for <akpm@linux-foundation.org>; Wed, 27 Jan 2016 10:09:27 +0000 (GMT)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0RA9dMa36765696
	for <akpm@linux-foundation.org>; Wed, 27 Jan 2016 10:09:39 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0RA9cCO030236
	for <akpm@linux-foundation.org>; Wed, 27 Jan 2016 03:09:39 -0700
Received: from tuxmaker.boeblingen.de.ibm.com (tuxmaker.boeblingen.de.ibm.com [9.152.85.9])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u0RA9cYF030218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 27 Jan 2016 03:09:38 -0700
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
	id 7C79420F20B; Wed, 27 Jan 2016 11:09:38 +0100 (CET)
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, davej@codemonkey.org.uk,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: s390: query dynamic DEBUG_PAGEALLOC setting
Date: Wed, 27 Jan 2016 11:10:01 +0100
Message-Id: <1453889401-43496-4-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.3.0
In-Reply-To: <1453889401-43496-1-git-send-email-borntraeger@de.ibm.com>
References: <1453889401-43496-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 16012710-0025-0000-0000-000008BCB4D0
Delivered-To: akpm@linux-foundation.org

We can use debug_pagealloc_enabled() to check if we can map
the identity mapping with 1MB/2GB pages as well as to print
the current setting in dump_stack.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/dumpstack.c |  6 +++---
 arch/s390/mm/vmem.c          | 10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index dc8e204..e57eb22 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/kdebug.h>
 #include <linux/ptrace.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <asm/processor.h>
@@ -185,9 +186,8 @@ void die(struct pt_regs *regs, const char *str)
 #ifdef CONFIG_SMP
 	printk("SMP ");
 #endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
+	if (debug_pagealloc_enabled())
+		printk("DEBUG_PAGEALLOC");
 	printk("\n");
 	notify_die(DIE_OOPS, str, regs, 0, regs->int_code & 0xffff, SIGSEGV);
 	print_modules();
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index ef7d6c8..d27fccba 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -94,16 +94,15 @@ static int vmem_add_mem(unsigned long start, unsigned long size, int ro)
 			pgd_populate(&init_mm, pg_dir, pu_dir);
 		}
 		pu_dir = pud_offset(pg_dir, address);
-#ifndef CONFIG_DEBUG_PAGEALLOC
 		if (MACHINE_HAS_EDAT2 && pud_none(*pu_dir) && address &&
-		    !(address & ~PUD_MASK) && (address + PUD_SIZE <= end)) {
+		    !(address & ~PUD_MASK) && (address + PUD_SIZE <= end) &&
+		     !debug_pagealloc_enabled()) {
 			pud_val(*pu_dir) = __pa(address) |
 				_REGION_ENTRY_TYPE_R3 | _REGION3_ENTRY_LARGE |
 				(ro ? _REGION_ENTRY_PROTECT : 0);
 			address += PUD_SIZE;
 			continue;
 		}
-#endif
 		if (pud_none(*pu_dir)) {
 			pm_dir = vmem_pmd_alloc();
 			if (!pm_dir)
@@ -111,9 +110,9 @@ static int vmem_add_mem(unsigned long start, unsigned long size, int ro)
 			pud_populate(&init_mm, pu_dir, pm_dir);
 		}
 		pm_dir = pmd_offset(pu_dir, address);
-#ifndef CONFIG_DEBUG_PAGEALLOC
 		if (MACHINE_HAS_EDAT1 && pmd_none(*pm_dir) && address &&
-		    !(address & ~PMD_MASK) && (address + PMD_SIZE <= end)) {
+		    !(address & ~PMD_MASK) && (address + PMD_SIZE <= end) &&
+		    !debug_pagealloc_enabled()) {
 			pmd_val(*pm_dir) = __pa(address) |
 				_SEGMENT_ENTRY | _SEGMENT_ENTRY_LARGE |
 				_SEGMENT_ENTRY_YOUNG |
@@ -121,7 +120,6 @@ static int vmem_add_mem(unsigned long start, unsigned long size, int ro)
 			address += PMD_SIZE;
 			continue;
 		}
-#endif
 		if (pmd_none(*pm_dir)) {
 			pt_dir = vmem_pte_alloc(address);
 			if (!pt_dir)
-- 
2.3.0

Patches currently in -mm which might be from borntraeger@de.ibm.com are

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch


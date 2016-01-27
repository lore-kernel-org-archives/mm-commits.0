From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-query-dynamic-debug_pagealloc-setting.patch
 removed from -mm tree
Date: Wed, 27 Jan 2016 11:50:36 -0800
Message-ID: <56a91f8c.tX6ankfZlza80WOU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966795AbcA0Tug (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:50:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     x86-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Return-Path: <borntraeger@de.ibm.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00 autolearn=ham
	version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id u0RABO2k001215
	for <akpm@localhost>; Wed, 27 Jan 2016 02:11:24 -0800
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Wed, 27 Jan 2016 02:11:24 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id 73978EC4
	for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 10:09:45 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id A726A10C
	for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 10:09:44 +0000 (UTC)
Received: by mail-wm0-f51.google.com with SMTP id n5so18400348wmn.0
        for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 02:09:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-original-authentication-results:x-gm-message-state:from:to:cc
         :subject:date:message-id:in-reply-to:references:delivered-to;
        bh=WkUbXpR8gFdujYGRePOlJVHn9D+HHG/oW5GrnuHGyjE=;
        b=IXTFenwd2yitRinnLNEn1WePQ/cZWAh3Gn3HUXXqFf8NK+1GS54VXZH96yIVzaDr5b
         rlRJTDCXXQrn+fPASHWZrvNLTdpnANZeIxMhlHstM/gCji7JqrRQBC1LNn8Cp4D6Ib5f
         yaLG1uSrhU24CtBvooXPBQA+sBnxNqy/WhBOtlssgVeLsLvgFRtMy0j2JpNQtXL6tv3/
         YfQ7JfrO8VUJhNJ2QAvc9xJ7MTzemNfk+O/6diZ/ES1TfP7Pxf8psriZ7EHmk2h/LDBR
         iZfV4uU7ZaHDUze3yNxZbaJDood+wRmVyrQy92ZTXRJn+UXq55t3C+AqQNt0EcoLBEBR
         JHHQ==
X-Original-Authentication-Results: mx.google.com;       spf=pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.102 as permitted sender) smtp.mailfrom=borntraeger@de.ibm.com
X-Gm-Message-State: AG10YOQlK4QfrCWk8v0VIzsyreqkn9kJptpKedBqhzhTZRC5CX4lpk7JGqYqYzzDAPkQB+1U3l1ZpTk5MG2aKyvzXHZjCo0VlmfEECB9r0UeApU131iyuQLe1tJ4k4c9/fpbcmkAm+tLflcZeuxZGdm082jW5bgmNkHWu4hm/593Aeow5jUMLV0YJc1OdPYroZ2dJw==
X-Received: by 10.28.57.214 with SMTP id g205mr28223177wma.20.1453889383436;
        Wed, 27 Jan 2016 02:09:43 -0800 (PST)
X-Received: by 10.28.57.214 with SMTP id g205mr28223130wma.20.1453889382879;
        Wed, 27 Jan 2016 02:09:42 -0800 (PST)
Received: from e06smtp06.uk.ibm.com (e06smtp06.uk.ibm.com. [195.75.94.102])
        by mx.google.com with ESMTPS id e2si11226833wmi.26.2016.01.27.02.09.42
        for <akpm@linux-foundation.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 27 Jan 2016 02:09:42 -0800 (PST)
Received-SPF: pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.102 as permitted sender) client-ip=195.75.94.102;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.102 as permitted sender) smtp.mailfrom=borntraeger@de.ibm.com
Received: from localhost
	by e06smtp06.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <akpm@linux-foundation.org> from <borntraeger@de.ibm.com>;
	Wed, 27 Jan 2016 10:09:42 -0000
Received: from d06dlp01.portsmouth.uk.ibm.com (9.149.20.13)
	by e06smtp06.uk.ibm.com (192.168.101.136) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
	Wed, 27 Jan 2016 10:09:40 -0000
X-IBM-Helo: d06dlp01.portsmouth.uk.ibm.com
X-IBM-MailFrom: borntraeger@de.ibm.com
X-IBM-RcptTo: akpm@linux-foundation.org
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id AE4FC17D8066
	for <akpm@linux-foundation.org>; Wed, 27 Jan 2016 10:09:48 +0000 (GMT)
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [9.149.37.248])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0RA9eAV1966346
	for <akpm@linux-foundation.org>; Wed, 27 Jan 2016 10:09:40 GMT
Received: from d06av07.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av07.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0RA9csv026602
	for <akpm@linux-foundation.org>; Wed, 27 Jan 2016 05:09:39 -0500
Received: from tuxmaker.boeblingen.de.ibm.com (tuxmaker.boeblingen.de.ibm.com [9.152.85.9])
	by d06av07.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u0RA9c0v026585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 27 Jan 2016 05:09:38 -0500
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
	id 5541120F20D; Wed, 27 Jan 2016 11:09:38 +0100 (CET)
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, davej@codemonkey.org.uk,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: x86: query dynamic DEBUG_PAGEALLOC setting
Date: Wed, 27 Jan 2016 11:10:00 +0100
Message-Id: <1453889401-43496-3-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.3.0
In-Reply-To: <1453889401-43496-1-git-send-email-borntraeger@de.ibm.com>
References: <1453889401-43496-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 16012710-0025-0000-0000-000005A8BC76
Delivered-To: akpm@linux-foundation.org

We can use debug_pagealloc_enabled() to check if we can map
the identity mapping with 2MB pages. We can also add the state
into the dump_stack output.

The patch does not touch the code for the 1GB pages, which ignored
CONFIG_DEBUG_PAGEALLOC. Do we need to fence this as well?

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/dumpstack.c |  5 ++---
 arch/x86/mm/init.c          |  7 ++++---
 arch/x86/mm/pageattr.c      | 14 ++++----------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 9c30acf..32e5699 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -265,9 +265,8 @@ int __die(const char *str, struct pt_regs *regs, long err)
 #ifdef CONFIG_SMP
 	printk("SMP ");
 #endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC ");
-#endif
+	if (debug_pagealloc_enabled())
+		printk("DEBUG_PAGEALLOC ");
 #ifdef CONFIG_KASAN
 	printk("KASAN");
 #endif
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 493f541..39823fd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -150,13 +150,14 @@ static int page_size_mask;
 
 static void __init probe_page_size_mask(void)
 {
-#if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
+#if !defined(CONFIG_KMEMCHECK)
 	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * For CONFIG_KMEMCHECK or pagealloc debugging, identity mapping will
+	 * use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
 	 * large pages into small in interrupt context, etc.
 	 */
-	if (cpu_has_pse)
+	if (cpu_has_pse && !debug_pagealloc_enabled())
 		page_size_mask |= 1 << PG_LEVEL_2M;
 #endif
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index fc6a4c8..5f68987 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -106,12 +106,6 @@ static inline unsigned long highmap_end_pfn(void)
 
 #endif
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-# define debug_pagealloc 1
-#else
-# define debug_pagealloc 0
-#endif
-
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -708,10 +702,10 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 {
 	struct page *base;
 
-	if (!debug_pagealloc)
+	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
 	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
-	if (!debug_pagealloc)
+	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
 	if (!base)
 		return -ENOMEM;
@@ -1331,10 +1325,10 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		if (!debug_pagealloc)
+		if (!debug_pagealloc_enabled())
 			spin_lock(&cpa_lock);
 		ret = __change_page_attr(cpa, checkalias);
-		if (!debug_pagealloc)
+		if (!debug_pagealloc_enabled())
 			spin_unlock(&cpa_lock);
 		if (ret)
 			return ret;
-- 
2.3.0

Patches currently in -mm which might be from borntraeger@de.ibm.com are

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch
s390-query-dynamic-debug_pagealloc-setting.patch


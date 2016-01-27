From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch
 removed from -mm tree
Date: Wed, 27 Jan 2016 11:50:35 -0800
Message-ID: <56a91f8b.xt+S9ay1haAdzFsi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966109AbcA0Tuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: provide debug_pagealloc_enabled() without CONFIG_DEBUG_PAGEALLOC
has been removed from the -mm tree.  Its filename was
     mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Return-Path: <borntraeger@de.ibm.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00 autolearn=ham
	version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id u0RABO2l001215
	for <akpm@localhost>; Wed, 27 Jan 2016 02:11:24 -0800
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Wed, 27 Jan 2016 02:11:24 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id A719EEC4
	for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 10:09:45 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id ED893117
	for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 10:09:44 +0000 (UTC)
Received: by mail-wm0-f46.google.com with SMTP id l65so138403330wmf.1
        for <akpm@mail.linuxfoundation.org>; Wed, 27 Jan 2016 02:09:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-original-authentication-results:x-gm-message-state:from:to:cc
         :subject:date:message-id:in-reply-to:references:delivered-to;
        bh=qx162xdcG2w2Ht64bLS1WPFp7XGI5eo58/h6o0xtLIM=;
        b=JPj90JKhsLE+DHjQUcI28WFQhwRfcO7frFbVV+v3rXyp4lzH8nenaHhFd3MHx+jWrA
         goIi+rCzGgdXxnXhXe1Ir8DUYYuqNPPMpTmj1J2jnmZFKt2rDfbCMJ2IQNUfSOJ6PDhf
         9mRgGyf8vO9/+G/bftM5ouqbKU7ZDIdDwOt4pNlzYGb5QZG+zpEl6qnvKMQuC4RpS/uo
         xLux+baGdG+izaWp8th5ietOF8eOWrf1ndil32uLXWwvUPU1cN36dKhFcxduxhxF1Rmi
         n3Zt58nAtbspACbZKa5Da6WMiLNc9onriEWzUQoO+4y1cjxVvq/GB0uXJFkE64h3tb0J
         Jz1Q==
X-Original-Authentication-Results: mx.google.com;       spf=pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.105 as permitted sender) smtp.mailfrom=borntraeger@de.ibm.com
X-Gm-Message-State: AG10YOSpkfDKQxyObrG2jetyEkHUwZXaUz4do1evCk/N5Bwia814qftYbOkh105ltl9SQiXAgw0JRzI3CRGSXIuq8xz9NJIu2jFxOxdmQyPf8Qkpp1yWZkwVVCq2QjsBf3HX5LiHT64YINxkwaKaUiT7fl8fZiaX8Ens7jTCBxjc9rf6RmeP8b+ycyUsAWFM56SIMw==
X-Received: by 10.28.0.132 with SMTP id 126mr31020204wma.67.1453889383838;
        Wed, 27 Jan 2016 02:09:43 -0800 (PST)
X-Received: by 10.28.0.132 with SMTP id 126mr31020141wma.67.1453889383258;
        Wed, 27 Jan 2016 02:09:43 -0800 (PST)
Received: from e06smtp09.uk.ibm.com (e06smtp09.uk.ibm.com. [195.75.94.105])
        by mx.google.com with ESMTPS id g65si10087996wma.77.2016.01.27.02.09.43
        for <akpm@linux-foundation.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 27 Jan 2016 02:09:43 -0800 (PST)
Received-SPF: pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.105 as permitted sender) client-ip=195.75.94.105;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of borntraeger@de.ibm.com designates 195.75.94.105 as permitted sender) smtp.mailfrom=borntraeger@de.ibm.com
Received: from localhost
	by e06smtp09.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <akpm@linux-foundation.org> from <borntraeger@de.ibm.com>;
	Wed, 27 Jan 2016 10:09:42 -0000
Received: from d06dlp02.portsmouth.uk.ibm.com (9.149.20.14)
	by e06smtp09.uk.ibm.com (192.168.101.139) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
	Wed, 27 Jan 2016 10:09:39 -0000
X-IBM-Helo: d06dlp02.portsmouth.uk.ibm.com
X-IBM-MailFrom: borntraeger@de.ibm.com
X-IBM-RcptTo: davej@codemonkey.org.uk;davem@davemloft.net;x86@kernel.org;linux-mm@kvack.org;iamjoonsoo.kim@lge.com;akpm@linux-foundation.org;linuxppc-dev@lists.ozlabs.org;linux-arch@vger.kernel.org;linux-kernel@vger.kernel.org;linux-s390@vger.kernel.org
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 142CB219005E;
	Wed, 27 Jan 2016 10:09:26 +0000 (GMT)
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0RA9cJL4850114;
	Wed, 27 Jan 2016 10:09:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8213152041;
	Wed, 27 Jan 2016 09:08:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 70C4252036;
	Wed, 27 Jan 2016 09:08:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
	id 29AC820F20C; Wed, 27 Jan 2016 11:09:38 +0100 (CET)
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, davej@codemonkey.org.uk,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: mm: provide debug_pagealloc_enabled() without CONFIG_DEBUG_PAGEALLOC
Date: Wed, 27 Jan 2016 11:09:59 +0100
Message-Id: <1453889401-43496-2-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.3.0
In-Reply-To: <1453889401-43496-1-git-send-email-borntraeger@de.ibm.com>
References: <1453889401-43496-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 16012710-0037-0000-0000-00000564C878
Delivered-To: akpm@linux-foundation.org

We can provide debug_pagealloc_enabled() also if CONFIG_DEBUG_PAGEALLOC
is not set. It will return false in that case.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/mm.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f1cd22f..ae84716 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2194,13 +2194,18 @@ kernel_map_pages(struct page *page, int numpages, int enable)
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
-#else
+#else  /* CONFIG_DEBUG_PAGEALLOC */
+static inline bool debug_pagealloc_enabled(void)
+{
+	return false;
+}
+
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif /* CONFIG_HIBERNATION */
-#endif
+#endif /* CONFIG_DEBUG_PAGEALLOC */
 
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
-- 
2.3.0

Patches currently in -mm which might be from borntraeger@de.ibm.com are

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch
x86-query-dynamic-debug_pagealloc-setting.patch
s390-query-dynamic-debug_pagealloc-setting.patch


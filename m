From: akpm@linux-foundation.org
Subject: [to-be-updated]
 x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-fix.patch removed from -mm tree
Date: Thu, 17 Apr 2014 11:57:05 -0700
Message-ID: <53502401.J3N4KStOdc76pSWW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDQS5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 14:57:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: [to-be-updated] x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-fix.patch removed from -mm tree
To: mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 11:57:05 -0700


The patch titled
     Subject: Re: linux-next: build failure after merge of the akpm-current tree
has been removed from the -mm tree.  Its filename was
     x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Return-Path: <mgorman@suse.de>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.5 tests=BAYES_00 autolearn=ham
	version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id s3H9vUuq004794
	for <akpm@localhost>; Thu, 17 Apr 2014 02:57:30 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Thu, 17 Apr 2014 02:57:30 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTP id BEE7B87D
	for <akpm@mail.linuxfoundation.org>; Thu, 17 Apr 2014 09:56:40 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-ee0-f48.google.com (mail-ee0-f48.google.com [74.125.83.48])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id D113C1FD42
	for <akpm@mail.linuxfoundation.org>; Thu, 17 Apr 2014 09:56:39 +0000 (UTC)
Received: by mail-ee0-f48.google.com with SMTP id b57so442626eek.35
        for <akpm@mail.linuxfoundation.org>; Thu, 17 Apr 2014 02:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-original-authentication-results:x-gm-message-state:date:from:to
         :cc:subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:delivered-to;
        bh=lTVhKOKsKHZzZEwrDAURTksOoTtrteI+Z9+00hkWivo=;
        b=Cezt3qOwm0++NPDCpCDXxu37XWrnN3fA8YQiEHqZuDWw2zfT53oYfgLE1kJ7dAfO1D
         eYY/fz03CIw9M1IzOsmEH2tZx8zWyQ7oa9q20qUduZJv92klQDr57HSGIe4LPA89JOZy
         AbWGzR0hUaq2Z/ceDZvCFYt2ADZfrutqUyEAqUMFa14bgjp9S4HUaAa0egrzkqRWQOzj
         3bgL6BMsmiK51thWfo4WnDsK2Rdal+kkFoRv+HACrQcuhWt8ZvlOVGjHxcAzHs7yd6Ky
         a39DUzPJFOSdEyLYZ3RbbC26oyUyhT9qSnxlJbSwhBRB68sPG04NFdv0sm4MaqNPVf+d
         U0+A==
X-Original-Authentication-Results: mx.google.com;       spf=pass (google.com: best guess record for domain of mgorman@suse.de designates 195.135.220.15 as permitted sender) smtp.mail=mgorman@suse.de
X-Received: by 10.14.115.195 with SMTP id e43mr2064992eeh.76.1397728597930;
        Thu, 17 Apr 2014 02:56:37 -0700 (PDT)
X-Gm-Message-State: ALoCoQnoJQ1F40UewiZ4rSOSagTmyi5DULp+BZwOhNlafTr56ukNNxqV9hycpYIG/koAYuMXtOmwOGhVnODb/ochngNBfS5P7GpsClXVXl02jAw+QK0SnlbyfGTkK184x0PB3OjojRPyeb/8WieH4voaAhAemtpzCA==
X-Received: by 10.14.115.195 with SMTP id e43mr2064938eeh.76.1397728597308;
        Thu, 17 Apr 2014 02:56:37 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de. [195.135.220.15])
        by mx.google.com with ESMTPS id u5si34543024een.173.2014.04.17.02.56.36
        for <akpm@linux-foundation.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 17 Apr 2014 02:56:36 -0700 (PDT)
Received-SPF: pass (google.com: best guess record for domain of mgorman@suse.de designates 195.135.220.15 as permitted sender) client-ip=195.135.220.15;
Authentication-Results: mx.google.com;
       spf=pass (google.com: best guess record for domain of mgorman@suse.de designates 195.135.220.15 as permitted sender) smtp.mail=mgorman@suse.de
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 074ACACF0;
	Thu, 17 Apr 2014 09:56:34 +0000 (UTC)
Date: Thu, 17 Apr 2014 10:56:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140417095630.GA7292@suse.de>
References: <20140417170831.53f065b7aa4ff04d30a79469@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140417170831.53f065b7aa4ff04d30a79469@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Delivered-To: akpm@linux-foundation.org

On Thu, Apr 17, 2014 at 05:08:31PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> In file included from mm/shmem.c:61:0:
> include/linux/swapops.h: In function 'is_swap_pte':
> include/linux/swapops.h:57:2: error: implicit declaration of function 'pte_present_nonuma' [-Werror=implicit-function-declaration]
> 
> And a couple more similar.
> 
> Caused by commit 851fe3337768 ("x86: define _PAGE_NUMA by reusing
> software bits on the PMD and PTE levels").
> 
> I have reverted this commit (and 7cb1c1eb682e "x86: define _PAGE_NUMA by
> reusing software bits on the PMD and PTE levels -fix") for today and
> wonder how many other architectures would be broken by this?  Everything
> else with CONFIG_MMU set?
> 

/me slaps self

Andrew, can you replace the broken fix with this version please?

---8<---
x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix

powerpc has NUMA_BALANCING and non-NUMA_BALANCING versions of pte_present
and I missed that when testing cross-compiling. This patch replaces
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/powerpc/include/asm/pgtable.h | 1 +
 arch/x86/include/asm/pgtable.h     | 1 +
 include/asm-generic/pgtable.h      | 4 ++++
 3 files changed, 6 insertions(+)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index cdf6679..d98c1ec 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -44,6 +44,7 @@ static inline int pte_present(pte_t pte)
 	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t pte)
 {
 	return pte_val(pte) & (_PAGE_PRESENT);
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 611dd32..d772c9c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -452,6 +452,7 @@ static inline int pte_present(pte_t a)
 			       _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t a)
 {
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index d2b92be..8916a76 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -220,6 +220,10 @@ static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
 # define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
 
+#ifndef pte_present_nonuma
+#define pte_present_nonuma(pte) pte_present(pte)
+#endif
+
 #ifndef flush_tlb_fix_spurious_fault
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif

Patches currently in -mm which might be from mgorman@suse.de are

mm-use-paravirt-friendly-ops-for-numa-hinting-ptes.patch
thp-close-race-between-split-and-zap-huge-pages.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch


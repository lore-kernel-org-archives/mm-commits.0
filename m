Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5C6C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432AF2054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196288;
	bh=AV6szoKFlequhBGLeWynr5ZTWNB/meukXNG43J1KeYs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Fi2hgIZ+/gQp24gWB3xrrJnRYjZPnFbeoSSEbjp0tboXzjytwD6VcFRYDyWKhOuXj
	 601Keq9vqks50IBbS5rU7Odigj0Es/zX9gezKM0o2bq8vr14cZ0TxdWYRP6Otsw/8l
	 apR8Ix4iKpHxLW/uUtk/fXDjAoM2/itQFXorRu2U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgHLBiI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBiH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E0B420658;
        Wed, 12 Aug 2020 01:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196287;
        bh=AV6szoKFlequhBGLeWynr5ZTWNB/meukXNG43J1KeYs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iRXuBQMjXITjrRmF/iek7WjtrtgLk3EaI8GUwTVAsSFo+y92G984VIN1nGKn+QuK8
         IfsHE4o2TTQcSmIDyeUNKmSrG6bZ6+32aGW2858HHy1YlnMwiySVBuiEvRVWGvmVTV
         Tnr6v/F9zv5TQ10LKhoivDoKUFOCC3+MJ6WfvLUM=
Date:   Tue, 11 Aug 2020 18:38:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 148/165] mm/ia64: use general page fault
 accounting
Message-ID: <20200812013806.ks7j7fxnL%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/ia64: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-9-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/fault.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/ia64/mm/fault.c~mm-ia64-use-general-page-fault-accounting
+++ a/arch/ia64/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/kdebug.h>
 #include <linux/prefetch.h>
 #include <linux/uaccess.h>
+#include <linux/perf_event.h>
 
 #include <asm/processor.h>
 #include <asm/exception.h>
@@ -105,6 +106,8 @@ ia64_do_page_fault (unsigned long addres
 		flags |= FAULT_FLAG_USER;
 	if (mask & VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 
@@ -143,7 +146,7 @@ retry:
 	 * sure we exit gracefully rather than endlessly redo the
 	 * fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -166,10 +169,6 @@ retry:
 	}
 
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7DBC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E82822076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196332;
	bh=PbmDYg/hGBueHackNRwqncJFDA/V9g+beDI/2t+zErw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0ZNhVrl6Qovt3c4QUnq/HjRyqK5qRjRuv1DBWPwDMSYYi/Gnqu5Yct5O49N/6UUFV
	 NgbYQUeupF81lf+EpMHlNrypNPx6rrt9TicUnp61dtV9Y6LA4nPhC0GUcM/T80/2Oc
	 RWPMBP3t3VtJRA60wOfJfnRoSM/DbfJaUpW4DL64=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBiv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBiv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C01F2054F;
        Wed, 12 Aug 2020 01:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196331;
        bh=PbmDYg/hGBueHackNRwqncJFDA/V9g+beDI/2t+zErw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gAI7bj898HSw/o0hAvl7Kc+kcubAmHRG7B3BT4rW+5jXc41MfmQTSyMdOWCOZdOlZ
         GFJKDpwM7sYbwg+kKHxXTTIIAqaBTI5uccAoTSDQ+3wavbDEzLjjaMkmKlQvJ1vzO7
         Sw965wJEkMlgDyaQINEdRZ1qYS0k3ADcDrcY0W3Y=
Date:   Tue, 11 Aug 2020 18:38:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, linux-mm@kvack.org,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 162/165] mm/x86: use general page fault accounting
Message-ID: <20200812013849.rLqbGyXIq%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-23-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/arch/x86/mm/fault.c~mm-x86-use-general-page-fault-accounting
+++ a/arch/x86/mm/fault.c
@@ -1139,7 +1139,7 @@ void do_user_addr_fault(struct pt_regs *
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct mm_struct *mm;
-	vm_fault_t fault, major = 0;
+	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
@@ -1291,8 +1291,7 @@ good_area:
 	 * userland). The return to userland is identified whenever
 	 * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are both set in flags.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
-	major |= fault & VM_FAULT_MAJOR;
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
@@ -1319,18 +1318,6 @@ good_area:
 		return;
 	}
 
-	/*
-	 * Major/minor page fault accounting. If any of the events
-	 * returned VM_FAULT_MAJOR, we account it as a major fault.
-	 */
-	if (major) {
-		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
-	} else {
-		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
-	}
-
 	check_v8086_mode(regs, address, tsk);
 }
 NOKPROBE_SYMBOL(do_user_addr_fault);
_

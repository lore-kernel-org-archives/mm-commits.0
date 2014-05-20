From: akpm@linux-foundation.org
Subject: +
 hwpoison-remove-unused-global-variable-in-do_machine_check.patch added to
 -mm tree
Date: Tue, 20 May 2014 15:13:14 -0700
Message-ID: <537bd37a.ng4s6qBMTCunlbgo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaETWNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 May 2014 18:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, n-horiguchi@ah.jp.nec.com, mingo@elte.hu, hpa@zytor.com, fengguang.wu@intel.com, andi@firstfloor.org, slaoub@gmail.com

Subject: + hwpoison-remove-unused-global-variable-in-do_machine_check.patch added to -mm tree
To: slaoub@gmail.com,andi@firstfloor.org,fengguang.wu@intel.com,hpa@zytor.com,mingo@elte.hu,n-horiguchi@ah.jp.nec.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 20 May 2014 15:13:14 -0700


The patch titled
     Subject: hwpoison: remove unused global variable in do_machine_check()
has been added to the -mm tree.  Its filename is
     hwpoison-remove-unused-global-variable-in-do_machine_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-remove-unused-global-variable-in-do_machine_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-remove-unused-global-variable-in-do_machine_check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: hwpoison: remove unused global variable in do_machine_check()

Remove an unused global variable mce_entry and relative operations in
do_machine_check().

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/mce.h       |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c |    5 -----
 2 files changed, 7 deletions(-)

diff -puN arch/x86/include/asm/mce.h~hwpoison-remove-unused-global-variable-in-do_machine_check arch/x86/include/asm/mce.h
--- a/arch/x86/include/asm/mce.h~hwpoison-remove-unused-global-variable-in-do_machine_check
+++ a/arch/x86/include/asm/mce.h
@@ -176,8 +176,6 @@ int mce_available(struct cpuinfo_x86 *c)
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
 
-extern atomic_t mce_entry;
-
 typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
 DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 
diff -puN arch/x86/kernel/cpu/mcheck/mce.c~hwpoison-remove-unused-global-variable-in-do_machine_check arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~hwpoison-remove-unused-global-variable-in-do_machine_check
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -60,8 +60,6 @@ static DEFINE_MUTEX(mce_chrdev_read_mute
 
 #define SPINUNIT 100	/* 100ns */
 
-atomic_t mce_entry;
-
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
 struct mce_bank *mce_banks __read_mostly;
@@ -1041,8 +1039,6 @@ void do_machine_check(struct pt_regs *re
 	DECLARE_BITMAP(valid_banks, MAX_NR_BANKS);
 	char *msg = "Unknown";
 
-	atomic_inc(&mce_entry);

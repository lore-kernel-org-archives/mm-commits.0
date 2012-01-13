From: akpm@linux-foundation.org
Subject: [merged] ia64-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:05 -0800
Message-ID: <20120113203205.9F98F1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36212 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075Ab2AMUcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:06 -0500
Received: by mail-yw0-f74.google.com with SMTP id j52so101798yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     ia64-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: ia64, exec: remove redundant set_fs(USER_DS)

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/processor.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/ia64/include/asm/processor.h~ia64-exec-remove-redundant-set_fsuser_ds arch/ia64/include/asm/processor.h
--- a/arch/ia64/include/asm/processor.h~ia64-exec-remove-redundant-set_fsuser_ds
+++ a/arch/ia64/include/asm/processor.h
@@ -309,7 +309,6 @@ struct thread_struct {
 }
 
 #define start_thread(regs,new_ip,new_sp) do {							\
-	set_fs(USER_DS);									\
 	regs->cr_ipsr = ((regs->cr_ipsr | (IA64_PSR_BITS_TO_SET | IA64_PSR_CPL))		\
 			 & ~(IA64_PSR_BITS_TO_CLEAR | IA64_PSR_RI | IA64_PSR_IS));		\
 	regs->cr_iip = new_ip;									\
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
arm-exec-remove-redundant-set_fsuser_ds.patch


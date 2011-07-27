From: akpm@linux-foundation.org
Subject: [merged] mn10300-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:27:52 -0700
Message-ID: <201107271926.p6RJQcMj003133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     mn10300, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     mn10300-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/processor.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/mn10300/include/asm/processor.h~mn10300-exec-remove-redundant-set_fsuser_ds arch/mn10300/include/asm/processor.h
--- a/arch/mn10300/include/asm/processor.h~mn10300-exec-remove-redundant-set_fsuser_ds
+++ a/arch/mn10300/include/asm/processor.h
@@ -127,7 +127,6 @@ static inline void start_thread(struct p
 {
 	struct thread_info *ti = current_thread_info();
 	struct pt_regs *frame0;
-	set_fs(USER_DS);
 
 	frame0 = thread_info_to_uregs(ti);
 	frame0->epsw = EPSW_nSL | EPSW_IE | EPSW_IM;
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
linux-next.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch


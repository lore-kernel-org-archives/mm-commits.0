From: akpm@linux-foundation.org
Subject: + remove-hardcoding-of-hard_smp_processor_id-on-up.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:26:22 -0800
Message-ID: <200703012326.l21NQMqp025736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161141AbXCAX1G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, ebiederm@xmission.com, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, jdike@addtoit.com, paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com, takata@linux-m32r.org, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     Remove hardcoding of hard_smp_processor_id on UP systems
has been added to the -mm tree.  Its filename is
     remove-hardcoding-of-hard_smp_processor_id-on-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove hardcoding of hard_smp_processor_id on UP systems
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

With the advent of kdump, the assumption that the boot CPU when booting an UP
kernel is always the CPU with a hardware ID of 0 (usually referred to as BSP
on some architectures) is not valid anymore.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Andi Kleen <ak@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    1 -
 1 files changed, 1 deletion(-)

diff -puN include/linux/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/linux/smp.h
--- a/include/linux/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/linux/smp.h
@@ -83,7 +83,6 @@ void smp_prepare_boot_cpu(void);
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-#define hard_smp_processor_id()			0
 static inline int up_smp_call_function(void)
 {
 	return 0;
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch

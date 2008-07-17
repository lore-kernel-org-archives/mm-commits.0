From: akpm@linux-foundation.org
Subject: + kvm-fix-build-error-of-arch-ia64-kvm.patch added to -mm tree
Date: Thu, 17 Jul 2008 14:20:26 -0700
Message-ID: <200807172120.m6HLKQC5006847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386AbYGQVUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 17:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, avi@qumranet.com, tony.luck@intel.com, xiantao.zhang@intel.com


The patch titled
     kvm: fix build error of arch/ia64/kvm/*
has been added to the -mm tree.  Its filename is
     kvm-fix-build-error-of-arch-ia64-kvm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: fix build error of arch/ia64/kvm/*
From: Takashi Iwai <tiwai@suse.de>

Fix calls of smp_call_function*() in arch/ia64/kvm for recent API
changes.

    CC [M]  arch/ia64/kvm/kvm-ia64.o
  arch/ia64/kvm/kvm-ia64.c: In function 'handle_global_purge':
  arch/ia64/kvm/kvm-ia64.c:398: error: too many arguments to function 'smp_call_function_single'
  arch/ia64/kvm/kvm-ia64.c: In function 'kvm_vcpu_kick':
  arch/ia64/kvm/kvm-ia64.c:1696: error: too many arguments to function 'smp_call_function_single'

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kvm/kvm-ia64.c |    4 ++--
 arch/ia64/kvm/kvm_fw.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kvm/kvm-ia64.c~kvm-fix-build-error-of-arch-ia64-kvm arch/ia64/kvm/kvm-ia64.c
--- a/arch/ia64/kvm/kvm-ia64.c~kvm-fix-build-error-of-arch-ia64-kvm
+++ a/arch/ia64/kvm/kvm-ia64.c
@@ -398,7 +398,7 @@ static int handle_global_purge(struct kv
 		if (kvm->vcpus[i]->cpu != -1) {
 			call_data.vcpu = kvm->vcpus[i];
 			smp_call_function_single(kvm->vcpus[i]->cpu,
-					vcpu_global_purge, &call_data, 0, 1);
+					vcpu_global_purge, &call_data, 1);
 		} else
 			printk(KERN_WARNING"kvm: Uninit vcpu received ipi!\n");
 
@@ -1691,7 +1691,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu
 		wake_up_interruptible(&vcpu->wq);
 
 	if (vcpu->guest_mode)
-		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
+		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
 }
 
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig)
diff -puN arch/ia64/kvm/kvm_fw.c~kvm-fix-build-error-of-arch-ia64-kvm arch/ia64/kvm/kvm_fw.c
--- a/arch/ia64/kvm/kvm_fw.c~kvm-fix-build-error-of-arch-ia64-kvm
+++ a/arch/ia64/kvm/kvm_fw.c
@@ -130,7 +130,7 @@ static struct ia64_pal_retval pal_cache_
 	args.cache_type = gr29;
 	args.operation = gr30;
 	smp_call_function(remote_pal_cache_flush,
-				(void *)&args, 1, 1);
+				(void *)&args, 1);
 	if (args.status != 0)
 		printk(KERN_ERR"pal_cache_flush error!,"
 				"status:0x%lx\n", args.status);
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
use-sysdev_class-in-schedc.patch
use-sysdev_class-in-schedc-fix.patch
kcalloc-remove-runtime-division.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
kvm-fix-build-error-of-arch-ia64-kvm.patch


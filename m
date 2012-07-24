From: akpm@linux-foundation.org
Subject: + ppc-e500_tlb-memset-clears-nothing.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:00:53 -0700
Message-ID: <20120724210054.4164420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:65132 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2GXVA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:00:57 -0400
Received: by bkcjc3 with SMTP id jc3so295bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:00:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, agraf@suse.de, avi@redhat.com, benh@kernel.crashing.org, dcb314@hotmail.com, mtosatti@redhat.com, paulus@samba.org


The patch titled
     Subject: ppc: e500_tlb memset clears nothing
has been added to the -mm tree.  Its filename is
     ppc-e500_tlb-memset-clears-nothing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: ppc: e500_tlb memset clears nothing

Put the parameters the right way around

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44031

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/e500_tlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kvm/e500_tlb.c~ppc-e500_tlb-memset-clears-nothing arch/powerpc/kvm/e500_tlb.c
--- a/arch/powerpc/kvm/e500_tlb.c~ppc-e500_tlb-memset-clears-nothing
+++ a/arch/powerpc/kvm/e500_tlb.c
@@ -322,11 +322,11 @@ static inline void kvmppc_e500_ref_relea
 static void clear_tlb1_bitmap(struct kvmppc_vcpu_e500 *vcpu_e500)
 {
 	if (vcpu_e500->g2h_tlb1_map)
-		memset(vcpu_e500->g2h_tlb1_map,
-		       sizeof(u64) * vcpu_e500->gtlb_params[1].entries, 0);
+		memset(vcpu_e500->g2h_tlb1_map, 0,
+		       sizeof(u64) * vcpu_e500->gtlb_params[1].entries);
 	if (vcpu_e500->h2g_tlb1_rmap)
-		memset(vcpu_e500->h2g_tlb1_rmap,
-		       sizeof(unsigned int) * host_tlb_params[1].entries, 0);
+		memset(vcpu_e500->h2g_tlb1_rmap, 0,
+		       sizeof(unsigned int) * host_tlb_params[1].entries);
 }
 
 static void clear_tlb_privs(struct kvmppc_vcpu_e500 *vcpu_e500)
_
Subject: Subject: ppc: e500_tlb memset clears nothing

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch
drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch


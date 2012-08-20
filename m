From: akpm@linux-foundation.org
Subject: [merged] ppc-e500_tlb-memset-clears-nothing.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:17 -0700
Message-ID: <20120820195618.3B91E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43787 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HTT4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:21 -0400
Received: by eaac1 with SMTP id c1so310335eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, agraf@suse.de, avi@redhat.com, benh@kernel.crashing.org, dcb314@hotmail.com, mtosatti@redhat.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ppc: e500_tlb memset clears nothing
has been removed from the -mm tree.  Its filename was
     ppc-e500_tlb-memset-clears-nothing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -320,11 +320,11 @@ static inline void kvmppc_e500_ref_relea
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

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch


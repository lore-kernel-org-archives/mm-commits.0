From: akpm@linux-foundation.org
Subject: [folded-merged]
 treewide-remove-gfp_temporary-allocation-flag-fix.patch removed from -mm
 tree
Date: Wed, 13 Sep 2017 16:24:50 -0700
Message-ID: <59b9be42.FttRixQcf92IEL0C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMXYw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mhocko@suse.com, neilb@suse.de, sfr@canb.auug.org.au, tytso@mit.edu, vbabka@suse.cz, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-remove-gfp_temporary-allocation-flag-fix
has been removed from the -mm tree.  Its filename was
     treewide-remove-gfp_temporary-allocation-flag-fix.patch

This patch was dropped because it was folded into treewide-remove-gfp_temporary-allocation-flag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: treewide-remove-gfp_temporary-allocation-flag-fix

fix typo

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/rtas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/rtas.c~treewide-remove-gfp_temporary-allocation-flag-fix arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~treewide-remove-gfp_temporary-allocation-flag-fix
+++ a/arch/powerpc/kernel/rtas.c
@@ -914,7 +914,7 @@ int rtas_online_cpus_mask(cpumask_var_t
 	if (ret) {
 		cpumask_var_t tmp_mask;
 
-		if (!alloc_cpumask_var(&tmp_mask, GFP_KENREL))
+		if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
 			return ret;
 
 		/* Use tmp_mask to preserve cpus mask from first failure */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch


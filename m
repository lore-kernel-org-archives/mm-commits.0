Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA37250F7;
	Thu, 18 Jan 2024 22:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616164; cv=none; b=hTSVos3sZoCDiP5hhahpB1lrONCKU7wFcsDBd4lLzEo2uDPWsFZPuxuXTSZQfhUZ8WmhoBYbzKvqyLlbkBwdjg1Gyk+l+aX3vxSp5sr8D6Pzfqir3QEVqfxUQ8RhOKFDAi7jEm5M0ZM30lfYGUX2YYMqOVhcxD3tJQz2dlg4VyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616164; c=relaxed/simple;
	bh=fPBSN2h/OREGese30qiHOxnuMYdC/808Xoqu9vd7y/w=;
	h=Date:To:From:Subject:Message-Id; b=mqCbMmibvgOpiNly2ZDh/LdxK81dgbXeEgklHbbo1IU1ooqUud1fDG5fJch+H04h4M4pPLYQTVsx9HhswVYcEsVJOqJv/dSsnaoloDruwEbroxVK4yzFacEl+9v548q6F4IS9kW1Y4YXsMieUSMlxI7DHIoM+usQw3JGNcA0ESE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wmq/3/jH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wmq/3/jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0601C433F1;
	Thu, 18 Jan 2024 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616163;
	bh=fPBSN2h/OREGese30qiHOxnuMYdC/808Xoqu9vd7y/w=;
	h=Date:To:From:Subject:From;
	b=wmq/3/jH2JsubIhEuk+DWIljpnvYa6qKdWoHIVllhh8B1mMbaSk/w22QAz6E8hV0N
	 NMgUDNWttfhlKgEJTqcm6WFQfxQzjfJ6urbR9poIXlZWSFMxL+N2wZlg5+Fnlqe7lC
	 FPYHviakag66N09YbKOvojS2Yvoxhhihr1+jtNiM=
Date: Thu, 18 Jan 2024 14:16:00 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,MPatlasov@parallels.com,zokeefe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch added to mm-hotfixes-unstable branch
Message-Id: <20240118221602.F0601C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again
Date: Thu, 18 Jan 2024 10:19:53 -0800

(struct dirty_throttle_control *)->thresh is an unsigned long, but is
passed as the u32 divisor argument to div_u64().  On architectures where
unsigned long is 64 bytes, the argument will be implicitly truncated.

Use div64_u64() instead of div_u64() so that the value used in the "is
this a safe division" check is the same as the divisor.

Also, remove redundant cast of the numerator to u64, as that should happen
implicitly.

This would be difficult to exploit in memcg domain, given the ratio-based
arithmetic domain_drity_limits() uses, but is much easier in global
writeback domain with a BDI_CAP_STRICTLIMIT-backing device, using e.g. 
vm.dirty_bytes=(1<<32)*PAGE_SIZE so that dtc->thresh == (1<<32)

Link: https://lkml.kernel.org/r/20240118181954.1415197-1-zokeefe@google.com
Fixes: f6789593d5ce ("mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Maxim Patlasov <MPatlasov@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again
+++ a/mm/page-writeback.c
@@ -1638,7 +1638,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch


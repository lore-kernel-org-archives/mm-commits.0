Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2D3BE65
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737380; cv=none; b=gVO4vQo8yRqQTzW5r0yZDccDTD2KkvJJ+SC0tn5VFJbEQIrtZXUuxE//qugygwJ7scVKao29RZFCDDxRIcfxypcub5/wWtTdQ7LXft0tExdOgoJ8fbyICwljTjuHcS7g5yTfMW28IA/QQu+uhb8MsiALLqcywVMuAkEJYkMy+hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737380; c=relaxed/simple;
	bh=3yAsT9EmA+CEndt7D7LXoSJMacYR4dyMt7QIoXmdMao=;
	h=Date:To:From:Subject:Message-Id; b=pj57lJAyy2Oj1EvQh7IFqfrPDU+1i9ggjyoc8Cj1+0QSxd+m00gPYTbbizUzZixD7dWz2a4wJqetT1B3k/JY6dTGZPtrhH0kwUenwE/X71RG+dROaAm3vzk3+1nGpwAJxfMjKu3I3Jhr38/xc4a0ab7iv/rY7L8uVFIti/DUYKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fas6gK/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fas6gK/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB83C43394;
	Sat, 24 Feb 2024 01:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708737380;
	bh=3yAsT9EmA+CEndt7D7LXoSJMacYR4dyMt7QIoXmdMao=;
	h=Date:To:From:Subject:From;
	b=fas6gK/tP7iMhUMMoJJMGltp2LHxraZNpSSRl1K6FB23QuJWtJ86+rf63z6nLhcnm
	 4z9o2cb6b2DR615UrghxfAvSWEjcBOpGM1sSU11pYijyGOkZ8xTYv9EjMIUcHEirBW
	 LMM8Nk2VGuDFNweslL7ftPCHX3FlGPX/bUhEFDzM=
Date: Fri, 23 Feb 2024 17:16:19 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,byungchul@sk.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch added to mm-unstable branch
Message-Id: <20240224011620.0CB83C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix
Date: Fri Feb 23 05:14:42 PM PST 2024

simplofy boolean expression, per ying.huang@intel.com

Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix
+++ a/mm/vmscan.c
@@ -2277,7 +2277,7 @@ static void prepare_scan_control(pg_data
 	 */
 	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
 	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE) &&
-	    !(sc->cache_trim_mode && !sc->reclaimable && sc->priority <= 1))
+	    (!sc->cache_trim_mode || sc->reclaimable || sc->priority > 1))
 		sc->cache_trim_mode = 1;
 	else
 		sc->cache_trim_mode = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch


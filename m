Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87261773D
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 01:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712192895; cv=none; b=L3Pc1jeO2odpnOvCokySHWKST1VUNfyvHi8U1gDiOmNnsBPm3QW7ezo1YvzJTsoww6kr7vHMgjf7OF8bn/nKEDTwg3K9NFgAA6SpKm+dQlM3NVco74FY1e6u4Blk1LA0DO3Ql7nHhmmgHvjQpsyMRLS2bwgCArCZqwTKZzXVydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712192895; c=relaxed/simple;
	bh=b30NAFSxHZ0uMmcX+/NJpzZG4WRJizvHKfTlhW7qnc0=;
	h=Date:To:From:Subject:Message-Id; b=T24TicyGCH2pxSff2IXEFgnCihNuliucnAdWv+xJvCf6oPIwCr/5uH2h+Zc2QiEw3ReJu73S395QiRdPqd4oTGotUKfJ5s9t9fs71nMDugXSs8b/jvdlVT+B7E1sB069dHi9GVkdH0/84oFwuFbqmgT+I+sEsrDj3VRV5REhhx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xtUHcMEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xtUHcMEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598BFC433C7;
	Thu,  4 Apr 2024 01:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712192895;
	bh=b30NAFSxHZ0uMmcX+/NJpzZG4WRJizvHKfTlhW7qnc0=;
	h=Date:To:From:Subject:From;
	b=xtUHcMEKSyDzJ47yfRa1OQ2CzA4GWWuP5Ul6GG2bK3j5UC6Ljy2hd3I9xjfLjT/DN
	 NppQr6a5pf2OfvX7zhH3RzpPaIg/2KZrZjCfPCu3EwhOpM6BXsnUhZiZ2PRqNNJnYy
	 HsrlPJLQ7KdLThNuQ7nHhLh0G1Me7E9sGRQpy0aA=
Date: Wed, 03 Apr 2024 18:08:14 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + __mod_memcg_lruvec_state-enhance-diagnostics.patch added to mm-unstable branch
Message-Id: <20240404010815.598BFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: __mod_memcg_lruvec_state(): enhance diagnostics
has been added to the -mm mm-unstable branch.  Its filename is
     __mod_memcg_lruvec_state-enhance-diagnostics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/__mod_memcg_lruvec_state-enhance-diagnostics.patch

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
Subject: __mod_memcg_lruvec_state(): enhance diagnostics
Date: Wed Apr  3 05:42:47 PM PDT 2024

sysbot reports a warning
(https://lkml.kernel.org/r/0000000000007545d00615188a03@google.com).  Add
additional info to perhaps help with this.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~__mod_memcg_lruvec_state-enhance-diagnostics
+++ a/mm/memcontrol.c
@@ -860,10 +860,12 @@ void __mod_memcg_lruvec_state(struct lru
 		case NR_ANON_THPS:
 		case NR_SHMEM_PMDMAPPED:
 		case NR_FILE_PMDMAPPED:
-			WARN_ON_ONCE(!in_task());
+			if (WARN_ON_ONCE(!in_task()))
+				pr_warn("stat item index: %d\n", idx);
 			break;
 		default:
-			VM_WARN_ON_IRQS_ENABLED();
+			if (VM_WARN_ON_IRQS_ENABLED())
+				pr_warn("stat item index: %d\n", idx);
 		}
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch


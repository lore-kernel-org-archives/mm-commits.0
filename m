Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1D97493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Um3Wup5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40A4C433C9;
	Mon, 11 Dec 2023 01:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257791;
	bh=qRS2qJtvdyIYjPFwLdjYxPTGcuqQC5h93CNZ3vNL1h0=;
	h=Date:To:From:Subject:From;
	b=Um3Wup5pThxgb55xcpX86ESUa9ClWWOR2naP4ScJ2MriwtGoi4IrCZkeaZUgGw1Gh
	 7t62z6aQbMMEABrBFUf1b2YF1mkphRsmv2idym2WK9OY19oswhKTxqlzDw+3sTN4FJ
	 aifxYZrkHy5Xnj/RIMUS1Cizgk2gEANqbNocbeI0=
Date: Sun, 10 Dec 2023 17:23:11 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-mm-mark-paging_init-as-static.patch removed from -mm tree
Message-Id: <20231211012311.B40A4C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: mm: mark paging_init() as static
has been removed from the -mm tree.  Its filename was
     hexagon-mm-mark-paging_init-as-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: mm: mark paging_init() as static
Date: Thu, 30 Nov 2023 15:58:15 -0700

Clang warns:

  arch/hexagon/mm/init.c:89:13: warning: no previous prototype for function 'paging_init' [-Wmissing-prototypes]
     89 | void __init paging_init(void)
        |             ^
  arch/hexagon/mm/init.c:89:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     89 | void __init paging_init(void)
        | ^
        | static

This function is only used within this translation unit, so mark it static
as suggested.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-2-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/hexagon/mm/init.c~hexagon-mm-mark-paging_init-as-static
+++ a/arch/hexagon/mm/init.c
@@ -86,7 +86,7 @@ void sync_icache_dcache(pte_t pte)
  * In this mode, we only have one pg_data_t
  * structure: contig_mem_data.
  */
-void __init paging_init(void)
+static void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch


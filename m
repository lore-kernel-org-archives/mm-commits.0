Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6592EBDDE
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 06:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770358631; cv=none; b=OlN6mlvFV8Sf+Xy15SxU9mUzpTK6UR7tWmwuAWif2QZb67MDltvyBm/aATYcAZ0oqpAkbI3NYRGdhsdWKaPBF5Kc3VPNCU0pxfPno6Q3zpm5PTFhyZCBinT2lKRePLXjBRierD2pQQOUXXu133tx4ktv6z/GUsCIzMZ15k0C5aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770358631; c=relaxed/simple;
	bh=GtkM0DbGvOz8K2YGSasSpq7Lsx7C3G/F9Eawb5aFO7U=;
	h=Date:To:From:Subject:Message-Id; b=uNbFEVP9+dtKWsa2coVpE6nmTyi7xQUBmV1akFHrAQ7hYkrp05XTs3otpu+TWnVKNm8zi0N5sgzHRYztYk19ui3wzrbjJfottfHpd57npDsIoz4pBaOFuAyuwgSDci00mNFPR82ZQ5Rc/F7nFNJvab3e+bVjQ+RxlpUZ4vwLcdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MtvKd/ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MtvKd/ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AE7C116C6;
	Fri,  6 Feb 2026 06:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770358630;
	bh=GtkM0DbGvOz8K2YGSasSpq7Lsx7C3G/F9Eawb5aFO7U=;
	h=Date:To:From:Subject:From;
	b=MtvKd/mahNo89ZjYQjlrUiFHefApRq+oOJl+nW/1YlhZuZ2CUOJ7foy28/EftAPi0
	 CxmBxdur7Z+9qyynAOAHd7whY82J7ZI5Xfpt3/WlSMLXW0LxDRzzYPkv/HHF+4DRFq
	 17JHSZzEmrPeNHLwomG2phBGEOjUW+B1AJ8FA0SU=
Date: Thu, 05 Feb 2026 22:17:10 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-remove-unnecessary-warn_onerr-in-kho_populate.patch added to mm-nonmm-unstable branch
Message-Id: <20260206061710.B5AE7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: remove unnecessary WARN_ON(err) in kho_populate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-remove-unnecessary-warn_onerr-in-kho_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-remove-unnecessary-warn_onerr-in-kho_populate.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho: remove unnecessary WARN_ON(err) in kho_populate()
Date: Fri, 6 Feb 2026 04:31:21 +0000

The following pr_warn() provides detailed error and location information,
WARN_ON(err) adds no additional debugging value, so remove the redundant
WARN_ON() call.

Link: https://lkml.kernel.org/r/20260206043121.197564-3-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-remove-unnecessary-warn_onerr-in-kho_populate
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1507,7 +1507,7 @@ void __init kho_populate(phys_addr_t fdt
 
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
-		if (WARN_ON(err)) {
+		if (err) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
 			goto err_unmap_scratch;
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-fix-missing-early_memunmap-call-in-kho_populate.patch
kho-remove-unnecessary-warn_onerr-in-kho_populate.patch


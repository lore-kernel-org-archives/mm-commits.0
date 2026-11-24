Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483450;
	b=sckvsPkSNVY2R5IPXtCY7VmkDXeaJzEddvznY2WCT19c369JUxyvb6B7wi/4O7EN/Sj9
	 DpzLE0twiWSJPjh+3NDZgC536qKh/LTL887lSYN2UaEk4oQgGFn5hTKt6Al/xat2F50hz
	 O6u2D99bL8l+bFUuY+MaxT3NcvFYI7drvCWqaavuQ2grDbvelsFvNP7PaP1vqn8DRct8l
	 svyIHjwS87Y0gPe8QpwnT/ZwtZFfkZ50Z92Jypt9biBRvvZcnBMq/gDFWcfiRdi56exma
	 bLDDTI3vIfz3MMPaupOsjd8nkR31nbYNKyykkgPeUxITUVKbT1ipZpfEE2dctatMiig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483450;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=OLoNZDyMLQI21RHk+/5JP/aH++Lj8NdTnXZy1GNjgV8=;
	b=XJKcMsmdMwkjLVh7IjKyJhSVaTecWVFMV4bW6wp8AQD8kK3MFNpy/EaT0DxC4BcjkZvd
	 Cu9CtdTvhfWOJ2LbTltipct/xn2lmBSXM5Ye/pNPJiYm7CkRwnsFTSVRe4Rng7M0Hs54O
	 V/TRUoXTxjKpyxXe39uWG5GWJTHxjJelFB+e3H/8Fp6LSklHvVj8rTKW7h8U7dWpo5GFq
	 dud3DGQMT68/eT3G4ttUunHWWPHkXkaWPVnwVEtyKsJAc4vmyyhK2UjXfZXtDvRKG9N46
	 AHX0GIknCH4/s5boBXCOce/vwckbd6MbMBQ/WO1SHnJshG/KddV/fZ98QjfyRndYhMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HtTC17eR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CED3606A31E;
	Tue, 24 Nov 2026 01:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HtTC17eR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7437F1F000C6;
	Tue, 24 Nov 2026 01:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795483449;
	bh=OLoNZDyMLQI21RHk+/5JP/aH++Lj8NdTnXZy1GNjgV8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=HtTC17eR13qZImNHpUyhWhm+S7/Fiiq4xBRUhoW840txrygcaPNDf9BQ3TdI8yIqU
	 gKfLHHUt195X+OAuOs+gf1jZnhHv+HOVY2tH1I4xVSFU3Pll7U0L0+QYbX9H/dpkMq
	 ZwuWuozt5HG+2Qgqe9K33idU9u9lLX3JXscK2D7k=
Date: Mon, 23 Nov 2026 17:24:09 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,stable@vger.kernel.org,
	sj@kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kees@kernel.org,
	kasong@tencent.com,gustavo@embeddedor.com,gustavoars@kernel.org,
	chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,
	android-mm@google.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120061750.2973004-1-kaleshsingh@google.com>
References: <20261120061750.2973004-1-kaleshsingh@google.com>
Subject: + mm-swap-make-swap_header-badpages-a-flexible-array.patch added to mm-hotfixes-unstable branch
Message-Id: <20261124012409.7437F1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: swap: make swap_header badpages a flexible array
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-make-swap_header-badpages-a-flexible-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-make-swap_header-badpages-a-flexible-array.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm: swap: make swap_header badpages a flexible array
Date: Fri, 20 Nov 2026 06:17:49 +0000

The swap header declares its list of bad pages as a one-element array,
even though the list can fill the rest of the header page.  Since the
kernel is built with -fstrict-flex-arrays=3, the compiler takes that size
literally, so with UBSAN bounds checking, swapon() of a swap area with two
or more bad pages reports an out-of-bounds access:

  UBSAN: array-index-out-of-bounds in mm/swapfile.c:3674:26
  index 1 is out of range for type '__u32[1]' (aka 'unsigned int[1]')

Kernels that trap on UBSAN reports and panic on oops, such as Android GKI
kernels, crash instead.

Declare the list as a flexible array. The layout of the swap header
does not change.

Link: https://patch.msgid.link/20261120061750.2973004-1-kaleshsingh@google.com
Fixes: df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <android-mm@google.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: <stable@vger.kernel.org> # 6.6.y, 6.12.y, 6.18.y

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-make-swap_header-badpages-a-flexible-array
+++ a/include/linux/swap.h
@@ -129,7 +129,7 @@ union swap_header {
 		unsigned char	sws_uuid[16];
 		unsigned char	sws_volume[16];
 		__u32		padding[117];
-		__u32		badpages[1];
+		__u32		badpages[];
 	} info;
 };
 
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-swap-make-swap_header-badpages-a-flexible-array.patch


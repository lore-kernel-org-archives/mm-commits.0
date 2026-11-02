Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793596652;
	b=ZIbvnTyAbpt7WXuLYa4F9wjuAei9qHb+IiFugVAnb2KY9Hzi1qqmkJORjt5rhoCqOwUJ
	 d9Zp+aXOWXRuoptjRRczpK0kjUCCEwN4Ho+nZtORJ4U3vIMFvVrAojNmJ4brAFqNnxR5j
	 K82VLVyVJQk/n4CAK7g/qRvDIQJZwtSvMMmAGsmg4o01r0Yn1rGKkmtOVFp/iM0LEZ//c
	 2kofs92j3tg2A/cfmX7+9M1ARJfrvlQ78e1QLgFgh18xi0ct/6uE6SkUIfGrLRcTpWvMQ
	 A20N6DnbT3QfBC1L6B066RQHIseyAMbTAV2daS3klq6xGOmaVUy7lotKbv/pHya+SgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793596652;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dKRCXpIHtO5YO9KHJAEeiRJXElZ8a/sloEqNTLpoJ3I=;
	b=gy7nzk//+xhlCIN6OaRhuAJdz/ErJ/r4nHFk2oxrWKkdeBoaD8swUR+3J/CZl24VHxxd
	 YD7D2fjaLgjb8B0MrFmiULMlPVG0xjug6N55LVrCHz90HHsZhbcwk2gJahMSFJvKMtBvw
	 vDVhjkf9qhVAR+taOlsC7ttgoRAbFMHv0wVtBu0jCdbs/FtTNmKZ+y7B3dGcZ/CcNTgBK
	 4y20qF8/FIWLeldzPEIc7dv7PvFs9TLTZmubBgJlMCDifnOC36vLy+WftAHKSuTcoNSEc
	 0wJIxCjj+3MrTasYdS4/SHc6m+6/eZRpHUT3S46J3U1AtdFQx10XCXWIpwijN3UjyQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DdISE3xA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921A0606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 05:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DdISE3xA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E91F000C1;
	Mon,  2 Nov 2026 05:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793596652;
	bh=dKRCXpIHtO5YO9KHJAEeiRJXElZ8a/sloEqNTLpoJ3I=;
	h=Date:To:From:Subject;
	b=DdISE3xAUvXvj/VabY23ViLsCrd4PT474OdetdD4vk+ZHbBLCAky77fFsdkUaNRqu
	 KWR+T3MIv4bCSSHwcUnux0dC/acOKy13cyrID7i3lr5oevp3m2pjTny4WgcpQkQngy
	 wfpnb4PnqSlAmnIttjw/fPPvvjrq1QFSYEm3kbaE=
Date: Sun, 01 Nov 2026 21:17:31 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,tongweilin@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch added to mm-new branch
Message-Id: <20261102051732.026E91F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm/thpmaps: fix partial THP anon/file accounting
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Weilin Tong <tongweilin@linux.alibaba.com>
Subject: tools/mm/thpmaps: fix partial THP anon/file accounting
Date: Tue, 27 Oct 2026 15:49:02 +0800

Patch series "tools/mm/thpmaps: fix THP statistics and mapping names".

This series fixes three issues in thpmaps.

Patch 1 corrects anon/file accounting for trailing partial THPs.
Patch 2 includes order-1 file THPs in the per-size statistics.
Patch 3 preserves mapping names containing whitespace, including
paths with a (deleted) suffix.

The three fixes are independent.


This patch (of 3):

thp_parse() reduces index_end before looking up the type of the
trailing partially mapped THP. The lookup then uses the preceding
page, or anons[-1] if the THP starts at index zero, so its pages can
be charged to the wrong anon/file counter.

Account the partial THP before reducing index_end.

Link: https://lore.kernel.org/20261027074904.3328878-1-tongweilin@linux.alibaba.com
Link: https://lore.kernel.org/20261027074904.3328878-2-tongweilin@linux.alibaba.com
Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 tools/mm/thpmaps |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/thpmaps~tools-mm-thpmaps-fix-partial-thp-anon-file-accounting
+++ a/tools/mm/thpmaps
@@ -263,8 +263,8 @@ def thp_parse(vma, kpageflags, ranges, i
             if flags & KPF_COMPOUND_TAIL:
                 nr = index_end - int(folios[-1])
                 folios = folios[:-1]
-                index_end -= nr
                 stats['anon' if anons[index_end - 1] else 'file']['partial'] += nr
+                index_end -= nr
 
         # Account fully mapped THPs in the middle of the range.
         if len(folios):
_

Patches currently in -mm which might be from tongweilin@linux.alibaba.com are

tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch
tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch
tools-mm-thpmaps-fix-missing-mapping-names.patch


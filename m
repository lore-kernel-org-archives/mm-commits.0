Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543301C84A0
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401646; cv=none; b=DSmULZy+FE70Sjcapqu3xBiZSKQYbawFPl7ZYDCo8R+7bjTM0KB4e0wuKnZijBuzECL4NfaSU0miu2UVq5t/wK9uInzKof51oiWwgSn17RS/6Oml82mBE10sGdo8r4oDwC22O8m37Q881Q7gztVLfy3r/QbF9JBNq0vDiPoiurI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401646; c=relaxed/simple;
	bh=oI12/xYxalDvI6KnyiGfnVzYt750NSzNU8TnCM3BGCc=;
	h=Date:To:From:Subject:Message-Id; b=U9Kj1l1LmaKGSHcIyGhLygD+KXsJll44btzEG37xF+/c/fiWzwdlRPDa0iy0PMpOr242oBU8A0VUYki6ZII8zgEQHg7MVPV4jI/fOvbFJboDJGvUf7uDka/c3g0RizU1qCgiqe5JpCpWbrIt6v2aSR2vzVr3/Bv60Z37O350NaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nC4WX49E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nC4WX49E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C671C19423;
	Mon, 17 Nov 2025 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763401645;
	bh=oI12/xYxalDvI6KnyiGfnVzYt750NSzNU8TnCM3BGCc=;
	h=Date:To:From:Subject:From;
	b=nC4WX49EHz/Q17kmv4c/yoMyvb5kV0/2kfJfa8UYQFOB6+d0ouWB+teqTCecAsQdO
	 WNWI5da2Vx7f0zTsR2KtzaFAyjj2drB/s1IZMhwwZkP/u0D/opN8ZhSzWBm35P+vZT
	 zfRp66plXJqXtvTXjU0joqvlrT40tSsM653hC8bU=
Date: Mon, 17 Nov 2025 09:47:24 -0800
To: mm-commits@vger.kernel.org,david.laight.linux@gmail.com,409411716@gms.tku.edu.tw,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251117174725.9C671C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix
Date: Mon Nov 17 09:44:57 AM PST 2025

remove u32 casts, per David and Guan-Chun

Cc: David Laight <david.laight.linux@gmail.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/base64.c~lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix
+++ a/lib/base64.c
@@ -83,7 +83,7 @@ int base64_encode(const u8 *src, int src
 	const char *base64_table = base64_tables[variant];
 
 	while (srclen >= 3) {
-		ac = (u32)src[0] << 16 | (u32)src[1] << 8 | (u32)src[2];
+		ac = src[0] << 16 | src[1] << 8 | src[2];
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		*cp++ = base64_table[(ac >> 6) & 0x3f];
@@ -95,7 +95,7 @@ int base64_encode(const u8 *src, int src
 
 	switch (srclen) {
 	case 2:
-		ac = (u32)src[0] << 16 | (u32)src[1] << 8;
+		ac = src[0] << 16 | src[1] << 8;
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		*cp++ = base64_table[(ac >> 6) & 0x3f];
@@ -103,7 +103,7 @@ int base64_encode(const u8 *src, int src
 			*cp++ = '=';
 		break;
 	case 1:
-		ac = (u32)src[0] << 16;
+		ac = src[0] << 16;
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		if (padding) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch


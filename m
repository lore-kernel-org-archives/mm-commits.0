Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794534674;
	b=wdu7B2whRwncu4mbBHx5LXd1gqV/ohH/UDC17sF/qagiL5l7calpIqu6iX5VfmKonP8E
	 6rPiRsIo5TLQuIdydkOcq5Fdnrn+yP/rR4IWK7oHblEbbrE2f5DxgORGBdoTF0c/7/r6p
	 ZZDDZA8rRGa149IpZ2fBkeRO7t7ZqF1XP/5qSnVU0ocqh/2KSzSci2lsQ/RRHAL0KB8Ew
	 Q23sBAgKrUF5U96N83NaKhkqUuJ/9p8VeNqjC2zyhUumJ/feUnCrJVewaqYmlQoBGlVsT
	 aEfk8FLsiK5m84sNI6gqyizfe2S3w5QcfG5MHmvsRXC5i4ZaxZ8XeU3cyRRiG0HpIbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794534674;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=F8973DKFgCZo6W/NxlHfhYyqR2IKf3dH1Hu2ezPnHtU=;
	b=ZqC+GfWO/mN7oDmEs3MYk2TWPKk6EFfiesIdFenHB+Jcc45bwlF1s85G5neIXR2FNBcu
	 ngRC36JYrAeQuKzs0LsPLuxh7Hno1Vs+CmOLUp9GdSIjiv+EW91emMnglAcPAQz0DHTIX
	 ZuPBwViNlqqj7IxmanNV7Z86Zbj3gYilgnlohphxefZmaY5YJIHEFvr1Fh7/32bssPGQc
	 9Ip4MqCWT0d4hXTMQxc0yBXxYIrovM/bpAuLNaTaomOEuOw2wJnjIfcTsCLxPS9/GQC5J
	 rOeIIOCZdd6nb4AENT+apfP/yOzG+JqwoKoF/pjKeFGFb/UnveYEi+SHo2sM3KCkYkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sFs3woa6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70AC606A323
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 01:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sFs3woa6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2D41F000C4;
	Fri, 13 Nov 2026 01:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794534674;
	bh=F8973DKFgCZo6W/NxlHfhYyqR2IKf3dH1Hu2ezPnHtU=;
	h=Date:To:From:Subject;
	b=sFs3woa6gbuGd/OZDZ6jxZcHFINThFUet2E2gwoA5YYzAC+wZWidU/LHwj/tFNnLU
	 MqtSE1SNt+MDY/0jtRYEXhsnwwPOuQr+PPtnWbpA5JKNdwuoc5MkiCKZ/iUMfAYfWJ
	 OHcuNP0/jasrW+O4HJODCui8sRGVC32SQAMPnsmY=
Date: Thu, 12 Nov 2026 17:51:13 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,elver@google.com,
	dwaipayanray1@gmail.com,apw@canonical.com,vdonnefort@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-context-analysis-attributes.patch added to mm-nonmm-unstable branch
Message-Id: <20261113015114.0E2D41F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: add context-analysis attributes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-context-analysis-attributes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-context-analysis-attributes.patch

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
From: Vincent Donnefort <vdonnefort@google.com>
Subject: checkpatch: add context-analysis attributes
Date: Thu, 12 Nov 2026 15:12:03 +0000

Checkpatch doesn't know about the context analysis attributes and
misparses annotated declarations (e.g.  mistaking __guarded_by() fields
for extern prototype).  Add them to the known attributes list.

Link: https://lore.kernel.org/20261112151203.3129005-1-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
---

 scripts/checkpatch.pl |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-context-analysis-attributes
+++ a/scripts/checkpatch.pl
@@ -526,6 +526,25 @@ our $InitAttributeData = qr{$InitAttribu
 our $InitAttributeConst = qr{$InitAttributePrefix(?:initconst\b)};
 our $InitAttributeInit = qr{$InitAttributePrefix(?:init\b)};
 our $InitAttribute = qr{$InitAttributeData|$InitAttributeConst|$InitAttributeInit};
+our $ContextAnalysis = qr{
+			__guarded_by\b|
+			__pt_guarded_by\b|
+			__rcu_guarded\b|
+			__must_hold\b|
+			__must_hold_shared\b|
+			__must_not_hold\b|
+			__acquires\b|
+			__acquires_shared\b|
+			__cond_acquires\b|
+			__cond_acquires_shared\b|
+			__releases\b|
+			__releases_shared\b|
+			__cond_releases\b|
+			__no_context_analysis\b|
+			__context_unsafe\b|
+			__acquires_ret\b|
+			__acquires_shared_ret\b
+		}x;
 
 # Notes to $Attribute:
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
@@ -551,6 +570,7 @@ our $Attribute	= qr{
 			__ro_after_init|
 			__kprobes|
 			$InitAttribute|
+			$ContextAnalysis|
 			__aligned\s*\(.*\)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
_

Patches currently in -mm which might be from vdonnefort@google.com are

checkpatch-add-context-analysis-attributes.patch


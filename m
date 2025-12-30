Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3EC32E12B
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767119045; cv=none; b=PVr60+kdUqbRY88qhc3lT3PAwyEvRF5QnH95N44rq7+eSYor0r+gCEXkEvgU9pPA48iuXXA3dpuw946Jv5iFREBDtKmRRpFHwGruWqo3rfQwqY/stPu722Re2oaZv5gnB23KGXxKqkrJ1MysnNLnUzHhnduGUbBbOiq1TUvqmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767119045; c=relaxed/simple;
	bh=4mt9utQ4hABXW41s/ceSfxh70glCGoGaOSVylgwwWpo=;
	h=Date:To:From:Subject:Message-Id; b=CHE4MbnYEFR0DUrH97PKoj2wrHWRjIWjjKPvFCrfXpEVrl1aB2qBNQRjofHrEbZYyuVI21tEl7WAhukghdLZYZ6sCuBy8b3i0GfaQ5Y7Zzb1ozU7w98TonIMD2ObSNYQwR17isjYTXsWG4Uda7SSpFr8XP0WL05ENE+g7LS/vRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBXORuNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBXORuNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FF8C116D0;
	Tue, 30 Dec 2025 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767119045;
	bh=4mt9utQ4hABXW41s/ceSfxh70glCGoGaOSVylgwwWpo=;
	h=Date:To:From:Subject:From;
	b=pBXORuNEpGzP7KSAhZXAsV5pElx2CeMBwL2F/a/P0KIGfjb2bK7ajyls+YZHFSzNC
	 ED/61LyvKn+FHJ0R0JZW3dREiRYDcZ1b+4Wlo8bXM2jy4VcXHmXmFL2XfR6j3Gq77L
	 RDgX2JzYCp3v+cYD172QpUhSQNuYDACYGXHAnKUE=
Date: Tue, 30 Dec 2025 10:24:04 -0800
To: mm-commits@vger.kernel.org,arnd@arndb.de,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + types-drop-definition-of-__exported_headers__.patch added to mm-nonmm-unstable branch
Message-Id: <20251230182404.E0FF8C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: types: Drop definition of __EXPORTED_HEADERS__
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     types-drop-definition-of-__exported_headers__.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/types-drop-definition-of-__exported_headers__.patch

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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: types: Drop definition of __EXPORTED_HEADERS__
Date: Tue, 30 Dec 2025 08:13:15 +0100

This definition disarms the warning in uapi/linux/types.h about including
kernel headers from user space.  However the warning is already disarmed
due to the fact that kernel code is built with -D__KERNEL__.

Drop the pointless definition.

Link: https://lkml.kernel.org/r/20251230-exported-headers-types-h-v1-1-947fc606f3d8@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/types.h~types-drop-definition-of-__exported_headers__
+++ a/include/linux/types.h
@@ -2,7 +2,6 @@
 #ifndef _LINUX_TYPES_H
 #define _LINUX_TYPES_H
 
-#define __EXPORTED_HEADERS__
 #include <uapi/linux/types.h>
 
 #ifndef __ASSEMBLY__
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

ipc-shm-uapi-remove-dependency-on-libc.patch
types-drop-definition-of-__exported_headers__.patch


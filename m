Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD5B4071C0
	for <mm-commits@vger.kernel.org>; Mon, 15 Jun 2026 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538771; cv=none; b=C0SkCoXynM9RiJUdlulSyig0oV7GfoSx8FNbovMHDndL0nnR/Ib54D1YO6J0cJ8wh8RuZfl278ypkHXyj8+x54S0JlA3PsBNDkfPPulTvwE9LbFwceewUGPK5NPzZPhvQlLN4Y/jRWwjTWrME1e5u9y4W7hDcxAaeUT3Z68fqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538771; c=relaxed/simple;
	bh=x4sqJd5b3xSjgDL1MvbzgNOFfQpUYVVEDPBrz2b6+Mo=;
	h=Date:To:From:Subject:Message-Id; b=ZiFtdemUB/OUsuzflik1QWEb8ue46pWt/mU/x4XUM3qFqMSteRIC1Gxtm7JsjyJg0Ao8e1Zzr7z7AsYFUeo9p3bIXFA2rg7o5X7ktpIsjpBzRqbwWw26DNxryIj4el92sPnfsL0SPcKQS6YDxRnjd2uu2aJff3qPWYBicfSr0Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W/qjSbFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W/qjSbFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EFA1F000E9;
	Mon, 15 Jun 2026 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781538770;
	bh=nAu2Xm6sg9CrlV9HLB0/f2z0BXRzyTClWANefeqem6o=;
	h=Date:To:From:Subject;
	b=W/qjSbFJ6wZ+Fwh7Hs094hFNTxFBS1Z55qxkwGvpAOuzpswplhfjlX5EZXJ6n4ox0
	 ks5E8kNMgdwGVp202E7sVyLl9T3VtGsBYmTMHXnxNVo7KrDsn9IJAqqR1qiLcAoJs+
	 XGHu9KzxK9X7RxoeZguS8nxBIkbwkHPDv9Flap9c=
Date: Mon, 15 Jun 2026 08:52:49 -0700
To: mm-commits@vger.kernel.org,davem@davemloft.net,andreas@gaisler.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] sparc-add-_mcount-prototype.patch removed from -mm tree
Message-Id: <20260615155250.64EFA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc: add _mcount() prototype
has been removed from the -mm tree.  Its filename was
     sparc-add-_mcount-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sparc: add _mcount() prototype
Date: Fri May 22 09:20:26 PM PDT 2026

sparc64 defconfig told me

WARNING: modpost: EXPORT symbol "_mcount" [vmlinux] version generation failed, symbol will not be versioned.
Is "_mcount" prototyped in <asm/asm-prototypes.h>?

so I added it.

BTW, altering arch/sparc/include/asm/asm-prototypes.h then running `make'
doesn't compile anything, so there's a missing dependency somewhere?

Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Tested-by: Andreas Larsson <andreas@gaisler.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/asm-prototypes.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/include/asm/asm-prototypes.h~sparc-add-_mcount-prototype
+++ a/arch/sparc/include/asm/asm-prototypes.h
@@ -25,6 +25,7 @@ void *memcpy(void *dest, const void *src
 void *memset(void *s, int c, size_t n);
 typedef int TItype __attribute__((mode(TI)));
 TItype __multi3(TItype a, TItype b);
+void _mcount(void);
 
 s64 __ashldi3(s64, int);
 s64 __lshrdi3(s64, int);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-interval_tree_test-validate-benchmark-parameters-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch


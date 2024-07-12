Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9346F61FE0
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 23:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827530; cv=none; b=HpJ1CQqI6GRRMbm67ORHU7H3cnjCa9t58uaDfIfzn2f0X/optiUjEBWUDcM51j6Mp+jj4vgP63o/a5Idv/KpR5EVdlVIpAdDqTJSu5P/BJAF1H0PihqGVgJOqok6eyOZMek+ThTw9h+/jCjK90amN2c6CZNT0MJ9RwbOyBgBoBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827530; c=relaxed/simple;
	bh=Dy158/6F32GEgWBzHMN81JyoXu1MBqMPKVTWiakuQCg=;
	h=Date:To:From:Subject:Message-Id; b=Ed0EaMAv4kucl80nkNWaEOCgPbiQhgS4pciGH4NuySRp72SCKDQPJDGREWuXWaFsOuo4QxUM4qz7iYpRSEuJmvvodKC4MqX196cAfUfHKr6hgOBh+dVJtGk16G0q1qT/mjQOpMqlFNBrGazW4Qs8FPa0xcF8ROXQ+SPYYsYEYKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2UJYexEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2UJYexEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA777C32782;
	Fri, 12 Jul 2024 23:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720827530;
	bh=Dy158/6F32GEgWBzHMN81JyoXu1MBqMPKVTWiakuQCg=;
	h=Date:To:From:Subject:From;
	b=2UJYexEFl7SG9IkGlU7AAJ1jmWq/w+KOQA6q4F7uAKJVVGCawQlSbSjrgiP7oNS2Q
	 KzCvY1c+r/MAszorYFfFu52SI5G3v7rwNojyjsXhpzO3xAdrEob4lQAJC0TRbrs/nB
	 U/m8jLXdHE621UAaKsQjv4XsH702Kw1Yvn7ABYV4=
Date: Fri, 12 Jul 2024 16:38:49 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,masahiroy@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch removed from -mm tree
Message-Id: <20240712233849.EA777C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
has been removed from the -mm tree.  Its filename was
     init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch

This patch was dropped because it was folded into init-modpost-conditionally-check-section-mismatch-to-__meminit.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
Date: Wed, 10 Jul 2024 09:28:02 +1000

remove MEM_KEEP from arch/powerpc/kernel/vmlinux.lds.S

Link: https://lkml.kernel.org/r/20240710093213.2aefb25f@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S~init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -123,8 +123,6 @@ SECTIONS
 		 */
 		*(.sfpr);
 		*(.text.asan.* .text.tsan.*)
-		MEM_KEEP(init.text)
-		MEM_KEEP(exit.text)
 	} :text
 
 	. = ALIGN(PAGE_SIZE);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

init-modpost-conditionally-check-section-mismatch-to-__meminit.patch


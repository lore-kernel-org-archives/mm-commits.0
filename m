Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33A243302E
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816320; cv=none; b=ka0kkgEPVrhANvbrAjSDLWjT4znvwuBb4SmYM1BhOOdtuM/fcghsgZous2J2azkulQ0C/v3oSIqA4wVWmqie8ycpyKimxAnV0vRXxOhgbjoKcUOmpPM5DpJvC70xDEJzuoHnWLVyiUNcu95i4eD9AYSDf6eWHJJLS3lmXUoMfiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816320; c=relaxed/simple;
	bh=GTwk57UK1/M/4JrCCkr/TBTDuiViu9tK/MzUWLDKWRQ=;
	h=Date:To:From:Subject:Message-Id; b=Fu7S+c0pCfMVUswH1gBrFHqSgpqAZRrUM1RM9N51KA0B8Wsui+Zo1b3SqXUhnL/LcjUGbpL5IXTh/nUvcpKAWtneZf4aE/G0254hJ1pE6teiFYrkdLALGyJiPHdu7ddj0V25tw+4pP8w+4GY9LzlRC6u1ZOfzUq16BuLGfNN28c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pjzew+BL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pjzew+BL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A721C1F00A3F;
	Tue,  4 Aug 2026 04:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816318;
	bh=BH/5IMUpPl5gfWFwsGGym84qIp8eHjByE/MR6Jo7sno=;
	h=Date:To:From:Subject;
	b=Pjzew+BLM2RKasDE+Y74Z3luX2Inyd95QuY20VCnLE1zg/CufjvxeZ1s+YdUOqY5F
	 fVbs3NQwa5kKAd6E3tZ36aAg3Vo+DAqdCPESxx0mAPPQzRuGJVN3i0iQg3DtwAdCIX
	 205UEumYLAGGvkqf1o+rTFPtXTPAib1+BhuMlW4k=
Date: Mon, 03 Aug 2026 21:05:18 -0700
To: mm-commits@vger.kernel.org,robh@kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,briannorris@chromium.org,apw@canonical.com,wenst@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-dont-emit-warnings-for-id-base-usb-pci-dt-compatibles.patch removed from -mm tree
Message-Id: <20260804040518.A721C1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: don't emit warnings for ID-base USB & PCI DT compatibles
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-emit-warnings-for-id-base-usb-pci-dt-compatibles.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen-Yu Tsai <wenst@chromium.org>
Subject: checkpatch: don't emit warnings for ID-base USB & PCI DT compatibles
Date: Tue, 7 Jul 2026 15:46:27 +0800

The USB and PCI device bindings define some compatible patterns based on
device IDs that use the comma to separate vendor and product IDs.

These prefix patterns include:

  - ^usb(if)?[0-9a-f]{1,4},
  - ^pci[0-9a-f]{2,4},
  - ^pciclass,

These are not real vendor prefixes.  Don't emit warnings for them. 
Instead just skip over the DT compatible check altogether, and leave the
real check to the DT validator.  This avoids false positive warnings about
undocumented DT vendor prefixes and compatibles.

Note that the script mostly only checks the first compatible string of
each node, as it processes the source file line-by-line, and the check
only matches on the line with 'compatible = "..."'.  Otherwise there would
be more warnings from arch/mips/boot/dts/loongson/ls7a-pch.dtsi since that
file also includes compatibles like "pciclass0c0310" and "pciclass0c03"
which are not accepted either.  "pci0014,7a24.0" is not valid either, but
this patch leaves the real check to the DT validator.

Link: https://lore.kernel.org/20260707074629.3132930-1-wenst@chromium.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-dont-emit-warnings-for-id-base-usb-pci-dt-compatibles
+++ a/scripts/checkpatch.pl
@@ -3781,6 +3781,12 @@ sub process {
 			my $vp_file = $dt_path . "vendor-prefixes.yaml";
 
 			foreach my $compat (@compats) {
+				# Skip ID-based PCI and USB compatible patterns.
+				# DT validation will check them properly.
+				next if $compat =~ /^pciclass,/;
+				next if $compat =~ /^pci[a-f0-9]{2,4},/;
+				next if $compat =~ /^usb(if)?[a-f0-9]{1,4},/;
+
 				my $compat2 = $compat;
 				$compat2 =~ s/\,[a-zA-Z0-9]*\-/\,<\.\*>\-/;
 				my $compat3 = $compat;
_

Patches currently in -mm which might be from wenst@chromium.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EC434753B
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 21:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783459074; cv=none; b=CVeK8l+/2zAwATO/x2yESA5z97u2G4UY7rsE9oJc2ZNb9J88HmhQlpw/wmT51+ylg6+dnIV/DScni6F2FqX/zE/jQRPS/1MYeg5MaNUI/mMIyYNEz+wUT0fjaN+Em9VZkBDHmiUb5Y+UrvwSKXflXREvdol/PkmwJjlohBVQSEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783459074; c=relaxed/simple;
	bh=EVrVRk4jcYd3VHC1ReiqDbq3gP/TLjfs/55zYmE5O9Q=;
	h=Date:To:From:Subject:Message-Id; b=b/r/3KP3MxgyAIhbUMhSb4qAXWnOP9FtNl80z/bsgoobKYxHCX8KWZqv1yD/mpqjlYpZvAFSw8Kojv9Xy3iEjJDANW71f5Ch17hlfnDcZblJ5UVkeoLIeMTPSOgPh3y2pWYt7c8mocNUy2qJRBc9gC+lDddMw4aJzqu3ybJzidg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=veS9eOiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="veS9eOiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10EE1F000E9;
	Tue,  7 Jul 2026 21:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783459072;
	bh=LB2dSOJ5tUmXLDIsnIwYQKVJp3Y3dDSCyrWqxksclaE=;
	h=Date:To:From:Subject;
	b=veS9eOiNfVDs383e4HSGIeDXAzPphpSoZFEkFUiABs/FhwJlEIPY6qNDJ6KaFmDyc
	 WKBJpUkPk76FVLGO42U3p2+LRbsRQJU0OALRJx9IlmRyaIIv9EdgvupqjSAa/xKMvI
	 qDEya/PNVaMhMel9CA7rGYD4uPjB7Xfiply4GHpY=
Date: Tue, 07 Jul 2026 14:17:52 -0700
To: mm-commits@vger.kernel.org,robh@kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,briannorris@chromium.org,apw@canonical.com,wenst@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-emit-warnings-for-id-base-usb-pci-dt-compatibles.patch added to mm-nonmm-unstable branch
Message-Id: <20260707211752.B10EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: don't emit warnings for ID-base USB & PCI DT compatibles
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-emit-warnings-for-id-base-usb-pci-dt-compatibles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-emit-warnings-for-id-base-usb-pci-dt-compatibles.patch

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

checkpatch-dont-emit-warnings-for-id-base-usb-pci-dt-compatibles.patch


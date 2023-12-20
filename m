Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE0747A59
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B/TKC69I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91999C433C7;
	Wed, 20 Dec 2023 17:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703093978;
	bh=d33A+Yt6rWc+hNdRt8qema/Mh96QWKS0HaAAdlHl0vc=;
	h=Date:To:From:Subject:From;
	b=B/TKC69IlLBcOvHRv/fS1IPuhJ/DXbOYnRKd2uImVM3IOyAnNmx6cROS7oqfyh9Fu
	 fQReuN1br4n1qqJYEk2NSeoWq0FfRMzWrvJw9Vr6hL6lNN8eEuZEwCtbEtJsk/GANN
	 mqifv4SesK0qtUHPS7+9MilnYSwNgEOB2sUv6wAM=
Date: Wed, 20 Dec 2023 09:39:38 -0800
To: mm-commits@vger.kernel.org,qun-wei.lin@mediatek.com,matthias.bgg@gmail.com,chinwen.chang@mediatek.com,casper.li@mediatek.com,angelogioacchino.delregno@collabora.com,Kuan-Ying.Lee@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-fix-no-space-expression-between-sp-and-offset.patch added to mm-nonmm-unstable branch
Message-Id: <20231220173938.91999C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/checkstack.pl: fix no space expression between sp and offset
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-fix-no-space-expression-between-sp-and-offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-fix-no-space-expression-between-sp-and-offset.patch

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
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/checkstack.pl: fix no space expression between sp and offset
Date: Wed, 20 Dec 2023 15:36:28 +0800

When I use older version aarch64 objdump (2.24) to disassemble aarch64
vmlinux, I get the result like below.  There is no space between sp and
offset.

ffff800008010000 <dw_apb_ictl_handle_irq>:
ffff800008010000:       d503233f        hint    #0x19
ffff800008010004:       a9bc7bfd        stp     x29, x30, [sp,#-64]!
ffff800008010008:       90011e60        adrp    x0, ffff80000a3dc000 <num_ictlrs>
ffff80000801000c:       910003fd        mov     x29, sp
ffff800008010010:       a9025bf5        stp     x21, x22, [sp,#32]

When I use newer version aarch64 objdump (2.35), I get
the result like below.
There is a space between sp and offset.

ffff800008010000 <dw_apb_ictl_handle_irq>:
ffff800008010000:       d503233f        paciasp
ffff800008010004:       a9bc7bfd        stp     x29, x30, [sp, #-64]!
ffff800008010008:       90011e60        adrp    x0, ffff80000a3dc000 <num_ictlrs>
ffff80000801000c:       910003fd        mov     x29, sp
ffff800008010010:       a9025bf5        stp     x21, x22, [sp, #32]

Add no space support of regular expression for old version objdump.

Link: https://lkml.kernel.org/r/20231220073629.2658-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Casper Li <casper.li@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkstack.pl~scripts-fix-no-space-expression-between-sp-and-offset
+++ a/scripts/checkstack.pl
@@ -56,7 +56,7 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 	if ($arch =~ '^(aarch|arm)64$') {
 		#ffffffc0006325cc:       a9bb7bfd        stp     x29, x30, [sp, #-80]!
 		#a110:       d11643ff        sub     sp, sp, #0x590
-		$re = qr/^.*stp.*sp, \#-([0-9]{1,8})\]\!/o;
+		$re = qr/^.*stp.*sp, ?\#-([0-9]{1,8})\]\!/o;
 		$dre = qr/^.*sub.*sp, sp, #(0x$x{1,8})/o;
 	} elsif ($arch eq 'arm') {
 		#c0008ffc:	e24dd064	sub	sp, sp, #100	; 0x64
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-fix-no-space-expression-between-sp-and-offset.patch


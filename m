Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D410C2904
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kr3S3Mvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBB4C433C8;
	Mon, 18 Dec 2023 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702924637;
	bh=J85bpHj6UJDvA21qycu6d8ydjHzle9hDSSfonTQRP6U=;
	h=Date:To:From:Subject:From;
	b=kr3S3Mvkur78dnl4Kb9OD0uhD3a5h9TfOvD3XD9Szf65LE1Z272OBP1NuTij41tyO
	 fnngbgR+td8vsno1a2c2837vJS3c+khSx+3dgEieGJ63L0Fz157zXsyUSwnih2w0wk
	 TrEzjrh6qdQqBdk0VsL6D+zxbX0B9PVLm43tGspU=
Date: Mon, 18 Dec 2023 10:37:16 -0800
To: mm-commits@vger.kernel.org,tangyouling@kylinos.cn,chenhuacai@loongson.cn,youling.tang@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decodecode-add-support-for-loongarch.patch added to mm-nonmm-unstable branch
Message-Id: <20231218183717.4EBB4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decodecode: add support for LoongArch
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decodecode-add-support-for-loongarch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decodecode-add-support-for-loongarch.patch

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
From: Youling Tang <youling.tang@outlook.com>
Subject: scripts/decodecode: add support for LoongArch
Date: Sat, 16 Dec 2023 14:51:28 +0800


An example how to invoke decodecode for loongarch64:
$ echo 'Code: 380839f6  380831f9  28412bae  <24000ca6>
  004081ad  0014cb50  004083e8  02bff34c  58008e91' | \
  ARCH=loongarch CROSS_COMPILE=loongarch64-linux-gnu- \
  ./scripts/decodecode
Code: 380839f6 380831f9 28412bae <24000ca6> 004081ad 0014cb50 004083e8 02bff34c 58008e91
All code
========
   0:	380839f6 	ldx.w       	$fp, $t3, $t2
   4:	380831f9 	ldx.w       	$s2, $t3, $t0
   8:	28412bae 	ld.h        	$t2, $s6, 74(0x4a)
   c:*	24000ca6 	ldptr.w     	$a2, $a1, 12(0xc)		<-- trapping instruction
  10:	004081ad 	slli.w      	$t1, $t1, 0x0
  14:	0014cb50 	and         	$t4, $s3, $t6
  18:	004083e8 	slli.w      	$a4, $s8, 0x0
  1c:	02bff34c 	addi.w      	$t0, $s3, -4(0xffc)
  20:	58008e91 	beq         	$t8, $t5, 140(0x8c)	# 0xac

Code starting with the faulting instruction
===========================================
   0:	24000ca6 	ldptr.w     	$a2, $a1, 12(0xc)
   4:	004081ad 	slli.w      	$t1, $t1, 0x0
   8:	0014cb50 	and         	$t4, $s3, $t6
   c:	004083e8 	slli.w      	$a4, $s8, 0x0
  10:	02bff34c 	addi.w      	$t0, $s3, -4(0xffc)
  14:	58008e91 	beq         	$t8, $t5, 140(0x8c)	# 0xa0

Link: https://lkml.kernel.org/r/MW4PR84MB3145B99B9677BB7887BB26CD8192A@MW4PR84MB3145.NAMPRD84.PROD.OUTLOOK.COM
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    5 +++++
 1 file changed, 5 insertions(+)

--- a/scripts/decodecode~scripts-decodecode-add-support-for-loongarch
+++ a/scripts/decodecode
@@ -67,6 +67,7 @@ if [ -z "$ARCH" ]; then
     case `uname -m` in
 	aarch64*) ARCH=arm64 ;;
 	arm*) ARCH=arm ;;
+	loongarch*) ARCH=loongarch ;;
     esac
 fi
 
@@ -98,6 +99,10 @@ disas() {
 		${CROSS_COMPILE}strip $t.o
 	fi
 
+	if [ "$ARCH" = "loongarch" ]; then
+		${CROSS_COMPILE}strip $t.o
+	fi
+
 	if [ $pc_sub -ne 0 ]; then
 		if [ $PC ]; then
 			adj_vma=$(( $PC - $pc_sub ))
_

Patches currently in -mm which might be from youling.tang@outlook.com are

scripts-decodecode-add-support-for-loongarch.patch


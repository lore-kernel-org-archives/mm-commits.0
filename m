Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A58713FE1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xgBwnvsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BC8C433C8;
	Fri, 29 Dec 2023 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881394;
	bh=6VRF7koIAUe9LyjSXNQSbLRamWuoT2Y8MAr9W7Oi+90=;
	h=Date:To:From:Subject:From;
	b=xgBwnvsE5qbUTEItwGAIihelwRmowEY05a+1QOwqwmFY9LeSor/84jqqndl3xqqiJ
	 bUUtSLoXbUMkR7bRPwpv2ofdO2lmAWCvjmBG1wgsW1/YKsyB5cmBEzloaDdQIlpakt
	 utw79J9wNw6ymee2atLN326E46jN4wa0RXEFITps=
Date: Fri, 29 Dec 2023 12:23:13 -0800
To: mm-commits@vger.kernel.org,glaubitz@physik.fu-berlin.de,chenhuacai@loongson.cn,tangyouling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkstack-add-loongarch-support-for-scripts-checkstackpl.patch removed from -mm tree
Message-Id: <20231229202314.61BC8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkstack: add loongarch support for scripts/checkstack.pl
has been removed from the -mm tree.  Its filename was
     checkstack-add-loongarch-support-for-scripts-checkstackpl.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youling Tang <tangyouling@kylinos.cn>
Subject: checkstack: add loongarch support for scripts/checkstack.pl
Date: Sat, 16 Dec 2023 14:40:54 +0800

scripts/checkstack.pl lacks support for the loongarch architecture.  Add
support to detect "addi.{w,d} $sp, $sp, -FRAME_SIZE" stack frame
generation instruction.

Link: https://lkml.kernel.org/r/MW4PR84MB314514273F0B7DBCC5E35A978192A@MW4PR84MB3145.NAMPRD84.PROD.OUTLOOK.COM
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/checkstack.pl~checkstack-add-loongarch-support-for-scripts-checkstackpl
+++ a/scripts/checkstack.pl
@@ -16,6 +16,7 @@
 #	sparc port by Martin Habets <errandir_news@mph.eclipse.co.uk>
 #	ppc64le port by Breno Leitao <leitao@debian.org>
 #	riscv port by Wadim Mueller <wafgo01@gmail.com>
+#	loongarch port by Youling Tang <tangyouling@kylinos.cn>
 #
 #	Usage:
 #	objdump -d vmlinux | scripts/checkstack.pl [arch]
@@ -104,6 +105,9 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 	} elsif ($arch =~ /^riscv(64)?$/) {
 		#ffffffff8036e868:	c2010113          	addi	sp,sp,-992
 		$re = qr/.*addi.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+	} elsif ($arch =~ /^loongarch(32|64)?$/) {
+		#9000000000224708:	02ff4063		addi.d  $sp, $sp, -48(0xfd0)
+		$re = qr/.*addi\..*sp, .*sp, -([0-9]{1,8}).*/o;
 	} else {
 		print("wrong or unknown architecture \"$arch\"\n");
 		exit
_

Patches currently in -mm which might be from tangyouling@kylinos.cn are



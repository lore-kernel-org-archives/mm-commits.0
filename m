Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC2038C
	for <mm-commits@vger.kernel.org>; Mon, 23 Dec 2024 00:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734914251; cv=none; b=YH37nu7XYl5eOlZv9GfIQ2zayLDZ+bs6EUVXlztnwv50wDpHnW2vkokAweSmvyxEwgdC4TyPFJedd/1mM98SNvBt5rpenf8ILfXKmt8x0fHw9AMZZoUh22DPXykL+HEyhvAoNngdOsgu/1WqVBKPMiun9yI7jwB9yd4XBdlhN+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734914251; c=relaxed/simple;
	bh=VPnqeKw/SkQCL10L8NB8I4zhdVQL3g0R0Am2Jma+7KM=;
	h=Date:To:From:Subject:Message-Id; b=dAfvvVDS+pz22DIFq5TeCCg693l/ahZo01kncHaa6Y/2FLwFzNjPKY3txnW4pNP7eFGE6a5pWW7fQ/MwFFZstxOS6tzKWS6eUfrY51k9e/f771M1yT55jQQDKq6hc4sekfir17qsaU1erXbH0DDjPodnGATK9PZsolpwKZjHYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0MrPHN0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0MrPHN0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C480C4CECD;
	Mon, 23 Dec 2024 00:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734914251;
	bh=VPnqeKw/SkQCL10L8NB8I4zhdVQL3g0R0Am2Jma+7KM=;
	h=Date:To:From:Subject:From;
	b=0MrPHN0+yqrOaGFepUgDm2f1nw3BaBUuOIdzT3PsPaOKk22A/1rfE9zh4mYeFaEDH
	 k+XXesm6o7UoRSOkojK26SgrXMZJ9R7fUAh1qxo1D/GO3thQrC1Qlxy/8S1WkEQlXi
	 ZqRmWyvzlAY8hkLCBi35a7OSHbwSa03FkrktTzVg=
Date: Sun, 22 Dec 2024 16:37:30 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,oleg@redhat.com,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,lukas.bulwahn@gmail.com,linux@rasmusvillemoes.dk,joe@perches.com,dwaipayanray1@gmail.com,arnd@arndb.de,apw@canonical.com,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch removed from -mm tree
Message-Id: <20241223003731.2C480C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: drop support for include/asm-<arch> in headers_check.pl
has been removed from the -mm tree.  Its filename was
     kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: kbuild: drop support for include/asm-<arch> in headers_check.pl
Date: Thu, 5 Dec 2024 14:20:43 +0100

"include/asm-<arch>" was replaced by "arch/<arch>/include/asm" a long time
ago.  All assembler header files are now included using "#include
<asm/*>", so there is no longer a need to rewrite paths.

Link: https://lkml.kernel.org/r/19fb5b49396239d28020015ba2640d77dacdb6c2.1733404444.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/include/headers_check.pl |    4 ----
 1 file changed, 4 deletions(-)

--- a/usr/include/headers_check.pl~kbuild-drop-support-for-include-asm-arch-in-headers_checkpl
+++ a/usr/include/headers_check.pl
@@ -55,10 +55,6 @@ sub check_include
 		my $found;
 		$found = stat($dir . "/" . $inc);
 		if (!$found) {
-			$inc =~ s#asm/#asm-$arch/#;
-			$found = stat($dir . "/" . $inc);
-		}
-		if (!$found) {
 			printf STDERR "$filename:$lineno: included file '$inc' is not exported\n";
 			$ret = 1;
 		}
_

Patches currently in -mm which might be from geert+renesas@glider.be are

checkpatch-update-reference-to-include-asm-arch.patch
include-update-references-to-include-asm-arch.patch


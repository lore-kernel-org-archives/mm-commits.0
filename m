Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613EB14D6F6
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742142; cv=none; b=K+aiDGXXI2HmYgUi+gp9EJN/FkCMS/p0T2tNP7V72PcXT6RsX6OW+jdOlxquLBeWQfYPMmkXC5ZJ5niIzQynZDSFyAGmjXRY68DgyMezojH/NiKiGM9F8igKXDYWTWoHUj7G18UOodaWuTXT71DsI5/ZDpXtPj6U2+Rww42vqns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742142; c=relaxed/simple;
	bh=irNR/WMDTtydPiakVGQwtq0paHJMDTheB1W2h+4fWyY=;
	h=Date:To:From:Subject:Message-Id; b=s63QKrzt7aq/lChSxFdIS9M9iKa+WMkLwstlsW/u9PlcelncQ2vGbpGir554sAuUrU7pscsTk4t4H+bUMNgdl8rGeWJns7/VQs/4dTeXL4vufbo7zd7JAJDguaEPcGniBDmhr08Xv1K6w4+Y4IrqmMEppJMRkaYWiL0Er6n9Ls4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PqU1SN/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PqU1SN/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B95C4CED6;
	Mon, 13 Jan 2025 04:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742142;
	bh=irNR/WMDTtydPiakVGQwtq0paHJMDTheB1W2h+4fWyY=;
	h=Date:To:From:Subject:From;
	b=PqU1SN/Ji5XlT7HFElevXPTgo6TPti01Jl6QOPcKUUpZGxl+/8Zrb6U4t6nkqSb5h
	 RhmBsRdJXbeHVZvfU/WPgYkthz54vNjP6HfH+4KmeWCu9bLyExI++w5s9gJ4Hw3ItJ
	 I4pzhZLYRw1lkQccnEaojSlltD0hqT+IhQcohFtg=
Date: Sun, 12 Jan 2025 20:22:21 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,oleg@redhat.com,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,lukas.bulwahn@gmail.com,linux@rasmusvillemoes.dk,joe@perches.com,dwaipayanray1@gmail.com,arnd@arndb.de,apw@canonical.com,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-update-reference-to-include-asm-arch.patch removed from -mm tree
Message-Id: <20250113042222.34B95C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: update reference to include/asm-<arch>
has been removed from the -mm tree.  Its filename was
     checkpatch-update-reference-to-include-asm-arch.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: checkpatch: update reference to include/asm-<arch>
Date: Thu, 5 Dec 2024 14:20:42 +0100

Patch series "Update reference to include/asm-<arch>".

Despite "include/asm-<arch>" having been replaced by
"arch/<arch>/include/asm" 15 years ago, there are still several
references left.

This patch series updates the most visible ones.


This patch (of 3):

"include/asm-<arch>" was replaced by "arch/<arch>/include/asm" a long
time ago.

Link: https://lkml.kernel.org/r/cover.1733404444.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/2c4a75726a976d117055055b68a31c40dcab044e.1733404444.git.geert+renesas@glider.be
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

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-update-reference-to-include-asm-arch
+++ a/scripts/checkpatch.pl
@@ -2875,7 +2875,7 @@ sub process {
 
 			if ($realfile =~ m@^include/asm/@) {
 				ERROR("MODIFIED_INCLUDE_ASM",
-				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
+				      "do not modify files in include/asm, change architecture specific files in arch/<architecture>/include/asm\n" . "$here$rawline\n");
 			}
 			$found_file = 1;
 		}
_

Patches currently in -mm which might be from geert+renesas@glider.be are



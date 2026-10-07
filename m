Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0983546F5
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338697; cv=none; b=mFyD4qfajoB+UuWFPgrPqnsf/RKfGbA2sNj+6GELIgVgBIFsoEY2vIQhBxGDP6F8kFjSeh1gbAK1UlecPZoaQ5ljl59gQpBVUVdUjXbaspDhb6174bpD5LkdihDZpJ77tMXGKo4E9N2gUuHDCIaP8fUXBoYYH5KQlUt+08qWDN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338697; c=relaxed/simple;
	bh=VNfAkT7EkSJb7rl6TV4/rKNU5DqkbcOLuCB67d1AX1I=;
	h=Date:To:From:Subject:Message-Id; b=i1J4jhJiftLa9wwGF4+08cHCfcQDPLWRr41caPX1R5jJ/Qq4bhrXVOZMBhfzBEsKKS6ESK/MmiOaivH+mUbe7CAt6DDdSKwB5nripbJ/Apl4xey1WRyNoqe8mu7a+D9Zebi4zlV/RvBAK3Wj1V5jLhlu65L76oGi7oJJAj/IRN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m3jN4FpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m3jN4FpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CD91F0089B;
	Wed,  7 Oct 2026 02:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338696;
	bh=y0RTLG4Ht0TgclRyQ+CYktYeeZOJiXMJwkrbthkb0Vs=;
	h=Date:To:From:Subject;
	b=m3jN4FpYDAtgWc1AESCOuXuNgSTr2++iCbinrpYt/1aQXaJeTFcO2Wi+E+8ZqI+7E
	 kxMaF0gHa4WjywP/zDI2S4+5gPhlPo11A4NJyH1Lk2y16wJWIOZJlQkNJ4Ya2MtPU8
	 /m7IMdtMLbBjxNsU56bPGkjccVxWS+oUwz76yx5o=
Date: Tue, 06 Oct 2026 19:04:55 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch removed from -mm tree
Message-Id: <20261007020456.33CD91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: ignore <inttypes.h> format macros for userspace tools
has been removed from the -mm tree.  Its filename was
     checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: checkpatch: ignore <inttypes.h> format macros for userspace tools
Date: Fri, 4 Sep 2026 13:02:28 +0200

Constants from <inttypes.h> are used only in userspace tools, they are
from ISO C99, let's don't report it:

    arch/mips/boot/tools/relocs.c:572: CHECK: Avoid CamelCase: <PRIx32>
    arch/s390/tools/relocs.c:52: CHECK: Avoid CamelCase: <PRIu64>
    tools/testing/selftests/mm/vm_util.c:244: CHECK: Avoid CamelCase: <SCNu64>

Link: https://lore.kernel.org/20260904110230.1219037-3-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-ignore-inttypesh-format-macros-for-userspace-tools
+++ a/scripts/checkpatch.pl
@@ -5950,6 +5950,8 @@ sub process {
 #Ignore SI style variants like nS, mV and dB
 #(ie: max_uV, regulator_min_uA_show, RANGE_mA_VALUE)
 			    $var !~ /^(?:[a-z0-9_]*|[A-Z0-9_]*)?_?[a-z][A-Z](?:_[a-z0-9_]+|_[A-Z0-9_]+)?$/ &&
+#Ignore <inttypes.h> format macros (e.g. PRIu64, SCNu64)
+			    (is_userspace($realfile) ? $var !~ /^(?:PRI|SCN)[dioux][A-Z0-9]+$/ : 1) &&
 #Ignore some three character SI units explicitly, like MiB and KHz
 			    $var !~ /^(?:[a-z_]*?)_?(?:[KMGT]iB|[KMGT]?Hz)(?:_[a-z_]+)?$/) {
 				while ($var =~ m{\b($Ident)}g) {
_

Patches currently in -mm which might be from pvorel@suse.cz are



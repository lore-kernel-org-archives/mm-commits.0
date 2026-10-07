Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B3175A86;
	Wed,  7 Oct 2026 02:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338640; cv=none; b=athHWAg+933CMrfXluMmkKD0lILpoVvM/6CYlDmlAqW+0BRn5K3UQtmUQJ++HEgteorR3NuTFKsZ60Y84viHPcPq/R1qNQX/QaYZwLB3Pi+355l9Y//0L07m8UKs7XocfBwBgmwM8mKBID4iUPhg234kiXtn0VfZYAmplihvNxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338640; c=relaxed/simple;
	bh=T5IyHeWvnaJaC/Tr75Bt3ps6+nA4+6bsKotE9l4kvOQ=;
	h=Date:To:From:Subject:Message-Id; b=hrz7vuZvz8lx2A9OZ4KLTy4a3nQp/a3kGOZsqBfWLFeNj+21dksyKuT5jKsp1dyuMeJJukaiDhiDKmlXUGVBWhPeahAIy+js7Efma2eIMM/HYoPF4AMyH2wcaXwz1Svw1Mz8h9Cb/lbHR2J2zeoAOGSaSJyJAbqrcBSPj+WiHZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=huhjbCPK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="huhjbCPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5BB1F0089C;
	Wed,  7 Oct 2026 02:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338639;
	bh=K+OjDyOck+R0rm8mOxChG+C+/tDLvI1BvcAb5NtZ1+o=;
	h=Date:To:From:Subject;
	b=huhjbCPKYbGKbu58ltcqpmUN1R3djCY5I2vaJDqIvTATlObI4OzBq6A03cfUgc4Kx
	 brykyGuuMlV2oCPaVWbPkh8g0nY7lezaYaFj+EL2rDv3nGQsRf7D6oedUuoH0Sz0uH
	 3KbK5cEQ6oAiG+dYJSeZCMKX+H2LiTCG6FnPZGFE=
Date: Tue, 06 Oct 2026 19:03:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,dmoulding@me.com,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-fix-early-boot-crash-with-bare-hostname-parameter.patch removed from -mm tree
Message-Id: <20261007020359.BC5BB1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: fix early boot crash with bare hostname parameter
has been removed from the -mm tree.  Its filename was
     init-fix-early-boot-crash-with-bare-hostname-parameter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <blum@kernel.org>
Subject: init: fix early boot crash with bare hostname parameter
Date: Wed, 26 Aug 2026 12:09:03 +0200

When a bare hostname parameter is specified on the kernel command line
without the '=' separator, early parameter parsing passes NULL to
early_hostname(), which dereferences it in strscpy() and can crash the
system during early boot.

Reject NULL values in early_hostname() and return -EINVAL instead.

Link: https://lore.kernel.org/20260826100904.296151-2-blum@kernel.org
Fixes: 5a704629f2c1 ("init: add "hostname" kernel parameter")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Moulding <dmoulding@me.com>
Cc: <stable@vger.kernel.org>
---

 init/version.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/init/version.c~init-fix-early-boot-crash-with-bare-hostname-parameter
+++ a/init/version.c
@@ -23,6 +23,9 @@ static int __init early_hostname(char *a
 	size_t maxlen  = bufsize - 1;
 	ssize_t arglen;
 
+	if (!arg)
+		return -EINVAL;
+
 	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
 	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
_

Patches currently in -mm which might be from blum@kernel.org are



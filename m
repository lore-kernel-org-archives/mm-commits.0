Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632418C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628629; cv=none; b=VVwDPQ0PCwvEGl75/CPGwDOr1TXutqHZoTMI9vuIzhspcNEgbOQzrNGT6h5D72Q9m28cdgX/tenf6t28jdMcMaM6JXi8zsDt/QjksIJl1xa58UwVOtOcjemzehQMO1YqczkZDLFALnG7VIxgqpR+zNT8gZZ4SlCOMQ0LmP8268A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628629; c=relaxed/simple;
	bh=DGeOtFXEg2DP30DH3uGwQ9uTr1B9aMRz4rVPvqGfY7E=;
	h=Date:To:From:Subject:Message-Id; b=uT1O9nYowW4GpCHEaW5HZXxGKfnJ5Yd8+8PY+xZTnUAWkNwirTIVSzfv50tPXnwhLPnvxSGLLKxLu6oonIO1qJaEeNnterYn0ChQe1RgRD3sjx5d2qT4ID0ti045yGQ2aK/6WiTIF3uqmnOoP27yB94Y8xUO4YNFbUg58EuxO6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gNhFTz79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gNhFTz79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E59C116B1;
	Sat, 29 Jun 2024 02:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628629;
	bh=DGeOtFXEg2DP30DH3uGwQ9uTr1B9aMRz4rVPvqGfY7E=;
	h=Date:To:From:Subject:From;
	b=gNhFTz79VNRhm98qtOAUDpmB7J6K+qu3PJL2s269wRKwMnhYxvfyDBi+0HTmvmboe
	 UGGmOxAG82bJ8dfx/hzl/A3kUTymmE85R+m+iJ+EtGB+n5FGbuJ+0+fo04Ebkw4yuF
	 eAtesT8T8cyFj+Gi54ZHmKoZ6chWm0F4XgTztyuY=
Date: Fri, 28 Jun 2024 19:37:08 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch removed from -mm tree
Message-Id: <20240629023708.F3E59C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: change VA_BITS_MIN when we use 16K page
has been removed from the -mm tree.  Its filename was
     scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: change VA_BITS_MIN when we use 16K page
Date: Wed, 19 Jun 2024 15:49:10 +0800

Change VA_BITS_MIN when we use 16K page.

Link: https://lkml.kernel.org/r/20240619074911.100434-6-kuan-ying.lee@canonical.com
Fixes: 9684ec186f8f ("arm64: Enable LPA2 at boot if supported by the system")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-change-va_bits_min-when-we-use-16k-page
+++ a/scripts/gdb/linux/mm.py
@@ -47,7 +47,10 @@ class aarch64_page_ops():
 
         self.VA_BITS = constants.LX_CONFIG_ARM64_VA_BITS
         if self.VA_BITS > 48:
-            self.VA_BITS_MIN = 48
+            if constants.LX_CONFIG_ARM64_16K_PAGES:
+                self.VA_BITS_MIN = 47
+            else:
+                self.VA_BITS_MIN = 48
             tcr_el1 = gdb.execute("info registers $TCR_EL1", to_string=True)
             tcr_el1 = int(tcr_el1.split()[1], 16)
             self.vabits_actual = 64 - ((tcr_el1 >> 16) & 63)
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are



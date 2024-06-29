Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1F718C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628628; cv=none; b=fFnezkT2vjxxcrEHTeoF1UhM3CTG3z0x7bmkqwDTytC8FBo3n68xx0BtHDJ4aPWjpRlbpqIBEPvPNkFvCLVoJ8ixe+irEGR+SF/hOWaIHfo6ns1ADBVf7bSEWGfir8Ky2p8K05BydhzESoX0LJXaJFuKOJmEVaxnR3F/dyVN0R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628628; c=relaxed/simple;
	bh=8Zc8cWvQEsf3FRuGA4R+31bt9IeYnsdSjrrgKs3O+3w=;
	h=Date:To:From:Subject:Message-Id; b=B2Dd/al5Wu0Vbnj3+2nZjymI4qx8HiRrKWpBQt9ZOZONmwlBgejx/zsIjMypGP3gJgH53nWoTsUq1vUnTXHg9s03dId3cF2iU5vjcl6aboyIkY8l76YNAx4k9Ng8gFE+2gMGayGWlGypuCOHveFRL8DjWQhA0R7ksvyyYPF5Ay0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vtwMP8gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vtwMP8gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D674DC116B1;
	Sat, 29 Jun 2024 02:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628627;
	bh=8Zc8cWvQEsf3FRuGA4R+31bt9IeYnsdSjrrgKs3O+3w=;
	h=Date:To:From:Subject:From;
	b=vtwMP8gr94GU9K90U8TXcpQvn2QfU/83/g3/3iWX9UPfOKVphCqOzn52YApMbbcXr
	 N2Pz+JoYGXAloz4cwELFzy+68+lKUDcXHnU92x8exQkpeihzj9AWJWQuLiLIdyzwYJ
	 IlWGv1Hijm91AtZatfeFpT7dtuJCDVmYrbc5gqIE=
Date: Fri, 28 Jun 2024 19:37:07 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch removed from -mm tree
Message-Id: <20240629023707.D674DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: set vabits_actual based on TCR_EL1
has been removed from the -mm tree.  Its filename was
     scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: set vabits_actual based on TCR_EL1
Date: Wed, 19 Jun 2024 15:49:09 +0800

We encounter the following issue after commit 9cce9c6c2c3b ("arm64: mm: Handle
LVA support as a CPU feature").

(gdb) lx-slabinfo
Python Exception <class 'gdb.error'>: No symbol "vabits_actual" in current context.
Error occurred in Python: No symbol "vabits_actual" in current context.

We set vabits_actual based on TCR_EL1 value when
VA_BITS is bigger than 48.

Link: https://lkml.kernel.org/r/20240619074911.100434-5-kuan-ying.lee@canonical.com
Fixes: 9cce9c6c2c3b ("arm64: mm: Handle LVA support as a CPU feature")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-set-vabits_actual-based-on-tcr_el1
+++ a/scripts/gdb/linux/mm.py
@@ -48,7 +48,9 @@ class aarch64_page_ops():
         self.VA_BITS = constants.LX_CONFIG_ARM64_VA_BITS
         if self.VA_BITS > 48:
             self.VA_BITS_MIN = 48
-            self.vabits_actual = gdb.parse_and_eval('vabits_actual')
+            tcr_el1 = gdb.execute("info registers $TCR_EL1", to_string=True)
+            tcr_el1 = int(tcr_el1.split()[1], 16)
+            self.vabits_actual = 64 - ((tcr_el1 >> 16) & 63)
         else:
             self.VA_BITS_MIN = self.VA_BITS
             self.vabits_actual = self.VA_BITS
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are



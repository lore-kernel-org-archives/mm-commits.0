Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D581111A8
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845971; cv=none; b=mfsvkUznBmIXjnDKGfI/OBOXJcR0eK9I4di5FNdpCIJwxKN78M1/q9ORWmeA0bU5rLkyW5y/we2evYVbCPdvXuGKg0e+nlDlgWmngXjLboUSGjdoBXU++4m8uCNjp/5J/+2LeqZTuZP0/a2/8E1xhNEdIJW5csmmvCENgZVP/+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845971; c=relaxed/simple;
	bh=LSmROh41tZ4DaWEwRyA2c86jxBcjUt+qwXNtfz9OIwM=;
	h=Date:To:From:Subject:Message-Id; b=TGXmg0Jg1BV4kHUc89NJZliIablZeR/d2Q9y7LdNhCMrsUF/d2HeiX0GnpmAhKvpj4OrNhfV1KKTyfu7Y0s+xyUv0wbUVSdDI0AL67MCm7AH7papjzzVUC/naTReHjgu8Vj6cVsFCspKlho3jadZKRFQUXZ2ECFHGeMlV+hr1p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oEJxZ4LS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oEJxZ4LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C32C2BBFC;
	Thu, 20 Jun 2024 01:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845971;
	bh=LSmROh41tZ4DaWEwRyA2c86jxBcjUt+qwXNtfz9OIwM=;
	h=Date:To:From:Subject:From;
	b=oEJxZ4LSoEfpc3gw23+0HXwdS8u8fqswMmsMhzR+N8J15WMEQnJFIfz7hrpNcIFNL
	 x/9Q5sXBnTs/k6x66AAt4pD4JPW4Dy/fd1h15RuYvFD6NttkYYGdYor9YeGPv1WyEP
	 y9LMNXodqjRCqntmgCR0stOvkqXuKiMjdg6sfi2Q=
Date: Wed, 19 Jun 2024 18:12:50 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch added to mm-nonmm-unstable branch
Message-Id: <20240620011251.60C32C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: set vabits_actual based on TCR_EL1
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch

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

scripts-gdb-redefine-max_order-sanely.patch
scripts-gdb-rework-module-va-range.patch
scripts-gdb-change-the-layout-of-vmemmap.patch
scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch
scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch
scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch


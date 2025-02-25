Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813831853
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454284; cv=none; b=R7o1WqR8ELFA9NjV4D45C/Nh7r8qWPqeFavEFxLfwStD4Shpc8LNzoNY+aVBkTdPBwN/yXcl+ur6uUfZmz7pnPcjr3vLpCc5YBsLo2dUim6ojer4gV2MrPAGkrhgoL0llYy/oQohx52Zvjz/VN1YgMbetWnIY1R5gTf+zENPMfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454284; c=relaxed/simple;
	bh=fhbjlfMBxLDG7DYYOUhhGc1pP57lULiE3ZkTh5tw2to=;
	h=Date:To:From:Subject:Message-Id; b=gUWRL5x1puEoDB253UZwYmbh7Aqba6t4kGmUt5J3ZPGCXv0IkzNaui/2sXtOCImriDq7L77y4bMGtiPICId1tiRkUUuTsFD7p9IXRZ/1VHuBU0Nvb/WvO4gHBLxINyQ7QWhtCEbhtGg4PQnIOEdxlQJAJtYgxHvmwSQmLvOuebI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIODZPDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIODZPDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2546C4CEE2;
	Tue, 25 Feb 2025 03:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454284;
	bh=fhbjlfMBxLDG7DYYOUhhGc1pP57lULiE3ZkTh5tw2to=;
	h=Date:To:From:Subject:From;
	b=qIODZPDD8lwEgunHABiMlbyLPAWMKtkyKGZoqMVK08bv3cx1ouMeHSsEbMRdxhUc6
	 1ZWuiSBm/Sb6BVE5Dp70A6UQcVpmj4znHoIs3N3Zoh9XnWqK+fHOAOhnrQqYfwmL78
	 qTM1EnncT7vIRpfAqm66ey8ExLt/zUnqF3FiV49I=
Date: Mon, 24 Feb 2025 19:31:23 -0800
To: mm-commits@vger.kernel.org,seanjc@google.com,pbonzini@redhat.com,binbin.wu@linux.intel.com,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-log2h-mark-is_power_of_2-with-__always_inline.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225033123.F2546C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/log2.h: mark is_power_of_2() with __always_inline
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     include-linux-log2h-mark-is_power_of_2-with-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-log2h-mark-is_power_of_2-with-__always_inline.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Su Hui <suhui@nfschina.com>
Subject: include/linux/log2.h: mark is_power_of_2() with __always_inline
Date: Fri, 21 Feb 2025 15:16:25 +0800

When building kernel with randconfig, there is an error:

In function `kvm_is_cr4_bit_set',inlined from
`kvm_update_cpuid_runtime' at arch/x86/kvm/cpuid.c:310:9:

include/linux/compiler_types.h:542:38: error: call to
`__compiletime_assert_380' declared with attribute error:
BUILD_BUG_ON failed: !is_power_of_2(cr4_bit).

'!is_power_of_2(X86_CR4_OSXSAVE)' is False, but gcc treats is_power_of_2()
as non-inline function and a compilation error happens. Fix this by marking
is_power_of_2() with __always_inline.

Link: https://lkml.kernel.org/r/20250221071624.1356899-1-suhui@nfschina.com
Signed-off-by: Su Hui <suhui@nfschina.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/log2.h~include-linux-log2h-mark-is_power_of_2-with-__always_inline
+++ a/include/linux/log2.h
@@ -41,7 +41,7 @@ int __ilog2_u64(u64 n)
  * *not* considered a power of two.
  * Return: true if @n is a power of 2, otherwise false.
  */
-static inline __attribute__((const))
+static __always_inline __attribute__((const))
 bool is_power_of_2(unsigned long n)
 {
 	return (n != 0 && ((n & (n - 1)) == 0));
_

Patches currently in -mm which might be from suhui@nfschina.com are

include-linux-log2h-mark-is_power_of_2-with-__always_inline.patch


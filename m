Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D523029CF0
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239457; cv=none; b=gRtnuVfIHw5tpNVVzVGvxr7dNoYbNnk8QWtISQRMTLyg+KjsoKM4AWZskiWzh5rEKHJAetrRVcGa5CqNl6uUZBPq/392PokX2HdELavcaox61+B+VBiyk6l//kTS/Kj0Rh5/10gCXcMoo5jfHPS0JRXpZlFJLrh36/IATgM4jjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239457; c=relaxed/simple;
	bh=vjFdWe5O58wA5jGZwOms8+Bjz5weDRUdUpxVlDJUwIE=;
	h=Date:To:From:Subject:Message-Id; b=KpBX71wQKNfZ7TQc0FeKmFmAR5Rupw+3sxBe5bQZYhFieASc0G3ae+6Vq3zinCtUkTaPLzdhcaiK2lWAr53WBvXkvf7I/1zaEETMqUM0fvr+6DD19wA2ciHp4OgCUwHHSoLKEK/5QnlckzgNDT8iK7WD4OXZyYCumijjrSjGOa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aFeqyyGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aFeqyyGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496F1C4CEE4;
	Thu,  6 Mar 2025 05:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239457;
	bh=vjFdWe5O58wA5jGZwOms8+Bjz5weDRUdUpxVlDJUwIE=;
	h=Date:To:From:Subject:From;
	b=aFeqyyGoFHBudcv7cTbR08pgn9CGBtXdI9be/xT/r5Mdivk8NDp5EQA36g0TQnwrY
	 5m+lUuYmKl7saKxemWPkmB7sKXRncVE+a7y5JensgCiskID2Tl+8x6DIhhNpCfae4E
	 xLshl35RSn0gFOgYLu3DtTgeBjNkcyX1H1ddsPLk=
Date: Wed, 05 Mar 2025 21:37:36 -0800
To: mm-commits@vger.kernel.org,seanjc@google.com,pbonzini@redhat.com,binbin.wu@linux.intel.com,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] include-linux-log2h-mark-is_power_of_2-with-__always_inline.patch removed from -mm tree
Message-Id: <20250306053737.496F1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/log2.h: mark is_power_of_2() with __always_inline
has been removed from the -mm tree.  Its filename was
     include-linux-log2h-mark-is_power_of_2-with-__always_inline.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



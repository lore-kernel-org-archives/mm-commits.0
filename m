Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2CA2629D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854813; cv=none; b=MRL12CucfAvKrf/ATsekd8vuUt2GXXpuSW1Z4a6jQB0Wc/ydCV9wKm73akfUuxmOMkq1Wuncx1xvDBtPT8ST6FB1zZ545b7LclgUOvL/yOcJVt2B3Ne2atWKDODaBFgNJzxLt62jzz1KzXnanHR+Z6Em/PLIsmNEjNrEM8Z98p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854813; c=relaxed/simple;
	bh=Bat2Ig9RcJxmMVL3l3yf7UGQRTvJkDqis2Z/F8GuFBI=;
	h=Date:To:From:Subject:Message-Id; b=Tn3RUvVZIEPylyzdcXdpgtotuFuOHYUYfeUvU3t1MBtR9DAbdfYMBRNftlouf/y+MfUBsZ2EORMOC7a5uinqEgSNZ8Jqr0YuS5rbWTaIIAhbI8sb76uP28/wqBICmsNoTQAArYj+OnlV42Q29RZWQ3twlyQrLidy5yhg3EPm7O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZNOtKfvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZNOtKfvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6566FC4CECF;
	Wed,  6 Nov 2024 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854813;
	bh=Bat2Ig9RcJxmMVL3l3yf7UGQRTvJkDqis2Z/F8GuFBI=;
	h=Date:To:From:Subject:From;
	b=ZNOtKfvn3m0n2OXcDUHaTzLdKHDwPPN3vz6rp1JLK9dYDOj0BqaTQs3jXThhZO8jw
	 GJTRNO2+F+V+2aXsb+Q06LsNZ7IG9E5geCniTXBlHq67xNELpxZnZqmMTR9zZDGRLi
	 HED3+jv3GTNYuSvs5HqOQXL+PeWqpU0aXQE9OZb8=
Date: Tue, 05 Nov 2024 17:00:12 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tj@kernel.org,tglx@linutronix.de,mingo@redhat.com,mingo@kernel.org,hpa@zytor.com,dennis@kernel.org,dave.hansen@linux.intel.com,cl@linux.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch removed from -mm tree
Message-Id: <20241106010013.6566FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/percpu: fix clang warning when dealing with unsigned types
has been removed from the -mm tree.  Its filename was
     x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: x86/percpu: fix clang warning when dealing with unsigned types
Date: Wed, 16 Oct 2024 21:23:51 +0300

Patch series "percpu: Add a test case and fix for clang", v2.

Add a test case to percpu to check a corner case with the specific 64-bit
unsigned value.  This test case shows why the first patch is done in the
way it's done.

The before and after has been tested with binary comparison of the
percpu_test module and runnig it on the real Intel system.


This patch (of 2):

When percpu_add_op() is used with an unsigned argument, it prevents kernel
builds with clang, `make W=1` and CONFIG_WERROR=y:

net/ipv4/tcp_output.c:187:3: error: result of comparison of constant -1 with expression of type 'u8' (aka 'unsigned char') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
  187 |                 NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPACKCOMPRESSED,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  188 |                               tp->compressed_ack);
      |                               ~~~~~~~~~~~~~~~~~~~
...
arch/x86/include/asm/percpu.h:238:31: note: expanded from macro 'percpu_add_op'
  238 |                               ((val) == 1 || (val) == -1)) ?            \
      |                                              ~~~~~ ^  ~~

Fix this by casting -1 to the type of the parameter and then compare.

Link: https://lkml.kernel.org/r/20241016182635.1156168-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20241016182635.1156168-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/percpu.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/percpu.h~x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types
+++ a/arch/x86/include/asm/percpu.h
@@ -234,9 +234,10 @@ do {									\
  */
 #define percpu_add_op(size, qual, var, val)				\
 do {									\
-	const int pao_ID__ = (__builtin_constant_p(val) &&		\
-			      ((val) == 1 || (val) == -1)) ?		\
-				(int)(val) : 0;				\
+	const int pao_ID__ =						\
+		(__builtin_constant_p(val) &&				\
+			((val) == 1 ||					\
+			 (val) == (typeof(val))-1)) ? (int)(val) : 0;	\
 									\
 	if (0) {							\
 		typeof(var) pao_tmp__;					\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch


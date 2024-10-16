Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B630C1D2780
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729116365; cv=none; b=fZlAW5GjOiaHzlQXtw1P082kqqTB9lGSByb7eaokfomD088fjNsnAkQ0ZPJaCBI4C8BXT3ARIUR3tBxQTF0Per05RqlZ2JsnN59hKWjHRt4s0tW0C+afFr2gL/uoAYaiFiB1Ba/BCwfEcsYOZxNjOTyIBKbobMdGiB1KtglF5AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729116365; c=relaxed/simple;
	bh=Pi8LqEU7h1vByMiES/7c+JW0MQeZ9SLecBSmCztzVwc=;
	h=Date:To:From:Subject:Message-Id; b=kQPYUiClMQUrx4tsO4sngKftgn7edtAIBaNeOxAe8mOEAyVNpKxK5v7YLj20DWft+44VquiC/DxX82pbVY/L9Sc79si2V1e1S2ci4BBhxEvHz/Axt8PogDhCQH0xBFXSXVSzLooxCSZ/K7G6IdUjwAc/sgVOIko2+nOfmtf0Oqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z9comha8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z9comha8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B7DC4CEC5;
	Wed, 16 Oct 2024 22:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729116365;
	bh=Pi8LqEU7h1vByMiES/7c+JW0MQeZ9SLecBSmCztzVwc=;
	h=Date:To:From:Subject:From;
	b=z9comha81A1WUwcFnpNq/IKoVdjTlTfG0eG/E3XHesDeNfb5Gsx0CtLCfFPofqA+K
	 umzj4TeHrdDES0IJuz8v7ZrSPijBoY5mI5BCJlRh6dvdrrOrxVhikNfgnNMNMReFSh
	 I8w+ZoZl7ev0CEhwj/MikKRq80PLRtDuFgG/w2Ok=
Date: Wed, 16 Oct 2024 15:06:04 -0700
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tj@kernel.org,tglx@linutronix.de,mingo@redhat.com,mingo@kernel.org,hpa@zytor.com,dennis@kernel.org,dave.hansen@linux.intel.com,cl@linux.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch added to mm-unstable branch
Message-Id: <20241016220605.18B7DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/percpu: fix clang warning when dealing with unsigned types
has been added to the -mm mm-unstable branch.  Its filename is
     x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch

This patch will later appear in the mm-unstable branch at
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

mm-remove-unused-stub-for-can_swapin_thp.patch
x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch
percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch
resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch


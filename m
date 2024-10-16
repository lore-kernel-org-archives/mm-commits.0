Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1280E1D2F5F
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729117308; cv=none; b=dW1P760oS4Qy9ksXYueTrpolhGZlgA9UFNfH0999/AKIsxwO+Mt1Lf58pi4ilBwUFg78xE10J7xIr/5e62q867C3ZlO1A/jpbzS+Ypl8EJ2ENCTfp1nPSDAMAkggfrMuRxi/4SNS/6DzuWEoXRgtidJFXDSKUL10YsBy6FkYpio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729117308; c=relaxed/simple;
	bh=f9GnLNyoJn+m1IpF3Cm2i/ztzhw2gvSABB7EgcKp/HI=;
	h=Date:To:From:Subject:Message-Id; b=t2S/rmm+tbi3XqDqIAr1Uhr0s2Yqlv1woTS7FdhTEmzSYSF1CHbAEMpJD/EjLCalAC1IerKcoh9oQQWf+gZDSmfEtkx5bjSd84nmkwRXkqg4j57HUqGks20eCd97ASWkf/nLZrvK9W2q9w3DpTMj062+JfLuGFgbOwmMYUKSEaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aeHT9So3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aeHT9So3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8BAC4CEC5;
	Wed, 16 Oct 2024 22:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729117307;
	bh=f9GnLNyoJn+m1IpF3Cm2i/ztzhw2gvSABB7EgcKp/HI=;
	h=Date:To:From:Subject:From;
	b=aeHT9So3lTSkLEqNBPKN1eBi/z7X8REssJP743NwC/cW5CIdF25yyeBHKkJnQSruK
	 SJUh8Zcjy8lM0PO3fXyX9svpPW4YSeOAVbPPCZpfXkwPiT2PBo6MEN/VpJOntzwItZ
	 wOpzkdLhoe6AhkWEq89x+Z76bbBRI8i6TeHQ2rb4=
Date: Wed, 16 Oct 2024 15:21:46 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,siyanteng@loongson.cn,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,andreyknvl@gmail.com,alexs@kernel.org,2023002089@link.tyut.edu.cn,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-move-checks-to-do_strncpy_from_user.patch added to mm-unstable branch
Message-Id: <20241016222147.7D8BAC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: move checks to do_strncpy_from_user
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-move-checks-to-do_strncpy_from_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-move-checks-to-do_strncpy_from_user.patch

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
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan: move checks to do_strncpy_from_user
Date: Wed, 16 Oct 2024 18:18:00 +0500

Patch series "kasan: migrate the last module test to kunit", v4.

copy_user_test() is the last KUnit-incompatible test with
CONFIG_KASAN_MODULE_TEST requirement, which we are going to migrate to
KUnit framework and delete the former test and Kconfig as well.

In this patch series:

	- [1/3] move kasan_check_write() and check_object_size() to
		do_strncpy_from_user() to cover with KASAN checks with
		multiple conditions	in strncpy_from_user().

	- [2/3] migrated copy_user_test() to KUnit, where we can also test
		strncpy_from_user() due to [1/4].

		KUnits have been tested on:
		- x86_64 with CONFIG_KASAN_GENERIC. Passed
		- arm64 with CONFIG_KASAN_SW_TAGS. 1 fail. See [1]
		- arm64 with CONFIG_KASAN_HW_TAGS. 1 fail. See [1]
		[1] https://lore.kernel.org/linux-mm/CACzwLxj21h7nCcS2-KA_q7ybe+5pxH0uCDwu64q_9pPsydneWQ@mail.gmail.com/

	- [3/3] delete CONFIG_KASAN_MODULE_TEST and documentation occurrences.


This patch (of 3):

Since in the commit 2865baf54077("x86: support user address masking
instead of non-speculative conditional") do_strncpy_from_user() is called
from multiple places, we should sanitize the kernel *dst memory and size
which were done in strncpy_from_user() previously.

Link: https://lkml.kernel.org/r/20241016131802.3115788-1-snovitoll@gmail.com
Link: https://lkml.kernel.org/r/20241016131802.3115788-2-snovitoll@gmail.com
Fixes: 2865baf54077 ("x86: support user address masking instead of non-speculative conditional")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/strncpy_from_user.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/strncpy_from_user.c~kasan-move-checks-to-do_strncpy_from_user
+++ a/lib/strncpy_from_user.c
@@ -120,6 +120,9 @@ long strncpy_from_user(char *dst, const
 	if (unlikely(count <= 0))
 		return 0;
 
+	kasan_check_write(dst, count);
+	check_object_size(dst, count, false);
+
 	if (can_do_masked_user_access()) {
 		long retval;
 
@@ -142,8 +145,6 @@ long strncpy_from_user(char *dst, const
 		if (max > count)
 			max = count;
 
-		kasan_check_write(dst, count);
-		check_object_size(dst, count, false);
 		if (user_read_access_begin(src, max)) {
 			retval = do_strncpy_from_user(dst, src, count, max);
 			user_read_access_end();
_

Patches currently in -mm which might be from snovitoll@gmail.com are

x86-traps-move-kmsan-check-after-instrumentation_begin.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault.patch
kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch


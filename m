Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632A16130A
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629080; cv=none; b=EtyImgXPGxOfFt1z4VPmGAS3n9qhwAJA0mlCLQQEGcDcPBAL/LwtfFxeQ2jP5Fw3iv2k1WEcfrkV0sK4uZnplVITK8TWxYI2JDjXk+lJhzZcVb1F971Urnm2vhmdMrPvZZN+8cCvMKGjnttEuKKpjcfNv/lnGdicsh4iqYnmVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629080; c=relaxed/simple;
	bh=Hdn9CWXtlf5QUUpN6ED9gmd1GwTzRG+Cr1xCitP2GJ0=;
	h=Date:To:From:Subject:Message-Id; b=mLqJm1ZBxL3ZAGDBSXjtsu+VfXO7UTPIo3/QcOASEl6AqFxFwYg3mujkThFEhqSuCU707rskPn6I1woDQJY8hHXSDc4IHFAUOXMQ7hkNkl0U1RYIOlMRH+HNoeWaY1zwAi7gQHydspQYy4T1YzT+1KZ1zpBHQKC7d9+azvKwjA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w1kC9uQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w1kC9uQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D43DC32782;
	Wed,  5 Jun 2024 23:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717629080;
	bh=Hdn9CWXtlf5QUUpN6ED9gmd1GwTzRG+Cr1xCitP2GJ0=;
	h=Date:To:From:Subject:From;
	b=w1kC9uQrmGZKInvEhfO2V0TU9ymWA+KVWPGOxlhncE6OMVXQ3TQPUfMJD+p++ahNc
	 ZWXUACTPLDKklSzqJNGPoAJ0kjcj/QHrUvZg4ekA8n0QI2zr9wOG1mSoYX34jyKAI6
	 aCfK0t+76dpJ68I4i96l0tfUVSGsiyxhvkBqrWek=
Date: Wed, 05 Jun 2024 16:11:19 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-add-missing-module_description-macro.patch added to mm-unstable branch
Message-Id: <20240605231120.7D43DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_hmm: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-add-missing-module_description-macro.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: lib: test_hmm: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 16:26:03 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_hmm.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-lib-md-test_hmm-v1-1-e4aa17daa57b@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_hmm.c~lib-test_hmm-add-missing-module_description-macro
+++ a/lib/test_hmm.c
@@ -1550,4 +1550,5 @@ static void __exit hmm_dmirror_exit(void
 
 module_init(hmm_dmirror_init);
 module_exit(hmm_dmirror_exit);
+MODULE_DESCRIPTION("HMM (Heterogeneous Memory Management) test module");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
test_xarray-add-missing-module_description-macro.patch
ubsan-add-missing-module_description-macro.patch
test_maple_tree-add-the-missing-module_description-macro.patch
lib-test_hmm-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch


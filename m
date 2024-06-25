Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF383145347
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293203; cv=none; b=dZKY7nELee8c97MGoeiizZItXRBculF5qHxyuzidJgS5+o9JEYPRSwdJkFu4CzzN3hhvATCkZv5PI5aA/k9rRaGb92v/JCJ5luKMMoMlVbqZwetZ3j9mT1wQ7oGdfMP6PcXk7NK3rSECyap7/pfVlcdCsDTH/8SnyDSICkU8Kys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293203; c=relaxed/simple;
	bh=wYdBTe0Osi/4GVamFeKaBEe2BBHerIo2b3imzuPWUPA=;
	h=Date:To:From:Subject:Message-Id; b=UZBlKxNcwE/2IAR61HaT3togKDpDxQyZ3h2LTJ+tTAHFfqaKBXmqsVnRwAVKoqv5NP9ElM7HgIoZQF2DDSzkzgRtKlbRV11NZEYKnLBI+yssJMjzuJqU07Nljp/UTYubfAlD+hnonNhUivf9Yavav3Bu2WCEKzghfa1xy7XjW6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1saI9VZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1saI9VZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D01C32782;
	Tue, 25 Jun 2024 05:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293202;
	bh=wYdBTe0Osi/4GVamFeKaBEe2BBHerIo2b3imzuPWUPA=;
	h=Date:To:From:Subject:From;
	b=1saI9VZf51cGx+/GvAVjyrFN0JDrvBTFA0Ytr/5NCTKGvTN6nILrnYcA56Fi21nGn
	 +Mn4wz+f2fuJSFGrL3jk/s6aQmd4CN9aNgIuQVOPG/oJRwJ7d7bTU1A1vI+Tr6vp0M
	 9e+1/lsQDo2t9076X0Ri0FGXIz7X4KHJLg2FbM2Q=
Date: Mon, 24 Jun 2024 22:26:42 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kunit-add-missing-module_description-macros-for-lib-_testko.patch removed from -mm tree
Message-Id: <20240625052642.B3D01C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KUnit: add missing MODULE_DESCRIPTION() macros for lib/*_test.ko
has been removed from the -mm tree.  Its filename was
     kunit-add-missing-module_description-macros-for-lib-_testko.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: KUnit: add missing MODULE_DESCRIPTION() macros for lib/*_test.ko
Date: Sat, 1 Jun 2024 16:33:23 -0700

make allmodconfig && make W=1 C=1 reports for lib/*_test.ko:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/atomic64_test.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/hashtable_test.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-lib-test2-v1-1-be764b785f17@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64_test.c  |    1 +
 lib/hashtable_test.c |    1 +
 2 files changed, 2 insertions(+)

--- a/lib/atomic64_test.c~kunit-add-missing-module_description-macros-for-lib-_testko
+++ a/lib/atomic64_test.c
@@ -273,4 +273,5 @@ static __exit void test_atomics_exit(voi
 module_init(test_atomics_init);
 module_exit(test_atomics_exit);
 
+MODULE_DESCRIPTION("Testsuite for atomic64_t functions");
 MODULE_LICENSE("GPL");
--- a/lib/hashtable_test.c~kunit-add-missing-module_description-macros-for-lib-_testko
+++ a/lib/hashtable_test.c
@@ -314,4 +314,5 @@ static struct kunit_suite hashtable_test
 
 kunit_test_suites(&hashtable_test_module);
 
+MODULE_DESCRIPTION("KUnit test for the Kernel Hashtable structures");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch


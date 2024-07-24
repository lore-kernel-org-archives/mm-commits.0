Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE964C84
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 05:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721799101; cv=none; b=pJqcF7JG2C3Y8DCyMcZ6Xc6NB+rgwhMUlcf+mDbh4SS/twxYVL0pCdz6jyaltFXLRw5xWSCyFri73qYe6ldv1BQxkMNjo6PO4nd2QxLkTF5jt8mJEBVDoWq6lJVsWwE6Ftx8llLIHZTl7QZ50Gh9PQfOrZEsUiF54qFl9Vm+7JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721799101; c=relaxed/simple;
	bh=nOGltC4F1anIy2EXoR+nyni+f71Kr2xH7DdUeq0VgB8=;
	h=Date:To:From:Subject:Message-Id; b=WfXS5URa7sF5zcTrcxMroanYS9/rT6w4S9yCgX10NWOXpnWYjgFnuvSXrghAdJsN8/sLR0efXN2RQT2tNQxUKMCTLSC71FPsJgtIRJeTwOo2voyvaC4W5gQRKM/yRcphM4ocEVuTEQY7x0bOVfIfIkZNL4fqAeL24GFaI3WKMuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TY+TZHIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TY+TZHIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8169C32782;
	Wed, 24 Jul 2024 05:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721799100;
	bh=nOGltC4F1anIy2EXoR+nyni+f71Kr2xH7DdUeq0VgB8=;
	h=Date:To:From:Subject:From;
	b=TY+TZHISrw3e6jJccRR1ClFbW0xqq2uk6Z1FoQ68+OKQWiwcL0X7QOiut8TM6J6J1
	 JlBnDhVUAtfO428PgZqRMyPaMr6hwOu5AFQ8bbi6Jo50L7xCQb4P+AMI5FbPfFV+sS
	 CFUjCs2jMBO1pGbvPkVTkTM/KUgsGtTZDv2ke78E=
Date: Tue, 23 Jul 2024 22:31:40 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,broonie@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems.patch added to mm-unstable branch
Message-Id: <20240724053140.D8169C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip test for non-LPA2 and non-LVA systems
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: skip test for non-LPA2 and non-LVA systems
Date: Thu, 18 Jul 2024 10:55:04 +0530

Post my improvement of the test in e4a4ba415419 ("selftests/mm:
va_high_addr_switch: dynamically initialize testcases to enable LPA2
testing"):

The test begins to fail on 4k and 16k pages, on non-LPA2 systems.  To
reduce noise in the CI systems, let us skip the test when higher address
space is not implemented.

Link: https://lkml.kernel.org/r/20240718052504.356517-1-dev.jain@arm.com
Fixes: e4a4ba415419 ("selftests/mm: va_high_addr_switch: dynamically initialize testcases to enable LPA2 testing")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.c |   16 ++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -293,6 +293,20 @@ static int run_test(struct testcase *tes
 	return ret;
 }
 
+#ifdef __aarch64__
+/* Check if userspace VA > 48 bits */
+static int high_address_present(void)
+{
+	void *ptr = mmap((void *)(1UL << 50), 1, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	if (ptr == MAP_FAILED)
+		return 0;
+
+	munmap(ptr, 1);
+	return 1;
+}
+#endif
+
 static int supported_arch(void)
 {
 #if defined(__powerpc64__)
@@ -300,7 +314,7 @@ static int supported_arch(void)
 #elif defined(__x86_64__)
 	return 1;
 #elif defined(__aarch64__)
-	return 1;
+	return high_address_present();
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems.patch


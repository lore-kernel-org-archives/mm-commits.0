Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8CD1C579E;
	Fri, 16 Aug 2024 21:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723843842; cv=none; b=X39ELvVsJOa7eqKuK118ze2mP855pbM+8SSBh2tlgrXkGBqNREJILfAOizGu7A3Iqbcvx22eHDcfGuCTFhltRKL6G0lWzhiArUbRiNPlJ48SiV7I/Y1/RohulCMnPu/MetjxVhy+i2EsEXpO3xfhcwbKfKArlRXrAWSODRlkgAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723843842; c=relaxed/simple;
	bh=u3DSAAUfU08UXeCPRQf7jZvv4EvlO7NBPG5KBltXVNw=;
	h=Date:To:From:Subject:Message-Id; b=hUE6Nmovsg88sUo+5FhkaLxGi5p7cGPZHLDuURAp4L1ksbbwwmlzO42w5SVnhmHrVcDocnbL1tYpg6V5w9Qan7fQ/nQuzjQhhMyJbCt+G9v4vCCQ2n0D2kCejRL9EgYqXpYOpjo4PygS0KXd49SfKvQFKoYGr7NIGa++aWO2Hp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p0Pfj6wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p0Pfj6wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACB2C32782;
	Fri, 16 Aug 2024 21:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723843842;
	bh=u3DSAAUfU08UXeCPRQf7jZvv4EvlO7NBPG5KBltXVNw=;
	h=Date:To:From:Subject:From;
	b=p0Pfj6wH+ANmnS39Se9YZY2750ewrpu7byge4xRSebTLh8Gz+j2eteniS3fxVGB0b
	 eeDy6I1pCSCvliX/DSJQnuLlbaZbZYGaNHiLhv7YNCpiN/gB5Ixwhgco5TzfxItqi2
	 KFrZbVSw3AFoyYMDpJmEjw4ZlsmwL0m6ydbNptSE=
Date: Fri, 16 Aug 2024 14:30:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sourabhjain@linux.ibm.com,hbathini@linux.ibm.com,eric_devolder@yahoo.com,ebiederm@xmission.com,bhe@redhat.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y.patch added to mm-hotfixes-unstable branch
Message-Id: <20240816213042.2ACB2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y.patch

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
From: Petr Tesarik <ptesarik@suse.com>
Subject: kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y
Date: Mon, 5 Aug 2024 17:07:50 +0200

Fix the condition to exclude the elfcorehdr segment from the SHA digest
calculation.

The j iterator is an index into the output sha_regions[] array, not into
the input image->segment[] array.  Once it reaches
image->elfcorehdr_index, all subsequent segments are excluded.  Besides,
if the purgatory segment precedes the elfcorehdr segment, the elfcorehdr
may be wrongly included in the calculation.

Link: https://lkml.kernel.org/r/20240805150750.170739-1-petr.tesarik@suse.com
Fixes: f7cc804a9fd4 ("kexec: exclude elfcorehdr from the segment digest")
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_file.c~kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y
+++ a/kernel/kexec_file.c
@@ -752,7 +752,7 @@ static int kexec_calculate_store_digests
 
 #ifdef CONFIG_CRASH_HOTPLUG
 		/* Exclude elfcorehdr segment to allow future changes via hotplug */
-		if (j == image->elfcorehdr_index)
+		if (i == image->elfcorehdr_index)
 			continue;
 #endif
 
_

Patches currently in -mm which might be from ptesarik@suse.com are

kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y.patch


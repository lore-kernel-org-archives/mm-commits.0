Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794254898;
	b=rsVuTEyV/Zi8YiBmChVprTbovJdU4QPjmrV7XL312XaTKsbO5AW+D8FDIycRR4zpPGN/
	 oANr+h8WaXLGUtCN9bBZLNplONdL6oUxl29eT9wYVJRdJdXsmv6UFc/xP0tkmlBT3tVwY
	 DIdvcWz5kAwNbuwBi5Xj0SMAHuaeQY59qtFk/36mAxMLL0PcrHkw6/n/6P1oy6r1HW/rU
	 UvFaN5qnKn+h8TIKMqz+zo597q5eXOrE4PfmFCW7mW59L9qJgHQ7Em5LHU/PrESJ+Ck55
	 RIswiuJyuX4yCyxbIJoDxnqRRsfTOkzjoU+noAMXP/1YDhj11QqRM1SMomKwiLmDKhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794254898;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=54PUVSCFqeUsNzedYgTE7q6vcx7/2xJEcki4qnKngVE=;
	b=K/kngetqwHOyvvkC505zTbNHVpb+0HcamOBfz/da6drY/jz64hxjMxItQG6W3kbfM0pm
	 NoBoGD/UbTJl9wMAr0IZTtfmgckhqLZHtNjrPN0zMzZkqAPDd/K1Cff7m3QgGUUlO4nfv
	 AJ/asaHUQYoszHaRodZTk3LqU/rYs0tSsvMw8v1qSb1q+kvql5AKaJhlsHYJ4invZ/kn/
	 mw7YTSWoRf0MHa4haHJdaunBAs7uxJdco9y/9YW0OHJDKx0I5vRMFkapTLqnNuu47cqju
	 O9JjY3B9rHvxknnq9IxtxqI/ddGRXzdltERgBTgyHrDi/J+y9ofdpbzDVTOt6NykwBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GGLYrNc6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C539606A32A
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GGLYrNc6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83DD1F0089F;
	Mon,  9 Nov 2026 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794254897;
	bh=54PUVSCFqeUsNzedYgTE7q6vcx7/2xJEcki4qnKngVE=;
	h=Date:To:From:Subject;
	b=GGLYrNc6uCzcK9py92hX1ZaBct6qMVEJp64Kq5G8IuU+xH/EcIm7K0aM14+3hzRPk
	 2CFa/CktVQEck4wdPV5+ONzTgz8qkNRynp9Whx+FFb+kENAzQRuI9h6a4pMbHweTY5
	 r+X/MjvlGhND2hxJ9V8WLzCPxiHc8ERhHJitqWFQ=
Date: Mon, 09 Nov 2026 12:08:17 -0800
To: mm-commits@vger.kernel.org,swarupkotikalapudi@gmail.com,shuah@kernel.org,
	kevin.brodsky@arm.com,clopez@suse.de,adobriyan@gmail.com,lylin1023@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys.patch added to mm-nonmm-unstable branch
Message-Id: <20261109200817.C83DD1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/proc: proc-empty-vm: handle CPUs without protection keys
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kurt Lin <lylin1023@gmail.com>
Subject: selftests/proc: proc-empty-vm: handle CPUs without protection keys
Date: Mon,  9 Nov 2026 23:19:12 +0800

On x86 CPUs without protection keys, pkey_alloc() fails with ENOSPC,
as documented in pkey_alloc(2). protection_key_support() only expects
ENOSYS or EINVAL, so the test fails on such machines, e.g. an Intel
Core i5-7200U:

  protection_key_support: error: rv -1, errno 28

Treat ENOSPC as "no protection key support" as well.

An AI coding assistant (Claude) was used to analyze the failure and to
draft the fix and this changelog. Tested on v7.4-rc1 on the machine
above; the test now passes.

Link: https://lore.kernel.org/20261109151912.156518-1-lylin1023@gmail.com
Fixes: bf5add391eeb ("proc: test ProtectionKey in proc-empty-vm test")
Signed-off-by: Kurt Lin <lylin1023@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Cc: Carlos López <clopez@suse.de>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
---

 tools/testing/selftests/proc/proc-empty-vm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -78,6 +78,9 @@ static int protection_key_support(void)
 	} else if (rv == -1 && errno == EINVAL) {
 		// ospke=n
 		return 0;
+	} else if (rv == -1 && errno == ENOSPC) {
+		// CPU without protection keys
+		return 0;
 	} else {
 		fprintf(stderr, "%s: error: rv %ld, errno %d\n", __func__, rv, errno);
 		exit(EXIT_FAILURE);
_

Patches currently in -mm which might be from lylin1023@gmail.com are

selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys.patch


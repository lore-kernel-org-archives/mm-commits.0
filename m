Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2281D140384
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721942107; cv=none; b=TY/wn7UcKXOa9bs1pU+mOS2eCsLH58VOfqV1pjItg/qj+rT768hcvsGJMJOwDtgOpXT08tottM75L4EAKx7cPzUUCBsgF2hHo27aj+4ODI7iqNvk7TU3SOVprqS7Gp5Ne9Ftl66p2rMFaK1mJy6qR7GyBIfzXHx9oo+4R0dD738=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721942107; c=relaxed/simple;
	bh=c8N6s+0jcvIK82z4UxXu4/lW+fmWVBDlvZQ6raCELK8=;
	h=Date:To:From:Subject:Message-Id; b=YTkbAeSjOEZ/vak3uNIOM0ZUL9TDvVITkT1Rzm3iilPMuz5RDtHMrplbPiShWEHlFtIRxfcfUBSv8Awsz/zc3IxNn1fLHPj019TNVJ2nqmx8AaDzYnBJwwZ+OCTS6s8wF2MJN+zVUNLsVNSBPLmaPSemk7VZ2bS4r+2vfpOxSQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TPw1Yrer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TPw1Yrer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B88CC116B1;
	Thu, 25 Jul 2024 21:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721942106;
	bh=c8N6s+0jcvIK82z4UxXu4/lW+fmWVBDlvZQ6raCELK8=;
	h=Date:To:From:Subject:From;
	b=TPw1YrerCiOVDoNxEOoORCbypRQzIrRrummdgUVKYd4dqeZUYBh2Y2qX2fq9gIwvG
	 GbHihmvFXXO/GgobvcgrL9cg7lORSs2++H2aI3pzyXuqgqQAk15hnKGuDOKIeTJFzP
	 0rESzfztDXBoLzWzHWPysVHoGP3LqOeKw68lI+vM=
Date: Thu, 25 Jul 2024 14:15:05 -0700
To: mm-commits@vger.kernel.org,weiyongjun1@huawei.com,chenjun102@huawei.com,catalin.marinas@arm.com,aleksandr.mikhalitsyn@canonical.com,ptikhomirov@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-test-add-percpu-leak.patch added to mm-unstable branch
Message-Id: <20240725211506.8B88CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmemleak-test: add percpu leak
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-test-add-percpu-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-test-add-percpu-leak.patch

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
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: kmemleak-test: add percpu leak
Date: Thu, 25 Jul 2024 12:12:16 +0800

Add a per-CPU memory leak, which will be reported like:

unreferenced object 0x3efa840195f8 (size 64):
  comm "modprobe", pid 4667, jiffies 4294688677
  hex dump (first 32 bytes on cpu 0):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    [<ffffffffa7fa87af>] pcpu_alloc+0x3df/0x840
    [<ffffffffc11642d9>] kmemleak_test_init+0x2c9/0x2f0 [kmemleak_test]
    [<ffffffffa7c02264>] do_one_initcall+0x44/0x300
    [<ffffffffa7de9e10>] do_init_module+0x60/0x240
    [<ffffffffa7deb946>] init_module_from_file+0x86/0xc0
    [<ffffffffa7deba99>] idempotent_init_module+0x109/0x2a0
    [<ffffffffa7debd2a>] __x64_sys_finit_module+0x5a/0xb0
    [<ffffffffa88f4f3a>] do_syscall_64+0x7a/0x160
    [<ffffffffa8a0012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Link: https://lkml.kernel.org/r/20240725041223.872472-3-ptikhomirov@virtuozzo.com
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kmemleak/kmemleak-test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/samples/kmemleak/kmemleak-test.c~kmemleak-test-add-percpu-leak
+++ a/samples/kmemleak/kmemleak-test.c
@@ -79,6 +79,8 @@ static int kmemleak_test_init(void)
 			per_cpu(kmemleak_test_pointer, i));
 	}
 
+	pr_info("__alloc_percpu(64, 4) = %p\n", __alloc_percpu(64, 4));
+
 	return 0;
 }
 module_init(kmemleak_test_init);
_

Patches currently in -mm which might be from ptikhomirov@virtuozzo.com are

kmemleak-enable-tracking-for-percpu-pointers.patch
kmemleak-test-add-percpu-leak.patch


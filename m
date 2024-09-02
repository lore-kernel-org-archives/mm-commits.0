Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D6341C92
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247691; cv=none; b=Qq0SS4a6QbzoemdsBhUAPlOOxvHdk8+NUBH4iJ//xq1bQ0TYdR8Oyz0b7PEtk29Z/wxwfI5tMnVV3jiWEzQGlcUd3NlA27IKRV89Qb82Kv0WGjVheH17bSIobwnC4wwOwM07gcIjhDOrsik/9U5wJxHgs6QQeh7niPs3MO6c1C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247691; c=relaxed/simple;
	bh=C7ZhRgLvR9w7jh9lGj8E4GmDmmY7wBneY8P8uu2zjQ8=;
	h=Date:To:From:Subject:Message-Id; b=gwAPrk6V/T60MyjOQkFJfIASHEx/yv6AcduWZahZ8JE1gWSGDbe8p8dcbQvJWRI0e/kaf0dCic9szPFn65/1yTyJKQLzGUy7HMxpUNQq3RsK5sui73JmY/srBduks6P8Fh6Kp9Hxs4fx4QqcUSWKidc8BqPEvyrbTUE6SC2O8KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C1BqrOEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C1BqrOEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C7BC4CEC2;
	Mon,  2 Sep 2024 03:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247691;
	bh=C7ZhRgLvR9w7jh9lGj8E4GmDmmY7wBneY8P8uu2zjQ8=;
	h=Date:To:From:Subject:From;
	b=C1BqrOEe0C3vxuQs8/YC+AvDkL8fZJZcsWVRoH3fC4TJU6e+ZsiPiYswWm1/whJTD
	 fcJEjPtd2kklPOVRNHsgLpJGw71RR6dlSedfn7Wqg/Xf2EL2gV9BYdZEKn+C0Vrc0A
	 zzYJvzA17tdrmCKqcC9o97CKhxYz2f5eNTMqhwcY=
Date: Sun, 01 Sep 2024 20:28:10 -0700
To: mm-commits@vger.kernel.org,weiyongjun1@huawei.com,chenjun102@huawei.com,catalin.marinas@arm.com,aleksandr.mikhalitsyn@canonical.com,ptikhomirov@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmemleak-test-add-percpu-leak.patch removed from -mm tree
Message-Id: <20240902032811.56C7BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmemleak-test: add percpu leak
has been removed from the -mm tree.  Its filename was
     kmemleak-test-add-percpu-leak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
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



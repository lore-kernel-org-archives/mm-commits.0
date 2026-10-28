Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156662;
	b=cTTjlzbv3x9KM2N34fPb6eyB6qoz53J6p25GvV0op4hPPM+F0p5dXlcCGEcpcNeaaIic
	 twN9p5wfM5HctLseF47ur0Ve+edvGR0OdeZB05oMo50gDGbr85a7BGChI6np+S6F7AomW
	 PaGQY1ftXeRHjgMNLkr/WNnuyAWtHFxG+/4LypoLJnVRhDq04OJqtV4y7LeZYTbU42tL9
	 6WEx/15C4PpKuAPnEE4XKMyyCrQeEoa24NgiYAB+mlBc7AAPadynfh6q+Ud2wBHf52k0V
	 mRD6PVBjw3Hp4+brGiF0uv+PwdGRCxOQFH+Vzwvg9AydbALNVAP/9ox9PNON/4xT6Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156662;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qTFb5M8F+jgplCIm0MKd/a0MPXCqVG8sSdq8fyvGQF8=;
	b=eyl04788QwUhSFyJI/vHRupKSCWKOIGCSBhaj6FWPbEgN+ANLf5oFRv46FnRh94tif9f
	 TOuduIOew2rd/n+RMEbwmSewkcUlzIXAWTKneyA4LcTyMJM5QIKKtJTfwKr9gS5Mes7DM
	 hmrC2INdpR5u1ECz2834RN28rL9rKIyFlZgybsEkpM5ifE0ONPQwAiUlZYs8BNAibgreh
	 IFbfZOWijE9JfP3I6B04EH6jYMMziOso9JORp2m/Gfd3a2bh8uKK2dBYLUhvcJIruJU9S
	 kWD0/Bl4e8w1dqixu9glBvz4AJMnPjIwV4McxhdaWcVBGVFEr9nVeKa5CBYqwGySSMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Dq9lmTCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FE8606A31A
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Dq9lmTCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6811F01828;
	Wed, 28 Oct 2026 03:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156661;
	bh=qTFb5M8F+jgplCIm0MKd/a0MPXCqVG8sSdq8fyvGQF8=;
	h=Date:To:From:Subject;
	b=Dq9lmTCGyCrff8O8MUotOUu84jyUMcmrvwY2Ysj7C3U6abpidS3eXm+naIovcIsrQ
	 EBmlk7cclrqMBWPGMEZIAV9ng/gTFkD9z1aLQkDqZlCPrpeug3/2ZOFmqz3oTnXjQN
	 cpFw5yfux6VappPgA+3SsvzYjhuM3sBiLEytJolU=
Date: Tue, 27 Oct 2026 20:04:21 -0700
To: mm-commits@vger.kernel.org,hengyul@cs.unc.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch removed from -mm tree
Message-Id: <20261028030421.CD6811F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hengyu Liang <hengyul@cs.unc.edu>
Subject: fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls
Date: Fri, 23 Oct 2026 14:13:00 -0400

Commit 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
optionally clear info about PTEs") made do_pagemap_cmd() the ioctl
handler of /proc/<pid>/pagemap.

However, do_pagemap_cmd() returns -EINVAL for every command other than
PAGEMAP_SCAN. Before that commit, pagemap had no ioctl handler, and
the VFS returned -ENOTTY for these commands. As of now, they fail with
EINVAL, so tcgetattr() and isatty() on pagemap report EINVAL instead
of ENOTTY.

The issue can be reproduced with a simple C program:

    #include <fcntl.h>
    #include <stdio.h>
    #include <termios.h>

    int main(void)
    {
            struct termios t;
            int fd = open("/proc/self/pagemap", O_RDONLY);

            if (tcgetattr(fd, &t) < 0)
                    perror("tcgetattr");
            return 0;
    }

Before that commit, the result is:

    tcgetattr: Inappropriate ioctl for device

After that commit, the result is:

    tcgetattr: Invalid argument

This patch will return -ENOIOCTLCMD for unknown commands, as
procfs_procmap_ioctl() in the same file does, so that the VFS turns it
into -ENOTTY.

Link: https://lore.kernel.org/20261023181300.3366487-1-hengyul@cs.unc.edu
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls
+++ a/fs/proc/task_mmu.c
@@ -3201,7 +3201,7 @@ static long do_pagemap_cmd(struct file *
 		return do_pagemap_scan(mm, arg);
 
 	default:
-		return -EINVAL;
+		return -ENOIOCTLCMD;
 	}
 }
 
_

Patches currently in -mm which might be from hengyul@cs.unc.edu are



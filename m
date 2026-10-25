Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792946972;
	b=fDyV5qD3Ka8I0o+LI1jgmzWLdAB4WL/Q2ZcytQjpHFE7T2u4hNwIl6Z06N6TLo48UA1L
	 fUjB9v8mGZgk1WLWcKSFFMyp0ush9EZO2ELzcVlSgZ9kruDSIf3XtZoaSatCjnqzA7Yvw
	 lkJweURz4VZ5+k26oLB+ci5/daXde597L520IW3WfNwhAmspXo0O8pzCoY+zM2vaylDp5
	 kkzlcPO9Tl48+SDN2uSErNwkkP5sQ0VPZj0+VtqYA9TBWBzr92gicNcF17WgXRGYx5TXB
	 hDcgoJvqZfu/BWCyvEWSqUN+eNmTHZF4DKK8zZ1lPQNazkebDP5KLSrVOmHS+X92HpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792946972;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kiEDcVPC9CUY5PdVhOrC2cHXjmPllkxAo3sNOTeLLIY=;
	b=XlRs/hElkmrli5nyrsOWMiaLhohpVJicrfp9i0zR01Okc3R1fz0RQMcOk3vEFvH0XmoI
	 mbo5hxsofjNENxLglzvdzqWQG7g4UnYgbbTmTZtZoQxJqN0Ojuns2SbAoUPQN/PlHWJO1
	 qd0+Rwst1NqCgBn5t4mbYaut2z7RWjGJB2L1k3kM6fO1A2kW9IJJpMjdU8E5eM4QLQ6lC
	 HWp+wjZ5zWqScv3YjBzYwvAVwv0UaOYNlbYPGeZEcn+URkIRW3FfGHDXo9bp+tJ3BEo4C
	 h6bo8DWZDpnMkc8P0Rjd5dWJpGzvBVs+fmKomYWWEdlpIPVaacXJH6cGM+Y5qbyramQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a26MWLSQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F7E606A31A;
	Sun, 25 Oct 2026 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a26MWLSQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8221F01825;
	Sun, 25 Oct 2026 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792946971;
	bh=kiEDcVPC9CUY5PdVhOrC2cHXjmPllkxAo3sNOTeLLIY=;
	h=Date:To:From:Subject;
	b=a26MWLSQok3LWHoPuHKhMisIw0hLb1pSULesmDl+IhvBo6FonzV7ZBsCWreUHEPRk
	 yjiZD7xwi9aiPe15RPVnMqR9DZMhNZlTXezU2S2Qpi1m2XFkUSmsBzdMQjYKE92nqT
	 xDhOFXiJ8uRqA61HaTkB2uXS2+x/R1YeWg8eA6jQ=
Date: Sun, 25 Oct 2026 09:49:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,
	stable@vger.kernel.org,pfalcato@suse.de,mirq-linux@rere.qmqm.pl,
	ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,
	avagin@gmail.com,arnd@arndb.de,hengyul@cs.unc.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch added to mm-unstable branch
Message-Id: <20261025164931.3C8221F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
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

fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156721;
	b=beYVAaPr611rURh17BwiH8mG+aawpK/fw1udTUeV2w3VjxXEJkjsfxyLKAUpkO2yYwu+
	 /LGfqBqcvcwNI/xGdb6+3iYI5RTQXPxUs/IjxC2q9NIzbTf2v2W5VElCBwKw5lLBtSwPI
	 6uckXxkP5erXfvpu+vAS4cEV92lJ6KrVphoFClwQJQeTbXcRftW/O1owpJKpBqxca4ho2
	 Ji1OddjLRepqwwsKEcLDBBQAS2lzgmpplq3UJL5Ahbx1wE5/dsI+i1KkMpiifL88KWInv
	 CRFSfkCKpD6wCStzht4V/rNpm79BEDoHOVujPv3+2uwvVFoOiwFeayLUZQMENHbSe1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156721;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Pe4LEuRORn0wOuSUWpNXTJL+z+B4lRAhZrFOKkTCyso=;
	b=FSXes1qAbZ7VBjt/Bka9E6opkzA3J949TFTs+hSfinMuc4nbd0qXitAyCuDSbRftHEc0
	 HtsQc8d8xwbutZ3K6LfZAwuZv+M0MbEsn7oQlUk9xiDrEFhxjJ52W7jXoxPb1vuqddAJd
	 ya/kzwMshV4nfMYtmwkqVr+jm2rjd8ED76f4lf7jHe1J+gbtLadBk4vA5OEfEBI11kmTh
	 hZz61t1jGxDM1PnAf1RZvoyi7dnu54CIcycmo8ai66RCo0GwDaQ00phNWahcPS3YGVFoe
	 Bj1GwcOPWofNNhr+5bp9p1sZD92177dy5kYYrDhK8M6xJ1D5I2mPKZrYL1LuE8Un2iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghnFFvGH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FF7606A323
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghnFFvGH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EAA1F01828;
	Wed, 28 Oct 2026 03:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156721;
	bh=Pe4LEuRORn0wOuSUWpNXTJL+z+B4lRAhZrFOKkTCyso=;
	h=Date:To:From:Subject;
	b=ghnFFvGHoPXFDoJjZnaO4ImoOSx9i9gofCkJK73zy8e9+e2etHFkqJtoSKMZldGOJ
	 h5j34ra9//HcqdpZgsZazYq9bMioogWbPRbDl8JiwBWJKF1HImwBZ1xM4ADj4pwI9P
	 iwjT3z4RTBb8cjQEhvOnhG5oqbhax62bsShpKznU=
Date: Tue, 27 Oct 2026 20:05:20 -0700
To: mm-commits@vger.kernel.org,hengyul@cs.unc.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch added to mm-unstable branch
Message-Id: <20261028030520.F3EAA1F01828@smtp.kernel.org>
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

fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch


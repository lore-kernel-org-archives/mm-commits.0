Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672137;
	b=4ErbJ+E2WbtCI3PqxyEZkoTeEX8HgoXRa/j2jlPbBnml8LTmj/ZozBqtq5Pm1N4I4yJn
	 T3IYaz38wBLDrjbKmlLGKuD+/UyIKtIu6YZXJdQb+oWpYvJeI3eGBME6mqG99xxr4Vo5j
	 6HtzVDI40hzKv87kOSJA9KgiYGZ63FyBoJevwnUezLIpXb+2XynyWE5S7CBYI2BtBWEkF
	 HpYmawLI6zEXjDBzPN3emb0lmUxI/z4KGY0K0NEcZdGsMVk/jpopFSisT8VujQ5u22Eir
	 KAV2sWRcyP4a1FEz2AauK35V9ekNQ4isXBTh+AyzQEDQ6fv0vn8MEUNiRi9OuvUSGlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672137;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IzQsRMFTLrvrQbCT5Whmhu2ZhM0dta6kir5kjC5DJL4=;
	b=ADdHZ96K4sXsBwjCT5np1KM5nFSIQb7EOnDlLAR9ixy3r5OzO6izqjIc5524bH5zDz91
	 PhaJH7wErxPn7zminAgXEF+DmAiElpnjoUlHneK0f+15tTujiR1HeT+pDW808oylCIn9U
	 UkiMoAwvKqvMjgYByNJvjhb6rVJucNsxsyOzHx8qd8CdBXbuGfCliMW6rLdSa5vxoyOny
	 2j4ratM/oTFboNDVLUuYY+N4S/SNNSq2CNJJwk65v0TECTDLtqY37T8KZNFrGHoO3nria
	 2DKtkQeD7BLvlyap448KLQq3EDZNmdZrNtEJxyKT62AIT181928uCe6nsuHcbOKmmyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cn6EcGQN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4522A606A329;
	Tue,  3 Nov 2026 02:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cn6EcGQN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064411F000C1;
	Tue,  3 Nov 2026 02:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672137;
	bh=IzQsRMFTLrvrQbCT5Whmhu2ZhM0dta6kir5kjC5DJL4=;
	h=Date:To:From:Subject;
	b=cn6EcGQNpohiGm4jgnzeY41zbZLCtckMnQdhFZ264obKhMRE4D610MS5CYdOX5/Gk
	 g2/dRS3FsYwpCXro13/VQzblBApCCl8dAYf955omyXcCq57ImtjRYaVeLOtB0anj4e
	 MXY4AGLoARC05srB31DcsM3K08BdzGJwaGZUivgY=
Date: Mon, 02 Nov 2026 18:15:36 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,
	stable@vger.kernel.org,pfalcato@suse.de,mirq-linux@rere.qmqm.pl,
	ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,
	avagin@gmail.com,arnd@arndb.de,hengyul@cs.unc.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-task_mmu-return-enotty-for-unknown-pagemap-ioctls.patch removed from -mm tree
Message-Id: <20261103021537.064411F000C1@smtp.kernel.org>
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

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



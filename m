Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755905;
	b=EtcJ1YaNYaCpCbF7tsUygmZhaKSMuIfNue88rOWejd3+PGnPgjmpknVseGyLwMcW10R3
	 c78s/jPw9QYz9AyjT1IqbH3oJgD2/QNvl76fwDHZlRt5gi1og1MJ/uc+1+9KWNnwTsj9I
	 eBY/aEaK2I1IqP9VxfzNX2DU8b7ePElGrCbFLnN8HUIIjyqP5PuNDwAL+JC16d5hoXYsv
	 1Wx6lPWUx6rnFC05pIp/gCmuPr0vS7lMTs/V/mNF75wY9UqsrCVodpQhBFa6N2I25ImH0
	 /OqXg5N2O3/yyzW7/3Y5fSzCQy1jVvunHsLbql9MFwhHZt3mCEGO55uSP0cb/KfkdIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755905;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ikMgYzfjsvlNJf1GZCYvrhvNC47k4zPIq+OpfbwiouI=;
	b=dGn1vOz71rbuAXtvZyWmfPVaYbDcGK5XWroW5SE7d15K2SH8z7UBprCQvh6t1O99DGOY
	 m5mIvas2VEwB1HArH+t+aEHcxBsB6/2igthVC5bLozBaIpgDdLPHOMAdVkj6J/zEGx8HC
	 5f9b7QKKTIRuB0VppdNVsIarPvjKL0po7T56LsAoU44FxOH8cfqHhESEeRJRdJQT+55JI
	 H6KFCheicsSdViVZGKiOoeT4KS2OCJKseTS7atrLudgZf3j0i6uYrbn23iTmW7xGA04B+
	 V4qNMjW40GokJc0Wyw3rogAUayDaU2npWELrEeRmaYCBaQgM0Cry2vA1dJSR/S71Ksw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gJ1bCkQt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065DA606A31E
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gJ1bCkQt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFC61F000C4;
	Sun, 15 Nov 2026 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794755904;
	bh=ikMgYzfjsvlNJf1GZCYvrhvNC47k4zPIq+OpfbwiouI=;
	h=Date:To:From:Subject;
	b=gJ1bCkQt6A862WgH5mv/UvCuj8gZkijIwgg6kt+gEFRJFfmBZj7VQ1yhlWaa9AQrj
	 hIYc4NC3Ri+uYhAQRPxuWzb33LAGw1hPzyXZwfmswblI1ToIcIvAMUc1hubWB6DEyv
	 ufmas1v5Z3SX2R4QAO59q8u1jveyVhgYKS2ZxWik=
Date: Sun, 15 Nov 2026 07:18:24 -0800
To: mm-commits@vger.kernel.org,wfelipe@google.com,ryan.roberts@arm.com,
	rppt@kernel.org,mhiramat@kernel.org,leitao@debian.org,ekffu200098@gmail.com,
	brauner@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-combine-blacklist-entry-allocations-in-initcall_blacklist.patch added to mm-nonmm-unstable branch
Message-Id: <20261115151824.AEFC61F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: init: combine blacklist entry allocations in initcall_blacklist()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-combine-blacklist-entry-allocations-in-initcall_blacklist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-combine-blacklist-entry-allocations-in-initcall_blacklist.patch

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
From: Thorsten Blum <blum@kernel.org>
Subject: init: combine blacklist entry allocations in initcall_blacklist()
Date: Sun, 15 Nov 2026 15:23:21 +0100

Use a flexible array member for the function name and allocate it together
with the blacklist entry.  This removes the pointer and saves one
allocation call per blacklist entry.

Link: https://lore.kernel.org/20261115142321.96774-4-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>

 init/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/init/main.c~init-combine-blacklist-entry-allocations-in-initcall_blacklist
+++ a/init/main.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/initrd.h>
 #include <linux/memblock.h>
+#include <linux/overflow.h>
 #include <linux/acpi.h>
 #include <linux/bootconfig.h>
 #include <linux/console.h>
@@ -1275,7 +1276,7 @@ static void __init do_ctors(void)
 #ifdef CONFIG_KALLSYMS
 struct blacklist_entry {
 	struct list_head next;
-	char *buf;
+	char buf[];
 };
 
 static __initdata_or_module LIST_HEAD(blacklisted_initcalls);
@@ -1290,8 +1291,8 @@ static int __init initcall_blacklist(cha
 		size_t buf_size = strlen(str_entry) + 1;
 
 		pr_debug("blacklisting initcall %s\n", str_entry);
-		entry = memblock_alloc_or_panic(sizeof(*entry), SMP_CACHE_BYTES);
-		entry->buf = memblock_alloc_or_panic(buf_size, SMP_CACHE_BYTES);
+		entry = memblock_alloc_or_panic(struct_size(entry, buf, buf_size),
+						SMP_CACHE_BYTES);
 		strscpy(entry->buf, str_entry, buf_size);
 		list_add(&entry->next, &blacklisted_initcalls);
 	}
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch
init-use-strscpy-in-do_initcalls.patch
init-use-kmalloc-in-do_initcalls.patch
init-remove-strlcat-and-sprintf-from-do_one_initcall.patch
init-use-strscpy-in-initcall_blacklist.patch
init-combine-blacklist-entry-allocations-in-initcall_blacklist.patch


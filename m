Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CDF154C0A
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560555; cv=none; b=FYEOpGJGWVgwJLD0HF6oGFsUxAeM5ByGriP61QVdNQXi7JZApz88YleuIOva7S65bcHYtO9YwRDdy82GUQ5+y8dNUANW/oBxvhT3TCVzXxTiDLmhBxgw2S0yEjiPdniDRuCylewZ4zqpmwQLe72Tp/E1Td2q6OvNRWIykdp/n/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560555; c=relaxed/simple;
	bh=e+ROcYSVhhuEJcwIXJEb1m2LWIeTp77Njqkkf3JIsHU=;
	h=Date:To:From:Subject:Message-Id; b=sE+b10+u5dAx6SGkJVuyNg9VEGBGf36wMO4EaIvSpt2fHDpXuleNdJbhv6qGvfUZ++2xGm5C7nVPjdSOHC5ADOMA9qz7f7AeHXSBvPEyaZZeBvyAJnFXlQWXjCunHRmzOtTMTHj8anabrrmKu8loA1VB0TWcsvcmi4Fq+9S6OBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LgpSkPaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LgpSkPaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF8FC4CEC7;
	Tue, 17 Sep 2024 08:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560554;
	bh=e+ROcYSVhhuEJcwIXJEb1m2LWIeTp77Njqkkf3JIsHU=;
	h=Date:To:From:Subject:From;
	b=LgpSkPaVU/Y9R2IHLq5wvSjrsLqHn54fSNf7rY8AmIBVJlphYESusjjqEiGwyl5QJ
	 DZEJpJgqOzhncaplegbCkRzz8RRLzvA8jYQ+mAC0R/cbxIdQwJGksscyLvU+WvOI4B
	 xOHS8svgcuJSrU60H4VD00w6xge5yQpFKpQG/T3k=
Date: Tue, 17 Sep 2024 01:09:11 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,arnd@arndb.de,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] set_memory-add-__must_check-to-generic-stubs.patch removed from -mm tree
Message-Id: <20240917080914.2EF8FC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: set_memory: add __must_check to generic stubs
has been removed from the -mm tree.  Its filename was
     set_memory-add-__must_check-to-generic-stubs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: set_memory: add __must_check to generic stubs
Date: Sat, 7 Sep 2024 17:40:42 +0200

Following query shows that architectures that don't provide
asm/set_memory.h don't use set_memory_...() functions.

  $ git grep set_memory_ alpha arc csky hexagon loongarch m68k microblaze mips nios2 openrisc parisc sh sparc um xtensa

Following query shows that all core users of set_memory_...()
functions always take returned value into account:

  $ git grep -w -e set_memory_ro -e set_memory_rw -e set_memory_x -e set_memory_nx -e set_memory_rox `find . -maxdepth 1 -type d | grep -v arch | grep /`

set_memory_...() functions can fail, leaving the memory attributes
unchanged. Make sure all callers check the returned code.

Link: https://github.com/KSPP/linux/issues/7
Link: https://lkml.kernel.org/r/6a89ffc69666de84721216947c6b6c7dcca39d7d.1725723347.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/set_memory.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/set_memory.h~set_memory-add-__must_check-to-generic-stubs
+++ a/include/linux/set_memory.h
@@ -8,10 +8,10 @@
 #ifdef CONFIG_ARCH_HAS_SET_MEMORY
 #include <asm/set_memory.h>
 #else
-static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_x(unsigned long addr,  int numpages) { return 0; }
-static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
+static inline int __must_check set_memory_ro(unsigned long addr, int numpages) { return 0; }
+static inline int __must_check set_memory_rw(unsigned long addr, int numpages) { return 0; }
+static inline int __must_check set_memory_x(unsigned long addr,  int numpages) { return 0; }
+static inline int __must_check set_memory_nx(unsigned long addr, int numpages) { return 0; }
 #endif
 
 #ifndef set_memory_rox
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are



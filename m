Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F054A2F656B;
	Sun, 26 Oct 2025 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761522993; cv=none; b=dQX2kmz7kjqMXcI/vk+PfZnALN1ti+rkWLouEKjc9A/qi1hdPeTS3lnfQ2UizmAdOZEaz+t9il2ZIycr9Vj6Rg5Gni6JkgL5SLY/wQTD5eqVCV81ZoC/YNOu+gGm+Jku1+PoYKr6iprOhIOLZhMSDrRb9N6bGJRZn4rGQ3Hn6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761522993; c=relaxed/simple;
	bh=w2EViOQ6CP6uAtzoo4LkqoEClWWci4dIHlu1CegL8fU=;
	h=Date:To:From:Subject:Message-Id; b=AtLX3ZKf0A7QPCRVN5V46hGg9HDI5TVEaoq7qVDBAydzoqIWrACImSXjdIgdvQRnaCJs7Fh0HmNH+hFxmDkbf3KiSpFEujcnJIriI71AXduFjcuki8RCxvHYAnrjm+LKjscbnGQQ6Kk2tafD6ASPaAWpyx4M1DmkcZ1bp6oyHik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hr5ZMmsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hr5ZMmsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E245C4CEE7;
	Sun, 26 Oct 2025 23:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761522992;
	bh=w2EViOQ6CP6uAtzoo4LkqoEClWWci4dIHlu1CegL8fU=;
	h=Date:To:From:Subject:From;
	b=Hr5ZMmspqAsS1ULQl/ZToGbbs1T6/LxO3gfClJHQYgedhNAs88kXHwRTIFMp80iPn
	 tbPNHVwEvkOhSoKhUKAjqnpeokGt0HLsdR0qIeA2/ofWfzMBnhZnT9lHS816x7pEAv
	 QTir2KVADENZE4jUUjJeBdJ4hAMs9X94ercU+rjY=
Date: Sun, 26 Oct 2025 16:56:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,gustavoars@kernel.org,david.hunter.linux@gmail.com,arnd@arndb.de,hannelotta@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + headers-add-check-for-c-standard-version.patch added to mm-hotfixes-unstable branch
Message-Id: <20251026235632.6E245C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: headers: add check for C standard version
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     headers-add-check-for-c-standard-version.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/headers-add-check-for-c-standard-version.patch

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
From: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Subject: headers: add check for C standard version
Date: Sun, 26 Oct 2025 21:58:46 +0200

Compiling the kernel with GCC 15 results in errors, as with GCC 15 the
default language version for C compilation has been changed from
-std=gnu17 to -std=gnu23 - unless the language version has been changed
using

    KBUILD_CFLAGS += -std=gnu17

or earlier.

C23 includes new keywords 'bool', 'true' and 'false', which cause
compilation errors in Linux headers:

    ./include/linux/types.h:30:33: error: `bool' cannot be defined
        via `typedef'

    ./include/linux/stddef.h:11:9: error: cannot use keyword `false'
        as enumeration constant

Add check for C Standard's version in the header files to be able to
compile the kernel with C23.

Link: https://lkml.kernel.org/r/20251026195846.69740-1-hannelotta@gmail.com
Signed-off-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stddef.h |    2 ++
 include/linux/types.h  |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/stddef.h~headers-add-check-for-c-standard-version
+++ a/include/linux/stddef.h
@@ -7,10 +7,12 @@
 #undef NULL
 #define NULL ((void *)0)
 
+#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 202311L
 enum {
 	false	= 0,
 	true	= 1
 };
+#endif
 
 #undef offsetof
 #define offsetof(TYPE, MEMBER)	__builtin_offsetof(TYPE, MEMBER)
--- a/include/linux/types.h~headers-add-check-for-c-standard-version
+++ a/include/linux/types.h
@@ -32,7 +32,9 @@ typedef __kernel_timer_t	timer_t;
 typedef __kernel_clockid_t	clockid_t;
 typedef __kernel_mqd_t		mqd_t;
 
+#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 202311L
 typedef _Bool			bool;
+#endif
 
 typedef __kernel_uid32_t	uid_t;
 typedef __kernel_gid32_t	gid_t;
_

Patches currently in -mm which might be from hannelotta@gmail.com are

headers-add-check-for-c-standard-version.patch


From: akpm@linux-foundation.org
Subject: + include-linux-fsh-fix-userspace-build.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:00:19 -0800
Message-ID: <201011121900.oACJ0JVC026052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236Ab0KLTAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: loic.minier@linaro.org, arnd.bergmann@linaro.org, dmonakhov@openvz.org, lczerner@redhat.com, tytso@mit.edu


The patch titled
     include/linux/fs.h: fix userspace build
has been added to the -mm tree.  Its filename is
     include-linux-fsh-fix-userspace-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: include/linux/fs.h: fix userspace build
=46rom: Lo=EFc Minier <loic.minier@linaro.org>

dpkg uses fiemap but didn't particularly need to include stdint.h so fa=
r.=20
Since 367a51a33902 ("fs: Add FITRIM ioctl"), build of linux/fs.h failed=
 in
dpkg with:

In file included from ../../src/filesdb.c:27:0:
/usr/include/linux/fs.h:37:2: error: expected specifier-qualifier-list =
before 'uint64_t'

Use exportable type __u64 to avoid the dependency on stdint.h.

b31d42a5af18 ("Fix compile brekage with !CONFIG_BLOCK") fixed only the
kernel build by including linux/types.h, but this also fixed "make
headers_check", so don't revert it.

Signed-off-by: Lo=EFc Minier <loic.minier@linaro.org>
Tested-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/fs.h~include-linux-fsh-fix-userspace-build incl=
ude/linux/fs.h
--- a/include/linux/fs.h~include-linux-fsh-fix-userspace-build
+++ a/include/linux/fs.h
@@ -34,9 +34,9 @@
 #define SEEK_MAX	SEEK_END
=20
 struct fstrim_range {
-	uint64_t start;
-	uint64_t len;
-	uint64_t minlen;
+	__u64 start;
+	__u64 len;
+	__u64 minlen;
 };
=20
 /* And dynamically-tunable limits and defaults: */
_

Patches currently in -mm which might be from loic.minier@linaro.org are

include-linux-fsh-fix-userspace-build.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

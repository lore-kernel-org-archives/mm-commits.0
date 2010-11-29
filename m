From: akpm@linux-foundation.org
Subject: [merged] include-linux-fsh-fix-userspace-build.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:50:44 -0800
Message-ID: <201011291951.oATJpDQA007274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756Ab0K2Tv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: loic.minier@linaro.org, arnd.bergmann@linaro.org, dmonakhov@openvz.org, lczerner@redhat.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     include/linux/fs.h: fix userspace build
has been removed from the -mm tree.  Its filename was
     include-linux-fsh-fix-userspace-build.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

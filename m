From: akpm@linux-foundation.org
Subject: [merged]
 ext4-in-ext4_dir_llseek-check-syscall-bitness-directly.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:40:45 -0700
Message-ID: <56f2d51d.XKfFOZvQxo+Oi31Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbcCWRkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, adilger.kernel@dilger.ca, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: in ext4_dir_llseek, check syscall bitness directly
has been removed from the -mm tree.  Its filename was
     ext4-in-ext4_dir_llseek-check-syscall-bitness-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: ext4: in ext4_dir_llseek, check syscall bitness directly

ext4 treats directory offsets differently for 32-bit and 64-bit
callers.  Check the caller type using in_compat_syscall, not
is_compat_task.  This changes behavior on SPARC slightly.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/dir.c~ext4-in-ext4_dir_llseek-check-syscall-bitness-directly fs/ext4/dir.c
--- a/fs/ext4/dir.c~ext4-in-ext4_dir_llseek-check-syscall-bitness-directly
+++ a/fs/ext4/dir.c
@@ -285,7 +285,7 @@ errout:
 static inline int is_32bit_api(void)
 {
 #ifdef CONFIG_COMPAT
-	return is_compat_task();
+	return in_compat_syscall();
 #else
 	return (BITS_PER_LONG == 32);
 #endif
_

Patches currently in -mm which might be from luto@kernel.org are



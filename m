From: akpm@linux-foundation.org
Subject: [merged]
 fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:19:10 -0700
Message-ID: <5535512e.wKQAZfg5gM5bH4YJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbbDTTMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: use bool instead of int for is_known_namespace() return value
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus: use bool instead of int for is_known_namespace() return value

is_known_namespace() only returns true/false.  Also remove inline and let
compiler decide what to do with static functions.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/xattr.c~fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value
+++ a/fs/hfsplus/xattr.c
@@ -44,7 +44,7 @@ static int strcmp_xattr_acl(const char *
 	return -1;
 }
 
-static inline int is_known_namespace(const char *name)
+static bool is_known_namespace(const char *name)
 {
 	if (strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) &&
 	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch


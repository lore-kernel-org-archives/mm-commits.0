From: akpm@linux-foundation.org
Subject: +
 fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:58:02 -0700
Message-ID: <5501fdda.tdUHF/EpF2yw7T/0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbbCLU6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: use bool instead of int for is_known_namespace() return value
has been added to the -mm tree.  Its filename is
     fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch
fs-hfsplus-atomically-set-inode-i_flags.patch
fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch
fs-affs-use-affs_mount-prefix-for-mount-options.patch
fs-affs-affsh-add-mount-option-manipulation-macros.patch
fs-affs-superc-use-affs_set_opt.patch
fs-affs-use-affs_test_opt.patch
linux-next.patch


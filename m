From: akpm@linux-foundation.org
Subject: + correctly-close-old-nfsd-lockd-sockets.patch added to -mm tree
Date: Sat, 15 Sep 2007 02:49:18 -0700
Message-ID: <200709150949.l8F9nIWQ027946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbXIOJto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 05:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, bfields@fieldses.org, wolfgang.walter@studentenwerk.mhn.de


The patch titled
     Correctly close old nfsd/lockd sockets
has been added to the -mm tree.  Its filename is
     correctly-close-old-nfsd-lockd-sockets.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Correctly close old nfsd/lockd sockets
From: Neil Brown <neilb@suse.de>

Commit aaf68cfbf2241d24d46583423f6bff5c47e088b3 added a bias to sk_inuse,
so this test for an unused socket now fails.  So no sockets gets closed
because they are old (they might get closed if the client closed them).

This bug has existed since 2.6.21-rc1.

Thanks to Wolfgang Walter for finding and reporting the bug.

Cc: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/svcsock.c~correctly-close-old-nfsd-lockd-sockets net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~correctly-close-old-nfsd-lockd-sockets
+++ a/net/sunrpc/svcsock.c
@@ -1594,7 +1594,8 @@ svc_age_temp_sockets(unsigned long closu
 
 		if (!test_and_set_bit(SK_OLD, &svsk->sk_flags))
 			continue;
-		if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY, &svsk->sk_flags))
+		if (atomic_read(&svsk->sk_inuse) > 1
+		    || test_bit(SK_BUSY, &svsk->sk_flags))
 			continue;
 		atomic_inc(&svsk->sk_inuse);
 		list_move(le, &to_be_aged);
_

Patches currently in -mm which might be from neilb@suse.de are

md-fix-some-bugs-with-growing-raid5-raid6-arrays.patch
git-nfsd.patch
correctly-close-old-nfsd-lockd-sockets.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fs-nfsd-exportc-make-3-functions-static.patch
md-software-raid-autodetect-dev-list-not-array.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
bitmaph-remove-dead-artifacts.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch

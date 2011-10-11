From: akpm@linux-foundation.org
Subject: + ceph-mds_clientc-quiet-sparse-noise.patch added to -mm tree
Date: Tue, 11 Oct 2011 14:27:58 -0700
Message-ID: <201110112127.p9BLRwJ3018153@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:55739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1JKV2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 17:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, sage@newdream.net


The patch titled
     Subject: ceph/mds_client.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     ceph-mds_clientc-quiet-sparse-noise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: ceph/mds_client.c: quiet sparse noise

warning: symbol 'get_nonsnap_parent' was not declared. Should it be static?
warning: symbol 'done_closing_sessions' was not declared. Should it be static?

Local functions don't need external visability. Make them static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Sage Weil <sage@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/mds_client.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ceph/mds_client.c~ceph-mds_clientc-quiet-sparse-noise fs/ceph/mds_client.c
--- a/fs/ceph/mds_client.c~ceph-mds_clientc-quiet-sparse-noise
+++ a/fs/ceph/mds_client.c
@@ -619,7 +619,7 @@ static void __unregister_request(struct 
  *
  * Called under mdsc->mutex.
  */
-struct dentry *get_nonsnap_parent(struct dentry *dentry)
+static struct dentry *get_nonsnap_parent(struct dentry *dentry)
 {
 	/*
 	 * we don't need to worry about protecting the d_parent access
@@ -3154,7 +3154,7 @@ void ceph_mdsc_sync(struct ceph_mds_clie
 /*
  * true if all sessions are closed, or we force unmount
  */
-bool done_closing_sessions(struct ceph_mds_client *mdsc)
+static bool done_closing_sessions(struct ceph_mds_client *mdsc)
 {
 	int i, n = 0;
 
_
Subject: Subject: ceph/mds_client.c: quiet sparse noise

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
ceph-mds_clientc-quiet-sparse-noise.patch
mm-memblockc-quiet-sparse-noise.patch
mm-thrashc-quiet-sparse-noise.patch
mm-mempolicyc-quiet-sparse-noise.patch
mm-huge_memoryc-quiet-sparse-noise.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
mm-page_cgroupc-quiet-sparse-noise.patch


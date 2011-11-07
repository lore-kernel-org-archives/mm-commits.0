From: akpm@linux-foundation.org
Subject: [merged] ceph-mds_clientc-quiet-sparse-noise.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:30:01 -0800
Message-ID: <201111072030.pA7KU11Z022737@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47781 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGUaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, sage@newdream.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ceph/mds_client.c: quiet sparse noise
has been removed from the -mm tree.  Its filename was
     ceph-mds_clientc-quiet-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch


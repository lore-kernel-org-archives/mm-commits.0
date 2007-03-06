From: akpm@linux-foundation.org
Subject: - reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:40 -0800
Message-ID: <200703060200.l2620ex2008744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692AbXCFCAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Fixed alloc_sha256 (missed argument)
has been removed from the -mm tree.  Its filename was
     reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Fixed alloc_sha256 (missed argument)
From: Edward Shishkin <edward@namesys.com>

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/crypto/digest.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/crypto/digest.c~reiser4-get-rid-of-deprecated-crypto-api-build-fix fs/reiser4/plugin/crypto/digest.c
--- a/fs/reiser4/plugin/crypto/digest.c~reiser4-get-rid-of-deprecated-crypto-api-build-fix
+++ a/fs/reiser4/plugin/crypto/digest.c
@@ -14,7 +14,7 @@ extern digest_plugin digest_plugins[LAST
 static struct crypto_hash * alloc_sha256 (void)
 {
 #if REISER4_SHA256
-	return crypto_alloc_hash ("sha256", 0);
+	return crypto_alloc_hash ("sha256", 0, CRYPTO_ALG_ASYNC);
 #else
 	warning("edward-1418", "sha256 unsupported");
 	return ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch

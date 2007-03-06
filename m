From: akpm@linux-foundation.org
Subject: - reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:48 -0800
Message-ID: <200703060159.l261xmPF008646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46574 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965686AbXCFB7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use do_sync_read() instead of generic_file_read()
has been removed from the -mm tree.  Its filename was
     reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: use do_sync_read() instead of generic_file_read()
From: Edward Shishkin <edward@namesys.com>

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/object.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/reiser4/plugin/object.c~reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix
+++ a/fs/reiser4/plugin/object.c
@@ -305,6 +305,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.llseek = generic_file_llseek,
 			.read = read_cryptcompress,
 			.write = write_cryptcompress,
+			.aio_read = generic_file_aio_read,
 			.mmap = mmap_cryptcompress,
 			.release = release_cryptcompress,
 			.fsync = sync_common,
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
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

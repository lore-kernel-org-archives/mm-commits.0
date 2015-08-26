From: akpm@linux-foundation.org
Subject: + ocfs2-add-errno-and-macro-definitions.patch added to -mm tree
Date: Wed, 26 Aug 2015 11:25:30 -0700
Message-ID: <55de049a.nlbrpyuCFKJNbQbD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbHZSZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 14:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.com, rgoldwyn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add errno and macro definitions
has been added to the -mm tree.  Its filename is
     ocfs2-add-errno-and-macro-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-errno-and-macro-definitions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-errno-and-macro-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: add errno and macro definitions

Add new errno, macro definitions and header file inclusion,
which will be used for file extent block online check.

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    4 ++++
 fs/ocfs2/filecheck.h |    1 +
 fs/ocfs2/journal.h   |    3 +++
 3 files changed, 8 insertions(+)

diff -puN fs/ocfs2/filecheck.c~ocfs2-add-errno-and-macro-definitions fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-add-errno-and-macro-definitions
+++ a/fs/ocfs2/filecheck.c
@@ -31,7 +31,10 @@
 #include "ocfs2.h"
 #include "ocfs2_fs.h"
 #include "stackglue.h"
+#include "dlmglue.h"
 #include "inode.h"
+#include "alloc.h"
+#include "journal.h"
 
 #include "filecheck.h"
 
@@ -45,6 +48,7 @@ static const char * const ocfs2_filechec
 	"INPROGRESS",
 	"READONLY",
 	"INVALIDINO",
+	"INVALIDEXT",
 	"BLOCKECC",
 	"BLOCKNO",
 	"VALIDFLAG",
diff -puN fs/ocfs2/filecheck.h~ocfs2-add-errno-and-macro-definitions fs/ocfs2/filecheck.h
--- a/fs/ocfs2/filecheck.h~ocfs2-add-errno-and-macro-definitions
+++ a/fs/ocfs2/filecheck.h
@@ -32,6 +32,7 @@ enum {
 	OCFS2_FILECHECK_ERR_INPROGRESS,		/* In progress */
 	OCFS2_FILECHECK_ERR_READONLY,		/* Read only */
 	OCFS2_FILECHECK_ERR_INVALIDINO,		/* Invalid ino */
+	OCFS2_FILECHECK_ERR_INVALIDEXT,		/* Invalid extent block */
 	OCFS2_FILECHECK_ERR_BLOCKECC,		/* Block ecc */
 	OCFS2_FILECHECK_ERR_BLOCKNO,		/* Block number */
 	OCFS2_FILECHECK_ERR_VALIDFLAG,		/* Inode valid flag */
diff -puN fs/ocfs2/journal.h~ocfs2-add-errno-and-macro-definitions fs/ocfs2/journal.h
--- a/fs/ocfs2/journal.h~ocfs2-add-errno-and-macro-definitions
+++ a/fs/ocfs2/journal.h
@@ -350,6 +350,9 @@ void ocfs2_journal_dirty(handle_t *handl
 /* simple file updates like chmod, etc. */
 #define OCFS2_INODE_UPDATE_CREDITS 1
 
+/* extent block update */
+#define OCFS2_EXTENT_BLOCK_UPDATE_CREDITS 1
+
 /* extended attribute block update */
 #define OCFS2_XATTR_BLOCK_UPDATE_CREDITS 1
 
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-export-ocfs2_kset-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch
ocfs2-add-feature-document-for-online-file-check.patch
ocfs2-update-filecheck-copyright.patch
ocfs2-add-errno-and-macro-definitions.patch
ocfs2-filecheck-validate_extent_block-function.patch
ocfs2-add-file-extent-block-check.patch


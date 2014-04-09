From: akpm@linux-foundation.org
Subject: + ntfs-remove-null-value-assignments.patch added to -mm tree
Date: Wed, 09 Apr 2014 13:34:52 -0700
Message-ID: <5345aeec.qSNUhR7xPLLf7KnX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbaDIUew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 16:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, anton@tuxera.com, fabf@skynet.be

Subject: + ntfs-remove-null-value-assignments.patch added to -mm tree
To: fabf@skynet.be,anton@tuxera.com
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 13:34:52 -0700


The patch titled
     Subject: ntfs: remove NULL value assignments
has been added to the -mm tree.  Its filename is
     ntfs-remove-null-value-assignments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-remove-null-value-assignments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-remove-null-value-assignments.patch

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
Subject: ntfs: remove NULL value assignments

Static values are automatically initialized to NULL.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/compress.c |    2 +-
 fs/ntfs/super.c    |    4 ++--
 fs/ntfs/sysctl.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ntfs/compress.c~ntfs-remove-null-value-assignments fs/ntfs/compress.c
--- a/fs/ntfs/compress.c~ntfs-remove-null-value-assignments
+++ a/fs/ntfs/compress.c
@@ -58,7 +58,7 @@ typedef enum {
 /**
  * ntfs_compression_buffer - one buffer for the decompression engine
  */
-static u8 *ntfs_compression_buffer = NULL;
+static u8 *ntfs_compression_buffer;
 
 /**
  * ntfs_cb_lock - spinlock which protects ntfs_compression_buffer
diff -puN fs/ntfs/super.c~ntfs-remove-null-value-assignments fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-remove-null-value-assignments
+++ a/fs/ntfs/super.c
@@ -50,8 +50,8 @@
 static unsigned long ntfs_nr_compression_users;
 
 /* A global default upcase table and a corresponding reference count. */
-static ntfschar *default_upcase = NULL;
-static unsigned long ntfs_nr_upcase_users = 0;
+static ntfschar *default_upcase;
+static unsigned long ntfs_nr_upcase_users;
 
 /* Error constants/strings used in inode.c::ntfs_show_options(). */
 typedef enum {
diff -puN fs/ntfs/sysctl.c~ntfs-remove-null-value-assignments fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~ntfs-remove-null-value-assignments
+++ a/fs/ntfs/sysctl.c
@@ -56,7 +56,7 @@ static ctl_table sysctls_root[] = {
 };
 
 /* Storage for the sysctls header. */
-static struct ctl_table_header *sysctls_root_table = NULL;
+static struct ctl_table_header *sysctls_root_table;
 
 /**
  * ntfs_sysctl - add or remove the debug sysctl
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ntfs-remove-null-value-assignments.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch


From: akpm@linux-foundation.org
Subject: + afs-prevent-double-cell-registration.patch added to -mm tree
Date: Tue, 25 Mar 2008 13:00:07 -0700
Message-ID: <200803252000.m2PK07lc010789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbYCYUBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 16:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, svens@stackframe.org


The patch titled
     afs: prevent double cell registration
has been added to the -mm tree.  Its filename is
     afs-prevent-double-cell-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: prevent double cell registration
From: David Howells <dhowells@redhat.com>

kafs doesn't check if the cell already exists - so if you do an echo "add
newcell.org 1.2.3.4" >/proc/fs/afs/cells it will try to create this cell
again.  kobject will also complain about a double registration.  To prevent
such problems, return -EEXIST in that case.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/cell.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN fs/afs/cell.c~afs-prevent-double-cell-registration fs/afs/cell.c
--- a/fs/afs/cell.c~afs-prevent-double-cell-registration
+++ a/fs/afs/cell.c
@@ -127,14 +127,20 @@ struct afs_cell *afs_cell_create(const c
 
 	_enter("%s,%s", name, vllist);
 
+	down_write(&afs_cells_sem);
+	read_lock(&afs_cells_lock);
+	list_for_each_entry(cell, &afs_cells, link) {
+		if (strcasecmp(cell->name, name) == 0)
+			goto duplicate_name;
+	}
+	read_unlock(&afs_cells_lock);
+
 	cell = afs_cell_alloc(name, vllist);
 	if (IS_ERR(cell)) {
 		_leave(" = %ld", PTR_ERR(cell));
 		return cell;
 	}
 
-	down_write(&afs_cells_sem);
-
 	/* add a proc directory for this cell */
 	ret = afs_proc_cell_setup(cell);
 	if (ret < 0)
@@ -167,6 +173,11 @@ error:
 	kfree(cell);
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
+
+duplicate_name:
+	read_unlock(&afs_cells_lock);
+	up_write(&afs_cells_sem);
+	return ERR_PTR(-EEXIST);
 }
 
 /*
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
afs-add-a-maintainers-record-for-afs.patch
afs-prevent-double-cell-registration.patch
git-unionfs.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
mutex-subsystem-synchro-test-module.patch


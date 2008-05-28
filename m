From: akpm@linux-foundation.org
Subject: + scsi-libiscsic-return-errno-rather-than-errno.patch added to -mm tree
Date: Wed, 28 May 2008 16:12:38 -0700
Message-ID: <200805282312.m4SNCc3Q005176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbYE1XMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com


The patch titled
     scsi/libiscsi.c: return -errno rather than errno
has been added to the -mm tree.  Its filename is
     scsi-libiscsic-return-errno-rather-than-errno.patch

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
Subject: scsi/libiscsi.c: return -errno rather than errno
From: Li Zefan <lizf@cn.fujitsu.com>

iscsi_prep_scsi_cmd_pdu() returns EIO in a failing path, but returns
-errno in other paths.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libiscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libiscsi.c~scsi-libiscsic-return-errno-rather-than-errno drivers/scsi/libiscsi.c
--- a/drivers/scsi/libiscsi.c~scsi-libiscsic-return-errno-rather-than-errno
+++ a/drivers/scsi/libiscsi.c
@@ -307,7 +307,7 @@ static int iscsi_prep_scsi_cmd_pdu(struc
 	hdr->hlength = hdrlength & 0xFF;
 
 	if (conn->session->tt->init_cmd_task(conn->ctask))
-		return EIO;
+		return -EIO;
 
 	conn->scsicmd_pdus_cnt++;
 	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x "
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

leds-fix-unsigned-value-overflow-in-for-loop.patch
scsi-libiscsic-return-errno-rather-than-errno.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch


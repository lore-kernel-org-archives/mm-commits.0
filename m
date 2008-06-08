From: akpm@linux-foundation.org
Subject: - scsi-libiscsic-return-errno-rather-than-errno.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:50 -0700
Message-ID: <200806081949.m58JnohC017713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637AbYFHTuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     scsi/libiscsi.c: return -errno rather than errno
has been removed from the -mm tree.  Its filename was
     scsi-libiscsic-return-errno-rather-than-errno.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
git-leds.patch
call_usermodehelper-increase-reliability.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
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
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch


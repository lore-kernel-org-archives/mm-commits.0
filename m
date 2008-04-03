From: akpm@linux-foundation.org
Subject: + sctp-fix-wrong-debug-counting-of-bind_bucket.patch added to -mm tree
Date: Thu, 03 Apr 2008 12:33:42 -0700
Message-ID: <200804031933.m33JXgAF018758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763360AbYDCTjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 15:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, sri@us.ibm.com, vladislav.yasevich@hp.com


The patch titled
     sctp: fix wrong debug counting of bind_bucket
has been added to the -mm tree.  Its filename is
     sctp-fix-wrong-debug-counting-of-bind_bucket.patch

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
Subject: sctp: fix wrong debug counting of bind_bucket
From: Li Zefan <lizf@cn.fujitsu.com>

Should not count it if the allocation of the object is failed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sctp/socket.c~sctp-fix-wrong-debug-counting-of-bind_bucket net/sctp/socket.c
--- a/net/sctp/socket.c~sctp-fix-wrong-debug-counting-of-bind_bucket
+++ a/net/sctp/socket.c
@@ -5761,8 +5761,8 @@ static struct sctp_bind_bucket *sctp_buc
 	struct sctp_bind_bucket *pp;
 
 	pp = kmem_cache_alloc(sctp_bucket_cachep, GFP_ATOMIC);
-	SCTP_DBG_OBJCNT_INC(bind_bucket);
 	if (pp) {
+		SCTP_DBG_OBJCNT_INC(bind_bucket);
 		pp->port = snum;
 		pp->fastreuse = 0;
 		INIT_HLIST_HEAD(&pp->owner);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

sctp-fix-wrong-debug-counting-of-datamsg.patch
sctp-fix-wrong-debug-counting-of-bind_bucket.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch


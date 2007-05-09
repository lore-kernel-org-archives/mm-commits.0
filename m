From: akpm@linux-foundation.org
Subject: + ocfs2-kobject-kset-foobar.patch added to -mm tree
Date: Wed, 09 May 2007 11:53:15 -0700
Message-ID: <200705091853.l49IrFUU030874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbXEISxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 14:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, mark.fasheh@oracle.com


The patch titled
     ocfs2: kobject/kset foobar
has been added to the -mm tree.  Its filename is
     ocfs2-kobject-kset-foobar.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ocfs2: kobject/kset foobar
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warning and Oops that it causes:

fs/ocfs2/cluster/masklog.c:161: warning: assignment from incompatible pointer type
[ 2776.204120] OCFS2 Node Manager 1.3.3
[ 2776.211729] BUG: spinlock bad magic on CPU#0, modprobe/4424
[ 2776.214269]  lock: ffff810021c8fe18, .magic: ffffffff, .owner: /6394416, .owner_cpu: 0
[ 2776.217864] [ 2776.217865] Call Trace:
[ 2776.219662]  [<ffffffff803426c8>] spin_bug+0x9e/0xe9
[ 2776.221921]  [<ffffffff803427bf>] _raw_spin_lock+0x23/0xf9
[ 2776.224417]  [<ffffffff8051acf4>] _spin_lock+0x9/0xb
[ 2776.226676]  [<ffffffff8033c3b1>] kobject_shadow_add+0x98/0x1ac
[ 2776.229367]  [<ffffffff8033c4d0>] kobject_add+0xb/0xd
[ 2776.231665]  [<ffffffff8033c4df>] kset_add+0xd/0xf
[ 2776.233845]  [<ffffffff8033c5a6>] kset_register+0x23/0x28
[ 2776.236309]  [<ffffffff8808ccb7>] :ocfs2_nodemanager:mlog_sys_init+0x68/0x6d
[ 2776.239518]  [<ffffffff8808ccee>] :ocfs2_nodemanager:o2cb_sys_init+0x32/0x4a
[ 2776.242726]  [<ffffffff880b80a6>] :ocfs2_nodemanager:init_o2nm+0xa6/0xd5
[ 2776.245772]  [<ffffffff8025266c>] sys_init_module+0x1471/0x15d2
[ 2776.248465]  [<ffffffff8033f250>] simple_strtoull+0x0/0xdc
[ 2776.250959]  [<ffffffff8020948e>] system_call+0x7e/0x83

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/masklog.c~ocfs2-kobject-kset-foobar fs/ocfs2/cluster/masklog.c
--- a/fs/ocfs2/cluster/masklog.c~ocfs2-kobject-kset-foobar
+++ a/fs/ocfs2/cluster/masklog.c
@@ -144,7 +144,8 @@ static struct kobj_type mlog_ktype = {
 };
 
 static struct kset mlog_kset = {
-	.kobj   = {.name = "logmask", .ktype = &mlog_ktype},
+	.kobj  = {.name = "logmask"},
+	.ktype = &mlog_ktype
 };
 
 int mlog_sys_init(struct kset *o2cb_subsys)
@@ -157,7 +158,7 @@ int mlog_sys_init(struct kset *o2cb_subs
 	}
 	mlog_attr_ptrs[i] = NULL;
 
-	kobj_set_kset_s(&mlog_kset, o2cb_subsys);
+	kobj_set_kset_s(&mlog_kset, *o2cb_subsys);
 	return kset_register(&mlog_kset);
 }
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
krealloc-fix-kerneldoc-comments.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
ocfs2-kobject-kset-foobar.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
profile-likely-unlikely-macros.patch

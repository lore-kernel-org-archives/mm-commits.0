From: akpm@linux-foundation.org
Subject: +
 fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists.patch added to -mm tree
Date: Tue, 07 Jan 2014 16:37:37 -0800
Message-ID: <52cc9dd1.Weo1ESBme0SRjKJ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaAHAhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 19:37:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, paulus@samba.org, jwboyer@fedoraproject.org, benh@kernel.crashing.org, davej@redhat.com

Subject: + fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists.patch added to -mm tree
To: davej@redhat.com,benh@kernel.crashing.org,jwboyer@fedoraproject.org,paulus@samba.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 16:37:37 -0800


The patch titled
     Subject: fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfirmware exists.
has been added to the -mm tree.  Its filename is
     fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfirmware exists.

Distribution kernels might want to build in support for /proc/device-tree
for kernels that might end up running on hardware that doesn't support
openfirmware.  This results in an empty /proc/device-tree existing. 
Remove it if the OFW root node doesn't exist.

This situation actually confuses grub2, resulting in install failures. 
grub2 sees the /proc/device-tree and picks the wrong install target cf. 
http://bzr.savannah.gnu.org/lh/grub/trunk/grub/annotate/4300/util/grub-install.in#L311
grub should be more robust, but still, leaving an empty proc dir seems
pointless.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=818378.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_devtree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/proc_devtree.c~fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists fs/proc/proc_devtree.c
--- a/fs/proc/proc_devtree.c~fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists
+++ a/fs/proc/proc_devtree.c
@@ -232,6 +232,7 @@ void __init proc_device_tree_init(void)
 		return;
 	root = of_find_node_by_path("/");
 	if (root == NULL) {
+		remove_proc_entry("device-tree", NULL);
 		pr_debug("/proc/device-tree: can't find root\n");
 		return;
 	}
_

Patches currently in -mm which might be from davej@redhat.com are

mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
fs-proc-proc_devtreec-remove-empty-proc-device-tree-when-no-openfirmware-exists.patch
linux-next.patch


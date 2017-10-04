From: akpm@linux-foundation.org
Subject: [to-be-updated]
 dax-disable-filesystem-dax-on-devices-that-do-not-map-pages.patch removed
 from -mm tree
Date: Wed, 04 Oct 2017 14:56:04 -0700
Message-ID: <59d558f4.YnGLmJP2UPQHfdKr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdJDV4F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 17:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: disable filesystem dax on devices that do not map pages
has been removed from the -mm tree.  Its filename was
     dax-disable-filesystem-dax-on-devices-that-do-not-map-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: disable filesystem dax on devices that do not map pages

If a dax buffer from a device that does not map pages is passed to read(2)
or write(2) as a target for direct-I/O it triggers SIGBUS.  If gdb
attempts to examine the contents of a dax buffer from a device that does
not map pages it triggers SIGBUS.  If fork(2) is called on a process with
a dax mapping from a device that does not map pages it triggers SIGBUS. 
'struct page' is required otherwise several kernel code paths break in
surprising ways.  Disable filesystem-dax on devices that do not map pages.

Link: http://lkml.kernel.org/r/150664807247.36094.11168730579639072446.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/dax/super.c~dax-disable-filesystem-dax-on-devices-that-do-not-map-pages drivers/dax/super.c
--- a/drivers/dax/super.c~dax-disable-filesystem-dax-on-devices-that-do-not-map-pages
+++ a/drivers/dax/super.c
@@ -15,6 +15,7 @@
 #include <linux/mount.h>
 #include <linux/magic.h>
 #include <linux/genhd.h>
+#include <linux/pfn_t.h>
 #include <linux/cdev.h>
 #include <linux/hash.h>
 #include <linux/slab.h>
@@ -123,6 +124,12 @@ int __bdev_dax_supported(struct super_bl
 		return len < 0 ? len : -EIO;
 	}
 
+	if (!pfn_t_has_page(pfn)) {
+		pr_debug("VFS (%s): error: dax support not enabled\n",
+				sb->s_id);
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__bdev_dax_supported);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-stop-using-vm_mixedmap-for-dax.patch
dax-stop-using-vm_hugepage-for-dax.patch


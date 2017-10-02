From: akpm@linux-foundation.org
Subject: + dax-quiet-bdev_dax_supported.patch added to -mm tree
Date: Mon, 02 Oct 2017 15:48:02 -0700
Message-ID: <59d2c222.ru5yOa9I/zcix23s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJBWsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 18:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: quiet bdev_dax_supported()
has been added to the -mm tree.  Its filename is
     dax-quiet-bdev_dax_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-quiet-bdev_dax_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-quiet-bdev_dax_supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: quiet bdev_dax_supported()

Patch series "dax: require 'struct page' and other fixups", v2.

Prompted by a recent change to add more protection around setting up
'vm_flags' for a dax vma [1], rework the implementation to remove the
requirement to set VM_MIXEDMAP and VM_HUGEPAGE.

VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
the memory page it is dealing with is not typical memory from the linear
map.  The get_user_pages_fast() path, since it does not resolve the vma,
is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
use that as a VM_MIXEDMAP replacement in some locations.  In the cases
where there is no pte to consult we fallback to using vma_is_dax() to
detect the VM_MIXEDMAP special case.

This patch series passes a run of the ndctl unit test suite and the
'mmap.sh' [2] test in particular.  'mmap.sh' tries to catch dependencies
on VM_MIXEDMAP and {pte,pmd}_devmap().

[1]: https://lkml.org/lkml/2017/9/25/638
[2]: https://github.com/pmem/ndctl/blob/master/test/mmap.sh


This patch (of 4):

Leave it to the caller to decide if bdev_dax_supported() failures are
errors worth emitting to the log.

Link: http://lkml.kernel.org/r/150664806686.36094.15885850593435187213.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/dax/super.c~dax-quiet-bdev_dax_supported drivers/dax/super.c
--- a/drivers/dax/super.c~dax-quiet-bdev_dax_supported
+++ a/drivers/dax/super.c
@@ -92,21 +92,21 @@ int __bdev_dax_supported(struct super_bl
 	long len;
 
 	if (blocksize != PAGE_SIZE) {
-		pr_err("VFS (%s): error: unsupported blocksize for dax\n",
+		pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
 				sb->s_id);
 		return -EINVAL;
 	}
 
 	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
 	if (err) {
-		pr_err("VFS (%s): error: unaligned partition for dax\n",
+		pr_debug("VFS (%s): error: unaligned partition for dax\n",
 				sb->s_id);
 		return err;
 	}
 
 	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	if (!dax_dev) {
-		pr_err("VFS (%s): error: device does not support dax\n",
+		pr_debug("VFS (%s): error: device does not support dax\n",
 				sb->s_id);
 		return -EOPNOTSUPP;
 	}
@@ -118,7 +118,7 @@ int __bdev_dax_supported(struct super_bl
 	put_dax(dax_dev);
 
 	if (len < 1) {
-		pr_err("VFS (%s): error: dax access failed (%ld)",
+		pr_debug("VFS (%s): error: dax access failed (%ld)",
 				sb->s_id, len);
 		return len < 0 ? len : -EIO;
 	}
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-quiet-bdev_dax_supported.patch
dax-disable-filesystem-dax-on-devices-that-do-not-map-pages.patch
dax-stop-using-vm_mixedmap-for-dax.patch
dax-stop-using-vm_hugepage-for-dax.patch


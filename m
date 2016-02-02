From: akpm@linux-foundation.org
Subject: + ext4-support-for-pud-sized-transparent-huge-pages.patch added
 to -mm tree
Date: Tue, 02 Feb 2016 14:53:55 -0800
Message-ID: <56b13383.10luTRlTVqE3O7nV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbcBBWx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, jack@suse.cz, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: support for PUD-sized transparent huge pages
has been added to the -mm tree.  Its filename is
     ext4-support-for-pud-sized-transparent-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext4-support-for-pud-sized-transparent-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext4-support-for-pud-sized-transparent-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: ext4: support for PUD-sized transparent huge pages

ext4 needs to reserve enough space in the journal to allocate a PUD-sized
page.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ext4/file.c~ext4-support-for-pud-sized-transparent-huge-pages fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-support-for-pud-sized-transparent-huge-pages
+++ a/fs/ext4/file.c
@@ -211,6 +211,10 @@ static int ext4_dax_fault(struct vm_area
 			nblocks = ext4_chunk_trans_blocks(inode,
 						PMD_SIZE / PAGE_SIZE);
 			break;
+		case FAULT_FLAG_SIZE_PUD:
+			nblocks = ext4_chunk_trans_blocks(inode,
+						PUD_SIZE / PAGE_SIZE);
+			break;
 		default:
 			return VM_FAULT_FALLBACK;
 		}
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-fix-race-in-gang-lookup.patch
hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch
btrfs-use-radix_tree_iter_retry.patch
mm-use-radix_tree_iter_retry.patch
radix-treeshmem-introduce-radix_tree_iter_next.patch


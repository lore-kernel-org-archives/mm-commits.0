From: akpm@linux-foundation.org
Subject: + dax-add-tracepoint-to-dax_insert_mapping.patch added to -mm
 tree
Date: Tue, 28 Feb 2017 17:02:03 -0800
Message-ID: <58b61d8b.V+Pj0llLHUB4I1dv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751526AbdCABMh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 20:12:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, jack@suse.cz, mawilcox@microsoft.com, mingo@redhat.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add tracepoint to dax_insert_mapping()
has been added to the -mm tree.  Its filename is
     dax-add-tracepoint-to-dax_insert_mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-tracepoint-to-dax_insert_mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-tracepoint-to-dax_insert_mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add tracepoint to dax_insert_mapping()

Add a tracepoint to dax_insert_mapping(), following the same logging
conventions as the rest of DAX.  This tracepoint, along with the one in
dax_load_hole(), lets us know how a DAX PTE fault was serviced.

Here is an example DAX fault that inserts a PTE mapping:

small-1126  [007] ....   145.451604: dax_pte_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff 0x220

small-1126  [007] ....   145.452317: dax_insert_mapping: dev 259:0 ino
0x1003 shared write address 0x10420000 radix_entry 0x100006

small-1126  [007] ....   145.452399: dax_pte_fault_done: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff
0x220 MAJOR|NOPAGE

Link: http://lkml.kernel.org/r/20170221195116.13278-7-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |    1 +
 include/trace/events/fs_dax.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN fs/dax.c~dax-add-tracepoint-to-dax_insert_mapping fs/dax.c
--- a/fs/dax.c~dax-add-tracepoint-to-dax_insert_mapping
+++ a/fs/dax.c
@@ -931,6 +931,7 @@ static int dax_insert_mapping(struct add
 		return PTR_ERR(ret);
 	*entryp = ret;
 
+	trace_dax_insert_mapping(mapping->host, vmf, ret);
 	return vm_insert_mixed(vma, vaddr, dax.pfn);
 }
 
diff -puN include/trace/events/fs_dax.h~dax-add-tracepoint-to-dax_insert_mapping include/trace/events/fs_dax.h
--- a/include/trace/events/fs_dax.h~dax-add-tracepoint-to-dax_insert_mapping
+++ a/include/trace/events/fs_dax.h
@@ -194,6 +194,36 @@ DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite_n
 DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite);
 DEFINE_PTE_FAULT_EVENT(dax_load_hole);
 
+TRACE_EVENT(dax_insert_mapping,
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, void *radix_entry),
+	TP_ARGS(inode, vmf, radix_entry),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long, vm_flags)
+		__field(unsigned long, address)
+		__field(void *, radix_entry)
+		__field(dev_t, dev)
+		__field(int, write)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->vm_flags = vmf->vma->vm_flags;
+		__entry->address = vmf->address;
+		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
+		__entry->radix_entry = radix_entry;
+	),
+	TP_printk("dev %d:%d ino %#lx %s %s address %#lx radix_entry %#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->vm_flags & VM_SHARED ? "shared" : "private",
+		__entry->write ? "write" : "read",
+		__entry->address,
+		(unsigned long)__entry->radix_entry
+	)
+)
+
 DECLARE_EVENT_CLASS(dax_writeback_range_class,
 	TP_PROTO(struct inode *inode, pgoff_t start_index, pgoff_t end_index),
 	TP_ARGS(inode, start_index, end_index),
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-add-tracepoints-to-dax_iomap_pte_fault.patch
dax-add-tracepoints-to-dax_pfn_mkwrite.patch
dax-add-tracepoints-to-dax_load_hole.patch
dax-add-tracepoints-to-dax_writeback_mapping_range.patch
dax-add-tracepoint-to-dax_writeback_one.patch
dax-add-tracepoint-to-dax_insert_mapping.patch


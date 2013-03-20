From: akpm@linux-foundation.org
Subject: [nacked] vmcore-clean-up-read_vmcore.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:44 -0700
Message-ID: <20130320233244.7BF3931C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:50496 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:45 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so211846qea.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: clean up read_vmcore()
has been removed from the -mm tree.  Its filename was
     vmcore-clean-up-read_vmcore.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: clean up read_vmcore()

Clean up read_vmcore().  Part for objects in vmcore_list can be written
uniformly to part for ELF headers.  By this change, duplicate and
complicated codes are removed, so it's more clear to see what's done
there.

Also, by this change, map_offset_to_paddr() is no longer used.  Remove it.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   68 +++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 48 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-clean-up-read_vmcore fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-clean-up-read_vmcore
+++ a/fs/proc/vmcore.c
@@ -118,27 +118,6 @@ static ssize_t read_from_oldmem(char *bu
 	return read;
 }
 
-/* Maps vmcore file offset to respective physical address in memroy. */
-static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
-					struct vmcore **m_ptr)
-{
-	struct vmcore *m;
-	u64 paddr;
-
-	list_for_each_entry(m, vc_list, list) {
-		u64 start, end;
-		start = m->offset;
-		end = m->offset + m->size - 1;
-		if (offset >= start && offset <= end) {
-			paddr = m->paddr + offset - start;
-			*m_ptr = m;
-			return paddr;
-		}
-	}
-	*m_ptr = NULL;
-	return 0;
-}
-
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
@@ -147,8 +126,8 @@ static ssize_t read_vmcore(struct file *
 {
 	ssize_t acc = 0, tmp;
 	size_t tsz;
-	u64 start, nr_bytes;
-	struct vmcore *curr_m = NULL;
+	u64 start;
+	struct vmcore *m;
 
 	if (buflen == 0 || *fpos >= vmcore_size)
 		return 0;
@@ -174,33 +153,26 @@ static ssize_t read_vmcore(struct file *
 			return acc;
 	}
 
-	start = map_offset_to_paddr(*fpos, &vmcore_list, &curr_m);
-	if (!curr_m)
-        	return -EINVAL;
-
-	while (buflen) {
-		tsz = min_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
-
-		/* Calculate left bytes in current memory segment. */
-		nr_bytes = (curr_m->size - (start - curr_m->paddr));
-		if (tsz > nr_bytes)
-			tsz = nr_bytes;
-
-		tmp = read_from_oldmem(buffer, tsz, &start, 1);
-		if (tmp < 0)
-			return tmp;
-		buflen -= tsz;
-		*fpos += tsz;
-		buffer += tsz;
-		acc += tsz;
-		if (start >= (curr_m->paddr + curr_m->size)) {
-			if (curr_m->list.next == &vmcore_list)
-				return acc;	/*EOF*/
-			curr_m = list_entry(curr_m->list.next,
-						struct vmcore, list);
-			start = curr_m->paddr;
+	list_for_each_entry(m, &vmcore_list, list) {
+		if (*fpos < m->offset + m->size) {
+			tsz = m->offset + m->size - *fpos;
+			if (buflen < tsz)
+				tsz = buflen;
+			start = m->paddr + *fpos - m->offset;
+			tmp = read_from_oldmem(buffer, tsz, &start, 1);
+			if (tmp < 0)
+				return tmp;
+			buflen -= tsz;
+			*fpos += tsz;
+			buffer += tsz;
+			acc += tsz;
+
+			/* leave now if filled buffer already */
+			if (buflen == 0)
+				return acc;
 		}
 	}
+
 	return acc;
 }
 
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

vmcore-read-buffers-for-vmcore-objects-copied-from-old-memory.patch
vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary.patch
kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch
kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch
elf-introduce-nt_vmcore_pad-type.patch
kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

